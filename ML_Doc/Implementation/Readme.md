# 1) Siapkan aset model & dependensi
Taruh file model monthly_tf.tflite (hasil konversi dari Colab) di:\
assets/model/monthly_tf.tflite

'''    
    Pubspec.yaml

    daftarkan asset:

    assets:
      - assets/model/monthly_tf.tflite
'''

paket yang disarankan:
tflite_flutter (load & infer TFLite)
intl (format rupiah)
opsional: hive/sqflite (simpan transaksi lokal), path_provider (cache model)


# 2) Bentuk data input dari pengguna

Form transaksi (sederhana & konsisten):

  - date (DateTime)

  - amount (double, + untuk income, – untuk expense atau “type” terpisah)

  - type (enum/string: Income / Expense)

  - category (string; nanti dipetakan ke super-category: Food, Transport, Shopping/Ent, Health, Rent, Utilities, …)

  - desc (string bebas; dipakai untuk rekomendasi token kalau mau)

Saran UX awal:\
Halaman Tambah Transaksi + Impor CSV (opsional).\
Simpan ke database lokal (Hive/Sqflite) supaya offline.

# 3) Agregasi bulanan (12 angka) & rata-rata kategori

Dari seluruh transaksi pengguna:\
Total bulanan 12 bulan terakhir (khusus Expense).\
Output: List<double> panjang 12 (urutan lama→baru, contoh 2023-04 … 2024-03).

  - Bulan kosong → isi 0.
  - Ini input ke model (setelah di-log1p).

Rata-rata per kategori (3 bulan terakhir) untuk rekomendasi.
  - Abaikan kategori “tetap” (mis. Rent, Utilities).
  - Ambil 2-3 kategori teratas rata-ratanya (prioritas pengeluaran besar).\

gambaran agregasi ini di code dart monthly_budget_model. Tinggal pakai atau adaptasi.

# 4) Siapkan pipeline inferensi TFLite (di Flutter)

Kontrak model (sudah fix):

 - Input: tensor float32 shape [1, 12] → log1p(total_bulan[i])
 - Output: tensor float32 shape [1, 1] → y_log (prediksi bulan depan dalam skala log)

Langkah di Flutter:\
Load model:

    final interpreter = await tfl.Interpreter.fromAsset('model/monthly_tf.tflite');


Siapkan input:

Ambil List<double> last12 = buildMonthlyTotals(txs); → memanjang 12.\
Konversi ke log1p:\

    final input = List<double>.from(last12.map((v) => math.log(1.0 + v)));
    final inputTensor = [input]; // shape [1, 12]

Inferensi:

    final output = List.filled(1, 0.0).reshape([1, 1]);
    interpreter.run(inputTensor, output);
    final yLog = output[0][0] as double; // angka mentah (log)


Balik ke rupiah (di app, bukan di model):

    final yNext = math.exp(yLog) - 1.0; // prediksi bulan depan (Rp)
    
# 5) Post-processing di Flutter (budget & rekomendasi)
Safety buffer (ikut KPI default 15% kalau belum dihitung KPI):

    final safety = 0.15; // atau dari KPI rMAE-3M jika kamu hitung di app


Budget bulanan & mingguan:

    final nextMonthBudget = math.max(0, yNext * (1.0 - safety));
    final weeklyBudget    = nextMonthBudget / 4.3;


Rekomendasi hemat (berbasis kategori):

 - Ambil top-3 kategori terbesar (rata-rata 3M).
 - Cut 10% dari avg, clamp: min Rp5.000, max 30% dari avg.
 - Peta token → kalimat (mis. Shopping/Ent → “belanja non-primer”).
 - Format kalimat:

       “Kurangi {token} sekitar RpX/bulan (~RpY/minggu).”


Ini semua di Flutter: fleksibel, tidak perlu reconvert model setiap kali ubah aturan.

# 6) Format hasil untuk UI

Tampilkan ringkas:
 - Prediksi bulan depan (Rp)
 - Safety buffer (%)
 - Budget mingguan (Rp)
 - Rekomendasi (2-3 kalimat)

Gunakan intl:

    final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final text = rp.format(weeklyBudget); // “Rp4.780”

# 7) Arsitektur & alur layar (sederhana)

Home: ringkasan bulan ini, tombol Tambah Transaksi.\
Tambah Transaksi: form input (date, amount, type, category, desc).\
Insight:

 - Tombol “Hitung Budget Bulan Depan” → jalankan pipeline:
 - ambil transaksi → agregasi
 - siapkan 12 angka → log1p → inferensi TFLite
 - expm1 → safety buffer → budget mingguan
 - rekomendasi berbasis kategori

Tampilkan hasil + tombol “Simpan sebagai target bulan depan” (opsional).

# 8) Validasi & debug (penting)

Cek shape input/output:

- interpreter.getInputTensor(0).shape == [1, 12]
- interpreter.getOutputTensor(0).shape == [1, 1]

Sanity check:

- Uji dengan last12 yang sama seperti di Colab → pastikan nilai y_log ≈ sama (diff < ~3%).

Fallback:

- Jika last12 tidak lengkap (kurang dari 12 bulan), isi kekurangannya 0.

# 9) Versi & distribusi model

 - Simpan file model di assets (mudah).
 - Untuk update cepat: host monthly_tf.tflite di GitHub Releases/Cloud Storage → download & cache saat app start (cek versi via etag/hash), lalu load dari file lokal.

# 10) Contoh payload hasil (yang nanti kirim ke UI)
      {
        "raw": {
          "y_log": 10.0417
        },
        "predictions": {
          "next_month_expense": 25553.47
        },
        "policy": {
          "safety_buffer": 0.15
        },
        "budget": {
          "monthly": 21720.45,
          "weekly": 5051.27
        },
        "recommendations": [
          "Kurangi belanja non-primer sekitar Rp90.000/bulan (~Rp20.930/minggu).",
          "Kurangi transport sekitar Rp50.000/bulan (~Rp11.630/minggu)."
        ]
      }


Ringkasnya
- Model TFLite hanya memprediksi 1 angka (y_log).
- Flutter mengurus:
- agregasi 12 bulan,
- log1p → inferensi → expm1,
- hitung budget (dengan safety),
- bikin teks rekomendasi.

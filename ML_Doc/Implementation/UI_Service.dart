final model = MonthlyBudgetModel();
await model.load();

// 1) Bentuk 12 angka total bulanan (lama -> baru) dari transaksi user
final monthlyTotals = buildMonthlyTotals(userTxs); // kamu isi sesuai data app

// 2) Hitung rata-rata per kategori (untuk rekomendasi)
final catAvg = buildCategoryAverages(userTxs);     // kamu isi sesuai data app

// 3) Ambil payload
final payload = await model.buildPayload(
  monthlyTotals: monthlyTotals,
  catAvg: catAvg,
  kpi3m: null, // atau isi nilai KPI rMAE-3M kalau ada
);

// 4) Tampilkan ke UI
print(payload['next_month_budget_weekly_formatted']);
print(payload['recommendations']);

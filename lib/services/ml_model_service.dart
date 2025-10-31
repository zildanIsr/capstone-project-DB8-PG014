import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MonthlyBudgetModel {
  final int lookback;
  final Set<String> fixedCats;
  final double defaultSafety; // 10% kalau tidak ada KPI
  final double minCut; // Rp minimum saran
  final double maxCutRatio; // plafon 30% dari rata-rata kategori
  Interpreter? _it;

  MonthlyBudgetModel({
    this.lookback = 12,
    this.fixedCats = const {'Rent', 'Utilities'},
    this.defaultSafety = 0.10,
    this.minCut = 5000,
    this.maxCutRatio = 0.30,
  });

  Future<void> load() async {
    // final interpreterOptions = InterpreterOptions()
    //   ..threads = 1
    //   ..useNnApiForAndroid = true
    //   ..useMetalDelegateForIOS = true;

    // // Use XNNPACK Delegate
    // if (Platform.isAndroid) {
    //   interpreterOptions.addDelegate(XNNPackDelegate());
    // }

    // // Use Metal Delegate
    // if (Platform.isIOS) {
    //   interpreterOptions.addDelegate(GpuDelegate());
    // }

    try {
      _it = await Interpreter.fromAsset(
        'assets/models/monthly_tf.tflite',
        // options: interpreterOptions,
      );
      log("Model loaded");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void dispose() => _it?.close();

  // ===== helpers =====
  double _log1p(num x) => math.log(1 + x);
  double _expm1(num x) => math.exp(x) - 1;
  String _idr(num v) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(v);

  /// Pastikan panjang = 12 (lama -> baru). Kalau kurang, pad dengan nilai terakhir.
  List<double> _ensure12(List<double> v) {
    final data = List<double>.from(v);
    if (data.isEmpty) return List.filled(lookback, 0);
    if (data.length < lookback) {
      final last = data.last;
      while (data.length < lookback) {
        data.insert(0, last);
      }
    } else if (data.length > lookback) {
      data.removeRange(0, data.length - lookback);
    }
    return data;
  }

  /// Jalankan model: kembalikan prediksi bulan depan (Rupiah).
  Future<double> predictNextMonthRupiah(List<double> monthlyTotals) async {
    if (_it == null) throw StateError('Interpreter belum di-load');
    final x12 = _ensure12(monthlyTotals).map(_log1p).toList(growable: false);
    final input = [x12]; // [1, 12]
    final output = [List<double>.filled(1, 0)]; // [1, 1]
    _it!.run(input, output);
    final yLog = output[0][0];
    final yRupiah = _expm1(yLog);
    return yRupiah.isFinite ? yRupiah : 0.0;
  }

  /// Build payload buat UI (budget + rekomendasi).
  /// catAvg = rata-rata per kategori (Rupiah) dari periode historis.
  Future<Map<String, dynamic>> buildPayload({
    required List<double> monthlyTotals,
    required Map<String, double> catAvg,
    double? kpi3m, // kalau punya KPI rMAE-3M, kirim di sini
  }) async {
    final predMonth = await predictNextMonthRupiah(monthlyTotals);
    final safety = (kpi3m != null && kpi3m.isFinite)
        ? math.min(0.15, kpi3m / 100.0)
        : defaultSafety;

    final monthBudget = predMonth * (1 - safety);
    final weekBudget = monthBudget / 4.3;

    // top-3 FLEX categories (exclude fixedCats)
    final flex =
        catAvg.entries.where((e) => !fixedCats.contains(e.key)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final recs = <String>[];
    for (final kv in flex.take(3)) {
      final avg = kv.value;
      final raw = avg * 0.10; // potong 10%
      final cut = raw.clamp(minCut, avg * maxCutRatio);
      if (cut > 0) {
        recs.add(
          'Kurangi ${kv.key} sekitar ${_idr(cut)} '
          'bulan depan (~${_idr(cut / 4.3)}/minggu).',
        );
      }
    }
    if (recs.isEmpty) {
      recs.add(
        'Pengeluaran stabil. Pertahankan pola saat ini dan cek kembali minggu depan.',
      );
    }
    // return hasil menyesuaikan
    return {
      if (kpi3m != null)
        'kpi': {'rmae3m': double.parse(kpi3m.toStringAsFixed(2))},
      'safety_buffer': safety,
      'next_month_budget_monthly': monthBudget,
      'next_month_budget_weekly': weekBudget,
      'next_month_budget_monthly_formatted': _idr(monthBudget),
      'next_month_budget_weekly_formatted': _idr(weekBudget),
      'recommendations': recs,
    };
  }
}

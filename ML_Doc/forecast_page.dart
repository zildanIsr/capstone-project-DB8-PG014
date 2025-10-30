import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'monthly_forecaster.dart'; // adjust import path
import '../main.dart'; // akses forecaster global

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});
  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  List<double> totals24 = List<double>.generate(24, (i) {
    // dummy: naik perlahan
    return 100000 + i * 5000;
  });

  double? next1;
  List<double>? next3;

  void _runOnce() {
    final y = forecaster.predictNext(totals24);
    setState(() => next1 = y);
  }

  void _runHorizon3() {
    final ys = forecaster.forecast(totals24, 3);
    setState(() => next3 = ys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Forecast Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Window 24 bulan (t-23..t):'),
            Text(totals24.map((e)=>e.toStringAsFixed(0)).join(', ')),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _runOnce, child: const Text('Prediksi t+1')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _runHorizon3, child: const Text('Prediksi 3 bulan')),
              ],
            ),
            const SizedBox(height: 16),
            if (next1 != null) Text('Prediksi bulan depan: ${next1!.toStringAsFixed(0)}'),
            if (next3 != null) Text('Prediksi 3 bulan: ${next3!.map((e)=>e.toStringAsFixed(0)).join(', ')}'),
          ],
        ),
      ),
    );
  }
}

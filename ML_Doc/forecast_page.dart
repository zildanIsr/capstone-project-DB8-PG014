// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import 'monthly_forecaster.dart'; // adjust import path
// import '../main.dart'; // akses forecaster global

// class ForecastPage extends StatefulWidget {
//   const ForecastPage({super.key});
//   @override
//   State<ForecastPage> createState() => _ForecastPageState();
// }

// class _ForecastPageState extends State<ForecastPage> {
//   List<double> totals24 = List<double>.generate(24, (i) {
//     // dummy: naik perlahan
//     return 100000 + i * 5000;
//   });

//   double? next1;
//   List<double>? next3;

//   void _runOnce() {
//     final y = forecaster.predictNext(totals24);
//     setState(() => next1 = y);
//   }

//   void _runHorizon3() {
//     final ys = forecaster.forecast(totals24, 3);
//     setState(() => next3 = ys);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Monthly Forecast Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Window 24 bulan (t-23..t):'),
//             Text(totals24.map((e)=>e.toStringAsFixed(0)).join(', ')),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 ElevatedButton(onPressed: _runOnce, child: const Text('Prediksi t+1')),
//                 const SizedBox(width: 12),
//                 ElevatedButton(onPressed: _runHorizon3, child: const Text('Prediksi 3 bulan')),
//               ],
//             ),
//             const SizedBox(height: 16),
//             if (next1 != null) Text('Prediksi bulan depan: ${next1!.toStringAsFixed(0)}'),
//             if (next3 != null) Text('Prediksi 3 bulan: ${next3!.map((e)=>e.toStringAsFixed(0)).join(', ')}'),
//           ],
//         ),
//       ),
//     );
//   }
// }


// static const String assetPath = 'assets/models/monthly_tf.tflite';

// class MonthlyBudgetModel {
//   static const int lookback = 24;
//   static const String assetPath = 'assets/models/monthly_tf.tflite';

//   late final Interpreter _interp;
//   late final int _idxX;       // posisi input x pada daftar input tensors
//   late final int _idxNaive;   // posisi input naive pada daftar input tensors
//   late final int _outputIndex; // index untuk map output pada runForMultipleInputs

//   Future<void> init() async {
//     final opts = InterpreterOptions()
//       ..threads = 2
//       ..useNnApiForAndroid = false;

//     _interp = await Interpreter.fromAsset(assetPath, options: opts);

//     final inputs = _interp.getInputTensors();
//     final outputs = _interp.getOutputTensors();

//     // Cari posisi input berdasarkan nama (lebih robust terhadap urutan)
//     _idxX = inputs.indexWhere((t) => t.name.contains('x'));
//     _idxNaive = inputs.indexWhere((t) => t.name.contains('naive'));

//     if (_idxX < 0 || _idxNaive < 0) {
//       // Debug info agar mudah melihat apa yang ada di model
//       print('Input tensor names: ${inputs.map((t) => t.name).toList()}');
//       throw Exception(
//           'Gagal menemukan input tensor "x" atau "naive". Periksa nama tensor di model .tflite.');
//     }

//     // Resize input tensors sesuai expectation (1 sample)
//     // Perhatikan: beberapa versi API menerima indeks posisi; ini biasanya bekerja.
//     _interp.resizeInputTensor(_idxX, [1, lookback]);
//     _interp.resizeInputTensor(_idxNaive, [1, 1]);
//     _interp.allocateTensors();

//     // Tentukan output index untuk Map<int, Object>
//     // Beberapa implementasi Tensor mungkin tidak memiliki property `.index`.
//     // Kita tentukan index berdasarkan panjang daftar output atau nama tensor, fallback ke 0.
//     int outIdx = 0;
//     if (outputs.length == 1) {
//       // single output, gunakan index 0
//       outIdx = 0;
//     } else {
//       // coba cari tensor yang mengandung kata 'output' pada namanya
//       final idxByName =
//           outputs.indexWhere((t) => t.name.toLowerCase().contains('output'));
//       outIdx = idxByName >= 0 ? idxByName : 0;
//     }
//     _outputIndex = outIdx;

//     // Debug info: tampilkan shapes / names untuk verifikasi jika perlu
//     try {
//       print('Input tensor names: ${inputs.map((t) => t.name).toList()}');
//       print('Input tensor shapes: ${inputs.map((t) => t.shape).toList()}');
//       print('Output tensor shapes: ${outputs.map((t) => t.shape).toList()}');
//       print('Using outputIndex = $_outputIndex');
//     } catch (_) {
//       // non-fatal: beberapa property mungkin tidak ada di versi tertentu
//     }
//   }

//   double _log1p(double v) => math.log(1.0 + (v < 0 ? 0.0 : v));
//   double _expm1(double v) => math.exp(v) - 1.0;

//   /// Predict single step (t+1)
//   double predictNext(List<double> totals24) {
//     assert(totals24.length == lookback);

//     final xLog1p = List<double>.generate(lookback, (i) => _log1p(totals24[i]));
//     final naiveLog1p = _log1p(totals24[12]);

//     // Bentuk input sesuai ekspektasi model:
//     final inputX = [xLog1p];        // [1, lookback]
//     final inputNaive = [
//       [naiveLog1p]
//     ]; // [1,1]

//     // Susun daftar inputs — pastikan urutan sama dengan model.
//     // Kalau modelmu mengharapkan urutan [x, naive], pakai urutan ini.
//     final inputs = <Object>[inputX, inputNaive];

//     // Siapkan output sesuai bentuk yang diharapkan model: [1,1]
//     final output = List.generate(1, (_) => List.filled(1, 0.0));

//     // runForMultipleInputs membutuhkan Map<int, Object> untuk outputs
//     final outputsMap = <int, Object>{_outputIndex: output};

//     // Run inference
//     _interp.runForMultipleInputs(inputs, outputsMap);

//     // Ambil hasil dari map
//     final got = outputsMap[_outputIndex];
//     double yLog1p;

//     if (got is List && got.isNotEmpty && got[0] is List && got[0].isNotEmpty) {
//       yLog1p = (got[0][0] as num).toDouble();
//     } else if (got is List && got.isNotEmpty && got[0] is num) {
//       // ada implementasi yang memberi [val] bukan [[val]]
//       yLog1p = (got[0] as num).toDouble();
//     } else {
//       // fallback: coba cast output variable 'output' langsung
//       try {
//         yLog1p = (output[0][0] as num).toDouble();
//       } catch (e) {
//         throw Exception('Format output tidak dikenali: $got');
//       }
//     }

//     final y = _expm1(yLog1p);
//     return y < 0 ? 0.0 : y;
//   }

//   /// Multi-step forecast (rolling window)
//   List<double> forecast(List<double> totals24, int horizon) {
//     final preds = <double>[];
//     final buf = List<double>.from(totals24);

//     for (int h = 0; h < horizon; h++) {
//       final y = predictNext(buf);
//       preds.add(y);
//       buf.removeAt(0);
//       buf.add(y);
//     }
//     return preds;
//   }

//   void dispose() => _interp.close();
// }
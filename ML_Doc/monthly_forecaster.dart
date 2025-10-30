import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';

class MonthlyForecaster {
  static const int lookback = 24;
  static const String assetPath = 'assets/ml/monthly_tf_blend.tflite';

  late final Interpreter _interp;
  late final int _idxX;
  late final int _idxNaive;
  late final int _idxY;

  Future<void> init() async {
    // Opsi performa; XNNPACK aktif default
    final opts = InterpreterOptions()
      ..threads = 2
      ..useNnApiForAndroid = false;

    _interp = await Interpreter.fromAsset(assetPath, options: opts);

    // Cari index tensor by name agar aman jika urutan berubah
    final inputs = _interp.getInputTensors();
    final outputs = _interp.getOutputTensors();
    _idxX     = inputs.indexWhere((t) => t.name.contains('x'));
    _idxNaive = inputs.indexWhere((t) => t.name.contains('naive'));
    _idxY     = outputs.isNotEmpty ? outputs.first.index : 0;

    // Set shape input & allocate
    _interp.resizeInputTensor(_interp.getInputTensors()[_idxX].index, [1, lookback]);
    _interp.resizeInputTensor(_interp.getInputTensors()[_idxNaive].index, [1]);
    _interp.allocateTensors();
  }

  // Helper
  double _log1p(double v) => math.log(1.0 + (v < 0 ? 0.0 : v));
  double _expm1(double v) => math.exp(v) - 1.0;

  /// Prediksi 1 langkah (t+1)
  /// totals24 = 24 angka non-negatif, urutan t-23..t (terlama -> terbaru)
  double predictNext(List<double> totals24) {
    assert(totals24.length == lookback);

    final xLog1p = List<double>.generate(lookback, (i) => _log1p(totals24[i]));
    final naiveLog1p = [_log1p(totals24[12])]; // lag-12 untuk t+1

    final inputX = [xLog1p];           // [1,24]
    final inputNaive = [naiveLog1p[0]]; // [1]
    final output = List.filled(1 * 1, 0.0).reshape([1, 1]);

    _interp.setTensor(_interp.getInputTensors()[_idxX].index, inputX);
    _interp.setTensor(_interp.getInputTensors()[_idxNaive].index, inputNaive);
    _interp.invoke();
    _interp.copyOutputTensor(_idxY, output);

    final yLog1p = output[0][0];
    final y = _expm1(yLog1p);
    return y < 0 ? 0.0 : y; // clamp >= 0
  }

  /// Prediksi multi-step (t+H) dengan rolling window
  List<double> forecast(List<double> totals24, int horizon) {
    final preds = <double>[];
    final buf = List<double>.from(totals24);

    for (int h = 0; h < horizon; h++) {
      final y = predictNext(buf);
      preds.add(y);
      // shift window: drop paling lama, append prediksi terbaru
      buf.removeAt(0);
      buf.add(y);
      // naive untuk step berikut otomatis bergeser (tetap ambil index 12)
    }
    return preds;
  }

  void dispose() => _interp.close();
}

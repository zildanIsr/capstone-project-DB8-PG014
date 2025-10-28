import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  CurrencyFormatter({this.maxDigits, this.prefix = "Rp. "});

  final int? maxDigits;
  final String prefix;
  num _uMaskValue = 0.0;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    num value = num.parse(newValue.text.isEmpty?'0':newValue.text);
    _uMaskValue = value;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits!) {
      return oldValue;
    }

    final formatter = NumberFormat("#,##0", "id_ID");
    String newText = "$prefix${formatter.format(value)}";
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }

  double getConvertToDouble() {
    return _uMaskValue.toDouble();
  }

  int getConvertToInt() {
    return _uMaskValue.toInt();
  }

  num getConvertToNum() {
    return _uMaskValue;
  }
}

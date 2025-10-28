import 'package:intl/intl.dart';

extension ContextExt on num {
  String get rupiah {
    final formatter = NumberFormat('#,##0', 'id-ID');
    return formatter.format(this);
  }
}
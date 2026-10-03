import 'package:intl/intl.dart';

final _numberFormat = NumberFormat('#,##0');

/// UGX has no decimals, so money is always a whole number.
String formatUgx(int amount) => 'UGX ${_numberFormat.format(amount)}';

String waitingLabel(DateTime since) {
  final minutes = DateTime.now().difference(since).inMinutes;
  return minutes < 1 ? 'just now' : '$minutes min';
}

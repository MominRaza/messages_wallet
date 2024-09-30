import 'package:intl/intl.dart';

String? currencyFormat(String? amount) {
  final doubleAmount = double.tryParse(amount ?? '');
  if (doubleAmount == null) return null;
  return NumberFormat.simpleCurrency(locale: 'HI').format(doubleAmount);
}

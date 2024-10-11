import 'package:intl/intl.dart';

String? currencyFormat(String? amount) {
  final doubleAmount = double.tryParse(amount ?? '');
  if (doubleAmount == null) return null;

  if (doubleAmount == doubleAmount.toInt()) {
    return NumberFormat.simpleCurrency(locale: 'HI', decimalDigits: 0)
        .format(doubleAmount);
  } else {
    return NumberFormat.simpleCurrency(locale: 'HI').format(doubleAmount);
  }
}

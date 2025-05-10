import 'package:intl/intl.dart';

String currencyFormat(double amount) {
  String formattedAmount;

  if (amount == amount.toInt()) {
    formattedAmount = NumberFormat.simpleCurrency(
      locale: 'HI',
      decimalDigits: 0,
    ).format(amount);
  } else {
    formattedAmount = NumberFormat.simpleCurrency(locale: 'HI').format(amount);
  }

  return formattedAmount.replaceAll('-', '\u2212 ');
}

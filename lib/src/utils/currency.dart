import 'package:intl/intl.dart';

import '../shared/models/spending_model.dart';

String currencyFormat(double amount, [TransactionType? type]) {
  if (type != null) {
    bool shouldBePositive =
        type == TransactionType.credited ||
        type == TransactionType.creditCardReversed;

    amount = shouldBePositive ? amount.abs() : -amount.abs();
  }

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

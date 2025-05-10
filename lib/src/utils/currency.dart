import 'package:intl/intl.dart';

import '../shared/models/spending_model.dart';

String currencyFormat(double amount, [TransactionType? type]) {
  // Apply sign based on transaction type if provided
  if (type != null) {
    // Only for credited and creditCardReversed, we want positive values
    // For all other transaction types, we want negative values
    bool shouldBePositive =
        type == TransactionType.credited ||
        type == TransactionType.creditCardReversed;

    // Ensure the amount has the correct sign
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

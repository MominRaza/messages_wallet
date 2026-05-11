import '../../shared/models/spending_model.dart';

final _monthMap = {
  'jan': '01',
  'feb': '02',
  'mar': '03',
  'apr': '04',
  'may': '05',
  'jun': '06',
  'jul': '07',
  'aug': '08',
  'sep': '09',
  'oct': '10',
  'nov': '11',
  'dec': '12',
};

Iterable<Transaction> extractHDFCMessages(Iterable<String> hdfcMessages) =>
    hdfcMessages
        .map((message) {
          if (message.contains('Online Payment of Rs.') &&
              message.contains('was credited to your card ending')) {
            final amountRegex = RegExp(
              r'Online Payment of Rs\.(\d+(?:\.\d{1,2})?)',
            );
            final cardRegex = RegExp(r'your card ending (\d{4})');
            final dateRegex = RegExp(r'On (\d{2})/([A-Z]{3})/(\d{4})');

            final amount = amountRegex.firstMatch(message)?.group(1);
            final cardNumber = cardRegex.firstMatch(message)?.group(1);
            final dateMatch = dateRegex.firstMatch(message);

            final day = dateMatch?.group(1);
            final monthStr = dateMatch?.group(2);
            final month = _monthMap[monthStr?.toLowerCase()];
            final year = dateMatch?.group(3);

            final dateTime = DateTime.tryParse('$year-$month-$day 00:00:00');

            return Transaction(
              type: TransactionType.credited,
              transactionAmount: double.tryParse(amount ?? '') ?? 0,
              accountNumber: cardNumber == null
                  ? ''
                  : 'HDFC Bank Credit Card $cardNumber',
              body: message,
              dateTime: dateTime ?? DateTime(0),
              finalAmount: null,
            );
          }

          if (message.contains('Spent Rs.') &&
              message.contains('On HDFC Bank Card')) {
            final amountRegex = RegExp(r'Spent Rs\.(\d+(?:\.\d{1,2})?)');
            final cardRegex = RegExp(r'On HDFC Bank Card (\d{4})');
            final dateRegex = RegExp(
              r'On (\d{4})-(\d{2})-(\d{2}):(\d{2}:\d{2}:\d{2})',
            );

            final amount = amountRegex.firstMatch(message)?.group(1);
            final cardNumber = cardRegex.firstMatch(message)?.group(1);
            final dateMatch = dateRegex.firstMatch(message);

            final year = dateMatch?.group(1);
            final month = dateMatch?.group(2);
            final day = dateMatch?.group(3);
            final time = dateMatch?.group(4);

            final dateTime = DateTime.tryParse('$year-$month-$day $time');

            return Transaction(
              type: TransactionType.creditCardSpent,
              transactionAmount: double.tryParse(amount ?? '') ?? 0,
              accountNumber: cardNumber == null
                  ? ''
                  : 'HDFC Bank Credit Card $cardNumber',
              body: message,
              dateTime: dateTime ?? DateTime(0),
              finalAmount: null,
            );
          }

          if (message.contains('Txn Rs.') && message.contains('by UPI')) {
            final amountRegex = RegExp(r'Txn Rs\.(\d+(?:\.\d{1,2})?)');
            final cardRegex = RegExp(r'On HDFC Bank Card (\d{4})');
            final dateRegex = RegExp(r'On (\d{2})-(\d{2})');

            final amount = amountRegex.firstMatch(message)?.group(1);
            final cardNumber = cardRegex.firstMatch(message)?.group(1);
            final dateMatch = dateRegex.firstMatch(message);

            final day = dateMatch?.group(1);
            final month = dateMatch?.group(2);
            final year = DateTime.now().year.toString();

            final dateTime = DateTime.tryParse('$year-$month-$day 00:00:00');

            return Transaction(
              type: TransactionType.creditCardSpent,
              transactionAmount: double.tryParse(amount ?? '') ?? 0,
              accountNumber: cardNumber == null
                  ? ''
                  : 'HDFC Bank Credit Card $cardNumber',
              body: message,
              dateTime: dateTime ?? DateTime(0),
              finalAmount: null,
            );
          }

          return null;
        })
        .whereType<Transaction>()
        .where(
          (element) =>
              element.transactionAmount != 0 &&
              element.accountNumber.isNotEmpty &&
              element.dateTime != DateTime(0),
        );

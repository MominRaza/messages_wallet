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

Iterable<Transaction> extractKotakMessages(
  Iterable<String> kotakMessages,
) => kotakMessages
    .map((message) {
      if (message.startsWith('Payment of INR')) {
        final paymentRegex = RegExp(
          r'Payment of INR ([\d,]+(?:\.\d{1,2})?) is credited to your Kotak Bank Credit Card x(\d+) on (\d{1,2})-(\w{3})-(\d{2,4})',
        );
        final limitRegex = RegExp(
          r'Available Credit limit is INR ([\d,]+(?:\.\d{1,2})?)',
        );

        final match = paymentRegex.firstMatch(message);
        final String? amount = match?.group(1);
        final String? cardNumber = match?.group(2);
        final String? day = match?.group(3)?.padLeft(2, '0');
        final String? monthStr = match?.group(4);
        final String? month = _monthMap[monthStr?.toLowerCase()];
        String? year = match?.group(5);
        year = year?.length == 2 ? '20$year' : year;
        final String? availableLimit = limitRegex.firstMatch(message)?.group(1);

        final DateTime? dateTime = DateTime.tryParse(
          '$year-$month-$day 00:00:00',
        );

        return Transaction(
          type: TransactionType.credited,
          transactionAmount:
              double.tryParse(amount?.replaceAll(',', '') ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'Kotak Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: double.tryParse(
            availableLimit?.replaceAll(',', '') ?? '',
          ),
        );
      }

      if (message.contains('spent on Kotak Bank Card')) {
        final spentRegex = RegExp(
          r'INR ([\d,]+(?:\.\d{1,2})?) spent on Kotak Bank Card x(\d+) on (\d{1,2})-(\w{3})-(\d{2,4})',
        );
        final limitRegex = RegExp(r'Avl limit INR ([\d,]+(?:\.\d{1,2})?)');

        final match = spentRegex.firstMatch(message);
        final String? amount = match?.group(1);
        final String? cardNumber = match?.group(2);
        final String? day = match?.group(3)?.padLeft(2, '0');
        final String? monthStr = match?.group(4);
        final String? month = _monthMap[monthStr?.toLowerCase()];
        String? year = match?.group(5);
        year = year?.length == 2 ? '20$year' : year;
        final String? availableLimit = limitRegex.firstMatch(message)?.group(1);

        final DateTime? dateTime = DateTime.tryParse(
          '$year-$month-$day 00:00:00',
        );

        return Transaction(
          type: TransactionType.creditCardSpent,
          transactionAmount:
              double.tryParse(amount?.replaceAll(',', '') ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'Kotak Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: double.tryParse(
            availableLimit?.replaceAll(',', '') ?? '',
          ),
        );
      }

      return Transaction(
        type: TransactionType.creditCardSpent,
        transactionAmount: 0,
        accountNumber: '',
        body: message,
        dateTime: DateTime(0),
        finalAmount: null,
      );
    })
    .where(
      (element) =>
          element.transactionAmount != 0 &&
          element.accountNumber.isNotEmpty &&
          element.dateTime != DateTime(0),
    );

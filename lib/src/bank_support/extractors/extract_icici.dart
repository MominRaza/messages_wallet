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

Iterable<Transaction> extractICICIMessages(
  Iterable<String> iciciMessages,
) => iciciMessages
    .map((message) {
      if (message.contains('has been reversed')) {
        RegExp reversedRegex = RegExp(
          r'transaction of (?:INR|Rs) ([\d,]+(?:\.\d{1,2})?) on ICICI Bank Credit Card XX(\d+)',
        );
        RegExp dateRegex = RegExp(
          r'dated (\d{1,2})-(\w{3})-(\d{2,4}) at (\d{2}:\d{2}:\d{2})',
        );
        RegExp limitRegex = RegExp(
          r'Available Credit limit is (?:INR|Rs) ([\d,]+(?:\.\d{1,2})?)',
        );

        String? amount = reversedRegex.firstMatch(message)?.group(1);
        String? cardNumber = reversedRegex.firstMatch(message)?.group(2);
        RegExpMatch? dateMatch = dateRegex.firstMatch(message);
        String? availableLimit = limitRegex.firstMatch(message)?.group(1);

        String? day = dateMatch?.group(1)?.padLeft(2, '0');
        String? monthStr = dateMatch?.group(2);
        String? month = _monthMap[monthStr?.toLowerCase()];
        String? year = dateMatch?.group(3);
        year = year?.length == 2 ? '20$year' : year;
        String? time = dateMatch?.group(4);

        String formattedDateTime = '$year-$month-$day $time';
        DateTime? dateTime = DateTime.tryParse(formattedDateTime);

        return Transaction(
          type: TransactionType.creditCardReversed,
          transactionAmount:
              double.tryParse(amount?.replaceAll(',', '') ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'ICICI Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: double.tryParse(
            availableLimit?.replaceAll(',', '') ?? '',
          ),
        );
      }

      if (message.contains('Payment of')) {
        RegExp paymentRegex = RegExp(
          r'Payment of (?:INR|Rs) ([\d,]+(?:\.\d{1,2})?) has been received on your ICICI Bank Credit Card XX(\d+)',
        );
        RegExp dateRegex = RegExp(r'on (\d{1,2})-(\w{3})-(\d{2,4})');

        String? amount = paymentRegex.firstMatch(message)?.group(1);
        String? cardNumber = paymentRegex.firstMatch(message)?.group(2);
        RegExpMatch? dateMatch = dateRegex.firstMatch(message);

        String? day = dateMatch?.group(1)?.padLeft(2, '0');
        String? monthStr = dateMatch?.group(2);
        String? month = _monthMap[monthStr?.toLowerCase()];
        String? year = dateMatch?.group(3);
        year = year?.length == 2 ? '20$year' : year;

        String formattedDateTimeString = '$year-$month-$day 00:00:00';
        DateTime? dateTime = DateTime.tryParse(formattedDateTimeString);

        return Transaction(
          type: TransactionType.credited,
          transactionAmount:
              double.tryParse(amount?.replaceAll(',', '') ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'ICICI Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: null,
        );
      }

      RegExp amountRegex = RegExp(r'(?:INR|Rs) ([\d,]+(?:\.\d{1,2})?)');
      RegExp cardRegex = RegExp(r'ICICI Bank (?:Credit )?Card XX(\d+)');
      RegExp dateRegex = RegExp(r'on (\d{1,2})-(\w{3})-(\d{2,4})');
      RegExp limitRegex = RegExp(
        r'Avl L(?:imit|mt): (?:INR|Rs) ([\d,]+(?:\.\d{1,2})?)',
      );

      String? amount = amountRegex.firstMatch(message)?.group(1);
      String? cardNumber = cardRegex.firstMatch(message)?.group(1);
      RegExpMatch? dateMatch = dateRegex.firstMatch(message);
      String? availableLimit = limitRegex.firstMatch(message)?.group(1);

      String? day = dateMatch?.group(1)?.padLeft(2, '0');
      String? monthStr = dateMatch?.group(2);
      String? month = _monthMap[monthStr?.toLowerCase()];
      String? year = dateMatch?.group(3);
      year = year?.length == 2 ? '20$year' : year;

      String formattedDateTimeString = '$year-$month-$day 00:00:00';
      DateTime? dateTime = DateTime.tryParse(formattedDateTimeString);

      return Transaction(
        type: TransactionType.creditCardSpent,
        transactionAmount:
            double.tryParse(amount?.replaceAll(',', '') ?? '') ?? 0,
        accountNumber: cardNumber == null
            ? ''
            : 'ICICI Bank Credit Card $cardNumber',
        body: message,
        dateTime: dateTime ?? DateTime(0),
        finalAmount: double.tryParse(availableLimit?.replaceAll(',', '') ?? ''),
      );
    })
    .where(
      (element) =>
          element.transactionAmount != 0 &&
          element.accountNumber.isNotEmpty &&
          element.dateTime != DateTime(0),
    );

import '../../shared/models/spending_model.dart';

Iterable<Transaction> extractAxisMessages(
  Iterable<String> axisMessages,
) => axisMessages
    .map((message) {
      if (message.contains('has been reversed')) {
        RegExp reversedRegex = RegExp(
          r'Transaction of INR (\d+(?:\.\d{1,2})?) on Axis Bank Credit Card no\. XX(\d+)',
        );
        RegExp reversedDateRegex = RegExp(
          r'(\d{2})-(\d{2})-(\d{2}) (\d{2}:\d{2}:\d{2})',
        );
        RegExp reversedLimitRegex = RegExp(
          r'Available limit: INR (\d+(?:\.\d{1,2})?)',
        );

        String? amount = reversedRegex.firstMatch(message)?.group(1);
        String? cardNumber = reversedRegex.firstMatch(message)?.group(2);
        RegExpMatch? dateMatch = reversedDateRegex.firstMatch(message);
        String? availableLimit = reversedLimitRegex
            .firstMatch(message)
            ?.group(1);

        String? day = dateMatch?.group(1);
        String? month = dateMatch?.group(2);
        String? year = dateMatch?.group(3);
        year = year?.length == 2 ? '20$year' : year;
        String? time = dateMatch?.group(4);

        String formattedDateTime = '$year-$month-$day $time';
        DateTime? dateTime = DateTime.tryParse(formattedDateTime);

        return Transaction(
          type: TransactionType.creditCardReversed,
          transactionAmount: double.tryParse(amount ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'Axis Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: double.tryParse(availableLimit ?? ''),
        );
      }

      if (message.contains('has been received towards')) {
        RegExp paymentRegex = RegExp(
          r'Payment of INR (\d+(?:\.\d{1,2})?) has been received towards your Axis Bank Credit Card XX(\d+)',
        );
        RegExp dateRegex = RegExp(r'on (\d{2})-(\d{2})-(\d{2})');

        String? amount = paymentRegex.firstMatch(message)?.group(1);
        String? cardNumber = paymentRegex.firstMatch(message)?.group(2);
        RegExpMatch? dateMatch = dateRegex.firstMatch(message);

        String? day = dateMatch?.group(1);
        String? month = dateMatch?.group(2);
        String? year = dateMatch?.group(3);
        year = year?.length == 2 ? '20$year' : year;

        String formattedDateTime = '$year-$month-$day 00:00:00';
        DateTime? dateTime = DateTime.tryParse(formattedDateTime);

        return Transaction(
          type: TransactionType.credited,
          transactionAmount: double.tryParse(amount ?? '') ?? 0,
          accountNumber: cardNumber == null
              ? ''
              : 'Axis Bank Credit Card $cardNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: null,
        );
      }

      if (message.contains('debited\n')) {
        RegExp amountRegex = RegExp(r'INR (\d+(?:\.\d{1,2})?) debited');
        RegExp accountRegex = RegExp(r'A/c no\. XX(\d+)');
        RegExp dateRegex = RegExp(
          r'(\d{2})-(\d{2})-(\d{2}), (\d{2}:\d{2}:\d{2})',
        );

        String? amount = amountRegex.firstMatch(message)?.group(1);
        String? accountNumber = accountRegex.firstMatch(message)?.group(1);
        RegExpMatch? dateMatch = dateRegex.firstMatch(message);

        String? day = dateMatch?.group(1);
        String? month = dateMatch?.group(2);
        String? year = dateMatch?.group(3);
        year = year?.length == 2 ? '20$year' : year;
        String? time = dateMatch?.group(4);

        String formattedDateTime = '$year-$month-$day $time';
        DateTime? dateTime = DateTime.tryParse(formattedDateTime);

        return Transaction(
          type: TransactionType.transferred,
          transactionAmount: double.tryParse(amount ?? '') ?? 0,
          accountNumber: accountNumber == null
              ? ''
              : 'Axis Bank $accountNumber',
          body: message,
          dateTime: dateTime ?? DateTime(0),
          finalAmount: null,
        );
      }

      RegExp typeRegex = RegExp(r'(credited|Debit|Spent)');
      RegExp debitTypeRegex = RegExp(r'(UPI/|ATM-WDL/)');
      RegExp amountRegex = RegExp(r'INR (\d+(?:\.\d{1,2})?)');
      RegExp finalAmountRegex = RegExp(
        r'(Avl Bal-|Bal|Avl Lmt) INR (\d+(?:\.\d{1,2})?)',
      );
      RegExp accountNumberRegex = RegExp(r'(A/c no|Card no)\. XX(\d+)');
      RegExp dateTimeRegex = RegExp(
        r'(\d{2})-(\d{2})-(\d{2}|\d{4}) (at )?(\d{2}:\d{2}:\d{2})',
      );

      String? transactionType = typeRegex.firstMatch(message)?.group(1);
      String? debitTransactionType = debitTypeRegex
          .firstMatch(message)
          ?.group(1);
      String? transactionAmount = amountRegex.firstMatch(message)?.group(1);
      String? finalAmount = finalAmountRegex.firstMatch(message)?.group(2);
      String? accountNumber = accountNumberRegex.firstMatch(message)?.group(2);
      RegExpMatch? dateTimeMatch = dateTimeRegex.firstMatch(message);

      String? day = dateTimeMatch?.group(1);
      String? month = dateTimeMatch?.group(2);
      String? year = dateTimeMatch?.group(3);
      year = year?.length == 2 ? '20$year' : year;
      String? time = dateTimeMatch?.group(5);

      String formattedDateTimeString = '$year-$month-$day $time';

      DateTime? dateTime = DateTime.tryParse(formattedDateTimeString);

      return Transaction(
        type: switch (transactionType) {
          'credited' => TransactionType.credited,
          'Debit' =>
            debitTransactionType == 'ATM-WDL/'
                ? TransactionType.withdrawn
                : TransactionType.transferred,
          'Spent' => TransactionType.creditCardSpent,
          _ => TransactionType.transferred,
        },
        transactionAmount: double.tryParse(transactionAmount ?? '') ?? 0,
        accountNumber: accountNumber == null
            ? ''
            : 'Axis Bank ${transactionType == 'Spent' ? 'Credit Card ' : ''}${accountNumber.substring(accountNumber.length - 4)}',
        body: message,
        dateTime: dateTime ?? DateTime(0),
        finalAmount: double.tryParse(finalAmount ?? ''),
      );
    })
    .where(
      (element) =>
          element.transactionAmount != 0 &&
          element.accountNumber.isNotEmpty &&
          element.dateTime != DateTime(0),
    );

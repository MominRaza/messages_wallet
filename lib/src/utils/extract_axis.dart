import '../shared/models/spending_model.dart';

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

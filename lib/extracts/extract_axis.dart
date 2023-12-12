import 'package:messages_wallet/models/transaction_model.dart';

Iterable<Transaction> extractAxisMessages(Iterable<String> axisMessages) =>
    axisMessages.map((message) {
      RegExp typeRegex = RegExp(r'(Credit|Debit)');
      RegExp debitTypeRegex = RegExp(r'(UPI/|ATM-WDL/)');
      RegExp amountRegex = RegExp(r'INR (\d+\.\d{2})');
      RegExp finalAmountRegex = RegExp(r'Bal INR (\d+\.\d{2})');
      RegExp accountNumberRegex = RegExp(r'A/c no\. XX(\d+)');
      RegExp dateTimeRegex =
          RegExp(r'(\d{2})-(\d{2})-(\d{2}|\d{4}) (\d{2}:\d{2}:\d{2})');

      String? transactionType = typeRegex.firstMatch(message)?.group(1);
      String? debitTransactionType =
          debitTypeRegex.firstMatch(message)?.group(1);
      String? transactionAmount = amountRegex.firstMatch(message)?.group(1);
      String? finalAmount = finalAmountRegex.firstMatch(message)?.group(1);
      String? accountNumber = accountNumberRegex.firstMatch(message)?.group(1);
      RegExpMatch? dateTimeMatch = dateTimeRegex.firstMatch(message);

      String? day = dateTimeMatch?.group(1);
      String? month = dateTimeMatch?.group(2);
      String? year = dateTimeMatch?.group(3);
      year = year?.length == 2 ? '20$year' : year;
      String? time = dateTimeMatch?.group(4);

      String formattedDateTimeString = '$year-$month-$day $time';

      DateTime? dateTime = DateTime.tryParse(formattedDateTimeString);

      return Transaction(
        type: switch (transactionType) {
          'Credit' => TransactionType.credited,
          'Debit' => debitTransactionType == 'ATM-WDL/'
              ? TransactionType.withdrawn
              : TransactionType.transferred,
          _ => TransactionType.transferred,
        },
        transactionAmount: transactionAmount,
        finalAmount: finalAmount,
        accountNumber:
            'Axis XX${accountNumber?.substring(accountNumber.length - 4)}',
        body: message,
        dateTime: dateTime,
      );
    }).where(
      (element) =>
          element.transactionAmount != null &&
          element.accountNumber != 'Axis XXnull',
    );

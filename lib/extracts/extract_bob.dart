import '../models/transaction_model.dart';

Iterable<Transaction> extractBOBMessages(Iterable<String> bobMessages) =>
    bobMessages.map((message) {
      RegExp typeRegex = RegExp(r'(Credited|withdrawn|transferred)');
      RegExp amountRegex = RegExp(r'Rs\.([\d,]+(?:\.\d{2})?)');
      RegExp finalAmountRegex = RegExp(r'Avlbl Amt:Rs\.([\d,]+(?:\.\d{1,2})?)');
      RegExp accountNumberRegex = RegExp(r'A/c \.{3}(\d+)');
      RegExp dateTimeRegex =
          RegExp(r'(\d{2})-(\d{2})-(\d{4}) (\d{2}:\d{2}:\d{2})');

      String? transactionType = typeRegex.firstMatch(message)?.group(1);
      String? transactionAmount = amountRegex.firstMatch(message)?.group(1);
      String? finalAmount = finalAmountRegex.firstMatch(message)?.group(1);
      String? accountNumber = accountNumberRegex.firstMatch(message)?.group(1);
      RegExpMatch? dateTimeMatch = dateTimeRegex.firstMatch(message);

      String? day = dateTimeMatch?.group(1);
      String? month = dateTimeMatch?.group(2);
      String? year = dateTimeMatch?.group(3);
      String? time = dateTimeMatch?.group(4);

      String formattedDateTimeString = '$year-$month-$day $time';

      DateTime dateTime = DateTime.parse(formattedDateTimeString);

      return Transaction(
        type: switch (transactionType?.toLowerCase()) {
          'credited' => TransactionType.credited,
          'transferred' => TransactionType.transferred,
          _ => TransactionType.withdrawn,
        },
        transactionAmount: transactionAmount,
        finalAmount: finalAmount,
        accountNumber: 'BoB XX$accountNumber',
        body: message,
        dateTime: dateTime,
      );
    });

import '../shared/models/spending_model.dart';

Iterable<Transaction> extractCosmosMessages(Iterable<String> bobMessages) =>
    bobMessages
        .map((message) {
          RegExp typeRegex = RegExp(r'(debited|credited)');
          RegExp amountRegex = RegExp(r'INR\.? ([\d,]+(?:\.\d{1,2})?)');
          RegExp finalAmountRegex = RegExp(
            r'A/c (balance is INR|bal is INR)\.? (\d+(?:\.\d{1,2})?)',
          );

          RegExp accountNumberRegex = RegExp(r'A/c (no )?X{1,2}(\d+)');
          RegExp dateTimeRegex = RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})');

          String? transactionType = typeRegex.firstMatch(message)?.group(1);
          String? transactionAmount = amountRegex.firstMatch(message)?.group(1);
          String? finalAmount = finalAmountRegex.firstMatch(message)?.group(2);
          String? accountNumber = accountNumberRegex
              .firstMatch(message)
              ?.group(2);
          RegExpMatch? dateTimeMatch = dateTimeRegex.firstMatch(message);

          String? day = dateTimeMatch?.group(1);
          String? month = dateTimeMatch?.group(2);
          String? year = dateTimeMatch?.group(3);
          year = year?.length == 2 ? '20$year' : year;

          String formattedDateTimeString = '$year-$month-$day 00:00:00';

          DateTime? dateTime = DateTime.tryParse(formattedDateTimeString);

          return Transaction(
            type:
                transactionType == 'credited'
                    ? TransactionType.credited
                    : TransactionType.transferred,
            transactionAmount: double.tryParse(transactionAmount ?? '') ?? 0,
            accountNumber:
                accountNumber == null ? '' : 'Cosmos Bank $accountNumber',
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

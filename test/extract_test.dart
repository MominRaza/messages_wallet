import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/extracts/extract_axis.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
import 'package:messages_wallet/extracts/extract_cosmos.dart';
import 'package:messages_wallet/models/transaction_model.dart';

import 'test_data.dart';

void main() {
  group(
    'BOB Extract',
    () {
      test(
        'Credited',
        () {
          var transaction = extractBOBMessages([bobMessages[0]]).first;
          expect(transaction.type, equals(TransactionType.credited));
          expect(transaction.transactionAmount, equals('30'));
          expect(transaction.finalAmount, equals('92.1'));
          expect(transaction.accountNumber, equals('BoB XX7544'));
          expect(transaction.body, equals(bobMessages[0]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-08-09 22:40:20')),
          );
        },
      );

      test(
        'withdrawn',
        () {
          var transaction = extractBOBMessages([bobMessages[1]]).first;
          expect(transaction.type, equals(TransactionType.withdrawn));
          expect(transaction.transactionAmount, equals('5500'));
          expect(transaction.finalAmount, equals('496.1'));
          expect(transaction.accountNumber, equals('BoB XX7544'));
          expect(transaction.body, equals(bobMessages[1]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-11-29 16:48:04')),
          );
        },
      );

      test(
        'transferred',
        () {
          var transaction = extractBOBMessages([bobMessages[2]]).first;
          expect(transaction.type, equals(TransactionType.transferred));
          expect(transaction.transactionAmount, equals('20'));
          expect(transaction.finalAmount, equals('3352.1'));
          expect(transaction.accountNumber, equals('BoB XX7544'));
          expect(transaction.body, equals(bobMessages[2]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-10-31 21:19:22')),
          );
        },
      );
    },
  );

  group(
    'Axis Extract',
    () {
      test(
        'credited',
        () {
          var transaction = extractAxisMessages([axisMessages[0]]).first;
          expect(transaction.type, equals(TransactionType.credited));
          expect(transaction.transactionAmount, equals('42476.00'));
          expect(transaction.finalAmount, equals('65789.44'));
          expect(transaction.accountNumber, equals('Axis XX5237'));
          expect(transaction.body, equals(axisMessages[0]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-08-30 05:31:41')),
          );
        },
      );

      test(
        'Debit ATM-WDL/',
        () {
          var transaction = extractAxisMessages([axisMessages[1]]).first;
          expect(transaction.type, equals(TransactionType.withdrawn));
          expect(transaction.transactionAmount, equals('5000.00'));
          expect(transaction.finalAmount, equals('4384.44'));
          expect(transaction.accountNumber, equals('Axis XX5237'));
          expect(transaction.body, equals(axisMessages[1]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-08-31 19:15:15')),
          );
        },
      );

      test(
        'Debit UPI/',
        () {
          var transaction = extractAxisMessages([axisMessages[2]]).first;
          expect(transaction.type, equals(TransactionType.transferred));
          expect(transaction.transactionAmount, equals('435.00'));
          expect(transaction.finalAmount, isNull);
          expect(transaction.accountNumber, equals('Axis XX5237'));
          expect(transaction.body, equals(axisMessages[2]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-09-20 16:47:23')),
          );
        },
      );
    },
  );

  group(
    'Cosmos Extract',
    () {
      test(
        'Debited UPI',
        () {
          var transaction = extractCosmosMessages([cosmosMessages[0]]).first;
          expect(transaction.type, equals(TransactionType.transferred));
          expect(transaction.transactionAmount, equals('123.45'));
          expect(transaction.finalAmount, equals('3456.45'));
          expect(transaction.accountNumber, equals('Cosmos XX2345'));
          expect(transaction.body, equals(cosmosMessages[0]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-11-23 00:00:00')),
          );
        },
      );

      test(
        'Debited Cheque',
        () {
          var transaction = extractCosmosMessages([cosmosMessages[1]]).first;
          expect(transaction.type, equals(TransactionType.transferred));
          expect(transaction.transactionAmount, equals('10000'));
          expect(transaction.finalAmount, equals('4567.89'));
          expect(transaction.accountNumber, equals('Cosmos XX2345'));
          expect(transaction.body, equals(cosmosMessages[1]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-12-01 00:00:00')),
          );
        },
      );

      test(
        'Credited UPI',
        () {
          var transaction = extractCosmosMessages([cosmosMessages[2]]).first;
          expect(transaction.type, equals(TransactionType.credited));
          expect(transaction.transactionAmount, equals('123.45'));
          expect(transaction.finalAmount, equals('3456.45'));
          expect(transaction.accountNumber, equals('Cosmos XX2345'));
          expect(transaction.body, equals(cosmosMessages[2]));
          expect(
            transaction.dateTime,
            equals(DateTime.parse('2023-11-23 00:00:00')),
          );
        },
      );
    },
  );
}

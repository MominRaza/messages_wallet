import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/shared/models/spending_model.dart';
import 'package:messages_wallet/src/utils/extract_axis.dart';
import 'package:messages_wallet/src/utils/extract_bob.dart';
import 'package:messages_wallet/src/utils/extract_cosmos.dart';

import 'test_data.dart';

void main() {
  group('BOB Extract', () {
    test('Credited', () {
      var transaction = extractBOBMessages([bobMessages[0]]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 30);
      expect(transaction.finalAmount, 92.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages[0]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-08-09 22:40:20'),
      );
    });

    test('withdrawn', () {
      var transaction = extractBOBMessages([bobMessages[1]]).first;
      expect(transaction.type, TransactionType.withdrawn);
      expect(transaction.transactionAmount, 5500);
      expect(transaction.finalAmount, 496.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages[1]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-11-29 16:48:04'),
      );
    });

    test('transferred', () {
      var transaction = extractBOBMessages([bobMessages[2]]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 20);
      expect(transaction.finalAmount, 3352.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages[2]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-10-31 21:19:22'),
      );
    });
  });

  group('Axis Extract', () {
    test('credited', () {
      var transaction = extractAxisMessages([axisMessages[0]]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 42476);
      expect(transaction.finalAmount, 65789.44);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages[0]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-08-30 05:31:41'),
      );
    });

    test('Debit ATM-WDL/', () {
      var transaction = extractAxisMessages([axisMessages[1]]).first;
      expect(transaction.type, TransactionType.withdrawn);
      expect(transaction.transactionAmount, 5000);
      expect(transaction.finalAmount, 4384.44);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages[1]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-08-31 19:15:15'),
      );
    });

    test('Debit UPI/', () {
      var transaction = extractAxisMessages([axisMessages[2]]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 435);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages[2]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-09-20 16:47:23'),
      );
    });

    test('credited 2', () {
      var transaction = extractAxisMessages([axisMessages[3]]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 1000);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages[3]);
      expect(
        transaction.dateTime,
        DateTime.parse('2024-10-07 07:32:10'),
      );
    });

    test('creditCardSpent', () {
      var transaction = extractAxisMessages([axisMessages[4]]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 50);
      expect(transaction.finalAmount, 34985);
      expect(transaction.accountNumber, 'Axis Bank Credit Card 3348');
      expect(transaction.body, axisMessages[4]);
      expect(
        transaction.dateTime,
        DateTime.parse('2024-10-07 21:52:10'),
      );
    });
  });

  group('Cosmos Extract', () {
    test('Debited UPI', () {
      var transaction = extractCosmosMessages([cosmosMessages[0]]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 123.45);
      expect(transaction.finalAmount, 3456.45);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages[0]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-11-23 00:00:00'),
      );
    });

    test('Debited Cheque', () {
      var transaction = extractCosmosMessages([cosmosMessages[1]]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 10000);
      expect(transaction.finalAmount, 4567.89);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages[1]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-12-01 00:00:00'),
      );
    });

    test('Credited UPI', () {
      var transaction = extractCosmosMessages([cosmosMessages[2]]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 123.45);
      expect(transaction.finalAmount, 3456.45);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages[2]);
      expect(
        transaction.dateTime,
        DateTime.parse('2023-11-23 00:00:00'),
      );
    });
  });
}

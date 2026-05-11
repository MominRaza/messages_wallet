import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/bank_support/extractors/extract_axis.dart';
import 'package:messages_wallet/src/bank_support/extractors/extract_bob.dart';
import 'package:messages_wallet/src/bank_support/extractors/extract_cosmos.dart';
import 'package:messages_wallet/src/bank_support/extractors/extract_icici.dart';
import 'package:messages_wallet/src/bank_support/extractors/extract_kotak.dart';
import 'package:messages_wallet/src/shared/models/spending_model.dart';

import 'test_data.dart';

void main() {
  group('BOB Extract', () {
    test('Credited', () {
      var transaction = extractBOBMessages([
        bobMessages['bob_credited']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 30);
      expect(transaction.finalAmount, 92.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages['bob_credited']);
      expect(transaction.dateTime, DateTime.parse('2023-08-09 22:40:20'));
    });

    test('withdrawn', () {
      var transaction = extractBOBMessages([
        bobMessages['bob_withdrawn']!,
      ]).first;
      expect(transaction.type, TransactionType.withdrawn);
      expect(transaction.transactionAmount, 5500);
      expect(transaction.finalAmount, 496.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages['bob_withdrawn']);
      expect(transaction.dateTime, DateTime.parse('2023-11-29 16:48:04'));
    });

    test('transferred', () {
      var transaction = extractBOBMessages([
        bobMessages['bob_transferred']!,
      ]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 20);
      expect(transaction.finalAmount, 3352.1);
      expect(transaction.accountNumber, 'Bank of Baroda 7544');
      expect(transaction.body, bobMessages['bob_transferred']);
      expect(transaction.dateTime, DateTime.parse('2023-10-31 21:19:22'));
    });
  });

  group('Axis Extract', () {
    test('credited', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_credited']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 42476);
      expect(transaction.finalAmount, 65789.44);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages['axis_credited']);
      expect(transaction.dateTime, DateTime.parse('2023-08-30 05:31:41'));
    });

    test('Debit ATM-WDL/', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_withdrawn']!,
      ]).first;
      expect(transaction.type, TransactionType.withdrawn);
      expect(transaction.transactionAmount, 5000);
      expect(transaction.finalAmount, 4384.44);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages['axis_withdrawn']);
      expect(transaction.dateTime, DateTime.parse('2023-08-31 19:15:15'));
    });

    test('Debit UPI/', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_transferred']!,
      ]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 435);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages['axis_transferred']);
      expect(transaction.dateTime, DateTime.parse('2023-09-20 16:47:23'));
    });

    test('credited 2', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_credited2']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 1000);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'Axis Bank 5237');
      expect(transaction.body, axisMessages['axis_credited2']);
      expect(transaction.dateTime, DateTime.parse('2024-10-07 07:32:10'));
    });

    test('creditCardSpent', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_creditCardSpent']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 50);
      expect(transaction.finalAmount, 34985);
      expect(transaction.accountNumber, 'Axis Bank Credit Card 3348');
      expect(transaction.body, axisMessages['axis_creditCardSpent']);
      expect(transaction.dateTime, DateTime.parse('2024-10-07 21:52:10'));
    });

    test('creditCardReversed transaction', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_creditCardReversed']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardReversed);
      expect(transaction.transactionAmount, 1);
      expect(transaction.finalAmount, 97678.37);
      expect(transaction.accountNumber, 'Axis Bank Credit Card 4257');
      expect(transaction.body, axisMessages['axis_creditCardReversed']);
      expect(transaction.dateTime, DateTime.parse('2025-03-15 15:10:22'));
    });
  });

  group('Cosmos Extract', () {
    test('Debited UPI', () {
      var transaction = extractCosmosMessages([
        cosmosMessages['cosmos_debited_upi']!,
      ]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 123.45);
      expect(transaction.finalAmount, 3456.45);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages['cosmos_debited_upi']);
      expect(transaction.dateTime, DateTime.parse('2023-11-23 00:00:00'));
    });

    test('Debited Cheque', () {
      var transaction = extractCosmosMessages([
        cosmosMessages['cosmos_debited_cheque']!,
      ]).first;
      expect(transaction.type, TransactionType.transferred);
      expect(transaction.transactionAmount, 10000);
      expect(transaction.finalAmount, 4567.89);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages['cosmos_debited_cheque']);
      expect(transaction.dateTime, DateTime.parse('2023-12-01 00:00:00'));
    });

    test('Credited UPI', () {
      var transaction = extractCosmosMessages([
        cosmosMessages['cosmos_credited_upi']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 123.45);
      expect(transaction.finalAmount, 3456.45);
      expect(transaction.accountNumber, 'Cosmos Bank 2345');
      expect(transaction.body, cosmosMessages['cosmos_credited_upi']);
      expect(transaction.dateTime, DateTime.parse('2023-11-23 00:00:00'));
    });
  });

  group('ICICI Extract', () {
    test('spent using Card (INR)', () {
      var transaction = extractICICIMessages([
        iciciMessages['icici_spent']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 1607.55);
      expect(transaction.finalAmount, 48392.45);
      expect(transaction.accountNumber, 'ICICI Bank Credit Card 7004');
      expect(transaction.body, iciciMessages['icici_spent']);
      expect(transaction.dateTime, DateTime.parse('2025-02-26 00:00:00'));
    });

    test('reversed', () {
      var transaction = extractICICIMessages([
        iciciMessages['icici_reversed']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardReversed);
      expect(transaction.transactionAmount, 1.00);
      expect(transaction.finalAmount, 46844.45);
      expect(transaction.accountNumber, 'ICICI Bank Credit Card 7004');
      expect(transaction.body, iciciMessages['icici_reversed']);
      expect(transaction.dateTime, DateTime.parse('2025-03-15 15:07:29'));
    });

    test('debited', () {
      var transaction = extractICICIMessages([
        iciciMessages['icici_debited']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 50.00);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'ICICI Bank Credit Card 5005');
      expect(transaction.body, iciciMessages['icici_debited']);
      expect(transaction.dateTime, DateTime.parse('2025-03-15 00:00:00'));
    });

    test('spent on Card (Rs)', () {
      var transaction = extractICICIMessages([
        iciciMessages['icici_spent_rs']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 5000.00);
      expect(transaction.finalAmount, 41794.45);
      expect(transaction.accountNumber, 'ICICI Bank Credit Card 5005');
      expect(transaction.body, iciciMessages['icici_spent_rs']);
      expect(transaction.dateTime, DateTime.parse('2025-03-24 00:00:00'));
    });

    test('payment received', () {
      var transaction = extractICICIMessages([
        iciciMessages['icici_payment']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 3155.55);
      expect(transaction.finalAmount, isNull);
      expect(transaction.accountNumber, 'ICICI Bank Credit Card 7004');
      expect(transaction.body, iciciMessages['icici_payment']);
      expect(transaction.dateTime, DateTime.parse('2025-03-28 00:00:00'));
    });
  });

  group('Defect #10: Single digit after decimal', () {
    test('BOB single digit decimal', () {
      var transaction = extractBOBMessages([
        bobMessages['bob_single_decimal']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 100.1);
      expect(transaction.finalAmount, 200.1);
      expect(transaction.accountNumber, 'Bank of Baroda 1234');
      expect(transaction.body, bobMessages['bob_single_decimal']);
      expect(transaction.dateTime, DateTime.parse('2025-05-10 10:10:10'));
    });
    test('Axis single digit decimal', () {
      var transaction = extractAxisMessages([
        axisMessages['axis_single_decimal']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 100.1);
      expect(transaction.finalAmount, 200.1);
      expect(transaction.accountNumber, 'Axis Bank 5678');
      expect(transaction.body, axisMessages['axis_single_decimal']);
      expect(transaction.dateTime, DateTime.parse('2025-05-10 10:10:10'));
    });
    test('Cosmos single digit decimal', () {
      var transaction = extractCosmosMessages([
        cosmosMessages['cosmos_single_decimal']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 100.1);
      expect(transaction.finalAmount, 200.1);
      expect(transaction.accountNumber, 'Cosmos Bank 9999');
      expect(transaction.body, cosmosMessages['cosmos_single_decimal']);
      expect(transaction.dateTime, DateTime.parse('2025-05-10 00:00:00'));
    });
  });

  group('Kotak Extract', () {
    test('spent (VM-KOTAKB)', () {
      var transaction = extractKotakMessages([
        kotakMessages['kotak_spent_vm']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 500);
      expect(transaction.finalAmount, 29500);
      expect(transaction.accountNumber, 'Kotak Bank Credit Card 6746');
      expect(transaction.body, kotakMessages['kotak_spent_vm']);
      expect(transaction.dateTime, DateTime.parse('2025-04-27 00:00:00'));
    });

    test('payment credited (AD-KOTAKB)', () {
      var transaction = extractKotakMessages([
        kotakMessages['kotak_payment']!,
      ]).first;
      expect(transaction.type, TransactionType.credited);
      expect(transaction.transactionAmount, 1606.4);
      expect(transaction.finalAmount, 30000);
      expect(transaction.accountNumber, 'Kotak Bank Credit Card 6746');
      expect(transaction.body, kotakMessages['kotak_payment']);
      expect(transaction.dateTime, DateTime.parse('2025-03-29 00:00:00'));
    });

    test('spent (AD-KOTAKB)', () {
      var transaction = extractKotakMessages([
        kotakMessages['kotak_spent_ad']!,
      ]).first;
      expect(transaction.type, TransactionType.creditCardSpent);
      expect(transaction.transactionAmount, 1600);
      expect(transaction.finalAmount, 28400);
      expect(transaction.accountNumber, 'Kotak Bank Credit Card 6746');
      expect(transaction.body, kotakMessages['kotak_spent_ad']);
      expect(transaction.dateTime, DateTime.parse('2025-02-27 00:00:00'));
    });
  });
}

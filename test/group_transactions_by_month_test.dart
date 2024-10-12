import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/shared/models/spending_model.dart';
import 'package:messages_wallet/src/utils/group_transactions_by_month.dart';

void main() {
  group('groupTransactionsByMonth', () {
    group('given 1 transaction', () {
      late List<Spending> result;

      setUp(() {
        List<Transaction> transactions = [
          Transaction(
            dateTime: DateTime(2023, 1, 15),
            transactionAmount: 1000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Salary',
          ),
        ];

        result = groupTransactionsByMonth(transactions);
      });

      test('should be a list of 2 items', () {
        expect(result.length, 2);
      });

      test('should have monthly spending at index 0', () {
        expect(result[0], isA<MonthlySpending>());
        expect((result[0] as MonthlySpending).monthYear, 'January 2023');
        expect((result[0] as MonthlySpending).totalCredit, 1000);
        expect((result[0] as MonthlySpending).totalDebit, 0);
      });

      test('should have transactions at index 1', () {
        expect(result[1], isA<Transaction>());
        expect((result[1] as Transaction).transactionAmount, 1000);
      });
    });

    group('given 2 transactions of a month', () {
      late List<Spending> result;

      setUp(() {
        List<Transaction> transactions = [
          Transaction(
            dateTime: DateTime(2023, 1, 15),
            transactionAmount: 1000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Salary',
          ),
          Transaction(
            dateTime: DateTime(2023, 1, 20),
            transactionAmount: 500,
            type: TransactionType.withdrawn,
            accountNumber: '123456',
            body: 'Groceries',
          ),
        ];

        result = groupTransactionsByMonth(transactions);
      });

      test('should be a list of 3 items', () {
        expect(result.length, 3);
      });

      test('should have monthly spending at index 0', () {
        expect(result[0], isA<MonthlySpending>());
        expect((result[0] as MonthlySpending).monthYear, 'January 2023');
        expect((result[0] as MonthlySpending).totalCredit, 1000);
        expect((result[0] as MonthlySpending).totalDebit, 500);
      });

      test('should have transactions at index 1', () {
        expect(result[1], isA<Transaction>());
        expect((result[1] as Transaction).transactionAmount, 500);
      });

      test('should have transactions at index 2', () {
        expect(result[2], isA<Transaction>());
        expect((result[2] as Transaction).transactionAmount, 1000);
      });
    });

    group('given 2 transactions of 2 months', () {
      late List<Spending> result;

      setUp(() {
        List<Transaction> transactions = [
          Transaction(
            dateTime: DateTime(2023, 1, 15),
            transactionAmount: 1000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Salary',
          ),
          Transaction(
            dateTime: DateTime(2023, 2, 10),
            transactionAmount: 2000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Freelance',
          ),
        ];

        result = groupTransactionsByMonth(transactions);
      });

      test('should be a list of 4 items', () {
        expect(result.length, 4);
      });

      test('should have monthly spending at index 0', () {
        expect(result[0], isA<MonthlySpending>());
        expect((result[0] as MonthlySpending).monthYear, 'February 2023');
        expect((result[0] as MonthlySpending).totalCredit, 2000);
        expect((result[0] as MonthlySpending).totalDebit, 0);
      });

      test('should have transactions at index 1', () {
        expect(result[1], isA<Transaction>());
        expect((result[1] as Transaction).transactionAmount, 2000);
      });

      test('should have monthly spending at index 2', () {
        expect(result[2], isA<MonthlySpending>());
        expect((result[2] as MonthlySpending).monthYear, 'January 2023');
        expect((result[2] as MonthlySpending).totalCredit, 1000);
        expect((result[2] as MonthlySpending).totalDebit, 0);
      });

      test('should have transactions at index 3', () {
        expect(result[3], isA<Transaction>());
        expect((result[3] as Transaction).transactionAmount, 1000);
      });
    });

    group('given 3 transactions of 2 months', () {
      late List<Spending> result;

      setUp(() {
        List<Transaction> transactions = [
          Transaction(
            dateTime: DateTime(2023, 1, 15),
            transactionAmount: 1000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Salary',
          ),
          Transaction(
            dateTime: DateTime(2023, 1, 20),
            transactionAmount: 500,
            type: TransactionType.withdrawn,
            accountNumber: '123456',
            body: 'Groceries',
          ),
          Transaction(
            dateTime: DateTime(2023, 2, 10),
            transactionAmount: 2000,
            type: TransactionType.credited,
            accountNumber: '123456',
            body: 'Freelance',
          ),
        ];

        result = groupTransactionsByMonth(transactions);
      });

      test('should be a list of 5 items', () {
        expect(result.length, 5);
      });

      test('should have monthly spending at index 0', () {
        expect(result[0], isA<MonthlySpending>());
        expect((result[0] as MonthlySpending).monthYear, 'February 2023');
        expect((result[0] as MonthlySpending).totalCredit, 2000);
        expect((result[0] as MonthlySpending).totalDebit, 0);
      });

      test('should have transactions at index 1', () {
        expect(result[1], isA<Transaction>());
        expect((result[1] as Transaction).transactionAmount, 2000);
      });

      test('should have monthly spending at index 2', () {
        expect(result[2], isA<MonthlySpending>());
        expect((result[2] as MonthlySpending).monthYear, 'January 2023');
        expect((result[2] as MonthlySpending).totalCredit, 1000);
        expect((result[2] as MonthlySpending).totalDebit, 500);
      });

      test('should have transactions at index 3', () {
        expect(result[3], isA<Transaction>());
        expect((result[3] as Transaction).transactionAmount, 500);
      });

      test('should have transactions at index 4', () {
        expect(result[4], isA<Transaction>());
        expect((result[4] as Transaction).transactionAmount, 1000);
      });
    });

    test('should handle empty list of transactions correctly', () {
      List<Transaction> transactions = [];

      List<Spending> result = groupTransactionsByMonth(transactions);

      expect(result, isEmpty);
    });
  });
}

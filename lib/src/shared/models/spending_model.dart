enum TransactionType {
  credited,
  withdrawn,
  transferred,
  creditCardSpent,
  creditCardReversed,
}

abstract class Spending {}

class Transaction implements Spending {
  TransactionType type;
  double transactionAmount;
  String accountNumber;
  String body;
  DateTime dateTime;
  double? finalAmount;

  Transaction({
    required this.type,
    required this.transactionAmount,
    required this.accountNumber,
    required this.body,
    required this.dateTime,
    this.finalAmount,
  });
}

class MonthlySpending implements Spending {
  final String monthYear;
  final double totalCredit;
  final double totalDebit;

  double get totalAmount => totalCredit - totalDebit;
  String get month => monthYear.split(' ')[0];
  String get year => monthYear.split(' ')[1];

  MonthlySpending({
    required this.monthYear,
    required this.totalCredit,
    required this.totalDebit,
  });
}

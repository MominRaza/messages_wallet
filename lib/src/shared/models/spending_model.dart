enum TransactionType { credited, withdrawn, transferred, creditCardSpent }

abstract class Spending {}

class Transaction implements Spending {
  TransactionType type;
  String transactionAmount;
  String accountNumber;
  String body;
  DateTime dateTime;
  String? finalAmount;

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
  final String month;
  final double totalCredit;
  final double totalDebit;

  MonthlySpending({
    required this.month,
    required this.totalCredit,
    required this.totalDebit,
  });
}

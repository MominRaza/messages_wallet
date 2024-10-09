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

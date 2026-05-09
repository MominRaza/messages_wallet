enum TransactionType {
  credited,
  withdrawn,
  transferred,
  creditCardSpent,
  creditCardReversed,
}

class Transaction {
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
enum TransactionType { credited, withdrawn, transferred, creditCardSpent }

class Transaction {
  TransactionType type;
  String? transactionAmount;
  String? finalAmount;
  String? accountNumber;
  String? body;
  DateTime? dateTime;

  Transaction({
    required this.type,
    this.transactionAmount,
    this.finalAmount,
    this.accountNumber,
    this.body,
    this.dateTime,
  });
}

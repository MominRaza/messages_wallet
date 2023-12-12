enum TransactionType { credited, withdrawn, transferred }

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

  @override
  String toString() {
    return '''
  Type: $type
  Transaction Amount: $transactionAmount
  Final Amount: $finalAmount
  Account Number: $accountNumber
  Body: $body
  Date and Time: $dateTime
''';
  }
}

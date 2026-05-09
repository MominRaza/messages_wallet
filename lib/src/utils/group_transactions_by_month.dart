import 'package:intl/intl.dart';
import '../shared/models/spending_model.dart';

class TransactionGroup {
  final String monthYear;
  final DateTime date;
  final List<Transaction> transactions;
  
  double get totalCredit => transactions
      .where((t) => t.type == TransactionType.credited || t.type == TransactionType.creditCardReversed)
      .fold(0, (sum, t) => sum + t.transactionAmount);
  
  double get totalDebit => transactions
      .where((t) => t.type != TransactionType.credited && t.type != TransactionType.creditCardReversed)
      .fold(0, (sum, t) => sum + t.transactionAmount);
  
  double get totalAmount => totalCredit - totalDebit;
  
  String get month => monthYear.split(' ')[0];
  String get year => monthYear.split(' ')[1];
  
  TransactionGroup({
    required this.monthYear,
    required this.date,
    required this.transactions,
  });
}

List<TransactionGroup> groupTransactionsByMonth(List<Transaction> transactions) {
  final Map<String, TransactionGroup> groups = {};
  
  for (var transaction in transactions) {
    final monthYear = DateFormat('MMMM yyyy').format(transaction.dateTime);
    final date = DateTime(transaction.dateTime.year, transaction.dateTime.month);
    
    if (!groups.containsKey(monthYear)) {
      groups[monthYear] = TransactionGroup(
        monthYear: monthYear,
        date: date,
        transactions: [],
      );
    }
    
    groups[monthYear]!.transactions.add(transaction);
  }
  
  final sortedGroups = groups.values.toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  for (var group in sortedGroups) {
    group.transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
  
  return sortedGroups;
}
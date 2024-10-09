import '../../shared/models/transaction_model.dart';

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

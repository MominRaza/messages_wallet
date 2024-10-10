import 'package:intl/intl.dart';

import '../shared/models/spending_model.dart';

List<Spending> groupTransactionsByMonth(List<Transaction> transactions) {
  List<Spending> items = [];
  String? runningMonth;
  double runningMonthCredit = 0;
  double runningMonthDebit = 0;

  for (var transaction in transactions) {
    String month = DateFormat('MMMM yyyy').format(transaction.dateTime);
    double amount = double.tryParse(transaction.transactionAmount) ?? 0;

    runningMonth ??= month;

    if (runningMonth == month) {
      items.add(transaction);

      if (transaction.type == TransactionType.credited) {
        runningMonthCredit += amount;
      } else {
        runningMonthDebit += amount;
      }
    }

    if (runningMonth != month) {
      items.add(
        MonthlySpending(
          month: runningMonth,
          totalCredit: runningMonthCredit,
          totalDebit: runningMonthDebit,
        ),
      );

      items.add(transaction);

      runningMonth = month;

      if (transaction.type == TransactionType.credited) {
        runningMonthCredit = amount;
        runningMonthDebit = 0;
      } else {
        runningMonthCredit = 0;
        runningMonthDebit = amount;
      }
    }

    if (transaction == transactions.last) {
      items.add(
        MonthlySpending(
          month: runningMonth,
          totalCredit: runningMonthCredit,
          totalDebit: runningMonthDebit,
        ),
      );
    }
  }

  return items.reversed.toList();
}

import 'package:intl/intl.dart';

import '../account/models/monthly_spending_model.dart';
import '../shared/models/transaction_model.dart';

List<dynamic> groupTransactionsByMonth(List<Transaction> transactions) {
  List<dynamic> items = [];
  String? currentMonth;
  double totalCredit = 0;
  double totalDebit = 0;
  double previousTotalCredit = 0;
  double previousTotalDebit = 0;

  for (var transaction in transactions) {
    String month = DateFormat('MMMM yyyy').format(transaction.dateTime);

    double amount = double.tryParse(transaction.transactionAmount) ?? 0;
    if (transaction.type == TransactionType.credited) {
      totalCredit += amount;
    } else {
      totalDebit += amount;
    }

    if (currentMonth != null && currentMonth != month) {
      items.add(
        MonthlySpending(
          month: currentMonth,
          totalCredit: previousTotalCredit,
          totalDebit: previousTotalDebit,
        ),
      );

      if (transaction.type == TransactionType.credited) {
        totalCredit = amount;
        totalDebit = 0;
      } else {
        totalCredit = 0;
        totalDebit = amount;
      }
    }

    previousTotalCredit = totalCredit;
    previousTotalDebit = totalDebit;

    items.add(transaction);

    if (currentMonth != null && transaction == transactions.last) {
      items.add(
        MonthlySpending(
          month: currentMonth,
          totalCredit: totalCredit,
          totalDebit: totalDebit,
        ),
      );
    }

    currentMonth = month;
  }

  return items.reversed.toList();
}

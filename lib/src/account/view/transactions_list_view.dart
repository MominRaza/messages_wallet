import 'package:flutter/material.dart';

import '../../shared/models/spending_model.dart';
import 'monthly_spending_list_item.dart';
import 'transactions_list_item.dart';

class TransactionsListView extends StatelessWidget {
  const TransactionsListView({
    required this.transactions,
    super.key,
  });

  final List<Spending> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int i) {
        var transaction = transactions[i];

        return transaction is Transaction
            ? TransactionListItem(transaction: transaction)
            : transaction is MonthlySpending
                ? MonthlySpendingListItem(monthlySpending: transaction)
                : null;
      },
    );
  }
}

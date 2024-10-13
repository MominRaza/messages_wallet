import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../shared/models/spending_model.dart';
import '../../utils/group_transactions_by_month.dart';
import 'monthly_spending_list_item.dart';
import 'transactions_list_item.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen(
      {required this.transactions, required this.title, super.key});

  final String title;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final spends = groupTransactionsByMonth(transactions);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: spends.length,
        itemBuilder: (BuildContext context, int i) {
          var spending = spends[i];

          return spending is Transaction
              ? TransactionListItem(transaction: spending)
              : spending is MonthlySpending
                  ? MonthlySpendingListItem(monthlySpending: spending)
                  : null;
        },
      ),
    );
  }
}

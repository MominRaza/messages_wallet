import 'package:flutter/material.dart';

import '../../shared/models/spending_model.dart';
import '../../utils/currency.dart';

class MonthlySpendingListItem extends StatelessWidget {
  const MonthlySpendingListItem({required this.monthlySpending, super.key});

  final MonthlySpending monthlySpending;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      collapsedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(monthlySpending.month),
      trailing: Text(
        monthlySpending.totalCredit > monthlySpending.totalDebit
            ? '${currencyFormat(
                (monthlySpending.totalCredit - monthlySpending.totalDebit)
                    .toString(),
              )}'
            : '- ${currencyFormat(
                (monthlySpending.totalDebit - monthlySpending.totalCredit)
                    .toString(),
              )}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      visualDensity: VisualDensity.compact,
      expandedAlignment: Alignment.centerRight,
      childrenPadding: const EdgeInsets.fromLTRB(16, 8, 24, 12),
      shape: const Border(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Credit:'),
            Text(
              '${currencyFormat(monthlySpending.totalCredit.toString())}',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Debit:'),
            Text(
              '- ${currencyFormat(monthlySpending.totalDebit.toString())}',
            ),
          ],
        ),
      ],
    );
  }
}

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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthlySpending.year,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            monthlySpending.month,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      trailing: Text(
        currencyFormat(monthlySpending.totalAmount),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      visualDensity: VisualDensity.compact,
      expandedAlignment: Alignment.centerRight,
      childrenPadding: const EdgeInsets.only(top: 8, bottom: 12),
      shape: const Border(),
      children: [
        SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.only(left: 16, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Credit:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    'Total Debit:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat(monthlySpending.totalCredit),
                  ),
                  Text(
                    currencyFormat(monthlySpending.totalDebit * -1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

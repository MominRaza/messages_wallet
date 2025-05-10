import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/currency.dart';
import '../../utils/date_time.dart';
import '../../utils/final_balance.dart';
import 'card_view.dart';

class BankCardView extends StatelessWidget {
  const BankCardView({required this.entry, super.key});

  final MapEntry<String, List<Transaction>> entry;

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: entry.key,
      description: finalBalance(
        entry.value.last.type,
        entry.value.last.finalAmount,
      ),
      transactions: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transactions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var transaction in entry.value.reversed.take(3))
                    Text(formatDateTime(transaction.dateTime)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var transaction in entry.value.reversed.take(3))
                    Text(
                      currencyFormat(
                        transaction.transactionAmount *
                            (transaction.type == TransactionType.credited
                                ? 1
                                : -1),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed:
              () => context.router.push(
                AccountRoute(title: entry.key, transactions: entry.value),
              ),
          child: const Text('View All'),
        ),
      ],
    );
  }
}

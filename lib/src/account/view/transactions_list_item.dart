import 'package:flutter/material.dart';

import '../../shared/models/spending_model.dart';
import '../../shared/view/link_text.dart';
import '../../utils/currency.dart';
import '../../utils/date_time.dart';
import '../../utils/final_balance.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({required this.transaction, super.key});

  final Transaction transaction;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  bool _isExpended = false;

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;

    return Card(
      clipBehavior: _isExpended ? Clip.hardEdge : null,
      elevation: _isExpended ? null : 0,
      margin: _isExpended ? const EdgeInsets.all(8) : EdgeInsets.zero,
      color: _isExpended ? null : Colors.transparent,
      child: ExpansionTile(
        shape: const Border(),
        onExpansionChanged: (value) => setState(() => _isExpended = value),
        leading: CircleAvatar(
          backgroundColor: switch (transaction.type) {
            TransactionType.credited =>
              Theme.of(context).brightness == Brightness.light
                  ? Colors.greenAccent
                  : Colors.green,
            TransactionType.transferred || TransactionType.creditCardSpent =>
              Theme.of(context).colorScheme.errorContainer,
            TransactionType.withdrawn => null,
          },
          child: Icon(switch (transaction.type) {
            TransactionType.credited => Icons.south_west,
            TransactionType.transferred => Icons.north_east,
            TransactionType.withdrawn => Icons.money_rounded,
            TransactionType.creditCardSpent => Icons.credit_card_rounded,
          }),
        ),
        title: Text(formatDateTime(transaction.dateTime)),
        subtitle: Text(finalBalance(transaction.type, transaction.finalAmount)),
        trailing: Text(
          currencyFormat(
            transaction.transactionAmount *
                (transaction.type == TransactionType.credited ? 1 : -1),
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        childrenPadding: const EdgeInsets.only(top: 8, bottom: 12),
        expandedAlignment: Alignment.centerLeft,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            minimum: const EdgeInsets.only(left: 16, right: 24),
            child: LinkText(transaction.body),
          ),
        ],
      ),
    );
  }
}

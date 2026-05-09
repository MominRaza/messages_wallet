// ignore_for_file: deprecated_member_use

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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (c, v, child) => Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child)),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: _isExpanded ? 2 : 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
        child: ExpansionTile(
          shape: const Border(),
          onExpansionChanged: (v) => setState(() => _isExpanded = v),
          leading: CircleAvatar(
            backgroundColor: _getBgColor(t.type, context),
            radius: 20,
            child: Icon(_getIcon(t.type), size: 20, color: _getIconColor(t.type, context)),
          ),
          title: Text(formatDateTime(t.dateTime), style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(finalBalance(t.type, t.finalAmount), style: Theme.of(context).textTheme.bodySmall),
          trailing: Text(currencyFormat(t.transactionAmount, t.type), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _getAmountColor(t.type))),
          childrenPadding: const EdgeInsets.all(16),
          expandedAlignment: Alignment.centerLeft,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
              child: LinkText(t.body),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBgColor(TransactionType t, BuildContext c) => switch (t) {
    TransactionType.credited || TransactionType.creditCardReversed => Colors.green.withOpacity(0.1),
    TransactionType.transferred || TransactionType.creditCardSpent => Colors.orange.withOpacity(0.1),
    TransactionType.withdrawn => Colors.red.withOpacity(0.1),
  };

  IconData _getIcon(TransactionType t) => switch (t) {
    TransactionType.credited => Icons.arrow_downward,
    TransactionType.transferred => Icons.arrow_upward,
    TransactionType.withdrawn => Icons.money_off,
    TransactionType.creditCardSpent => Icons.credit_card,
    TransactionType.creditCardReversed => Icons.undo,
  };

  Color _getIconColor(TransactionType t, BuildContext c) => switch (t) {
    TransactionType.credited || TransactionType.creditCardReversed => Colors.green,
    TransactionType.transferred || TransactionType.creditCardSpent => Colors.orange,
    TransactionType.withdrawn => Colors.red,
  };

  Color _getAmountColor(TransactionType t) => switch (t) {
    TransactionType.credited || TransactionType.creditCardReversed => Colors.green,
    _ => Colors.red,
  };
}
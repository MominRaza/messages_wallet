import 'package:flutter/material.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:messages_wallet/utils/utils.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  bool _isExpended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _isExpended ? null : 0,
      margin: _isExpended ? const EdgeInsets.all(8) : EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        onExpansionChanged: (value) => setState(() => _isExpended = value),
        leading: CircleAvatar(
          backgroundColor: switch (widget.transaction.type) {
            TransactionType.credited => Colors.greenAccent,
            TransactionType.transferred => Colors.redAccent,
            TransactionType.withdrawn => null,
          },
          child: Icon(
            switch (widget.transaction.type) {
              TransactionType.credited => Icons.south_west,
              TransactionType.transferred => Icons.north_east,
              TransactionType.withdrawn => Icons.arrow_downward,
            },
          ),
        ),
        title: Text(
          widget.transaction.dateTime != null
              ? formatDateTime(widget.transaction.dateTime!)
              : 'null',
        ),
        subtitle: Text(
          'Total Bal: ${widget.transaction.finalAmount ?? 'N/A'}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${widget.transaction.type == 'Credited' ? '+' : '-'} ${widget.transaction.transactionAmount}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text('${widget.transaction.body}'),
          ),
        ],
      ),
    );
  }
}

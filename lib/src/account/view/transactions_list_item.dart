import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String _formatTransaction(Transaction t) {
    final buf = StringBuffer();
    buf.writeln('---');
    buf.writeln(t.body);
    buf.writeln('===');
    buf.writeln('Extracted Data:');
    buf.writeln('Type: ${t.type.name}');
    buf.writeln('Amount: ${currencyFormat(t.transactionAmount, t.type)}');
    buf.writeln('Account: ${t.accountNumber}');
    buf.writeln('Date: ${formatDateTime(t.dateTime)}');
    buf.writeln('Final Balance: ${finalBalance(t.type, t.finalAmount)}');
    return buf.toString().trim();
  }

  void _copy() {
    final formatted = _formatTransaction(widget.transaction);
    log(formatted);
    Clipboard.setData(ClipboardData(text: formatted));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Copied to clipboard'),
      ),
    );
  }

  void _email() {
    final formatted = _formatTransaction(widget.transaction);
    const recipient = 'mominraza.dev@gmail.com';
    final subject = Uri.encodeComponent('Incorrect Extraction Report');
    final body = Uri.encodeComponent(formatted);
    launchUrl(Uri.parse('mailto:$recipient?subject=$subject&body=$body'));
  }

  void _showContextMenu(BuildContext context, LongPressStartDetails details) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu<void>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          onTap: _copy,
          child: const ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          onTap: _email,
          child: const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Report via Email'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;

    return GestureDetector(
      onLongPressStart: (details) => _showContextMenu(context, details),
      child: Card(
        clipBehavior: _isExpended ? Clip.hardEdge : null,
        elevation: _isExpended ? null : 0,
        margin: _isExpended ? const EdgeInsets.all(8) : EdgeInsets.zero,
        color: _isExpended ? null : Colors.transparent,
        child: ExpansionTile(
          shape: const Border(),
          onExpansionChanged: (value) => setState(() => _isExpended = value),
          leading: CircleAvatar(
            backgroundColor: switch (transaction.type) {
              TransactionType.credited || TransactionType.creditCardReversed =>
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
              TransactionType.creditCardReversed => Icons.undo,
            }),
          ),
          title: Text(formatDateTime(transaction.dateTime)),
          subtitle: Text(
            finalBalance(transaction.type, transaction.finalAmount),
          ),
          trailing: Text(
            currencyFormat(transaction.transactionAmount, transaction.type),
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
      ),
    );
  }
}

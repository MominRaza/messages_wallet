import 'package:flutter/material.dart';
import 'package:messages_wallet/components/transactions_list_item.dart';
import 'package:messages_wallet/models/transaction_model.dart';

class TransactionsListView extends StatelessWidget {
  const TransactionsListView({
    super.key,
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int i) {
        var transaction = transactions[i];

        return TransactionListItem(transaction: transaction);
      },
    );
  }
}

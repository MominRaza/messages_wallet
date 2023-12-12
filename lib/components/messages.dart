import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/components/messages_list_view.dart';
import 'package:messages_wallet/components/transactions_list_view.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:messages_wallet/utils/flags.dart';

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.axisMessages,
    required this.bobMessages,
    required this.transactionsGroup,
  });
  final Iterable<SmsMessage> axisMessages;
  final Iterable<SmsMessage> bobMessages;
  final Map<String, List<Transaction>> transactionsGroup;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: transactionsGroup.length + (isDebug ? 2 : 0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages Wallet'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              if (isDebug) ...[
                const Tab(
                  child: Text('Bank of Baroda'),
                ),
                const Tab(
                  child: Text('Axis Bank'),
                ),
              ],
              ...transactionsGroup.entries.map(
                (entry) => Tab(
                  child: Text(entry.key),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (isDebug) ...[
              bobMessages.isNotEmpty
                  ? MessagesListView(
                      messages: bobMessages,
                    )
                  : Center(
                      child: Text(
                        'No messages to show.',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
              axisMessages.isNotEmpty
                  ? MessagesListView(
                      messages: axisMessages,
                    )
                  : Center(
                      child: Text(
                        'No messages to show.',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
            ...transactionsGroup.entries.map(
              (entry) => TransactionsListView(
                transactions: entry.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

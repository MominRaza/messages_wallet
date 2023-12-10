import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/models/transaction_model.dart';

class Messages extends StatelessWidget {
  const Messages(
      {super.key,
      required this.axisMessages,
      required this.bobMessages,
      required this.bobTransactions});
  final List<SmsMessage> axisMessages;
  final List<SmsMessage> bobMessages;
  final List<Transaction> bobTransactions;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Bank of Baroda'),
              ),
              Tab(
                child: Text('BOB'),
              ),
              Tab(
                child: Text('Axis Bank'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            bobMessages.isNotEmpty
                ? _MessagesListView(
                    messages: bobMessages,
                  )
                : Center(
                    child: Text(
                      'No messages to show.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
            bobTransactions.isNotEmpty
                ? _TransactionsListView(
                    transactions: bobTransactions,
                  )
                : Center(
                    child: Text(
                      'No transactions to show.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
            axisMessages.isNotEmpty
                ? _MessagesListView(
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
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    required this.messages,
  });

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];
        print(message.body?.replaceAll('\n', ' '));

        return ListTile(
          title: Text('${message.sender} [${message.date}] ${message.address}'),
          subtitle: Text(
            '${message.body?.trim()}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _TransactionsListView extends StatelessWidget {
  const _TransactionsListView({
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int i) {
        var message = transactions[i];

        return ListTile(
          title: Text(
              '${message.accountNumber} ${message.type} ${message.transactionAmount}'),
          subtitle: Text(
            message.finalAmount,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

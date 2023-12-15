import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/components/messages_list_view.dart';
import 'package:messages_wallet/components/transactions_list_view.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:messages_wallet/utils/flags.dart';
import 'package:url_launcher/url_launcher.dart';

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.allMessages,
    required this.transactionsGroup,
  });
  final Iterable<SmsMessage> allMessages;
  final Map<String, List<Transaction>> transactionsGroup;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: transactionsGroup.length + (isDebug ? 1 : 0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages Wallet'),
          actions: [
            IconButton(
              onPressed: () {
                launchUrl(
                  Uri.https(
                    'github.com',
                    '/MominRaza/messages_wallet',
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              if (isDebug) ...[
                const Tab(
                  child: Text('Debug'),
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
        body: transactionsGroup.isEmpty && !isDebug
            ? Center(
                child: Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      'No messages to show',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Are your bank messages not displaying? Please, raise an issue on our GitHub page.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'When reporting, include sample messages and the sender\'s address from your bank. Remember to remove any sensitive information first!',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        launchUrl(
                          Uri.https(
                            'github.com',
                            '/MominRaza/messages_wallet/issues',
                          ),
                        );
                      },
                      child: const Text('Create an issue'),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              )
            : TabBarView(
                children: [
                  if (isDebug) ...[
                    allMessages.isNotEmpty
                        ? MessagesListView(
                            messages: allMessages,
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

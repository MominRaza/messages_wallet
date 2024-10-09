import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../account/view/transactions_list_view.dart';
import '../../debug/view/messages_list_view.dart';
import '../../shared/models/transaction_model.dart';
import '../../utils/flags.dart';

enum MoreMenuOption {
  openGitHub,
  settings,
  about,
}

class Messages extends StatelessWidget {
  const Messages({
    required this.allMessages,
    required this.transactionsGroup,
    super.key,
  });
  final Iterable<SmsMessage> allMessages;
  final Map<String, List<Spending>> transactionsGroup;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: transactionsGroup.length + (isDebug ? 1 : 0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages Wallet'),
          actions: <Widget>[
            PopupMenuButton<MoreMenuOption>(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<MoreMenuOption>>[
                  const PopupMenuItem<MoreMenuOption>(
                    value: MoreMenuOption.openGitHub,
                    child: Text('Open GitHub'),
                  ),
                  const PopupMenuItem<MoreMenuOption>(
                    value: MoreMenuOption.settings,
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<MoreMenuOption>(
                    value: MoreMenuOption.about,
                    child: Text('About'),
                  ),
                ];
              },
              onSelected: (MoreMenuOption value) {
                switch (value) {
                  case MoreMenuOption.openGitHub:
                    launchUrl(
                      Uri.https('github.com', '/MominRaza/messages_wallet'),
                    );
                    break;
                  case MoreMenuOption.settings:
                    Navigator.pushNamed(context, '/settings');
                    break;
                  case MoreMenuOption.about:
                    launchUrl(Uri.https('mominraza.dev', '/messages_wallet'));
                    break;
                }
              },
              icon: const Icon(Icons.more_vert),
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
                            "When reporting, include sample messages and the sender's address from your bank. Remember to remove any sensitive information first!",
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

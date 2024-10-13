import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/currency.dart';
import '../../utils/date_time.dart';
import '../../utils/final_balance.dart';
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
  final Map<String, List<Transaction>> transactionsGroup;

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
                    context.router.push(const SettingsRoute());
                    break;
                  case MoreMenuOption.about:
                    launchUrl(Uri.https('mominraza.dev', '/messages_wallet'));
                    break;
                }
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            if (index == transactionsGroup.entries.length) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your bank is not showing up?',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          'Please raise an issue on GitHub or send a email, we will try to add support for it.'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Open GitHub Issue'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Send Email'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            final entry = transactionsGroup.entries.elementAt(index);
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      finalBalance(
                        entry.value.last.type,
                        entry.value.last.finalAmount,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var transaction in entry.value.take(3))
                                  Text(formatDateTime(transaction.dateTime)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (var transaction in entry.value.take(3))
                                  Text(
                                    currencyFormat(
                                        transaction.transactionAmount *
                                            (transaction.type ==
                                                    TransactionType.credited
                                                ? 1
                                                : -1)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () => context.router.push(
                            AccountRoute(
                              title: entry.key,
                              transactions: entry.value,
                            ),
                          ),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: transactionsGroup.entries.length + 1,
        ),
      ),
    );
  }
}

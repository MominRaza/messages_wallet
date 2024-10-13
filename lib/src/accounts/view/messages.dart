import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/flags.dart';
import 'bank_card_view.dart';
import 'no_bank_card_view.dart';

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
          padding: EdgeInsets.only(
            top: 6,
            bottom: max(6, MediaQuery.paddingOf(context).bottom),
            left: max(6, MediaQuery.paddingOf(context).left),
            right: max(6, MediaQuery.paddingOf(context).right),
          ),
          itemBuilder: (context, index) {
            if (index == transactionsGroup.entries.length) {
              return const NoBankCardView();
            }

            final entry = transactionsGroup.entries.elementAt(index);
            return BankCardView(entry: entry);
          },
          itemCount: transactionsGroup.entries.length + 1,
        ),
      ),
    );
  }
}

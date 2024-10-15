import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../shared/view/issue_dialog.dart';
import 'bank_card_view.dart';
import 'no_bank_card_view.dart';

enum MoreMenuOption {
  settings,
  repo,
  feedback,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages Wallet'),
        actions: <Widget>[
          PopupMenuButton<MoreMenuOption>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<MoreMenuOption>>[
                const PopupMenuItem<MoreMenuOption>(
                  value: MoreMenuOption.settings,
                  child: Text('Settings'),
                ),
                const PopupMenuItem<MoreMenuOption>(
                  value: MoreMenuOption.repo,
                  child: Text('Star GitHub Repo'),
                ),
                const PopupMenuItem<MoreMenuOption>(
                  value: MoreMenuOption.feedback,
                  child: Text('Feedback'),
                ),
              ];
            },
            onSelected: (MoreMenuOption value) {
              switch (value) {
                case MoreMenuOption.settings:
                  context.router.push(const SettingsRoute());
                  break;
                case MoreMenuOption.repo:
                  launchUrl(
                    Uri.https('github.com', '/MominRaza/messages_wallet'),
                  );
                  break;
                case MoreMenuOption.feedback:
                  showIssueDialog(context);
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
    );
  }
}

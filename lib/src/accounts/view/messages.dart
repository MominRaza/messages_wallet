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

class Messages extends StatelessWidget {
  const Messages({required this.allMessages, required this.transactionsGroup, super.key});
  final Iterable<SmsMessage> allMessages;
  final Map<String, List<Transaction>> transactionsGroup;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Messages Wallet'),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (v) {
            if (v == 'settings') {
              context.router.push(const SettingsRoute());
            } else if (v == 'repo') {
              launchUrl(Uri.https('github.com', '/MominRaza/messages_wallet'));
            } else if (v == 'feedback') {
              showIssueDialog(context);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'settings', child: Row(children: [Icon(Icons.settings, size: 20), SizedBox(width: 12), Text('Settings')])),
            PopupMenuItem(value: 'repo', child: Row(children: [Icon(Icons.star, size: 20), SizedBox(width: 12), Text('Star GitHub Repo')])),
            PopupMenuItem(value: 'feedback', child: Row(children: [Icon(Icons.feedback, size: 20), SizedBox(width: 12), Text('Feedback')])),
          ],
        ),
      ],
    ),
    body: transactionsGroup.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.inbox, size: 64), const SizedBox(height: 16), Text('No transactions found', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('Grant SMS permission and refresh', style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 16), FilledButton.icon(onPressed: () => context.router.replace(const PermissionRoute()), icon: const Icon(Icons.sms), label: const Text('Grant SMS Permission'))]))
        : ListView.builder(
            padding: EdgeInsets.only(top: 12, bottom: max(12, MediaQuery.paddingOf(context).bottom), left: max(12, MediaQuery.paddingOf(context).left), right: max(12, MediaQuery.paddingOf(context).right)),
            itemCount: transactionsGroup.entries.length + 1,
            itemBuilder: (c, i) => i == transactionsGroup.entries.length ? const NoBankCardView() : BankCardView(entry: transactionsGroup.entries.elementAt(i)),
          ),
  );
}
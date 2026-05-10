import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/providers/sms_providers.dart';
import '../../utils/sms_helpers.dart';

class BankSupportScreen extends ConsumerStatefulWidget {
  const BankSupportScreen({super.key});

  @override
  ConsumerState<BankSupportScreen> createState() => _BankSupportScreenState();
}

class _BankSupportScreenState extends ConsumerState<BankSupportScreen> {
  final Set<SmsMessage> _selectedMessages = {};
  bool _hideSupported = false;

  List<SmsMessage> _messagesForSender(
    String key,
    Map<String, List<SmsMessage>> filteredGroups,
  ) => filteredGroups[key] ?? [];

  List<SmsMessage> _visibleMessagesForSender(
    String key,
    Map<String, List<SmsMessage>> filteredGroups,
    Set<String> transactionBodies,
  ) {
    final msgs = _messagesForSender(key, filteredGroups);
    if (_hideSupported && isSupported(key)) {
      return msgs
          .where((m) => !transactionBodies.contains(m.body ?? ''))
          .toList();
    }
    return msgs;
  }

  String _formatMessages(List<SmsMessage> messages) {
    final buf = StringBuffer();
    for (final msg in messages) {
      buf.writeln('Sender: ${msg.address ?? ''}');
      buf.writeln('---');
      buf.writeln(msg.body ?? '');
      buf.writeln('===');
    }
    return buf.toString().trim();
  }

  void _copy() {
    final selected = _selectedMessages.toList();
    if (selected.isEmpty) return;
    final formatted = _formatMessages(selected);
    log(formatted);
    Clipboard.setData(ClipboardData(text: formatted));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Messages copied to clipboard'),
      ),
    );
  }

  void _email() {
    final selected = _selectedMessages.toList();
    if (selected.isEmpty) return;
    final senders = selected
        .map((m) => groupKey(m.address ?? ''))
        .toSet()
        .join(', ');
    final formatted = _formatMessages(selected);
    const recipient = 'mominraza.dev@gmail.com';
    final subject = Uri.encodeComponent('Bank Support Request - $senders');
    final body = Uri.encodeComponent(formatted);
    launchUrl(Uri.parse('mailto:$recipient?subject=$subject&body=$body'));
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(smsMessagesProvider);
    final senderGroups = ref.watch(senderGroupsProvider);
    final filteredGroups = ref.watch(filteredSenderGroupsProvider);
    final transactionBodies = ref.watch(transactionBodiesProvider);

    final anyChecked = _selectedMessages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          anyChecked
              ? '${_selectedMessages.length} selected'
              : 'Select messages to share',
        ),
        actions: anyChecked
            ? [
                IconButton(
                  tooltip: 'Copy selected',
                  onPressed: _copy,
                  icon: const Icon(Icons.copy),
                ),
                IconButton(
                  tooltip: 'Email selected',
                  onPressed: _email,
                  icon: const Icon(Icons.email_outlined),
                ),
              ]
            : [],
      ),
      body: messagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Failed to load messages.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (_) => senderGroups.isEmpty
            ? const Center(child: Text('No bank-like SMS senders found.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                    child: Row(
                      children: [
                        Text(
                          'Hide supported messages',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Switch.adaptive(
                          value: _hideSupported,
                          onChanged: (v) => setState(() => _hideSupported = v),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final key in senderGroups.keys)
                          if (_visibleMessagesForSender(
                            key,
                            filteredGroups,
                            transactionBodies,
                          ).isNotEmpty)
                            _SenderExpansionTile(
                              senderKey: key,
                              messages: _visibleMessagesForSender(
                                key,
                                filteredGroups,
                                transactionBodies,
                              ),
                              selectedMessages: _selectedMessages,
                              transactionBodies: transactionBodies,
                              hideSupported: _hideSupported,
                              onMessageToggled: (msg, selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedMessages.add(msg);
                                  } else {
                                    _selectedMessages.remove(msg);
                                  }
                                });
                              },
                            ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SenderExpansionTile extends StatelessWidget {
  const _SenderExpansionTile({
    required this.senderKey,
    required this.messages,
    required this.selectedMessages,
    required this.transactionBodies,
    required this.hideSupported,
    required this.onMessageToggled,
  });

  final String senderKey;
  final List<SmsMessage> messages;
  final Set<SmsMessage> selectedMessages;
  final Set<String> transactionBodies;
  final bool hideSupported;
  final void Function(SmsMessage msg, bool selected) onMessageToggled;

  @override
  Widget build(BuildContext context) {
    final supported = isSupported(senderKey);
    final count = messages.length;
    final subtitle = supported
        ? 'Supported · $count message${count == 1 ? '' : 's'}'
        : '$count message${count == 1 ? '' : 's'}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        leading: CircleAvatar(
          backgroundColor: supported
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            supported ? Icons.check : Icons.sms_outlined,
            size: 20,
            color: supported
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(senderKey),
        subtitle: Text(subtitle),
        children: count == 0
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No transaction messages found'),
                ),
              ]
            : [
                const Divider(height: 1),
                for (final msg in messages)
                  _MessageCheckboxTile(
                    msg: msg,
                    senderKey: senderKey,
                    supported: supported,
                    isSelected: selectedMessages.contains(msg),
                    isTransaction:
                        supported && transactionBodies.contains(msg.body ?? ''),
                    hideSupported: hideSupported,
                    onChanged: (v) => onMessageToggled(msg, v ?? false),
                  ),
              ],
      ),
    );
  }
}

class _MessageCheckboxTile extends StatelessWidget {
  const _MessageCheckboxTile({
    required this.msg,
    required this.senderKey,
    required this.supported,
    required this.isSelected,
    required this.isTransaction,
    required this.hideSupported,
    required this.onChanged,
  });

  final SmsMessage msg;
  final String senderKey;
  final bool supported;
  final bool isSelected;
  final bool isTransaction;
  final bool hideSupported;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final showChip = supported && (isTransaction || !hideSupported);
    return CheckboxListTile(
      value: isSelected,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: showChip
          ? Row(
              children: [
                Chip(
                  label: Text(
                    isTransaction ? 'Transaction' : 'Skipped',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: isTransaction
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            )
          : null,
      subtitle: Text(msg.body ?? ''),
    );
  }
}

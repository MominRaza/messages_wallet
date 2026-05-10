import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/providers/sms_providers.dart';
import '../../utils/sms_helpers.dart';

class BankSupportScreen extends ConsumerStatefulWidget {
  const BankSupportScreen({super.key});

  @override
  ConsumerState<BankSupportScreen> createState() => _BankSupportScreenState();
}

class _BankSupportScreenState extends ConsumerState<BankSupportScreen> {
  final Set<String> _selectedSenders = {};
  final Set<int> _selectedIndices = {};
  bool _showAll = false;

  List<SmsMessage> _visibleMessages(
    Map<String, List<SmsMessage>> senderGroups,
    Map<String, List<SmsMessage>> filteredGroups,
  ) => _selectedSenders
      .expand(
        (s) =>
            (_showAll ? senderGroups[s] : filteredGroups[s]) ?? <SmsMessage>[],
      )
      .toList();

  List<SmsMessage> _checkedMessages(List<SmsMessage> visible) => [
    for (var i = 0; i < visible.length; i++)
      if (_selectedIndices.contains(i)) visible[i],
  ];

  String _formatMessages(List<SmsMessage> messages) {
    final buf = StringBuffer();
    for (final msg in messages) {
      buf.writeln('Sender: ${msg.address ?? ''}');
      if (msg.date != null) {
        buf.writeln(
          'Date: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(msg.date!)}',
        );
      }
      buf.writeln('---');
      buf.writeln(msg.body ?? '');
      buf.writeln('===');
    }
    return buf.toString().trim();
  }

  void _copy(List<SmsMessage> visible) {
    final selected = _checkedMessages(visible);
    if (selected.isEmpty) return;
    final formatted = _formatMessages(selected);
    log('[BankSupport] ${selected.length} message(s) copied:\n$formatted');
    Clipboard.setData(ClipboardData(text: formatted));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Messages copied to clipboard'),
      ),
    );
  }

  void _email(List<SmsMessage> visible) {
    final selected = _checkedMessages(visible);
    if (selected.isEmpty) return;
    final senders = _selectedSenders.join(', ');
    final formatted = _formatMessages(selected);
    log('[BankSupport] Emailing ${selected.length} message(s) for: $senders');
    final subject = Uri.encodeComponent('Bank Support Request - $senders');
    final body = Uri.encodeComponent(formatted);
    launchUrl(Uri.parse('mailto:?subject=$subject&body=$body'));
  }

  bool _allSelected(List<SmsMessage> visible) {
    final count = visible.length;
    return count > 0 && _selectedIndices.length == count;
  }

  void _toggleAll(List<SmsMessage> visible) {
    final count = visible.length;
    setState(() {
      if (_allSelected(visible)) {
        _selectedIndices.clear();
      } else {
        _selectedIndices.addAll(List.generate(count, (i) => i));
      }
    });
  }

  void _onSenderToggled(String key, bool selected) {
    setState(() {
      if (selected) {
        _selectedSenders.add(key);
      } else {
        _selectedSenders.remove(key);
      }
      _selectedIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(smsMessagesProvider);
    final senderGroups = ref.watch(senderGroupsProvider);
    final filteredGroups = ref.watch(filteredSenderGroupsProvider);
    final transactionBodies = ref.watch(transactionBodiesProvider);

    final messages = _visibleMessages(senderGroups, filteredGroups);
    final anyChecked = _selectedIndices.isNotEmpty;
    final allSel = _allSelected(messages);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bank Support'),
        actions: [
          IconButton(
            tooltip: allSel ? 'Deselect all' : 'Select all',
            onPressed: messages.isNotEmpty ? () => _toggleAll(messages) : null,
            icon: Icon(allSel ? Icons.deselect : Icons.select_all),
          ),
          IconButton(
            tooltip: 'Copy selected',
            onPressed: anyChecked ? () => _copy(messages) : null,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            tooltip: 'Email selected',
            onPressed: anyChecked ? () => _email(messages) : null,
            icon: const Icon(Icons.email_outlined),
          ),
        ],
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
                  _SenderChipBar(
                    senderGroups: senderGroups,
                    filteredGroups: filteredGroups,
                    selectedSenders: _selectedSenders,
                    showAll: _showAll,
                    onSenderToggled: _onSenderToggled,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                    child: Row(
                      children: [
                        Text(
                          'Show all messages',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Switch.adaptive(
                          value: _showAll,
                          onChanged: (v) => setState(() {
                            _showAll = v;
                            _selectedIndices.clear();
                          }),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _selectedSenders.isEmpty
                        ? const Center(
                            child: Text(
                              'Select a sender above to view messages',
                            ),
                          )
                        : messages.isEmpty
                        ? const Center(
                            child: Text('No transaction messages found'),
                          )
                        : ListView.separated(
                            itemCount: messages.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final addr = msg.address ?? '';
                              final senderKey = groupKey(addr);
                              final supported = isSupported(senderKey);
                              final isTx =
                                  supported &&
                                  transactionBodies.contains(msg.body ?? '');

                              return CheckboxListTile(
                                value: _selectedIndices.contains(index),
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _selectedIndices.add(index);
                                  } else {
                                    _selectedIndices.remove(index);
                                  }
                                }),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        addr,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    if (supported) ...[
                                      const SizedBox(width: 4),
                                      Chip(
                                        label: Text(
                                          isTx ? 'Transaction' : 'Skipped',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        backgroundColor: isTx
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer
                                            : null,
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                    const Spacer(),
                                    if (msg.date != null)
                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy',
                                        ).format(msg.date!),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    msg.body ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                isThreeLine: true,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SenderChipBar extends StatelessWidget {
  const _SenderChipBar({
    required this.senderGroups,
    required this.filteredGroups,
    required this.selectedSenders,
    required this.showAll,
    required this.onSenderToggled,
  });

  final Map<String, List<SmsMessage>> senderGroups;
  final Map<String, List<SmsMessage>> filteredGroups;
  final Set<String> selectedSenders;
  final bool showAll;
  final void Function(String key, bool selected) onSenderToggled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: senderGroups.keys.expand((key) {
          final supported = isSupported(key);
          final count = showAll
              ? (senderGroups[key]?.length ?? 0)
              : (filteredGroups[key]?.length ?? 0);
          if (!supported && count == 0) return const <Widget>[];
          final selected = selectedSenders.contains(key);
          return [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  supported ? '$key · Supported ($count)' : '$key ($count)',
                ),
                selected: selected,
                onSelected: (v) => onSenderToggled(key, v),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}

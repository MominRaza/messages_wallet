import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

const _supportedSenders = ['axisbk', 'bobtxn', 'cosmos'];
final _dltRegex = RegExp(r'^[A-Za-z]{2}-[A-Za-z0-9]{3,8}$');
final _allDigitsRegex = RegExp(r'^\d+$');

// Minimum bare requirement derived from all existing bank extractors.
// A message must match all three to be considered a likely transaction.
final _amountRegex = RegExp(r'(Rs\.|INR)\s*[\d,]+', caseSensitive: false);
final _dateRegex = RegExp(r'\d{2}[-/]\d{2}[-/]\d{2,4}');
final _keywordRegex = RegExp(
  r'credit|debit|withdraw|transfer|spent',
  caseSensitive: false,
);

bool _isLikelyTransaction(String body) =>
    _amountRegex.hasMatch(body) &&
    _dateRegex.hasMatch(body) &&
    _keywordRegex.hasMatch(body);

String _groupKey(String address) {
  final dash = address.indexOf('-');
  return dash == -1 ? address : address.substring(dash + 1);
}

bool _isNumericOnly(String key) => _allDigitsRegex.hasMatch(key);

@RoutePage()
class BankSupportScreen extends StatefulWidget {
  const BankSupportScreen({super.key});

  @override
  State<BankSupportScreen> createState() => _BankSupportScreenState();
}

class _BankSupportScreenState extends State<BankSupportScreen> {
  final SmsQuery _query = SmsQuery();

  /// All messages grouped by middle sender ID.
  Map<String, List<SmsMessage>> _senderGroups = {};

  /// Only likely-transaction messages, grouped by middle sender ID.
  Map<String, List<SmsMessage>> _filteredGroups = {};

  final Set<String> _selectedSenders = {};
  final Set<int> _selectedIndices = {};

  bool _loading = true;
  bool _permissionDenied = false;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadSenders();
  }

  Future<void> _loadSenders() async {
    final permission = await Permission.sms.status;
    if (!permission.isGranted) {
      setState(() {
        _loading = false;
        _permissionDenied = true;
      });
      return;
    }

    final messages = await _query.querySms();
    final Map<String, List<SmsMessage>> groups = {};
    final Map<String, List<SmsMessage>> filtered = {};

    for (final msg in messages) {
      final addr = msg.address ?? '';
      if (!_dltRegex.hasMatch(addr)) continue;
      final key = _groupKey(addr);
      if (_isNumericOnly(key)) continue;
      groups.putIfAbsent(key, () => []).add(msg);
      if (_isLikelyTransaction(msg.body ?? '')) {
        filtered.putIfAbsent(key, () => []).add(msg);
      }
    }

    final sortedKeys = groups.keys.toList()..sort();

    setState(() {
      _senderGroups = {for (final k in sortedKeys) k: groups[k]!};
      _filteredGroups = filtered;
      _loading = false;
    });
  }

  bool _isSupported(String key) =>
      _supportedSenders.contains(key.toLowerCase());

  List<SmsMessage> get _visibleMessages => _selectedSenders
      .expand(
        (s) =>
            (_showAll ? _senderGroups[s] : _filteredGroups[s]) ??
            <SmsMessage>[],
      )
      .toList();

  List<SmsMessage> get _checkedMessages {
    final visible = _visibleMessages;
    return [
      for (var i = 0; i < visible.length; i++)
        if (_selectedIndices.contains(i)) visible[i],
    ];
  }

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

  void _copy() {
    final selected = _checkedMessages;
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

  void _email() {
    final selected = _checkedMessages;
    if (selected.isEmpty) return;
    final senders = _selectedSenders.join(', ');
    final formatted = _formatMessages(selected);
    log('[BankSupport] Emailing ${selected.length} message(s) for: $senders');
    final subject = Uri.encodeComponent('Bank Support Request - $senders');
    final body = Uri.encodeComponent(formatted);
    launchUrl(Uri.parse('mailto:?subject=$subject&body=$body'));
  }

  bool get _allSelected {
    final count = _visibleMessages.length;
    return count > 0 && _selectedIndices.length == count;
  }

  void _toggleAll() {
    final count = _visibleMessages.length;
    setState(() {
      if (_allSelected) {
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
    final messages = _visibleMessages;
    final anyChecked = _selectedIndices.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bank Support'),
        actions: [
          IconButton(
            tooltip: _allSelected ? 'Deselect all' : 'Select all',
            onPressed: messages.isNotEmpty ? _toggleAll : null,
            icon: Icon(_allSelected ? Icons.deselect : Icons.select_all),
          ),
          IconButton(
            tooltip: 'Copy selected',
            onPressed: anyChecked ? _copy : null,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            tooltip: 'Email selected',
            onPressed: anyChecked ? _email : null,
            icon: const Icon(Icons.email_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _permissionDenied
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'SMS permission is required.\nGrant it from Settings.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _senderGroups.isEmpty
          ? const Center(child: Text('No bank-like SMS senders found.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SenderChipBar(
                  senderGroups: _senderGroups,
                  filteredGroups: _filteredGroups,
                  selectedSenders: _selectedSenders,
                  showAll: _showAll,
                  isSupported: _isSupported,
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
                          child: Text('Select a sender above to view messages'),
                        )
                      : messages.isEmpty
                      ? const Center(
                          child: Text('No transaction messages found'),
                        )
                      : ListView.separated(
                          itemCount: messages.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            return CheckboxListTile(
                              value: _selectedIndices.contains(index),
                              onChanged: (v) => setState(() {
                                if (v == true) {
                                  _selectedIndices.add(index);
                                } else {
                                  _selectedIndices.remove(index);
                                }
                              }),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      msg.address ?? '',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
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
    );
  }
}

class _SenderChipBar extends StatelessWidget {
  const _SenderChipBar({
    required this.senderGroups,
    required this.filteredGroups,
    required this.selectedSenders,
    required this.showAll,
    required this.isSupported,
    required this.onSenderToggled,
  });

  final Map<String, List<SmsMessage>> senderGroups;
  final Map<String, List<SmsMessage>> filteredGroups;
  final Set<String> selectedSenders;
  final bool showAll;
  final bool Function(String) isSupported;
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
          if (supported) {
            return [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text('$key · Supported'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ];
          }
          return [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text('$key ($count)'),
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

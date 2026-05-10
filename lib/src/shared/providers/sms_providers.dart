import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/extract_axis.dart';
import '../../utils/extract_bob.dart';
import '../../utils/extract_cosmos.dart';
import '../../utils/sms_helpers.dart';
import '../models/spending_model.dart';

/// Single SMS read for the entire app. Kept alive so messages are never
/// re-fetched across navigation.
final smsMessagesProvider = FutureProvider<List<SmsMessage>>((ref) async {
  final permission = await Permission.sms.status;
  if (!permission.isGranted) return [];
  final query = SmsQuery();
  return await query.querySms();
});

/// Transactions extracted from supported-bank messages, grouped by account
/// number and sorted by datetime.
final transactionsGroupProvider = Provider<Map<String, List<Transaction>>>((
  ref,
) {
  final messagesAsync = ref.watch(smsMessagesProvider);
  return messagesAsync.when(
    data: (messages) {
      final axisMessages = messages.where(
        (m) => m.address?.toLowerCase().contains('-axisbk') ?? false,
      );
      final bobMessages = messages.where(
        (m) => m.address?.toLowerCase().contains('-bobtxn') ?? false,
      );
      final cosmosMessages = messages.where(
        (m) => m.address?.toLowerCase().contains('-cosmos') ?? false,
      );

      final transactions = [
        ...extractBOBMessages(bobMessages.map((e) => e.body ?? '')),
        ...extractAxisMessages(axisMessages.map((e) => e.body ?? '')),
        ...extractCosmosMessages(cosmosMessages.map((e) => e.body ?? '')),
      ];

      final grouped = groupBy(transactions, (Transaction t) => t.accountNumber);

      return {
        for (final entry in grouped.entries)
          entry.key: (entry.value
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime))),
      };
    },
    loading: () => {},
    error: (_, _) => {},
  );
});

/// Set of all transaction message bodies for O(1) lookup.
/// Used by bank support screen to show whether a message was extracted
/// as a transaction.
final transactionBodiesProvider = Provider<Set<String>>((ref) {
  final group = ref.watch(transactionsGroupProvider);
  return {
    for (final transactions in group.values)
      for (final t in transactions) t.body,
  };
});

/// All SMS messages grouped by DLT sender ID, sorted by key.
final senderGroupsProvider = Provider<Map<String, List<SmsMessage>>>((ref) {
  final messagesAsync = ref.watch(smsMessagesProvider);
  return messagesAsync.when(
    data: (messages) {
      final Map<String, List<SmsMessage>> groups = {};
      for (final msg in messages) {
        final addr = msg.address ?? '';
        if (!dltRegex.hasMatch(addr)) continue;
        final key = groupKey(addr);
        if (isNumericOnly(key)) continue;
        groups.putIfAbsent(key, () => []).add(msg);
      }
      final sortedKeys = groups.keys.toList()..sort();
      return {for (final k in sortedKeys) k: groups[k]!};
    },
    loading: () => {},
    error: (_, _) => {},
  );
});

/// Likely-transaction messages grouped by sender ID (heuristic filter).
final filteredSenderGroupsProvider = Provider<Map<String, List<SmsMessage>>>((
  ref,
) {
  final groups = ref.watch(senderGroupsProvider);
  final Map<String, List<SmsMessage>> filtered = {};
  for (final entry in groups.entries) {
    final txMessages = entry.value
        .where((m) => isLikelyTransaction(m.body ?? ''))
        .toList();
    if (txMessages.isNotEmpty) {
      filtered[entry.key] = txMessages;
    }
  }
  return filtered;
});

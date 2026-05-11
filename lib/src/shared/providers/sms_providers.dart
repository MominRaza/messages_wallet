import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bank_support/extractors/extract_axis.dart';
import '../../bank_support/extractors/extract_bob.dart';
import '../../bank_support/extractors/extract_cosmos.dart';
import '../../bank_support/extractors/extract_hdfc.dart';
import '../../bank_support/extractors/extract_icici.dart';
import '../../bank_support/extractors/extract_kotak.dart';
import '../../utils/sms_helpers.dart';
import '../models/sms_data.dart';
import '../models/spending_model.dart';

final smsMessagesProvider = FutureProvider<List<SmsData>>((ref) async {
  final permission = await Permission.sms.status;
  if (!permission.isGranted) return [];
  final query = SmsQuery();
  final messages = await query.querySms();
  return messages
      .map((m) => SmsData(address: m.address ?? '', body: m.body ?? ''))
      .toList();
});

final transactionsGroupProvider = Provider<Map<String, List<Transaction>>>((
  ref,
) {
  final messagesAsync = ref.watch(smsMessagesProvider);
  return messagesAsync.when(
    data: (messages) {
      final axisMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-axisbk'),
      );
      final bobMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-bobtxn'),
      );
      final cosmosMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-cosmos'),
      );
      final iciciMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-icicit'),
      );
      final hdfcMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-hdfcbk'),
      );
      final kotakMessages = messages.where(
        (m) => m.address.toLowerCase().contains('-kotakb'),
      );

      final transactions = [
        ...extractBOBMessages(bobMessages.map((e) => e.body)),
        ...extractAxisMessages(axisMessages.map((e) => e.body)),
        ...extractCosmosMessages(cosmosMessages.map((e) => e.body)),
        ...extractHDFCMessages(hdfcMessages.map((e) => e.body)),
        ...extractICICIMessages(iciciMessages.map((e) => e.body)),
        ...extractKotakMessages(kotakMessages.map((e) => e.body)),
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

final transactionBodiesProvider = Provider<Set<String>>((ref) {
  final group = ref.watch(transactionsGroupProvider);
  return {
    for (final transactions in group.values)
      for (final t in transactions) t.body,
  };
});

final senderGroupsProvider = Provider<Map<String, List<SmsData>>>((ref) {
  final messagesAsync = ref.watch(smsMessagesProvider);
  return messagesAsync.when(
    data: (messages) {
      final Map<String, List<SmsData>> groups = {};
      for (final msg in messages) {
        if (!dltRegex.hasMatch(msg.address)) continue;
        final key = groupKey(msg.address);
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

final filteredSenderGroupsProvider = Provider<Map<String, List<SmsData>>>((
  ref,
) {
  final groups = ref.watch(senderGroupsProvider);
  final Map<String, List<SmsData>> filtered = {};
  for (final entry in groups.entries) {
    final txMessages = entry.value
        .where((m) => isLikelyTransaction(m.body))
        .toList();
    if (txMessages.isNotEmpty) {
      filtered[entry.key] = txMessages;
    }
  }
  return filtered;
});

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/components/messages.dart';
import 'package:messages_wallet/extracts/extract_axis.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:messages_wallet/utils/flags.dart';
import 'package:permission_handler/permission_handler.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery _query = SmsQuery();
  Iterable<SmsMessage> _allMessages = [];
  Map<String, List<Transaction>> _transactionsGroup = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms();
      final axisMessages = messages.where(
        (message) =>
            message.address?.toLowerCase().contains('-axisbk') ?? false,
      );
      final bobMessages = messages.where(
        (message) =>
            message.address?.toLowerCase().contains('-bobtxn') ?? false,
      );
      Iterable<Transaction> bobTransactions =
          extractBOBMessages(bobMessages.map((e) => e.body ?? ''));

      Iterable<Transaction> axisTransaction =
          extractAxisMessages(axisMessages.map((e) => e.body ?? ''));

      Map<String, List<Transaction>> transactionsGroup = groupBy(
        [...bobTransactions, ...axisTransaction],
        (Transaction transaction) => transaction.accountNumber ?? '',
      );

      transactionsGroup.forEach((_, value) {
        value.sort(
          (a, b) => b.dateTime?.compareTo(a.dateTime ?? DateTime(0)) ?? 0,
        );
      });

      if (isDebug) {
        messages.sort((a, b) => a.address?.compareTo(b.address ?? '') ?? 0);
        setState(() {
          _allMessages = messages.where(
            (message) => message.address?[2] == '-',
          );
        });
      }

      setState(() {
        _transactionsGroup = transactionsGroup;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Messages(
      allMessages: _allMessages,
      transactionsGroup: _transactionsGroup,
    );
  }
}

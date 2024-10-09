import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/models/transaction_model.dart';
import '../../utils/extract_axis.dart';
import '../../utils/extract_bob.dart';
import '../../utils/extract_cosmos.dart';
import '../../utils/flags.dart';
import '../../utils/group_transactions_by_month.dart';
import 'messages.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery _query = SmsQuery();
  Iterable<SmsMessage> _allMessages = [];
  Map<String, List<Spending>> _transactionsGroup = {};

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
      final cosmosMessages = messages.where(
        (message) =>
            message.address?.toLowerCase().contains('-cosmos') ?? false,
      );

      Iterable<Transaction> bobTransactions =
          extractBOBMessages(bobMessages.map((e) => e.body ?? ''));
      Iterable<Transaction> axisTransactions =
          extractAxisMessages(axisMessages.map((e) => e.body ?? ''));
      Iterable<Transaction> cosmosTransactions =
          extractCosmosMessages(cosmosMessages.map((e) => e.body ?? ''));

      Map<String, List<Transaction>> transactionsGroup = groupBy(
        [...bobTransactions, ...axisTransactions, ...cosmosTransactions],
        (Transaction transaction) => transaction.accountNumber,
      );

      Map<String, List<Spending>> transactionsGroupWithMonth = {};

      transactionsGroup.forEach((key, value) {
        value.sort(
          (a, b) => a.dateTime.compareTo(b.dateTime),
        );
        transactionsGroupWithMonth[key] = groupTransactionsByMonth(value);
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
        _transactionsGroup = transactionsGroupWithMonth;
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

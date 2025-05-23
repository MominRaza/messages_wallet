import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/models/spending_model.dart';
import '../../utils/extract_axis.dart';
import '../../utils/extract_bob.dart';
import '../../utils/extract_cosmos.dart';
import 'messages.dart';

@RoutePage()
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
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
      final cosmosMessages = messages.where(
        (message) =>
            message.address?.toLowerCase().contains('-cosmos') ?? false,
      );

      Iterable<Transaction> bobTransactions = extractBOBMessages(
        bobMessages.map((e) => e.body ?? ''),
      );
      Iterable<Transaction> axisTransactions = extractAxisMessages(
        axisMessages.map((e) => e.body ?? ''),
      );
      Iterable<Transaction> cosmosTransactions = extractCosmosMessages(
        cosmosMessages.map((e) => e.body ?? ''),
      );

      Map<String, List<Transaction>> transactionsGroup = groupBy([
        ...bobTransactions,
        ...axisTransactions,
        ...cosmosTransactions,
      ], (Transaction transaction) => transaction.accountNumber);

      Map<String, List<Transaction>> shortedTransactions = {};

      transactionsGroup.forEach((key, value) {
        shortedTransactions[key] =
            value..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      });

      setState(() {
        _allMessages = messages;
        _transactionsGroup = shortedTransactions;
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

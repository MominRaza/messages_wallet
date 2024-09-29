import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/messages.dart';
import '../extracts/extract_axis.dart';
import '../extracts/extract_bob.dart';
import '../extracts/extract_cosmos.dart';
import '../models/monthly_spending_model.dart';
import '../models/transaction_model.dart';
import '../utils/flags.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery _query = SmsQuery();
  Iterable<SmsMessage> _allMessages = [];
  Map<String, List<dynamic>> _transactionsGroup = {};

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
        (Transaction transaction) => transaction.accountNumber ?? '',
      );

      Map<String, List<dynamic>> transactionsGroupWithMonth = {};

      transactionsGroup.forEach((key, value) {
        value.sort(
          (a, b) => a.dateTime?.compareTo(b.dateTime ?? DateTime(0)) ?? 0,
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

  List<dynamic> groupTransactionsByMonth(List<Transaction> transactions) {
    List<dynamic> items = [];
    String? currentMonth;
    double totalCredit = 0;
    double totalDebit = 0;
    double previousTotalCredit = 0;
    double previousTotalDebit = 0;

    for (var transaction in transactions) {
      String month = transaction.dateTime != null
          ? DateFormat('MMMM yyyy').format(transaction.dateTime!)
          : 'N/A';

      double amount = double.tryParse(transaction.transactionAmount ?? '') ?? 0;
      if (transaction.type == TransactionType.credited) {
        totalCredit += amount;
      } else {
        totalDebit += amount;
      }

      if (currentMonth != null && currentMonth != month) {
        items.add(
          MonthlySpending(
            month: currentMonth,
            totalCredit: previousTotalCredit,
            totalDebit: previousTotalDebit,
          ),
        );

        if (transaction.type == TransactionType.credited) {
          totalCredit = amount;
          totalDebit = 0;
        } else {
          totalCredit = 0;
          totalDebit = amount;
        }
      }

      previousTotalCredit = totalCredit;
      previousTotalDebit = totalDebit;

      items.add(transaction);

      if (currentMonth != null && transaction == transactions.last) {
        items.add(
          MonthlySpending(
            month: currentMonth,
            totalCredit: totalCredit,
            totalDebit: totalDebit,
          ),
        );
      }

      currentMonth = month;
    }

    return items.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Messages(
      allMessages: _allMessages,
      transactionsGroup: _transactionsGroup,
    );
  }
}

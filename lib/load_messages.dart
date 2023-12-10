import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/messages.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadMessages extends StatefulWidget {
  const LoadMessages({super.key});

  @override
  State<LoadMessages> createState() => _LoadMessagesState();
}

class _LoadMessagesState extends State<LoadMessages> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _axisMessages = [];
  List<SmsMessage> _bobMessages = [];
  List<Transaction> _bobTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  _loadMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      var messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
        ],
      );
      var axisMessages = messages
          .where(
            (message) => message.address!.contains('AXISBK'),
          )
          .toList();
      var bobMessages = messages
          .where(
            (message) => message.address!.contains('BOBTXN'),
          )
          .toList();
      List<Transaction> bobTransactions = bobMessages.map((message) {
        RegExp typeRegex =
            RegExp(r'(Credited|withdrawn|transferred)'); // Transaction type
        RegExp amountRegex =
            RegExp(r'Rs\.([\d,]+(?:\.\d{2})?)'); // Transaction amount
        RegExp finalAmountRegex =
            RegExp(r'Avlbl Amt:Rs\.([\d,]+(?:\.\d{2})?)'); // Final amount
        RegExp accountNumberRegex = RegExp(r'A/c \.{3}(\d+)'); // Account number

        // Extracting values using regex
        String transactionType =
            typeRegex.firstMatch(message.body!)?.group(1) ?? "N/A";
        String transactionAmount =
            amountRegex.firstMatch(message.body!)?.group(1) ?? "N/A";
        String finalAmount =
            finalAmountRegex.firstMatch(message.body!)?.group(1) ?? "N/A";
        String accountNumber =
            accountNumberRegex.firstMatch(message.body!)?.group(1) ?? "N/A";

        // Returning a Transaction object
        return Transaction(
            transactionType, transactionAmount, finalAmount, accountNumber);
      }).toList();

      print('axis sms inbox messages: ${axisMessages.length}');
      print('bob sms inbox messages: ${bobMessages.length}');
      setState(() {
        _axisMessages = axisMessages;
        _bobMessages = bobMessages;
        _bobTransactions = bobTransactions;
      });
    } else {
      await Permission.sms.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Messages(
      axisMessages: _axisMessages,
      bobMessages: _bobMessages,
      bobTransactions: _bobTransactions,
    );
  }
}

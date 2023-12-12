import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/components/messages.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
import 'package:messages_wallet/models/transaction_model.dart';
import 'package:permission_handler/permission_handler.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _axisMessages = [];
  List<SmsMessage> _bobMessages = [];
  Map<String, List<Transaction>> _transactions = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
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
      Map<String, List<Transaction>> bobTransactions =
          extractBOBMessages(bobMessages.map((e) => e.body ?? '').toList());

      setState(() {
        _axisMessages = axisMessages;
        _bobMessages = bobMessages;
        _transactions = bobTransactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Messages(
      axisMessages: _axisMessages,
      bobMessages: _bobMessages,
      transactionsGroup: _transactions,
    );
  }
}

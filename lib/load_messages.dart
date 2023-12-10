import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:messages_wallet/extracts/extract_bob.dart';
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
  Map<String, List<Transaction>> _transactions = {};

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
      Map<String, List<Transaction>> bobTransactions =
          extractBOBMessages(bobMessages.map((e) => e.body ?? '').toList());

      print('axis sms inbox messages: ${axisMessages.length}');
      print('bob sms inbox messages: ${bobMessages.length}');
      setState(() {
        _axisMessages = axisMessages;
        _bobMessages = bobMessages;
        _transactions = bobTransactions;
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
      transactionsGroup: _transactions,
    );
  }
}

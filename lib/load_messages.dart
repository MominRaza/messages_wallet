import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final AppLifecycleListener _listener;
  bool _shouldReload = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _listener = AppLifecycleListener(
      onResume: () {
        if (_shouldReload) {
          _loadMessages();
          setState(() {
            _shouldReload = false;
          });
        }
      },
    );
  }

  @override
  dispose() {
    _listener.dispose();
    super.dispose();
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
    } else {
      await Permission.sms
          .onGrantedCallback(_loadMessages)
          .onDeniedCallback(
            () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Allow SMS Permission'),
                content: const Text(
                  'In order to use this app you have to allow read SMS permission.',
                ),
                actions: [
                  const TextButton(
                    onPressed: SystemNavigator.pop,
                    child: Text('Close App'),
                  ),
                  TextButton(
                    onPressed: () {
                      _loadMessages();
                      Navigator.pop(context);
                    },
                    child: const Text('Allow'),
                  ),
                ],
              ),
            ),
          )
          .onPermanentlyDeniedCallback(
            () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Allow SMS Permission'),
                content: const Text(
                  'In order to use this app you have to allow read SMS permission.',
                ),
                actions: [
                  const TextButton(
                    onPressed: SystemNavigator.pop,
                    child: Text('Close App'),
                  ),
                  TextButton(
                    onPressed: () async {
                      openAppSettings();
                      setState(() {
                        _shouldReload = true;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ),
          )
          .request();
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

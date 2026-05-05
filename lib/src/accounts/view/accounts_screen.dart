import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/universal_parser.dart';
import 'messages.dart';

@RoutePage()
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});
  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _query = SmsQuery();
  Map<String, List<Transaction>> _groups = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    if (!await Permission.sms.isGranted) {
      setState(() { _error = 'SMS permission not granted'; _loading = false; });
      return;
    }
    try {
      final messages = await _query.querySms();
      final txns = <Transaction>[];
      final keys = <String>{};
      for (var m in messages) {
        final t = UniversalParser.parseSms(m);
        if (t != null) {
          final key = '${t.transactionAmount}_${t.dateTime.millisecondsSinceEpoch}_${t.accountNumber}';
          if (keys.add(key)) txns.add(t);
        }
      }
      _process(txns);
    } catch (e) {
      setState(() { _error = 'Error: $e'; _loading = false; });
    }
  }

  void _process(List<Transaction> txns) {
    final groups = groupBy(txns, (Transaction t) => t.accountNumber);
    groups.forEach((k, v) { v.sort((a, b) => b.dateTime.compareTo(a.dateTime)); });
    setState(() { _groups = groups; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.error_outline, size: 64), const SizedBox(height: 16), Text(_error!), const SizedBox(height: 16), FilledButton(onPressed: _load, child: const Text('Retry'))])));
    return RefreshIndicator(onRefresh: _load, child: Messages(allMessages: const [], transactionsGroup: _groups));
  }
}
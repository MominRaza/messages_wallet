import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/sms_providers.dart';
import 'messages.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(smsMessagesProvider);
    final transactionsGroup = ref.watch(transactionsGroupProvider);

    return messagesAsync.when(
      data: (allMessages) => Messages(
        allMessages: allMessages,
        transactionsGroup: transactionsGroup,
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Messages Wallet')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: const Text('Messages Wallet')),
        body: const Center(child: Text('Failed to load messages')),
      ),
    );
  }
}

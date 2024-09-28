import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({
    required this.messages,
    super.key,
  });

  final Iterable<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages.toList()[i];

        return ListTile(
          title: Text('${message.address}'),
          subtitle: Text(
            '${message.body?.trim()}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueDialog extends StatelessWidget {
  const IssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Raise an issue on GitHub'),
      content: const Text(
        'If you have found a bug or have a feature request or your bank is not showing up, please raise an issue on GitHub.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.https(
                'github.com',
                'MominRaza/messages_wallet/issues/new',
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Open GitHub Issue'),
        ),
      ],
    );
  }
}

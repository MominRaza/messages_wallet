import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueDialog extends StatelessWidget {
  const IssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report an Issue on GitHub'),
      content: const Text(
        "If you've found a bug, have a feature request, or can't find your bank, please report it on GitHub.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.tonal(
          onPressed: () {
            launchUrl(
              Uri.https(
                'github.com',
                'MominRaza/messages_wallet/issues/new/choose',
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

void showIssueDialog(BuildContext context) =>
    showDialog(context: context, builder: (_) => const IssueDialog());

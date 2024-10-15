import 'package:flutter/material.dart';

import '../../shared/view/issue_dialog.dart';
import 'card_view.dart';

class NoBankCardView extends StatelessWidget {
  const NoBankCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: 'Your bank is not showing up?',
      description:
          'Please raise an issue on GitHub and we will add your bank as soon as possible.',
      actions: [
        FilledButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const IssueDialog(),
          ),
          child: const Text('Open GitHub Issue'),
        ),
      ],
    );
  }
}

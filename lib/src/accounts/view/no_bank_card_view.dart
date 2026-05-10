import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/view/issue_dialog.dart';
import 'card_view.dart';

class NoBankCardView extends StatelessWidget {
  const NoBankCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: "Can't Find Your Bank?",
      description:
          "Let us know on GitHub, and we'll add it as soon as possible.",
      actions: [
        FilledButton(
          onPressed: () => context.push('/bank-support'),
          child: const Text('Add Bank Support'),
        ),
        TextButton(
          onPressed: () => showIssueDialog(context),
          child: const Text('Report an Issue'),
        ),
      ],
    );
  }
}

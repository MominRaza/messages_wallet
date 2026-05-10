import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app_router.gr.dart';
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
          onPressed: () => context.router.push(const BankSupportRoute()),
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

import 'package:flutter/material.dart';

import 'card_view.dart';

class NoBankCardView extends StatelessWidget {
  const NoBankCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: 'Your bank is not showing up?',
      description:
          'Please raise an issue on GitHub or send a email, we will try to add support for it.',
      actions: [
        OutlinedButton(
          onPressed: () {},
          child: const Text('Open GitHub Issue'),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () {},
          child: const Text('Send Email'),
        ),
      ],
    );
  }
}

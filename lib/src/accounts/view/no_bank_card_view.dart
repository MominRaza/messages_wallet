import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'card_view.dart';

class NoBankCardView extends StatelessWidget {
  const NoBankCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: "Can't Find Your Bank?",
      description:
          "Send us your bank's SMS samples via email or raise a GitHub issue — we'll add support as soon as possible.",
      actions: [
        FilledButton(
          onPressed: () => context.push('/bank-support'),
          child: const Text('Request Bank Support'),
        ),
      ],
    );
  }
}

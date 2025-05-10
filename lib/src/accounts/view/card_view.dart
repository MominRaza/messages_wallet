import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({
    required this.title,
    required this.description,
    required this.actions,
    super.key,
    this.transactions,
  });

  final String title;
  final String description;
  final List<Widget> actions;
  final Widget? transactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            if (transactions != null) transactions!,
            if (transactions != null) const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
          ],
        ),
      ),
    );
  }
}

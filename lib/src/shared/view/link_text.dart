import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkText extends StatelessWidget {
  const LinkText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );
    final match = urlRegExp.firstMatch(text);
    if (match == null) {
      return Text(text, style: Theme.of(context).textTheme.bodyMedium);
    }

    final url = match.group(0)!;
    final beforeUrl = text.substring(0, match.start);
    final afterUrl = text.substring(match.end);

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: beforeUrl),
          TextSpan(
            text: url,
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrlString(url)) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  },
          ),
          TextSpan(text: afterUrl),
        ],
      ),
    );
  }
}

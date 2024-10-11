import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/shared/view/link_text.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('Displays plain text without URL', (tester) async {
    const testText = 'This is a plain text without any links.';

    await tester.pumpWidget(buildTestableWidget(const LinkText(testText)));

    expect(find.text(testText), findsOneWidget);

    final RichText richText = tester.widget(find.byType(RichText));
    final TextSpan span = richText.text as TextSpan;

    expect(span.recognizer, isNull);
    expect(span.children, isNull);
  });

  testWidgets('Displays text with a single URL', (WidgetTester tester) async {
    const beforeUrl = 'Check out this website: ';
    const url = 'https://flutter.dev';
    const afterUrl = ' for more information.';
    const testText = beforeUrl + url + afterUrl;

    await tester.pumpWidget(buildTestableWidget(const LinkText(testText)));

    final RichText richText = tester.widget(find.byType(RichText));
    final TextSpan span = richText.text as TextSpan;

    expect(span.children, isNotNull);
    expect(span.children!.length, 3);

    final beforeUrlSpan = span.children![0] as TextSpan;
    expect(beforeUrlSpan.text, equals(beforeUrl));

    final urlSpan = span.children![1] as TextSpan;
    expect(urlSpan.text, equals(url));
    expect(urlSpan.style?.decoration, TextDecoration.underline);
    expect(urlSpan.recognizer, isNotNull);

    final afterUrlSpan = span.children![2] as TextSpan;
    expect(afterUrlSpan.text, equals(afterUrl));
  });
}

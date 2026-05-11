import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/utils/sms_helpers.dart';

void main() {
  group('isLikelyTransaction', () {
    test('matches ...XXXX pattern', () {
      expect(isLikelyTransaction('INR 500 debited from A/c ...5237'), isTrue);
    });

    test('matches XX1234 pattern', () {
      expect(isLikelyTransaction('Spent on Card no. XX3348 INR 50'), isTrue);
    });

    test('matches x1234 pattern', () {
      expect(
        isLikelyTransaction('INR 500 spent on Kotak Bank Card x6746'),
        isTrue,
      );
    });

    test('matches Card 1234 pattern', () {
      expect(
        isLikelyTransaction('INR 500 spent on HDFC Bank Card 1234'),
        isTrue,
      );
    });

    test('matches card 1234 pattern (lowercase)', () {
      expect(
        isLikelyTransaction('INR 500 spent on hdfc bank card 1234'),
        isTrue,
      );
    });

    test('matches Card ending 1234 pattern', () {
      expect(
        isLikelyTransaction('INR 500 spent on HDFC Bank Card ending 1234'),
        isTrue,
      );
    });

    test('matches card ending 1234 pattern (lowercase)', () {
      expect(
        isLikelyTransaction('INR 500 spent on hdfc bank card ending 1234'),
        isTrue,
      );
    });

    test('does not match plain promotional SMS', () {
      expect(
        isLikelyTransaction(
          'Congratulations! You have won a prize. Call 9999999999.',
        ),
        isFalse,
      );
    });
  });
}

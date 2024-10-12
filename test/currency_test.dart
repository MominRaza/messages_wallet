import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/utils/currency.dart';

void main() {
  group('currencyFormat', () {
    test('should format amount correctly', () {
      expect(currencyFormat(123.45), '₹123.45');
      expect(currencyFormat(1000), '₹1,000');
      expect(currencyFormat(1234567.89), '₹12,34,567.89');
      expect(currencyFormat(1000000), '₹10,00,000');
      expect(currencyFormat(0), '₹0');
    });
  });
}

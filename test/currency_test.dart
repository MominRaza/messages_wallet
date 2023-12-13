import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/utils/currency.dart';

void main() {
  group('currencyFormat', () {
    test('should format valid amount correctly', () {
      expect(currencyFormat('123.45'), equals('₹123.45'));
      expect(currencyFormat('1000'), equals('₹1,000.00'));
      expect(currencyFormat('1234567.89'), equals('₹12,34,567.89'));
      expect(currencyFormat('1000000'), equals('₹10,00,000.00'));
    });

    test('should return null for invalid amount', () {
      expect(currencyFormat('abc'), isNull);
      expect(currencyFormat(''), isNull);
      expect(currencyFormat(null), isNull);
    });
  });
}

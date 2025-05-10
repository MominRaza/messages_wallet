import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/shared/models/spending_model.dart';
import 'package:messages_wallet/src/utils/currency.dart';

void main() {
  group('currencyFormat', () {
    test('should format amount correctly without transaction type', () {
      expect(currencyFormat(123.45), '₹123.45');
      expect(currencyFormat(1000), '₹1,000');
      expect(currencyFormat(1234567.89), '₹12,34,567.89');
      expect(currencyFormat(1000000), '₹10,00,000');
      expect(currencyFormat(0), '₹0');
      expect(currencyFormat(-500), '\u2212 ₹500');
      expect(currencyFormat(-123.45), '\u2212 ₹123.45');
    });

    test('should format one decimal place numbers correctly', () {
      expect(currencyFormat(100.1), '₹100.10');
      expect(currencyFormat(9999.5), '₹9,999.50');
      expect(currencyFormat(0.5), '₹0.50');
      expect(currencyFormat(-0.5), '\u2212 ₹0.50');
      expect(currencyFormat(10.7), '₹10.70');
    });

    test('should format with credited transaction type as positive', () {
      expect(currencyFormat(100, TransactionType.credited), '₹100');
      expect(currencyFormat(100.5, TransactionType.credited), '₹100.50');
      expect(currencyFormat(-100, TransactionType.credited), '₹100');
      expect(currencyFormat(-567.89, TransactionType.credited), '₹567.89');
    });

    test(
      'should format with creditCardReversed transaction type as positive',
      () {
        expect(currencyFormat(100, TransactionType.creditCardReversed), '₹100');
        expect(
          currencyFormat(100.5, TransactionType.creditCardReversed),
          '₹100.50',
        );
        expect(
          currencyFormat(-100, TransactionType.creditCardReversed),
          '₹100',
        );
        expect(
          currencyFormat(-567.89, TransactionType.creditCardReversed),
          '₹567.89',
        );
      },
    );
  });
}

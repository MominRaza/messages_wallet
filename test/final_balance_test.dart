import 'package:flutter_test/flutter_test.dart';
import 'package:messages_wallet/src/shared/models/transaction_model.dart';
import 'package:messages_wallet/src/utils/final_balance.dart';

void main() {
  group('finalBalance', () {
    test('should return available limit for credit card spent', () {
      String result = finalBalance(TransactionType.creditCardSpent, '34985');
      expect(result, 'Available Limit: ₹34,985.00');
    });

    test('should return final balance for other transaction types', () {
      String result = finalBalance(TransactionType.withdrawn, '65789.44');
      expect(result, 'Final Balance: ₹65,789.44');
    });

    test('should return N/A when finalAmount is null', () {
      String result = finalBalance(TransactionType.credited, null);
      expect(result, 'Final Balance: N/A');
    });
  });
}

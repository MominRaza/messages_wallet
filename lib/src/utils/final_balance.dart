import '../shared/models/transaction_model.dart';
import 'currency.dart';

String finalBalance(TransactionType type, String? finalAmount) =>
    '${type == TransactionType.creditCardSpent ? 'Available Limit:' : 'Final Balance:'} ${currencyFormat(finalAmount) ?? 'N/A'}';

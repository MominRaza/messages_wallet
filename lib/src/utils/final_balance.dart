import '../shared/models/spending_model.dart';
import 'currency.dart';

String finalBalance(TransactionType type, double? finalAmount) =>
    '${type == TransactionType.creditCardSpent ? 'Available Limit:' : 'Final Balance:'} ${finalAmount != null ? currencyFormat(finalAmount) : 'N/A'}';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../shared/models/spending_model.dart';
import 'bank_patterns.dart';

class UniversalParser {
  static Transaction? parseSms(SmsMessage message) {
    final body = message.body ?? '';
    final bank = BankPatterns.detectBank(body, message.address);
    if (bank == null) return null;

    final isCreditCard = BankPatterns.isCreditCardTransaction(body, bank);
    
    var amount = BankPatterns.extractAmount(body, bank.amountPatterns);
    amount ??= BankPatterns.extractAmount(body, BankPatterns.allBanks.last.amountPatterns);
    if (amount == null || amount <= 0) return null;

    var accountNum = isCreditCard && bank.creditCardPatterns.isNotEmpty
        ? BankPatterns.extractAccountNumber(body, bank.creditCardPatterns)
        : BankPatterns.extractAccountNumber(body, bank.accountPatterns);
    accountNum ??= 'Unknown';

    final fullAccount = isCreditCard 
        ? '${bank.name} Credit Card $accountNum'
        : '${bank.name} $accountNum';

    return Transaction(
      type: BankPatterns.detectTransactionType(body, isCreditCard),
      transactionAmount: amount,
      accountNumber: fullAccount,
      body: body,
      dateTime: BankPatterns.extractDateTime(body, bank.datePatterns) ?? DateTime.now(),
      finalAmount: BankPatterns.extractFinalBalance(body),
    );
  }
}
import '../shared/models/spending_model.dart';

class BankPattern {
  final String name;
  final String bankCode;
  final List<String> keywords;
  final List<String> creditCardKeywords;
  final List<RegExp> amountPatterns;
  final List<RegExp> accountPatterns;
  final List<RegExp> creditCardPatterns;
  final List<RegExp> datePatterns;
  final RegExp? transactionTypePattern;
  final bool isCreditCard;
  
  BankPattern({
    required this.name,
    required this.bankCode,
    required this.keywords,
    required this.amountPatterns, required this.accountPatterns, required this.datePatterns, this.creditCardKeywords = const [],
    this.creditCardPatterns = const [],
    this.transactionTypePattern,
    this.isCreditCard = false,
  });
}

class BankPatterns {
  static final List<BankPattern> allBanks = [
    // ==================== AXIS BANK ====================
    BankPattern(
      name: 'Axis Bank',
      bankCode: 'AXIS',
      keywords: ['axis', 'axisbk', 'axis bank'],
      creditCardKeywords: ['axis bank credit card', 'axis credit card', 'axis bank card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c no\.?\s*XX?(\d+)'),
        RegExp(r'Account\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card no\.?\s*XX?(\d+)'),
        RegExp(r'Credit Card.*?XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})-(\d{2})-(\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
        RegExp(r'(\d{2})/(\d{2})/(\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== HDFC BANK ====================
    BankPattern(
      name: 'HDFC Bank',
      bankCode: 'HDFC',
      keywords: ['hdfc', 'hdfcbk', 'hdfc bank', 'hdfc bank ltd'],
      creditCardKeywords: ['hdfc credit card', 'hdfc bank credit card', 'hdfc card', 'hdfc credit'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
        RegExp(r'Account\s*XX?(\d+)'),
        RegExp(r'Savings A/c.*?(\d{4})'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
        RegExp(r'Credit Card.*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== ICICI BANK ====================
    BankPattern(
      name: 'ICICI Bank',
      bankCode: 'ICICI',
      keywords: ['icici', 'icicibank', 'icici bank'],
      creditCardKeywords: ['icici credit card', 'icici bank credit card', 'icici card', 'icici cc'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
        RegExp(r'Account\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
        RegExp(r'Credit Card.*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== SBI BANK ====================
    BankPattern(
      name: 'SBI Bank',
      bankCode: 'SBI',
      keywords: ['sbi', 'state bank', 'sbibk', 'state bank of india', 'sbi bank'],
      creditCardKeywords: ['sbi credit card', 'sbi card', 'state bank credit card', 'sbi cc'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
        RegExp(r'Account\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
        RegExp(r'Credit Card.*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== BANK OF BARODA ====================
    BankPattern(
      name: 'Bank of Baroda',
      bankCode: 'BOB',
      keywords: ['bob', 'baroda', 'bobtxn', 'bank of baroda'],
      creditCardKeywords: ['bob credit card', 'baroda credit card', 'bank of baroda credit card'],
      amountPatterns: [
        RegExp(r'Rs\.?\s*([\d,]+(?:\.\d{1,2})?)'),
        RegExp(r'INR\s*([\d,]+(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*\.{3}(\d+)'),
        RegExp(r'Account\s*\.{3}(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*\.{3}(\d+)'),
        RegExp(r'Credit Card.*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})-(\d{2})-(\d{4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== COSMOS BANK ====================
    BankPattern(
      name: 'Cosmos Bank',
      bankCode: 'COSMOS',
      keywords: ['cosmos', 'cosmos bank'],
      creditCardKeywords: ['cosmos credit card', 'cosmos bank credit card'],
      amountPatterns: [
        RegExp(r'INR\.?\s*([\d,]+(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*no\s*X{1,2}(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*X{1,2}(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== YES BANK ====================
    BankPattern(
      name: 'Yes Bank',
      bankCode: 'YES',
      keywords: ['yes bank', 'yesbank', 'yes bank ltd'],
      creditCardKeywords: ['yes bank credit card', 'yes credit card', 'yes bank card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
        RegExp(r'Account\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
        RegExp(r'Credit Card.*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== KOTAK BANK ====================
    BankPattern(
      name: 'Kotak Bank',
      bankCode: 'KOTAK',
      keywords: ['kotak', 'kotak bank', 'kotak mahindra'],
      creditCardKeywords: ['kotak credit card', 'kotak bank credit card', 'kotak card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== PNB BANK ====================
    BankPattern(
      name: 'PNB Bank',
      bankCode: 'PNB',
      keywords: ['pnb', 'punjab national bank', 'pnb bank'],
      creditCardKeywords: ['pnb credit card', 'pnb card', 'punjab national bank credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== CANARA BANK ====================
    BankPattern(
      name: 'Canara Bank',
      bankCode: 'CANARA',
      keywords: ['canara', 'canara bank'],
      creditCardKeywords: ['canara credit card', 'canara bank credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== UNION BANK ====================
    BankPattern(
      name: 'Union Bank',
      bankCode: 'UNION',
      keywords: ['union bank', 'union bank of india'],
      creditCardKeywords: ['union bank credit card', 'union credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== IDFC BANK ====================
    BankPattern(
      name: 'IDFC Bank',
      bankCode: 'IDFC',
      keywords: ['idfc', 'idfc bank', 'idfc first bank'],
      creditCardKeywords: ['idfc credit card', 'idfc bank credit card', 'idfc card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
    
    // ==================== INDUSIND BANK ====================
    BankPattern(
      name: 'IndusInd Bank',
      bankCode: 'INDUSIND',
      keywords: ['indusind', 'indusind bank'],
      creditCardKeywords: ['indusind credit card', 'indusind bank credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== FEDERAL BANK ====================
    BankPattern(
      name: 'Federal Bank',
      bankCode: 'FEDERAL',
      keywords: ['federal bank', 'federal'],
      creditCardKeywords: ['federal bank credit card', 'federal credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== RBL BANK ====================
    BankPattern(
      name: 'RBL Bank',
      bankCode: 'RBL',
      keywords: ['rbl', 'rbl bank', 'ratnakar bank'],
      creditCardKeywords: ['rbl credit card', 'rbl bank credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== CUB BANK ====================
    BankPattern(
      name: 'City Union Bank',
      bankCode: 'CUB',
      keywords: ['city union bank', 'cub', 'city union'],
      creditCardKeywords: ['city union credit card', 'cub credit card'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'A/c\s*XX?(\d+)'),
      ],
      creditCardPatterns: [
        RegExp(r'Card\s*XX?(\d+)'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
      ],
    ),
    
    // ==================== DEFAULT/UNKNOWN BANK ====================
    BankPattern(
      name: 'Bank Account',
      bankCode: 'UNKNOWN',
      keywords: ['bank', 'account', 'credited', 'debited', 'transaction'],
      creditCardKeywords: ['credit card', 'card', 'visa', 'mastercard', 'rupay', 'amex'],
      amountPatterns: [
        RegExp(r'INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
        RegExp(r'₹\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)'),
      ],
      accountPatterns: [
        RegExp(r'(?:A/c|Account|Card).*?(\d{4})'),
      ],
      creditCardPatterns: [
        RegExp(r'(?:Credit Card|Card).*?(\d{4})'),
      ],
      datePatterns: [
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})'),
        RegExp(r'(\d{2})[-/](\d{2})[-/](\d{2,4})\s+(\d{2}:\d{2}:\d{2})'),
      ],
    ),
  ];
  
  static BankPattern? detectBank(String message, String? senderAddress) {
    final searchText = (message + (senderAddress ?? '')).toLowerCase();
    
    // First check for credit card patterns
    for (var bank in allBanks) {
      for (var keyword in bank.creditCardKeywords) {
        if (searchText.contains(keyword.toLowerCase())) {
          return bank;
        }
      }
    }
    
    // Then check for bank keywords
    for (var bank in allBanks) {
      for (var keyword in bank.keywords) {
        if (searchText.contains(keyword.toLowerCase())) {
          return bank;
        }
      }
    }
    
    return null;
  }
  
  static bool isCreditCardTransaction(String message, BankPattern bank) {
    final searchText = message.toLowerCase();
    
    // Check credit card specific keywords for this bank
    for (var keyword in bank.creditCardKeywords) {
      if (searchText.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    
    // Generic credit card indicators
    if (searchText.contains('credit card') ||
        searchText.contains('card no') ||
        searchText.contains('spent') ||
        searchText.contains('card transaction')) {
      return true;
    }
    
    return false;
  }
  
  static TransactionType detectTransactionType(String message, bool isCreditCard) {
    final msg = message.toLowerCase();
    
    if (isCreditCard) {
      // Credit card transactions
      if (msg.contains('reversal') || msg.contains('reversed') || msg.contains('refund')) {
        return TransactionType.creditCardReversed;
      }
      if (msg.contains('spent') || msg.contains('purchase') || msg.contains('debit') || msg.contains('debited')) {
        return TransactionType.creditCardSpent;  // This is DEBIT for credit card
      }
      if (msg.contains('credit') || msg.contains('credited')) {
        return TransactionType.creditCardReversed;  // Credit to credit card = reversal
      }
      return TransactionType.creditCardSpent;
    } else {
      // Bank account transactions
      if (msg.contains('credit') || msg.contains('credited') || msg.contains('received')) {
        return TransactionType.credited;
      }
      if (msg.contains('debit') || msg.contains('debited') || msg.contains('transfer')) {
        return TransactionType.transferred;
      }
      if (msg.contains('withdraw') || msg.contains('atm')) {
        return TransactionType.withdrawn;
      }
      return TransactionType.transferred;
    }
  }
  
  static double? extractAmount(String message, List<RegExp> patterns) {
    for (var pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        String amountStr = match.group(1)?.replaceAll(',', '') ?? '';
        return double.tryParse(amountStr);
      }
    }
    return null;
  }
  
  static String? extractAccountNumber(String message, List<RegExp> patterns) {
    for (var pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        String account = match.group(1) ?? '';
        if (account.isNotEmpty) {
          return account.length > 4 ? account.substring(account.length - 4) : account;
        }
      }
    }
    return null;
  }
  
  static DateTime? extractDateTime(String message, List<RegExp> patterns) {
    for (var pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        try {
          String day = match.group(1) ?? '';
          String month = match.group(2) ?? '';
          String year = match.group(3) ?? '';
          String time = match.groupCount >= 4 ? (match.group(4) ?? '00:00:00') : '00:00:00';
          
          if (year.length == 2) year = '20$year';
          if (int.parse(day) > 31) {
            // Swap day and month if needed
            String temp = day;
            day = month;
            month = temp;
          }
          
          String dateTimeStr = '$year-$month-$day $time';
          return DateTime.tryParse(dateTimeStr);
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }
  
  static double? extractFinalBalance(String message) {
    final patterns = [
      RegExp(r'Avl\s*Bal\s*[:\s]*INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'Balance\s*[:\s]*INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'Bal\s*[:\s]*INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),  // ADD THIS
      RegExp(r'Available\s*balance\s*[:\s]*INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),  // ADD THIS
      RegExp(r'Available\s*limit\s*[:\s]*INR\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'Avlbl\s*Amt\s*[:\s]*Rs\.\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
      RegExp(r'Bal\s*[:\s]*₹\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
      // Generic balance pattern for any format
      RegExp(r'(?:Bal|Balance|Avl Bal|Available balance)\s*[:\s]*[A-Za-z]*\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false),
    ];
    
    for (var pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        String balanceStr = match.group(1)?.replaceAll(',', '') ?? '';
        final balance = double.tryParse(balanceStr);
        if (balance != null && balance > 0) {
          return balance;
        }
      }
    }
    return null;
  }
}
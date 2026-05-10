const supportedSenders = ['axisbk', 'bobtxn', 'cosmos'];
final dltRegex = RegExp(r'^[A-Za-z]{2}-[A-Za-z0-9]{3,8}$');
final _allDigitsRegex = RegExp(r'^\d+$');

// Minimum bare requirement derived from all existing bank extractors.
// A message must match all three to be considered a likely transaction.
final _amountRegex = RegExp(r'(Rs\.|INR)\s*[\d,]+', caseSensitive: false);
final _dateRegex = RegExp(r'\d{2}[-/]\d{2}[-/]\d{2,4}');
final _keywordRegex = RegExp(
  r'credit|debit|withdraw|transfer|spent',
  caseSensitive: false,
);

bool isLikelyTransaction(String body) =>
    _amountRegex.hasMatch(body) &&
    _dateRegex.hasMatch(body) &&
    _keywordRegex.hasMatch(body);

String groupKey(String address) {
  final dash = address.indexOf('-');
  return dash == -1 ? address : address.substring(dash + 1);
}

bool isNumericOnly(String key) => _allDigitsRegex.hasMatch(key);

bool isSupported(String key) => supportedSenders.contains(key.toLowerCase());

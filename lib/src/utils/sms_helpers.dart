const supportedSenders = ['axisbk', 'bobtxn', 'cosmos'];
final dltRegex = RegExp(r'^[A-Za-z]{2}-[A-Za-z0-9]{3,8}$');
final _allDigitsRegex = RegExp(r'^\d+$');

// A message is considered a likely transaction if it contains at least
// 4 consecutive digits (e.g. account number).
final _fourDigitsRegex = RegExp(r'\d{4}');

bool isLikelyTransaction(String body) => _fourDigitsRegex.hasMatch(body);

String groupKey(String address) {
  final dash = address.indexOf('-');
  final key = dash == -1 ? address : address.substring(dash + 1);
  return key.toUpperCase();
}

bool isNumericOnly(String key) => _allDigitsRegex.hasMatch(key);

bool isSupported(String key) => supportedSenders.contains(key.toLowerCase());

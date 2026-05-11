const supportedSenders = ['axisbk', 'bobtxn', 'cosmos'];
final dltRegex = RegExp(r'^[A-Za-z]{2}-[A-Za-z0-9]{3,8}$');
final _allDigitsRegex = RegExp(r'^\d+$');

final _fourDigitsRegex = RegExp(r'\d{4}');

bool isLikelyTransaction(String body) => _fourDigitsRegex.hasMatch(body);

String groupKey(String address) {
  final dash = address.indexOf('-');
  final key = dash == -1 ? address : address.substring(dash + 1);
  return key.toUpperCase();
}

bool isNumericOnly(String key) => _allDigitsRegex.hasMatch(key);

bool isSupported(String key) => supportedSenders.contains(key.toLowerCase());

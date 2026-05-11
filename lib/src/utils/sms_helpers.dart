const supportedSenders = [
  'axisbk',
  'bobtxn',
  'cosmos',
  'hdfcbk',
  'icicit',
  'kotakb',
];
final dltRegex = RegExp(r'^[A-Z]{2}-[A-Za-z0-9]{6}(?:-[ST])?$');
final _allDigitsRegex = RegExp(r'^\d+$');

final _transactionIndicatorRegex = RegExp(
  r'(?:\.{3}|X{1,2}|x{1,2})\d{4,6}|[Cc]ard(?:\s+ending)?\s+\d{4}',
);

bool isLikelyTransaction(String body) =>
    _transactionIndicatorRegex.hasMatch(body);

String groupKey(String address) {
  final firstDash = address.indexOf('-');
  if (firstDash == -1) return address.toUpperCase();
  final afterFirst = address.substring(firstDash + 1);
  final secondDash = afterFirst.indexOf('-');
  final key = secondDash == -1
      ? afterFirst
      : afterFirst.substring(0, secondDash);
  return key.toUpperCase();
}

bool isNumericOnly(String key) => _allDigitsRegex.hasMatch(key);

bool isSupported(String key) => supportedSenders.contains(key.toLowerCase());

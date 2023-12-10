import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) =>
    '${DateFormat('MMM d, y').format(dateTime)} at ${DateFormat('h:m a').format(dateTime)}';

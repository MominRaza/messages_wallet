import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) =>
    '${DateFormat('MMM d, y').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';

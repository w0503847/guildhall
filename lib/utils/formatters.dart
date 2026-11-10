import 'package:intl/intl.dart';

final _postTimeFormat = DateFormat('EEE, MMM d · h:mm a');

/// e.g. "Thu, Nov 12 · 8:00 PM"
String formatPostTime(DateTime dateTime) => _postTimeFormat.format(dateTime);

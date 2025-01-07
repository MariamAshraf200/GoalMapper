

import 'package:intl/intl.dart';

String formatedDate(
    DateTime date, {
      bool useRelativeDateLabels = true,
    }) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  if (useRelativeDateLabels) {
    if (date.isAtSameMomentAs(today)) {
      return "Today";
    } else if (date.isAtSameMomentAs(yesterday)) {
      return "Yesterday";
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return "Tomorrow";
    }
  }

  // Default date formatting if not Today/Yesterday/Tomorrow
  return DateFormat('yyyy-MM-dd').format(date);
}

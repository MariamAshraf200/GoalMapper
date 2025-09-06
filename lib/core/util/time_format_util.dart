import 'package:flutter/material.dart';

class TimeFormatUtil {
  /// Formats a [TimeOfDay] to a string, optionally using [context] for locale-aware formatting.
  static String? formatTime(TimeOfDay? timeOfDay, [BuildContext? context]) {
    if (timeOfDay == null) return null;
    if (context != null) return timeOfDay.format(context);

    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Parses a time string in 'hh:mm a' format to a TimeOfDay object.
  static TimeOfDay parseTime(String timeStr) {
    final format = RegExp(r'^(\d{1,2}):(\d{2})\s*([AP]M)$', caseSensitive: false);
    final match = format.firstMatch(timeStr.trim());
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);
      final String period = match.group(3)!.toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    throw FormatException('Invalid time format: $timeStr');
  }
}

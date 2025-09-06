import 'package:intl/intl.dart';

class DateFormatUtil {
  /// Returns the current date formatted as 'dd/MM/yyyy'.
  static String getCurrentDateFormatted() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  /// Formats a given [date] as 'dd/MM/yyyy'.
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formats a given [date] as 'yyyy/MM/dd'.
  static String formatDateYearFirst(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  /// Parses a date string in 'dd/MM/yyyy' format to a DateTime object.
  static DateTime parseDate(String dateStr) {
    return DateFormat('dd/MM/yyyy').parse(dateStr);
  }

  /// Formats a given [dateStr] ('dd/MM/yyyy') into 'MMMM d, yyyy' (e.g. April 20th, 2024).
  static String formatFullDate(String dateStr) {
    final date = parseDate(dateStr);
    return DateFormat("MMMM d, yyyy").format(date);
  }
}

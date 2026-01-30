import 'package:flutter/material.dart';

/// Utility class for date formatting
class DateFormatHelper {
  /// Formats a date with "Today" prefix if it's today
  /// 
  /// Example: "Today, 29 Jan, 2026" or "15 Dec, 2025"
  static String formatDate(DateTime date, {TimeOfDay? time}) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Today, ${date.day} ${getMonthAbbreviation(date.month)}, ${date.year}";
    }
    return "${date.day} ${getMonthAbbreviation(date.month)}, ${date.year}";
  }

  /// Gets the abbreviated month name
  /// 
  /// Example: 1 -> "Jan", 12 -> "Dec"
  static String getMonthAbbreviation(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  /// Formats date with time
  /// 
  /// Example: "Today, 29 Jan, 2026 at 3:45 PM"
  static String formatDateWithTime(DateTime date, TimeOfDay time) {
    final dateStr = formatDate(date);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return "$dateStr at $hour:$minute $period";
  }
}

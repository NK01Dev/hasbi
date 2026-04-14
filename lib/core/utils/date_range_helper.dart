import 'package:flutter/material.dart';
import '../../features/finance/data/models/finance_enums.dart';

class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);
}

class DateRangeHelper {
  static DateRange resolve({
    required StatsPeriod period,
    required DateTime anchor,
    DateTimeRange? customRange,
  }) {
    if (customRange != null) {
      return DateRange(
        DateTime(
          customRange.start.year,
          customRange.start.month,
          customRange.start.day,
        ),
        DateTime(
          customRange.end.year,
          customRange.end.month,
          customRange.end.day,
          23,
          59,
          59,
        ),
      );
    }
    switch (period) {
      case StatsPeriod.day:
        final s = DateTime(anchor.year, anchor.month, anchor.day);
        return DateRange(
          s,
          DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59),
        );
      case StatsPeriod.week:
        final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
        final s = DateTime(monday.year, monday.month, monday.day);
        return DateRange(
          s,
          s.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59)),
        );
      case StatsPeriod.month:
        return DateRange(
          DateTime(anchor.year, anchor.month, 1),
          DateTime(anchor.year, anchor.month + 1, 0, 23, 59, 59),
        );
      case StatsPeriod.year:
        return DateRange(
          DateTime(anchor.year),
          DateTime(anchor.year, 12, 31, 23, 59, 59),
        );
    }
  }
}

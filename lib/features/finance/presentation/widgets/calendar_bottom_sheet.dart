import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:intl/intl.dart';

class CalendarBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?)? onRangeSelected;
  final bool enableRangeSelection;

  const CalendarBottomSheet({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onRangeSelected,
    this.enableRangeSelection = true,
  });

  static Future<Map<String, DateTime?>?> show({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    bool enableRangeSelection = true,
  }) async {
    return await showModalBottomSheet<Map<String, DateTime?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarBottomSheet(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        enableRangeSelection: enableRangeSelection,
        onRangeSelected: (start, end) {
          Navigator.pop(context, {'start': start, 'end': end});
        },
      ),
    );
  }

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _focusedMonth = widget.initialStartDate ?? DateTime.now();
  }

  void _handleDateTap(DateTime date) {
    if (!widget.enableRangeSelection) {
      setState(() {
        _startDate = date;
        _endDate = null;
      });
      return;
    }

    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Start new range
        _startDate = date;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        // Complete the range
        if (date.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
      }
    });
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null) return false;
    if (_endDate == null) return _isSameDay(date, _startDate!);

    return (date.isAfter(_startDate!) || _isSameDay(date, _startDate!)) &&
        (date.isBefore(_endDate!) || _isSameDay(date, _endDate!));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isStartOrEndDate(DateTime date) {
    return (_startDate != null && _isSameDay(date, _startDate!)) ||
        (_endDate != null && _isSameDay(date, _endDate!));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(height: SpacingHelper.lg),

          // Month/Year Header with Navigation
          Padding(
            padding: SpacingHelper.pHMedium,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 28.sp),
                  onPressed: _previousMonth,
                  color: Colors.black87,
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedMonth),
                  style: TextStyleHelper.textStyle20(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 28.sp),
                  onPressed: _nextMonth,
                  color: Colors.black87,
                ),
              ],
            ),
          ),

          SizedBox(height: SpacingHelper.md),

          // Calendar Grid
          Expanded(
            child: Padding(
              padding: SpacingHelper.pHMedium,
              child: Column(
                children: [
                  // Weekday Headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                        .map((day) => SizedBox(
                      width: 40.w,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyleHelper.textStyle11(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),

                  SizedBox(height: SpacingHelper.md),

                  // Calendar Days Grid
                  Expanded(
                    child: _buildCalendarGrid(),
                  ),
                ],
              ),
            ),
          ),

          // Selected Range Display
          if (_startDate != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: SpacingHelper.md),
              padding: EdgeInsets.all(SpacingHelper.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SELECTED RANGE',
                          style: TextStyleHelper.textStyle11(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDateRange(),
                          style: TextStyleHelper.textStyle16(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 20.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: SpacingHelper.md),

          // Action Buttons
          Padding(
            padding: EdgeInsets.all(SpacingHelper.md),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyleHelper.textStyle16(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SpacingHelper.sm),
                // Apply Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _startDate != null
                        ? () {
                      widget.onRangeSelected?.call(_startDate, _endDate);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A7B8E),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Period',
                      style: TextStyleHelper.textStyle16(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    // Start from Monday
    int weekdayOffset = firstDayOfMonth.weekday - 1; // Monday = 0

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = weekdayOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final dayNumber = rowIndex * 7 + colIndex - weekdayOffset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return SizedBox(width: 40.w, height: 40.h);
              }

              final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
              final isInRange = _isDateInRange(date);
              final isStartOrEnd = _isStartOrEndDate(date);

              return GestureDetector(
                onTap: () => _handleDateTap(date),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isStartOrEnd
                        ? AppColors.primary
                        : isInRange
                        ? AppColors.primary.withOpacity(0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyleHelper.textStyle16(
                        color: isStartOrEnd
                            ? Colors.white
                            : isInRange
                            ? AppColors.primary
                            : Colors.black87,
                        fontWeight: isStartOrEnd ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  String _formatDateRange() {
    if (_startDate == null) return '';

    final dateFormat = DateFormat('MMM d');

    if (_endDate == null) {
      return '${dateFormat.format(_startDate!)}, ${_startDate!.year}';
    }

    if (_startDate!.year == _endDate!.year) {
      return '${dateFormat.format(_startDate!)} - ${dateFormat.format(_endDate!)}, ${_startDate!.year}';
    }

    return '${dateFormat.format(_startDate!)}, ${_startDate!.year} - ${dateFormat.format(_endDate!)}, ${_endDate!.year}';
  }
}
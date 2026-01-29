import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/stats_provider.dart';

class DayTimelineWidget extends ConsumerWidget {
  final DateTime selectedDate;

  const DayTimelineWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpacingHelper.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: EasyDateTimeLine(
        initialDate: selectedDate,
        activeColor: const Color(0xFF5B7FFF),
        headerProps: _buildHeaderProps(),
        dayProps: _buildDayProps(),
        onDateChange: (date) {
          ref.read(selectedDateProvider.notifier).update(date);
        },
      ),
    );
  }

  EasyHeaderProps _buildHeaderProps() {
    return EasyHeaderProps(
      showHeader: true,
      monthPickerType: MonthPickerType.dropDown,
      dateFormatter: const DateFormatter.custom('MMMM yyyy'),
      monthStyle: TextStyleHelper.textStyle14(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      selectedDateStyle: TextStyleHelper.textStyle14(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  EasyDayProps _buildDayProps() {
    return EasyDayProps(
      height: 80.h,
      width: 56.w,
      dayStructure: DayStructure.dayStrDayNum,
      inactiveDayStyle: _buildInactiveDayStyle(),
      activeDayStyle: _buildActiveDayStyle(),
      todayStyle: _buildTodayStyle(),
    );
  }

  DayStyle _buildInactiveDayStyle() {
    return DayStyle(
      monthStrStyle: TextStyleHelper.textStyle10(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
      dayNumStyle: TextStyleHelper.textStyle16(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
      dayStrStyle: TextStyleHelper.textStyle10(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SpacingHelper.xs),
      ),
    );
  }

  DayStyle _buildActiveDayStyle() {
    return DayStyle(
      monthStrStyle: TextStyleHelper.textStyle10(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      dayNumStyle: TextStyleHelper.textStyle16(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      dayStrStyle: TextStyleHelper.textStyle10(
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FFF),
        borderRadius: BorderRadius.circular(SpacingHelper.xs),
      ),
    );
  }

  DayStyle _buildTodayStyle() {
    return DayStyle(
      monthStrStyle: TextStyleHelper.textStyle10(
        color: const Color(0xFF5B7FFF),
        fontWeight: FontWeight.w600,
      ),
      dayNumStyle: TextStyleHelper.textStyle16(
        color: const Color(0xFF5B7FFF),
        fontWeight: FontWeight.bold,
      ),
      dayStrStyle: TextStyleHelper.textStyle10(
        color: const Color(0xFF5B7FFF).withOpacity(0.7),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(SpacingHelper.xs),
        border: Border.all(
          color: const Color(0xFF5B7FFF).withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }
}
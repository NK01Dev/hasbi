import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/stats_provider.dart';
import '../widgets/transaction_tile.dart';

class StatsView extends HookConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the providers
    final selectedDate = ref.watch(selectedDateProvider);
    final filterMode = ref.watch(statsFilterProvider);
    final customRange = ref.watch(customRangeProvider);
    final asyncTransactions = ref.watch(statsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: SpacingHelper.pAllSmall,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Mode Selector
              _buildFilterModeSelector(context, ref, filterMode),
              SizedBox(height: 16.h),

              // Date Timeline - Always visible with different configurations based on mode
              _buildDateTimeline(
                context,
                ref,
                filterMode,
                selectedDate,
                customRange,
              ),
              SizedBox(height: 20.h),

        

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyleHelper.textStyle16(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getFilterLabel(filterMode, selectedDate, customRange),
                    style: TextStyleHelper.textStyle12(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Transaction List
              asyncTransactions.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64.sp,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "No transactions found",
                              style: TextStyleHelper.textStyle14(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: transactions
                        .map((tx) => TransactionTile(transaction: tx))
                        .toList(),
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: const CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Error: $error",
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterModeSelector(
    BuildContext context,
    WidgetRef ref,
    DateFilterMode mode,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildModeButton(context, ref, 'Day', DateFilterMode.day, mode),
          _buildModeButton(context, ref, 'Month', DateFilterMode.month, mode),
          _buildModeButton(context, ref, 'Year', DateFilterMode.year, mode),
          _buildModeButton(
            context,
            ref,
            'Custom',
            DateFilterMode.customRange,
            mode,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    DateFilterMode filterMode,
    DateFilterMode currentMode,
  ) {
    final isSelected = filterMode == currentMode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(statsFilterProvider.notifier).setMode(filterMode);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyleHelper.textStyle13(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeline(
    BuildContext context,
    WidgetRef ref,
    DateFilterMode mode,
    DateTime selectedDate,
    DateTimeRange? customRange,
  ) {
    switch (mode) {
      case DateFilterMode.day:
        return _buildDayTimeline(ref, selectedDate);
      case DateFilterMode.month:
        return _buildMonthTimeline(context, ref, selectedDate);
      case DateFilterMode.year:
        return _buildYearTimeline(context, ref, selectedDate);
      case DateFilterMode.customRange:
        return _buildCustomRangeTimeline(context, ref, customRange);
    }
  }

  // Day Mode - Shows individual days in a horizontal timeline
  Widget _buildDayTimeline(WidgetRef ref, DateTime selectedDate) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
        headerProps: EasyHeaderProps(
          showHeader: true,
          monthPickerType: MonthPickerType.dropDown,
          dateFormatter: const DateFormatter.fullDateMDY(),
          monthStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          selectedDateStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        dayProps: EasyDayProps(
          height: 70.h,
          width: 56.w,
          dayStructure: DayStructure.dayStrDayNum,
          inactiveDayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          activeDayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          todayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFF5B7FFF).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
        onDateChange: (date) {
          ref.read(selectedDateProvider.notifier).update(date);
        },
      ),
    );
  }

  // Month Mode - Shows weeks with days in month view
  Widget _buildMonthTimeline(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
        headerProps: EasyHeaderProps(
          showHeader: true,
          monthPickerType: MonthPickerType.dropDown,
          dateFormatter: const DateFormatter.monthOnly(),
          monthStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          selectedDateStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        timeLineProps: EasyTimeLineProps(hPadding: 16.w, vPadding: 12.h),
        dayProps: EasyDayProps(
          height: 70.h,
          width: 56.w,
          dayStructure: DayStructure.dayStrDayNum,
          inactiveDayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          activeDayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          todayStyle: DayStyle(
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
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFF5B7FFF).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
        onDateChange: (date) {
          ref.read(selectedDateProvider.notifier).update(date);
        },
      ),
    );
  }

  // Year Mode - Shows months in a timeline
  Widget _buildYearTimeline(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
        headerProps: EasyHeaderProps(
          showHeader: true,
          monthPickerType: MonthPickerType.dropDown,
          dateFormatter: const DateFormatter.custom('yyyy'),  // Fixed here
          monthStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          selectedDateStyle: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        timeLineProps: EasyTimeLineProps(hPadding: 16.w, vPadding: 12.h),
        dayProps: EasyDayProps(
          height: 70.h,
          width: 56.w,
          dayStructure: DayStructure.monthDayNumDayStr,
          inactiveDayStyle: DayStyle(
            monthStrStyle: TextStyleHelper.textStyle11(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
            dayNumStyle: TextStyleHelper.textStyle14(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            dayStrStyle: TextStyleHelper.textStyle10(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          activeDayStyle: DayStyle(
            monthStrStyle: TextStyleHelper.textStyle11(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dayNumStyle: TextStyleHelper.textStyle14(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dayStrStyle: TextStyleHelper.textStyle10(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF5B7FFF),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          todayStyle: DayStyle(
            monthStrStyle: TextStyleHelper.textStyle11(
              color: const Color(0xFF5B7FFF),
              fontWeight: FontWeight.bold,
            ),
            dayNumStyle: TextStyleHelper.textStyle14(
              color: const Color(0xFF5B7FFF),
              fontWeight: FontWeight.bold,
            ),
            dayStrStyle: TextStyleHelper.textStyle10(
              color: const Color(0xFF5B7FFF).withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF5B7FFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFF5B7FFF).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
        onDateChange: (date) {
          ref.read(selectedDateProvider.notifier).update(date);
        },
      ),
    );
  }

  // Custom Range Mode - Shows date range selection
  Widget _buildCustomRangeTimeline(
    BuildContext context,
    WidgetRef ref,
    DateTimeRange? range,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          initialDateRange: range,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF5B7FFF),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          ref.read(customRangeProvider.notifier).setRange(picked);
          // Update selected date to the start of the range
          ref.read(selectedDateProvider.notifier).update(picked.start);
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: const Color(0xFF5B7FFF),
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Select Custom Date Range',
                  style: TextStyleHelper.textStyle14(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            if (range != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B7FFF).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyleHelper.textStyle11(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          DateFormat('MMM dd, yyyy').format(range.start),
                          style: TextStyleHelper.textStyle14(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5B7FFF),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFF5B7FFF),
                        size: 16.sp,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'To',
                          style: TextStyleHelper.textStyle11(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          DateFormat('MMM dd, yyyy').format(range.end),
                          style: TextStyleHelper.textStyle14(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5B7FFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget _buildSummaryStats(
  //   AsyncValue<List<TransactionDisplayModel>> asyncTransactions,
  // ) {
  //   return asyncTransactions.when(
  //     data: (transactions) {
  //       final totalIncome = transactions
  //           .where((t) => !t.isExpense)
  //           .fold<double>(0, (sum, t) => sum + t.amount);
  //       final totalExpense = transactions
  //           .where((t) => t.isExpense)
  //           .fold<double>(0, (sum, t) => sum + t.amount);
  //       final balance = totalIncome - totalExpense;
  //
  //       return Container(
  //         padding: EdgeInsets.all(20.w),
  //         decoration: BoxDecoration(
  //           gradient: const LinearGradient(
  //             colors: [Color(0xFF5B7FFF), Color(0xFF4C6AE8)],
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //           ),
  //           borderRadius: BorderRadius.circular(16.r),
  //           boxShadow: [
  //             BoxShadow(
  //               color: const Color(0xFF5B7FFF).withOpacity(0.3),
  //               blurRadius: 12,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildStatItem('Income', totalIncome, const Color(0xFF4ADE80)),
  //             Container(width: 1, height: 40.h, color: Colors.white30),
  //             _buildStatItem('Expense', totalExpense, const Color(0xFFF87171)),
  //             Container(width: 1, height: 40.h, color: Colors.white30),
  //             _buildStatItem('Balance', balance, Colors.white),
  //           ],
  //         ),
  //       );
  //     },
  //     loading: () => const SizedBox.shrink(),
  //     error: (_, __) => const SizedBox.shrink(),
  //   );
  // }

  Widget _buildStatItem(String label, double amount, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyleHelper.textStyle11(
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyleHelper.textStyle16(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _getFilterLabel(
    DateFilterMode mode,
    DateTime selectedDate,
    DateTimeRange? customRange,
  ) {
    switch (mode) {
      case DateFilterMode.day:
        return DateFormat('MMM dd, yyyy').format(selectedDate);
      case DateFilterMode.month:
        return DateFormat('MMMM yyyy').format(selectedDate);
      case DateFilterMode.year:
        return DateFormat('yyyy').format(selectedDate);
      case DateFilterMode.customRange:
        if (customRange == null) return 'Select range';
        final days = customRange.end.difference(customRange.start).inDays + 1;
        return '$days days selected';
    }
  }
}

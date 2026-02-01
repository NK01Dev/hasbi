import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/widgets/empty_widget.dart';
import '../../../../core/common/widgets/error_widget.dart' as custom;
import '../../../../core/common/widgets/loading_widget.dart' as custom;
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/features/finance/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:hasbi/features/finance/presentation/widgets/dashboard_animations.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';
import 'package:hasbi/features/auth/presentation/providers/user_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/finance_enums.dart';

class StatsView extends HookConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedFilter = ref.watch(statisticsControllerProvider);
    
    // Map StatsPeriod enum to int for SegmentedControl
    final initialFilterValue = switch(selectedFilter) {
      StatsPeriod.day => 1,
      StatsPeriod.week => 2,
      StatsPeriod.month => 3,
      StatsPeriod.year => 4,
    };

    final user = ref.watch(currentUserProvider).value;
    final userId = user?.id ?? '';
    final statsAsync = ref.watch(statisticsProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Statistics',
          style: TextStyleHelper.textStyle18(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () async {
                final result = await CalendarBottomSheet.show(
                  context: context,
                  initialStartDate: selectedDate,
                  enableRangeSelection: true,
                );
                if (result != null) {
                  if (result['start'] != null && result['end'] != null) {
                    ref.read(statsFilterProvider.notifier).setMode(DateFilterMode.customRange);
                    ref.read(customRangeProvider.notifier).update(DateTimeRange(start: result['start']!, end: result['end']!));
                    ref.read(selectedDateProvider.notifier).update(result['start']!);
                  } else if (result['start'] != null) {
                    ref.read(statsFilterProvider.notifier).setMode(DateFilterMode.day);
                    ref.read(selectedDateProvider.notifier).update(result['start']!);
                    ref.read(customRangeProvider.notifier).update(null);
                  }
                }
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // White background for segmented control
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: SpacingHelper.md,
              vertical: SpacingHelper.sm,
            ),
            child: Center(
              child: CustomSlidingSegmentedControl<int>(
                initialValue: initialFilterValue,
                children: {
                  1: _buildSegmentText('DAY'),
                  2: _buildSegmentText('WEEK'),
                  3: _buildSegmentText('MONTH'),
                  4: _buildSegmentText('YEAR'),
                },
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                onValueChanged: (v) {
                  StatsPeriod period;
                  switch(v) {
                    case 1: period = StatsPeriod.day; break;
                    case 2: period = StatsPeriod.week; break;
                    case 4: period = StatsPeriod.year; break;
                    default: period = StatsPeriod.month; break;
                  }
                  ref.read(statisticsControllerProvider.notifier).setPeriod(period);
                  ref.read(statsFilterProvider.notifier).setMode(DateFilterMode.day);
                  ref.read(customRangeProvider.notifier).update(null);
                },
              ),
            ),
          ),
          Expanded(
            child: statsAsync.when(
              loading: () => const custom.LoadingWidget(),
              error: (err, stack) => custom.ErrorWidget(
                errorMessage: 'Failed to load statistics.',
                onRetry: () => ref.refresh(statisticsProvider(userId)),
              ),
              data: (data) {
                if (data.totalIncome == 0 && data.totalExpense == 0) {
                  return const EmptyWidget(message: 'No data found for this period.');
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: SpacingHelper.md),
                      StaggeredEntrance(
                        index: 1,
                        child: _buildSummaryCard(data),
                      ),
                      SizedBox(height: SpacingHelper.md),
                      StaggeredEntrance(
                        index: 2,
                        child: _buildInsightCardsSection(),
                      ),
                      SizedBox(height: SpacingHelper.md),
                      StaggeredEntrance(
                        index: 3,
                        child: _buildWeeklyTrendSection(data),
                      ),
                      SizedBox(height: SpacingHelper.md),
                      _buildCategoryDetailsSection(data),
                      SizedBox(height: 100.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyleHelper.textStyle12(
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey.shade700,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(StatisticsData data) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Breakdown',
                style: TextStyleHelper.textStyle14(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 12.sp, color: AppColors.success),
                    SizedBox(width: 4.w),
                    Text(
                      '12%',
                      style: TextStyleHelper.textStyle12(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '\$${data.totalExpense.toStringAsFixed(2)}',
            style: TextStyleHelper.textStyle32(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: SpacingHelper.lg),
          SizedBox(
            height: 260.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 85.w,
                    sections: _buildPieChartSections(data.categoryBreakdown),
                    borderData: FlBorderData(show: false),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyleHelper.textStyle11(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Expenses',
                      style: TextStyleHelper.textStyle20(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingHelper.lg),
          Column(
            children: [
              ...List.generate((data.categoryBreakdown.length / 2).ceil(), (index) {
                final firstIndex = index * 2;
                final secondIndex = firstIndex + 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == (data.categoryBreakdown.length / 2).ceil() - 1 ? 0 : SpacingHelper.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLegendItem(
                          data.categoryBreakdown[firstIndex].categoryName,
                          '\$${data.categoryBreakdown[firstIndex].amount.toStringAsFixed(0)}',
                          data.categoryBreakdown[firstIndex].color,
                        ),
                      ),
                      SizedBox(width: SpacingHelper.md),
                      if (secondIndex < data.categoryBreakdown.length)
                        Expanded(
                          child: _buildLegendItem(
                            data.categoryBreakdown[secondIndex].categoryName,
                            '\$${data.categoryBreakdown[secondIndex].amount.toStringAsFixed(0)}',
                            data.categoryBreakdown[secondIndex].color,
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List<CategoryStat> categories) {
    if (categories.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade200,
          value: 100,
          title: '',
          radius: 40.w,
        ),
      ];
    }
    return categories.map((cat) {
      return PieChartSectionData(
        color: cat.color,
        value: cat.amount,
        title: '',
        radius: 40.w,
      );
    }).toList();
  }

  Widget _buildLegendItem(String label, String amount, Color color) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyleHelper.textStyle10(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                amount,
                style: TextStyleHelper.textStyle14(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCardsSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildInsightCard(
            icon: Icons.trending_up,
            title: 'You saved 12% more than last month. Keep it up!',
            buttonText: 'VIEW DETAILS',
            color: const Color(0xFF2C7A7B),
          ),
        ),
        SizedBox(width: SpacingHelper.sm),
        Expanded(
          child: _buildWarningCard(
            icon: Icons.warning_amber_rounded,
            title: "'Dining Out'\nthan your budget",
            buttonText: 'ADJUST BUDGET',
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String buttonText,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.md),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: SpacingHelper.sm),
          Text(
            title,
            style: TextStyleHelper.textStyle13(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SpacingHelper.sm),
          Text(
            buttonText,
            style: TextStyleHelper.textStyle11(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String buttonText,
  }) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: const Color(0xFFE53E3E), size: 20.sp),
          ),
          SizedBox(height: SpacingHelper.sm),
          Text(
            title,
            style: TextStyleHelper.textStyle11(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SpacingHelper.sm),
          Text(
            buttonText,
            style: TextStyleHelper.textStyle10(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendSection(StatisticsData data) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Trend',
                style: TextStyleHelper.textStyle16(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Daily Avg: \$${(data.dailyAverage ?? 0).toStringAsFixed(0)}',
                style: TextStyleHelper.textStyle13(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: SpacingHelper.md),
          SizedBox(
            height: 120.h,
            child: _buildWeeklyBarChart(data.weeklyTrend),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBarChart(List<DailySpending> weeklyTrend) {
    if (weeklyTrend.isEmpty) {
      return Center(
        child: Text(
          'No data for this week',
          style: TextStyleHelper.textStyle13(color: AppColors.textSecondary),
        ),
      );
    }

    final maxAmount = weeklyTrend.map((e) => e.amount).fold(0.0, (prev, element) => element > prev ? element : prev);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxAmount + 50,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < weeklyTrend.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      DateFormat('E').format(weeklyTrend[index].date).toUpperCase(),
                      style: TextStyleHelper.textStyle10(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: List.generate(
          weeklyTrend.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: weeklyTrend[index].amount,
                color: weeklyTrend[index].amount == maxAmount && maxAmount > 0
                    ? const Color(0xFF2C7A7B)
                    : Colors.grey.shade300,
                width: 24.w,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDetailsSection(StatisticsData data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category Details',
              style: TextStyleHelper.textStyle18(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              'See All',
              style: TextStyleHelper.textStyle14(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: SpacingHelper.md),
        ...List.generate(data.categoryBreakdown.length, (index) {
          final cat = data.categoryBreakdown[index];
          return Padding(
            padding: EdgeInsets.only(bottom: SpacingHelper.sm),
            child: StaggeredEntrance(
              index: index + 4,
              child: _buildCategoryDetailItem(
                icon: cat.icon,
                iconColor: cat.color,
                iconBg: cat.color.withOpacity(0.1),
                title: cat.categoryName,
                amount: '\$${cat.amount.toStringAsFixed(0)}',
                progress: data.totalExpense > 0 ? cat.amount / data.totalExpense : 0,
                progressColor: cat.color,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryDetailItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String amount,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: SpacingHelper.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyleHelper.textStyle14(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyleHelper.textStyle16(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
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

// New Imports
import '../widgets/stats/stats_selectors.dart';
import '../widgets/stats/stats_summary_card.dart';
import '../widgets/stats/stats_trend_chart.dart';
import '../widgets/stats/stats_insights_list.dart';
import '../widgets/stats/stats_category_list.dart';

class StatsView extends HookConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedFilter = ref.watch(statisticsControllerProvider);

    // Map StatsPeriod enum to int for SegmentedControl
    final initialFilterValue = switch (selectedFilter) {
      StatsPeriod.day => 1,
      StatsPeriod.week => 2,
      StatsPeriod.month => 3,
      StatsPeriod.year => 4,
    };

    final user = ref.watch(currentUserProvider).value;
    final userId = user?.id ?? '';
    final statsAsync = ref.watch(statisticsProvider(userId));
    final selectedType = useState<int>(1); // 1: Expenses, 2: Income

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
                    ref
                        .read(statsFilterProvider.notifier)
                        .setMode(DateFilterMode.customRange);
                    ref
                        .read(customRangeProvider.notifier)
                        .update(
                      DateTimeRange(
                        start: result['start']!,
                        end: result['end']!,
                      ),
                    );
                    ref
                        .read(selectedDateProvider.notifier)
                        .update(result['start']!);
                  } else if (result['start'] != null) {
                    ref
                        .read(statsFilterProvider.notifier)
                        .setMode(DateFilterMode.day);
                    ref
                        .read(selectedDateProvider.notifier)
                        .update(result['start']!);
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
          // Period Selector
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: StatsPeriodSelector(
              selectedIndex: initialFilterValue,
              onPeriodChanged: (v) {
                StatsPeriod period;
                switch (v) {
                  case 1:
                    period = StatsPeriod.day;
                    break;
                  case 2:
                    period = StatsPeriod.week;
                    break;
                  case 4:
                    period = StatsPeriod.year;
                    break;
                  default:
                    period = StatsPeriod.month;
                    break;
                }
                ref.read(statisticsControllerProvider.notifier).setPeriod(period);
                ref.read(statsFilterProvider.notifier).setMode(DateFilterMode.day);
                ref.read(customRangeProvider.notifier).update(null);
              },
            ),
          ),
          
          // Type Selector (Expenses / Income)
          StatsTypeSelector(
            selectedType: selectedType.value,
            onTypeChanged: (val) {
              selectedType.value = val;
              ref.read(pieChartTouchedIndexProvider.notifier).setIndex(-1);
            },
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
                  return const EmptyWidget(
                    message: 'No data found for this period.',
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 100.h),
                  child: Column(
                    children: [
                      SizedBox(height: SpacingHelper.md),
                      
                      // Summary Card
                      StaggeredEntrance(
                        index: 1,
                        child: StatsSummaryCard(
                          data: data,
                          isExpenseSelected: selectedType.value == 1,
                        ),
                      ),
                      
                      SizedBox(height: SpacingHelper.lg),
                      
                      // Trends
                      StaggeredEntrance(
                        index: 2,
                        child: StatsTrendChart(
                          expenseTrend: data.weeklyTrend,
                          incomeTrend: data.incomeWeeklyTrend,
                          period: selectedFilter,
                        ),
                      ),
                      
                      SizedBox(height: SpacingHelper.lg),

                      // Insights
                      const StaggeredEntrance(
                        index: 3,
                        child: StatsInsightsList(),
                      ),
                      
                      SizedBox(height: SpacingHelper.lg),

                      // Category Details
                      StaggeredEntrance(
                        index: 4,
                        child: StatsCategoryList(
                          categoryStats: selectedType.value == 1 
                              ? data.categoryBreakdown 
                              : data.incomeCategoryBreakdown,
                        ),
                      ),
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
}
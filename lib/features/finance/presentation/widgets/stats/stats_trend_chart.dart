import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';

class StatsTrendChart extends StatelessWidget {
  final List<DailySpending> expenseTrend;
  final List<DailySpending> incomeTrend;
  final StatsPeriod period;

  const StatsTrendChart({
    super.key,
    required this.expenseTrend,
    required this.incomeTrend, // Although image shows side by side, we might overlay or just show one based on context.
    // The image shows "Expense Trend" and "Income Trend" columns... implying two charts or a grouped bar chart?
    // Actually looking at the bars, there are alternating colors or just different bars.
    // Let's implement a grouped bar chart if possible, or just the selected type.
    // For now, let's stick to the current "selected type" approach but style it better, 
    // OR create a dual view if that's what the image implies. 
    // Image: "Expense Trend" "Income Trend" ... looks like two columns of text, but ONE chart below. 
    // The bars are Light Grey + Dark Blue/Green. It looks like "Expense" = Dark Blue, "Income" = Green.
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    // Merge trends to find max Y
    final allAmounts = [...expenseTrend.map((e) => e.amount), ...incomeTrend.map((e) => e.amount)];
    final maxY = (allAmounts.isEmpty ? 100.0 : allAmounts.reduce((a, b) => a > b ? a : b)) * 1.2;

    // Calculate averages
    final expenseAvg = expenseTrend.isEmpty ? 0.0 : expenseTrend.map((e) => e.amount).reduce((a,b)=>a+b) / expenseTrend.length;
    final incomeAvg = incomeTrend.isEmpty ? 0.0 : incomeTrend.map((e) => e.amount).reduce((a,b)=>a+b) / incomeTrend.length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildHeaderItem('Expense\nTrend', expenseAvg, const Color(0xFF1E556B)), // Dark Blue
              SizedBox(width: 24.w),
              _buildHeaderItem('Income\nTrend', incomeAvg, const Color(0xFF4CAF50)), // Green
            ],
          ),
          SizedBox(height: 24.h),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    tooltipPadding: EdgeInsets.all(8.w),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toStringAsFixed(0),
                         TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30.h,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= expenseTrend.length) return const SizedBox();
                        // Use expense trend date for labels (assuming same buckets)
                         return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            _getBottomLabel(expenseTrend[index].date, period, index),
                            style: TextStyleHelper.textStyle10(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: List.generate(expenseTrend.length, (index) {
                   return BarChartGroupData(
                    x: index,
                    barRods: [
                      // Expense Bar
                      BarChartRodData(
                        toY: expenseTrend[index].amount,
                        color: const Color(0xFF1E556B),
                        width: 8.w,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      // Income Bar
                      BarChartRodData(
                        toY: incomeTrend.length > index ? incomeTrend[index].amount : 0,
                        color: const Color(0xFF4CAF50),
                        width: 8.w,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                    barsSpace: 4.w,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String title, double avg, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.textStyle14(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Daily Avg:\n\$${avg.toStringAsFixed(0)}',
          style: TextStyleHelper.textStyle11(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  String _getBottomLabel(DateTime date, StatsPeriod period, int index) {
      // Simplified label logic
      switch (period) {
        case StatsPeriod.day:
          return '${date.hour}';
        case StatsPeriod.week:
          // return DateFormat('E').format(date).substring(0, 1);
          // Standardize: "MON", "FRI", "SUN" shown in image
           const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
           return days[date.weekday - 1]; 
        case StatsPeriod.month:
          return '${date.day}';
        case StatsPeriod.year:
          return '${date.month}';
      }
  }
}

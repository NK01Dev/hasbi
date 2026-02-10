import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';
import 'package:hasbi/features/finance/presentation/widgets/finance_pie_chart.dart';

class StatsSummaryCard extends StatelessWidget {
  final StatisticsData data;
  final bool isExpenseSelected;

  const StatsSummaryCard({
    super.key,
    required this.data,
    required this.isExpenseSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Determine what to show in the chart
    final chartData = isExpenseSelected ? data.expensesByCategory : data.incomesByCategory;
    
    // Check if we have data
    final bool hasData = chartData.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
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
          // Header Rows with Totals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTotalInfo('Monthly Spending', data.totalExpense, -12), // negative implies saved? or less spending? 
              // For design matching, let's assume we want to show both or switch based on selection?
              // The image shows BOTH spending and income.
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTotalInfo('Monthly Income', data.totalIncome, 8.5),
            ],
          ),

          SizedBox(height: SpacingHelper.lg),

          // Pie Chart
          SizedBox(
            height: 250.h,
            child: hasData
                ? FinancePieChart(
                    data: chartData,
                    isIncome: !isExpenseSelected,
                  )
                : Center(
                    child: Text(
                      'No data available',
                      style: TextStyleHelper.textStyle14(color: Colors.grey),
                    ),
                  ),
          ),

          SizedBox(height: SpacingHelper.lg),

          // Legend Grid
          if (hasData) _buildLegendGrid(isExpenseSelected ? data.categoryBreakdown : data.incomeCategoryBreakdown),
        ],
      ),
    );
  }

  Widget _buildTotalInfo(String label, double amount, double percentage) {
    final isPositive = percentage >= 0;
    final color = isPositive ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50); // Image uses green for both "saved" and "up"
    // Actually image has arrows: Down arrow 12% (Green), Up arrow 8.5% (Green).
    // Green usually means "Good". Less spending is good, More income is good.
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyleHelper.textStyle12(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      percentage >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12.sp,
                      color: color,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${percentage.abs().toStringAsFixed(1)}%',
                      style: TextStyleHelper.textStyle11(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyleHelper.textStyle24(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendGrid(List<CategoryStat> stats) {
    // Show top 4 or all? Image shows 6 items in a 2-column grid.
    final itemsToShow = stats.take(6).toList();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        final stat = itemsToShow[index];
        return Row(
          children: [
            Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: stat.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stat.categoryName.toUpperCase(),
                    style: TextStyleHelper.textStyle10(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '\$${stat.amount.toStringAsFixed(0)}',
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
      },
    );
  }
}

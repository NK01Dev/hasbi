import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import '../../data/models/category_model.dart';
import '../../providers/home_provider.dart';

class FinancePieChart extends StatelessWidget {
  final FinanceData? financeData;
  final int touchedIndex;
  final ValueChanged<int> onSectionTouched;

  const FinancePieChart({
    super.key,
    required this.financeData,
    required this.touchedIndex,
    required this.onSectionTouched,
  });

  @override
  Widget build(BuildContext context) {
    if (financeData == null || financeData!.expensesByCategory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48.sp, color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Text('No data available', style: TextStyleHelper.textStyle14(color: Colors.grey)),
          ],
        ),
      );
    }

    final entries = financeData!.expensesByCategory.entries.toList();
    final allCategories = AppCategories.getExpenseCategories();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return SfCircularChart(
      margin: EdgeInsets.all(SpacingHelper.xs),
      selectionGesture: ActivationMode.singleTap,
      onSelectionChanged: (SelectionArgs args) {
        onSectionTouched(args.pointIndex ?? -1);
      },
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
            padding: EdgeInsets.all(SpacingHelper.md),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyleHelper.textStyle11(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: TextStyleHelper.textStyle20(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      series: <DoughnutSeries<MapEntry<String, double>, String>>[
        DoughnutSeries<MapEntry<String, double>, String>(
          dataSource: entries,
          xValueMapper: (e, _) => allCategories
              .firstWhere((cat) => cat.id == e.key,
              orElse: () => allCategories.last)
              .name,
          yValueMapper: (e, _) => e.value,
          pointColorMapper: (e, _) => allCategories
              .firstWhere((cat) => cat.id == e.key,
              orElse: () => allCategories.last)
              .color,
          innerRadius: '70%',
          radius: '85%',
          explode: true,
          explodeIndex: touchedIndex,
          explodeOffset: '10%',
          strokeColor: Colors.white,
          strokeWidth: 3,
          cornerStyle: CornerStyle.bothCurve,
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            useSeriesColor: true,
            labelIntersectAction: LabelIntersectAction.shift,
            connectorLineSettings: const ConnectorLineSettings(
              type: ConnectorType.curve,
              length: '15%',
              width: 1.5,
            ),
            builder: (data, point, series, index, prevPoint) {
              final category = allCategories.firstWhere(
                    (cat) => cat.id == entries[index].key,
                orElse: () => allCategories.last,
              );
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${category.name}\n\$${entries[index].value.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.textStyle10(
                    fontWeight: FontWeight.w600,
                    color: category.color,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      return const Center(child: Text('No data'));
    }

    final entries = financeData!.expensesByCategory.entries.toList();
    final allCategories = AppCategories.getExpenseCategories();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return SfCircularChart(
      // Added margin to ensure labels have room within the container
      margin: EdgeInsets.all(10.w),
      selectionGesture: ActivationMode.singleTap,
      onSelectionChanged: (SelectionArgs args) {
        onSectionTouched(args.pointIndex ?? -1);
      },
      // Better alternative to Stack for central text alignment
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
      series: <DoughnutSeries<MapEntry<String, double>, String>>[
        DoughnutSeries<MapEntry<String, double>, String>(
          dataSource: entries,
          // Maps ID to Name from your CategoryModel
          xValueMapper: (e, _) => allCategories
              .firstWhere((cat) => cat.id == e.key,
              orElse: () => allCategories.last)
              .name,
          yValueMapper: (e, _) => e.value,
          // Explicitly define the label text to show Name and Value
          dataLabelMapper: (e, _) {
            final category = allCategories.firstWhere(
                  (cat) => cat.id == e.key,
              orElse: () => allCategories.last,
            );
            return '${category.name}\n\$${e.value.toStringAsFixed(0)}';
          },
          // Fetches specific category color
          pointColorMapper: (e, _) => allCategories
              .firstWhere((cat) => cat.id == e.key,
              orElse: () => allCategories.last)
              .color,
          // Reduced radius to 75% to prevent labels from being cut off
          innerRadius: '60%',
          radius: '75%',
          explode: true,
          explodeIndex: touchedIndex,
          explodeOffset: '45%',
          strokeColor: Colors.white,
          strokeWidth: 2,

          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            // Uses the segment color for the label text for better UI
            useSeriesColor: true,

            connectorLineSettings: const ConnectorLineSettings(
              type: ConnectorType.curve,

              length: '18%',
              width: 2
            ),
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
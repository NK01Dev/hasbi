import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/home_provider.dart';

class FinancePieChart extends StatelessWidget {
  final FinanceData? financeData;
  final int touchedIndex;
  final ValueChanged<int> onSectionTouched;
  final List<PieChartSectionData> sections;

  const FinancePieChart({
    super.key,
    required this.financeData,
    required this.touchedIndex,
    required this.onSectionTouched,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    if (financeData == null || sections.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return SizedBox.expand(

      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glassmorphic Center
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Net",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "\$${financeData!.periodBalance.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response?.touchedSection == null) {
                    onSectionTouched(-1);
                    return;
                  }
                  onSectionTouched(
                    response!.touchedSection!.touchedSectionIndex,
                  );
                },
              ),
              sections: sections,
              centerSpaceRadius: 50.r,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ],
      ),
    );
  }
}

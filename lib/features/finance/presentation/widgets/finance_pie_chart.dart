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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "\$${financeData!.totalExpense.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

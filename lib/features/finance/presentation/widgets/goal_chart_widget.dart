import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/goal_model.dart';

class GoalChartWidget extends StatelessWidget {
  final List<GoalModel> goals;

  const GoalChartWidget({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    // Prepare colors
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF97316), // Orange
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40.r,
        sections: goals.asMap().entries.map((entry) {
          final index = entry.key;
          final goal = entry.value;
          final color = colors[index % colors.length];

          // Avoid division by zero
          final value = goal.currentAmount.isFinite && goal.currentAmount > 0
              ? goal.currentAmount
              : 0.001;

          return PieChartSectionData(
            color: color,
            value: value,
            title: '${(goal.currentAmount * 100 / (goals.fold(0.0, (p, c) => p + c.currentAmount) + 0.001)).toStringAsFixed(0)}%',
            radius: 50.r,
            titleStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
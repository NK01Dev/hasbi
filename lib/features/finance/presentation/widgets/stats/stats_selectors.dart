import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/text_styles.dart';

class StatsPeriodSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onPeriodChanged;

  const StatsPeriodSelector({
    super.key,
    required this.selectedIndex,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    const periods = ['DAY', 'WEEK', 'MONTH', 'YEAR'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Light grey background
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = selectedIndex == (index + 1);
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChanged(index + 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyleHelper.textStyle12(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class StatsTypeSelector extends StatelessWidget {
  final int selectedType; // 1: Expense, 2: Income
  final Function(int) onTypeChanged;

  const StatsTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Expanded(child: _buildButton('Expenses', 1)),
          Expanded(child: _buildButton('Income', 2)),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int value) {
    final isSelected = selectedType == value;
    return GestureDetector(
      onTap: () => onTypeChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyleHelper.textStyle14(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

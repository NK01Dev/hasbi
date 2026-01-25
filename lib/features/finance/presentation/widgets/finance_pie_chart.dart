import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/text_styles.dart';
import '../../providers/mocking_finance_provider.dart';

class FinancePieChart extends ConsumerWidget {
  const FinancePieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeState = ref.watch(financeProvider);
    final notifier = ref.read(financeProvider.notifier);

    return SizedBox.expand( // FIX 1: Forces the Stack to fill the parent Container exactly
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total",
                style: TextStyleHelper.textStyle14(color: Colors.grey),
              ),
              Text(
                "\$3,000",
                style: TextStyleHelper.textStyle20(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // FIX 2: Wrap PieChart in SizedBox.expand to prevent overflow
          SizedBox.expand(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      notifier.setTouchedIndex(-1);
                      return;
                    }
                    notifier.setTouchedIndex(response.touchedSection!.touchedSectionIndex);
                  },
                ),
                sectionsSpace: 2, // Slightly reduced space for a cleaner look
                // FIX 3: Adjusted to fit nicely inside 240.h container
                // If your provider radius is ~90-100.r, this creates a nice donut
                centerSpaceRadius: 50.r,
                sections: notifier.getPieSections(),
                borderData: FlBorderData(
                  show: false,
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 250),
              swapAnimationCurve: Curves.easeOutQuart,
            ),
          ),
        ],
      ),
    );
  }
}
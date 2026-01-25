import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FinanceFilter { day, week, month, year }
class FinanceState {
  final FinanceFilter selectedFilter;
  final int touchedIndex;

  FinanceState({
    required this.selectedFilter,
    this.touchedIndex = -1,
  });
  FinanceState copyWith({FinanceFilter? selectedFilter, int? touchedIndex}) {
    return FinanceState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      touchedIndex: touchedIndex ?? this.touchedIndex,
    );
  }
}

// The Logic (Notifier)
class FinanceNotifier extends Notifier<FinanceState> {
  @override
  FinanceState build() {
    return FinanceState(selectedFilter: FinanceFilter.month);
  }

  void setFilter(FinanceFilter filter) {
    state = state.copyWith(selectedFilter: filter, touchedIndex: -1);
  }

  void setTouchedIndex(int index) {
    state = state.copyWith(touchedIndex: index);
  }

  // Pure logic to generate chart sections
  List<PieChartSectionData> getPieSections() {
    final Map<FinanceFilter, List<double>> mockValues = {
      FinanceFilter.day: [150.0, 50.0, 20.0],
      FinanceFilter.week: [500.0, 300.0, 150.0],
      FinanceFilter.month: [1200.0, 800.0, 400.0, 600.0],
      FinanceFilter.year: [15000.0, 9000.0, 5000.0, 7000.0],
    };

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red];
    final titles = ["Food", "Bills", "Rent", "Misc"];
    final currentValues = mockValues[state.selectedFilter]!;

    return List.generate(currentValues.length, (i) {
      final isTouched = i == state.touchedIndex;
      return PieChartSectionData(
        color: colors[i],
        value: currentValues[i],
        title: isTouched ? '\$${currentValues[i]}' : titles[i],
        radius: isTouched ? 110.r : 100.r,
        titleStyle: TextStyle(
          fontSize: isTouched ? 18.sp : 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

// The Provider
final financeProvider = NotifierProvider<FinanceNotifier, FinanceState>(() {
  return FinanceNotifier();
});
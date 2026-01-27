import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/presentation/states/auth_state.dart';
import '../data/models/expense_model.dart';
import '../data/models/income_model.dart';
import '../data/models/category_model.dart';
import '../domain/repositories/finance_repository.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'finance_provider.dart';

part 'home_provider.g.dart';

enum FinanceFilter { day, week, month, year }

class FinanceData {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<ExpenseModel> expenses;
  final List<IncomeModel> incomes;
  final double balancePercentageChange;
  final Map<String, double> expensesByCategory;
  final Map<String, double> incomesByCategory;

  FinanceData({
    required this.totalIncome,
    required this.totalExpense,
    required this.balancePercentageChange,
    required this.balance,
    required this.expenses,
    required this.incomes,
    required this.expensesByCategory,
    required this.incomesByCategory,
  });

  FinanceData copyWith({
    double? totalIncome,
    double? totalExpense,
    double? balance,
    double? balancePercentageChange,
    List<ExpenseModel>? expenses,
    List<IncomeModel>? incomes,
    Map<String, double>? expensesByCategory,
    Map<String, double>? incomesByCategory,
  }) {
    return FinanceData(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      balance: balance ?? this.balance,
      balancePercentageChange:
      balancePercentageChange ?? this.balancePercentageChange,
      expenses: expenses ?? this.expenses,
      incomes: incomes ?? this.incomes,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      incomesByCategory: incomesByCategory ?? this.incomesByCategory,
    );
  }

}

class FinanceState {
  final FinanceFilter selectedFilter;
  final int touchedIndex;
  final FinanceData? data;
  final bool isLoading;
  final String? error;

  FinanceState({
    required this.selectedFilter,
    this.touchedIndex = -1,
    this.data,
    this.isLoading = false,
    this.error,
  });

  FinanceState copyWith({
    FinanceFilter? selectedFilter,
    int? touchedIndex,
    FinanceData? data,
    bool? isLoading,
    String? error,
  }) {
    return FinanceState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      touchedIndex: touchedIndex ?? this.touchedIndex,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider to fetch finance data based on filter
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  FinanceState build() {
    // Watch userId to trigger auto-load on login/resume
    final authState = ref.watch(authProvider);
    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    if (userId != null) {
      // Use microtask to ensure build finishes before updating state
      Future.microtask(() => loadFinanceData(userId));
    }

    return FinanceState(selectedFilter: FinanceFilter.month);
  }

  Future<void> loadFinanceData(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(financeRepositoryProvider);

      // Fetch all data
      final results = await Future.wait([
        repository.getIncomes(userId),
        repository.getExpenses(userId),
      ]);
      print('Results: $results');
      final allIncomes = results[0] as List<IncomeModel>;
      final allExpenses = results[1] as List<ExpenseModel>;

      // Filter data based on selected filter
      final filteredData = _filterDataByPeriod(
        allIncomes,
        allExpenses,
        state.selectedFilter,
      );

      state = state.copyWith(
        data: filteredData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setFilter(FinanceFilter filter, String userId) {
    state = state.copyWith(
      selectedFilter: filter,
      touchedIndex: -1,
    );
    loadFinanceData(userId);
  }

  void setTouchedIndex(int index) {
    state = state.copyWith(touchedIndex: index);
  }

  FinanceData _filterDataByPeriod(
      List<IncomeModel> allIncomes,
      List<ExpenseModel> allExpenses,
      FinanceFilter filter,
      ) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime previousStartDate;
    DateTime previousEndDate;

    switch (filter) {
      case FinanceFilter.day:
        startDate = DateTime(now.year, now.month, now.day);
        previousStartDate = startDate.subtract(const Duration(days: 1));
        previousEndDate = startDate;
        break;
      case FinanceFilter.week:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        previousStartDate = startDate.subtract(const Duration(days: 7));
        previousEndDate = startDate;
        break;
      case FinanceFilter.month:
        startDate = DateTime(now.year, now.month, 1);
        previousStartDate = DateTime(now.year, now.month - 1, 1);
        previousEndDate = startDate;
        break;
      case FinanceFilter.year:
        startDate = DateTime(now.year, 1, 1);
        previousStartDate = DateTime(now.year - 1, 1, 1);
        previousEndDate = startDate;
        break;
    }

    // Filter incomes for current period
    final filteredIncomes = allIncomes.where((income) {
      return income.date.isAfter(startDate) ||
          income.date.isAtSameMomentAs(startDate);
    }).toList();

    // Filter expenses for current period
    final filteredExpenses = allExpenses.where((expense) {
      return expense.date.isAfter(startDate) ||
          expense.date.isAtSameMomentAs(startDate);
    }).toList();

    // Filter incomes for previous period
    final previousIncomes = allIncomes.where((income) {
      return (income.date.isAfter(previousStartDate) ||
          income.date.isAtSameMomentAs(previousStartDate)) &&
          income.date.isBefore(previousEndDate);
    }).toList();

    // Filter expenses for previous period
    final previousExpenses = allExpenses.where((expense) {
      return (expense.date.isAfter(previousStartDate) ||
          expense.date.isAtSameMomentAs(previousStartDate)) &&
          expense.date.isBefore(previousEndDate);
    }).toList();

    // Calculate totals for current period
    final totalIncome = filteredIncomes.fold<double>(
      0.0,
          (sum, income) => sum + income.amount,
    );

    final totalExpense = filteredExpenses.fold<double>(
      0.0,
          (sum, expense) => sum + expense.amount,
    );

    final currentBalance = totalIncome - totalExpense;

    // Calculate totals for previous period
    final previousIncome = previousIncomes.fold<double>(
      0.0,
          (sum, income) => sum + income.amount,
    );

    final previousExpense = previousExpenses.fold<double>(
      0.0,
          (sum, expense) => sum + expense.amount,
    );

    final previousBalance = previousIncome - previousExpense;

    // Calculate percentage change
    double balancePercentageChange = 0.0;
    if (previousBalance != 0) {
      balancePercentageChange = ((currentBalance - previousBalance) / previousBalance.abs()) * 100;
    } else if (currentBalance != 0) {
      // If previous balance was 0 but current is not, it's a 100% increase or -100% decrease
      balancePercentageChange = currentBalance > 0 ? 100.0 : -100.0;
    }

    // Group by category
    final expensesByCategory = <String, double>{};
    for (var expense in filteredExpenses) {
      expensesByCategory[expense.categoryId] =
          (expensesByCategory[expense.categoryId] ?? 0) + expense.amount;
    }

    final incomesByCategory = <String, double>{};
    for (var income in filteredIncomes) {
      incomesByCategory[income.categoryId] =
          (incomesByCategory[income.categoryId] ?? 0) + income.amount;
    }

    return FinanceData(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: currentBalance,
      balancePercentageChange: balancePercentageChange,
      expenses: filteredExpenses,
      incomes: filteredIncomes,
      expensesByCategory: expensesByCategory,
      incomesByCategory: incomesByCategory,
    );
  }

  // Generate pie chart sections for expenses
  List<PieChartSectionData> getExpensePieSections() {
    if (state.data == null || state.data!.expensesByCategory.isEmpty) {
      return [];
    }

    final categories = AppCategories.getExpenseCategories();
    final expensesByCategory = state.data!.expensesByCategory;

    final List<PieChartSectionData> sections = [];
    int index = 0;

    expensesByCategory.forEach((categoryId, amount) {
      final category = categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => categories.last, // Default to 'Other'
      );

      final isTouched = index == state.touchedIndex;
      final radius = isTouched ? 110.r : 100.r;
      final fontSize = isTouched ? 18.sp : 12.sp;

      sections.add(
        PieChartSectionData(
          color: category.color,
          value: amount,
          title: isTouched ? '\$${amount.toStringAsFixed(0)}' : category.name,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return sections;
  }

  // Generate pie chart sections for income
  List<PieChartSectionData> getIncomePieSections() {
    if (state.data == null || state.data!.incomesByCategory.isEmpty) {
      return [];
    }

    final categories = AppCategories.getIncomeCategories();
    final incomesByCategory = state.data!.incomesByCategory;

    final List<PieChartSectionData> sections = [];
    int index = 0;

    incomesByCategory.forEach((categoryId, amount) {
      final category = categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => categories.last, // Default to 'Other'
      );

      final isTouched = index == state.touchedIndex;
      final radius = isTouched ? 110.r : 100.r;
      final fontSize = isTouched ? 18.sp : 12.sp;

      sections.add(
        PieChartSectionData(
          color: category.color,
          value: amount,
          title: isTouched ? '\$${amount.toStringAsFixed(0)}' : category.name,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return sections;
  }
}
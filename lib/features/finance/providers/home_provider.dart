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
  final double totalIncome; // Current Month (for cards - static)
  final double totalExpense; // Current Month (for cards - static)
  final double periodBalance; // Current Month Balance
  final double totalBalance; // Global (All-time)
  final double balancePercentageChange; // Month vs Month change
  final List<ExpenseModel> expenses; // Filtered (for chart)
  final List<IncomeModel> incomes; // Filtered
  final Map<String, double> expensesByCategory; // Filtered (for chart)
  final Map<String, double> incomesByCategory; // Filtered

  FinanceData({
    required this.totalIncome,
    required this.totalExpense,
    required this.periodBalance,
    required this.totalBalance,
    required this.balancePercentageChange,
    required this.expenses,
    required this.incomes,
    required this.expensesByCategory,
    required this.incomesByCategory,
  });

  FinanceData copyWith({
    double? totalIncome,
    double? totalExpense,
    double? periodBalance,
    double? totalBalance,
    double? balancePercentageChange,
    List<ExpenseModel>? expenses,
    List<IncomeModel>? incomes,
    Map<String, double>? expensesByCategory,
    Map<String, double>? incomesByCategory,
  }) {
    return FinanceData(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      periodBalance: periodBalance ?? this.periodBalance,
      totalBalance: totalBalance ?? this.totalBalance,
      balancePercentageChange: balancePercentageChange ?? this.balancePercentageChange,
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
  // Caches to hold the full lists so we don't have to refetch when filtering
  List<IncomeModel>? _cachedIncomes;
  List<ExpenseModel>? _cachedExpenses;

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
      final allIncomes = results[0] as List<IncomeModel>;
      final allExpenses = results[1] as List<ExpenseModel>;

      // Populate Cache
      _cachedIncomes = allIncomes;
      _cachedExpenses = allExpenses;

      // Process data using current filter
      final processedData = _processFinanceData(
        _cachedIncomes!,
        _cachedExpenses!,
        state.selectedFilter,
      );

      state = state.copyWith(
        data: processedData,
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

    // If data is already cached, update locally without network call
    if (_cachedIncomes != null && _cachedExpenses != null) {
      final processedData = _processFinanceData(
        _cachedIncomes!,
        _cachedExpenses!,
        filter,
      );
      state = state.copyWith(data: processedData);
    } else {
      // Fallback: if cache is empty for some reason, fetch from network
      loadFinanceData(userId);
    }
  }

  void setTouchedIndex(int index) {
    state = state.copyWith(touchedIndex: index);
  }

  FinanceData _processFinanceData(
      List<IncomeModel> allIncomes,
      List<ExpenseModel> allExpenses,
      FinanceFilter filter,
      ) {
    final now = DateTime.now();
    // final today = DateTime(now.year, now.month, now.day);
    final today = DateTime.now().subtract(const Duration(hours: 24));

    // --- 1. CARD DATA: Current Month (Always static, doesn't change with filter) ---
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = now;

    // Current month incomes/expenses
    final currentMonthIncomes = allIncomes.where((income) {
      return !_isBeforeDate(income.date, monthStart) &&
          !_isAfterDate(income.date, monthEnd);
    }).toList();

    final currentMonthExpenses = allExpenses.where((expense) {
      return !_isBeforeDate(expense.date, monthStart) &&
          !_isAfterDate(expense.date, monthEnd);
    }).toList();

    final totalIncome = _sumIncomes(currentMonthIncomes);
    final totalExpense = _sumExpenses(currentMonthExpenses);
    final periodBalance = totalIncome - totalExpense;

    // Previous month for percentage calculation
    final prevMonthStart = DateTime(now.year, now.month - 1, 1);
    final prevMonthEnd = monthStart;

    final prevMonthIncomes = allIncomes.where((income) {
      return !_isBeforeDate(income.date, prevMonthStart) &&
          income.date.isBefore(prevMonthEnd);
    }).toList();

    final prevMonthExpenses = allExpenses.where((expense) {
      return !_isBeforeDate(expense.date, prevMonthStart) &&
          expense.date.isBefore(prevMonthEnd);
    }).toList();

    final prevIncome = _sumIncomes(prevMonthIncomes);
    final prevExpense = _sumExpenses(prevMonthExpenses);
    final prevBalance = prevIncome - prevExpense;

    // Calculate percentage change (Month over Month)
    double balancePercentageChange = 0.0;
    if (prevBalance != 0) {
      balancePercentageChange = ((periodBalance - prevBalance) / prevBalance.abs()) * 100;
    } else if (periodBalance != 0) {
      balancePercentageChange = periodBalance > 0 ? 100.0 : -100.0;
    }

    // Global balance (All-time)
    final globalIncome = _sumIncomes(allIncomes);
    final globalExpense = _sumExpenses(allExpenses);
    final totalBalance = globalIncome - globalExpense;

    // --- 2. CHART DATA: Filtered by selected period (Day/Week/Month/Year) ---
    DateTime filterStart;

    switch (filter) {
      case FinanceFilter.day:
        filterStart = today;
        break;
      case FinanceFilter.week:
      // Start of week (Monday)
        final daysSinceMonday = now.weekday - 1;
        filterStart = today.subtract(Duration(days: daysSinceMonday));
        break;
      case FinanceFilter.month:
        filterStart = DateTime(now.year, now.month, 1);
        break;
      case FinanceFilter.year:
        filterStart = DateTime(now.year, 1, 1);
        break;
    }

    final filterEnd = now;

    // Filtered lists for chart
    final filteredExpenses = allExpenses.where((expense) {
      return !_isBeforeDate(expense.date, filterStart) &&
          !_isAfterDate(expense.date, filterEnd);
    }).toList();

    final filteredIncomes = allIncomes.where((income) {
      return !_isBeforeDate(income.date, filterStart) &&
          !_isAfterDate(income.date, filterEnd);
    }).toList();

    // Group by category for pie chart (using filtered data)
    final expensesByCategory = _groupByCategory(filteredExpenses);
    final incomesByCategory = _groupByCategory(filteredIncomes, isIncome: true);

    return FinanceData(
      totalIncome: totalIncome,           // Month data (static for cards)
      totalExpense: totalExpense,         // Month data (static for cards)
      periodBalance: periodBalance,       // Month balance
      totalBalance: totalBalance,         // Global
      balancePercentageChange: balancePercentageChange, // Month trend
      expenses: filteredExpenses,         // Filtered for chart
      incomes: filteredIncomes,           // Filtered
      expensesByCategory: expensesByCategory, // Filtered breakdown
      incomesByCategory: incomesByCategory,
    );
  }

  // Helper: Check if date is before (ignoring time)
  bool _isBeforeDate(DateTime date, DateTime boundary) {
    final d = DateTime(date.year, date.month, date.day);
    final b = DateTime(boundary.year, boundary.month, boundary.day);
    return d.isBefore(b);
  }

  // Helper: Check if date is after (ignoring time)
  bool _isAfterDate(DateTime date, DateTime boundary) {
    final d = DateTime(date.year, date.month, date.day);
    final b = DateTime(boundary.year, boundary.month, boundary.day);
    return d.isAfter(b);
  }

  double _sumIncomes(List<IncomeModel> incomes) {
    return incomes.fold<double>(0.0, (sum, inc) => sum + inc.amount);
  }

  double _sumExpenses(List<ExpenseModel> expenses) {
    return expenses.fold<double>(0.0, (sum, exp) => sum + exp.amount);
  }

  Map<String, double> _groupByCategory(List<dynamic> items, {bool isIncome = false}) {
    final result = <String, double>{};
    for (var item in items) {
      final categoryId = item.categoryId;
      result[categoryId] = (result[categoryId] ?? 0) + item.amount;
    }
    return result;
  }

  // Generate pie chart sections for expenses (uses filtered data)
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

  // Generate pie chart sections for income (uses filtered data)
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
        orElse: () => categories.last,
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
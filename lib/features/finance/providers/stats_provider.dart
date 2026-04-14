import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hasbi/features/finance/data/models/finance_enums.dart';
import 'package:hasbi/features/finance/data/models/transaction_display_model.dart';
import 'package:hasbi/features/finance/data/models/category_model.dart';
import 'transaction_provider.dart';
import 'package:hasbi/features/finance/providers/raw_finance_provider.dart';
import '../../../core/utils/date_range_helper.dart';

part 'stats_provider.g.dart';

// --- MODELS ---

class CategoryStat {
  final String categoryId;
  final String categoryName;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryStat({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.color,
    required this.icon,
  });
}

class DailySpending {
  final DateTime date;
  final double amount;

  DailySpending({required this.date, required this.amount});
}

class StatisticsData {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CategoryStat> categoryBreakdown;
  final List<CategoryStat> incomeCategoryBreakdown; // Added
  final List<DailySpending> weeklyTrend;
  final List<DailySpending> incomeWeeklyTrend; // Added
  final double percentageChange;
  final DateTime startDate;
  final DateTime endDate;
  final String? highestCategory;
  final double? dailyAverage;
  final List<TransactionDisplayModel> transactions;
  final Map<String, double> expensesByCategory; // Added generic map
  final Map<String, double> incomesByCategory; // Added generic map

  StatisticsData({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.categoryBreakdown,
    this.incomeCategoryBreakdown = const [], // Added
    required this.weeklyTrend,
    this.incomeWeeklyTrend = const [], // Added
    required this.percentageChange,
    required this.startDate,
    required this.endDate,
    this.highestCategory,
    this.dailyAverage,
    this.transactions = const [],
    this.expensesByCategory = const {}, // Added
    this.incomesByCategory = const {}, // Added
  });
}

// --- NOTIFIERS ---

@riverpod
class StatsFilter extends _$StatsFilter {
  @override
  DateFilterMode build() => DateFilterMode.day;

  void setMode(DateFilterMode mode) => state = mode;
}

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void update(DateTime date) => state = date;
}

@riverpod
class CustomRange extends _$CustomRange {
  @override
  DateTimeRange? build() => null;

  void update(DateTimeRange? range) => state = range;
}

@riverpod
class StatisticsController extends _$StatisticsController {
  @override
  StatsPeriod build() => StatsPeriod.month;

  void setPeriod(StatsPeriod period) => state = period;
}

@riverpod
class PieChartTouchedIndex extends _$PieChartTouchedIndex {
  @override
  int build() => -1;

  void setIndex(int index) => state = index;
}

// --- PROVIDERS (Class-based for better generation) ---

@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  FutureOr<StatisticsData> build(String userId) async {
    final raw =
        await ref.watch(rawFinanceDataProvider(userId).future)
            as FinanceRawData;
    final period = ref.watch(statisticsControllerProvider);
    final anchorDate = ref.watch(selectedDateProvider);
    final filterMode = ref.watch(statsFilterProvider);
    final customRange = ref.watch(customRangeProvider);

    return _processStats(
      raw: raw,
      period: period,
      anchorDate: anchorDate,
      filterMode: filterMode,
      customRange: customRange,
    );
  }
}

@riverpod
class PieChartNotifier extends _$PieChartNotifier {
  @override
  FutureOr<List<CategoryStat>> build(String userId) async {
    final statsAsync = ref.watch(statisticsProvider(userId));
    return statsAsync.maybeWhen(
      data: (data) => data.categoryBreakdown,
      orElse: () => [],
    );
  }
}

// --- HELPERS ---

Future<StatisticsData> _processStats({
  required FinanceRawData raw,
  required StatsPeriod period,
  required DateTime anchorDate,
  required DateFilterMode filterMode,
  DateTimeRange? customRange,
}) async {
  DateTime startDate;
  DateTime endDate;

  final range = DateRangeHelper.resolve(
    period: period,
    anchor: anchorDate,
    customRange: filterMode == DateFilterMode.customRange ? customRange : null,
  );
  startDate = range.start;
  endDate = range.end;

  // Utilize shared data source
  final incomes = raw.incomes;
  final expenses = raw.expenses;

  // Filter by date
  final filteredIncomes = incomes.where((i) {
    return i.date.isAfter(
          startDate.subtract(const Duration(milliseconds: 1)),
        ) &&
        i.date.isBefore(endDate.add(const Duration(milliseconds: 1)));
  }).toList();

  final filteredExpenses = expenses.where((e) {
    return e.date.isAfter(
          startDate.subtract(const Duration(milliseconds: 1)),
        ) &&
        e.date.isBefore(endDate.add(const Duration(milliseconds: 1)));
  }).toList();

  final totalIncome = filteredIncomes.fold<double>(
    0,
    (sum, item) => sum + item.amount,
  );
  final totalExpense = filteredExpenses.fold<double>(
    0,
    (sum, item) => sum + item.amount,
  );

  // Category Breakdown - Expenses (same data source as expensesByCategory, with names/colors from AppCategories)
  final Map<String, double> expensesMap = {};
  for (var expense in filteredExpenses) {
    expensesMap[expense.categoryId] =
        (expensesMap[expense.categoryId] ?? 0) + expense.amount;
  }

  final expenseCategories = AppCategories.getExpenseCategories();
  final List<CategoryStat> categoryBreakdown = expensesMap.entries.map((entry) {
    final cat = expenseCategories.firstWhere(
      (c) => c.id == entry.key,
      orElse: () => expenseCategories.last,
    );
    return CategoryStat(
      categoryId: entry.key,
      categoryName: cat.name,
      amount: entry.value,
      color: cat.color,
      icon: cat.icon,
    );
  }).toList();

  // Category Breakdown - Incomes (same data source as incomesByCategory)
  final Map<String, double> incomesMap = {};
  for (var income in filteredIncomes) {
    incomesMap[income.categoryId] =
        (incomesMap[income.categoryId] ?? 0) + income.amount;
  }

  final incomeCategories = AppCategories.getIncomeCategories();
  final List<CategoryStat> incomeCategoryBreakdown = incomesMap.entries.map((
    entry,
  ) {
    final cat = incomeCategories.firstWhere(
      (c) => c.id == entry.key,
      orElse: () => incomeCategories.last,
    );
    return CategoryStat(
      categoryId: entry.key,
      categoryName: cat.name,
      amount: entry.value,
      color: cat.color,
      icon: cat.icon,
    );
  }).toList();

  // Period-dependent trend: day (4 time slots), week (7 days), month (4–5 weeks), year (12 months)
  List<DailySpending> calculatePeriodTrend(
    List<dynamic> items,
    DateTime rangeStart,
    DateTime rangeEnd,
    StatsPeriod period,
  ) {
    final List<DailySpending> trend = [];
    final hasDate = (dynamic e) => e.date;
    final hasAmount = (dynamic e) => e.amount;

    switch (period) {
      case StatsPeriod.day:
        // 4 slots: 00–06, 06–12, 12–18, 18–24
        for (int slot = 0; slot < 4; slot++) {
          final slotStart = DateTime(
            rangeStart.year,
            rangeStart.month,
            rangeStart.day,
            slot * 6,
            0,
            0,
          );
          final slotEnd = slot == 3
              ? DateTime(
                  rangeStart.year,
                  rangeStart.month,
                  rangeStart.day,
                  23,
                  59,
                  59,
                )
              : DateTime(
                  rangeStart.year,
                  rangeStart.month,
                  rangeStart.day,
                  (slot + 1) * 6 - 1,
                  59,
                  59,
                );
          final amount = items
              .where(
                (e) =>
                    hasDate(
                      e,
                    ).isAfter(slotStart.subtract(const Duration(seconds: 1))) &&
                    hasDate(
                      e,
                    ).isBefore(slotEnd.add(const Duration(seconds: 1))),
              )
              .fold<double>(0, (sum, item) => sum + hasAmount(item));
          trend.add(DailySpending(date: slotStart, amount: amount));
        }
        break;
      case StatsPeriod.week:
        for (int i = 0; i < 7; i++) {
          final dayStart = rangeStart.add(Duration(days: i));
          final dayEnd = DateTime(
            dayStart.year,
            dayStart.month,
            dayStart.day,
            23,
            59,
            59,
          );
          final amount = items
              .where(
                (e) =>
                    hasDate(
                      e,
                    ).isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
                    hasDate(e).isBefore(dayEnd.add(const Duration(seconds: 1))),
              )
              .fold<double>(0, (sum, item) => sum + hasAmount(item));
          trend.add(DailySpending(date: dayStart, amount: amount));
        }
        break;
      case StatsPeriod.month:
        // Up to 5 weeks in month (days 1–7, 8–14, 15–21, 22–28, 29–31)
        final daysInMonth = DateTime(rangeEnd.year, rangeEnd.month + 1, 0).day;
        for (int w = 0; w < 5; w++) {
          final weekStartDay = w * 7 + 1;
          if (weekStartDay > daysInMonth) break;
          final weekStart = DateTime(
            rangeStart.year,
            rangeStart.month,
            weekStartDay,
          );
          final weekEndDay = (weekStartDay + 6).clamp(1, daysInMonth);
          final weekEnd = DateTime(
            rangeStart.year,
            rangeStart.month,
            weekEndDay,
            23,
            59,
            59,
          );
          final amount = items
              .where(
                (e) =>
                    hasDate(
                      e,
                    ).isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
                    hasDate(
                      e,
                    ).isBefore(weekEnd.add(const Duration(seconds: 1))),
              )
              .fold<double>(0, (sum, item) => sum + hasAmount(item));
          trend.add(DailySpending(date: weekStart, amount: amount));
        }
        break;
      case StatsPeriod.year:
        for (int m = 1; m <= 12; m++) {
          final monthStart = DateTime(rangeStart.year, m, 1);
          final monthEnd = DateTime(rangeStart.year, m + 1, 0, 23, 59, 59);
          final amount = items
              .where(
                (e) =>
                    hasDate(e).isAfter(
                      monthStart.subtract(const Duration(seconds: 1)),
                    ) &&
                    hasDate(
                      e,
                    ).isBefore(monthEnd.add(const Duration(seconds: 1))),
              )
              .fold<double>(0, (sum, item) => sum + hasAmount(item));
          trend.add(DailySpending(date: monthStart, amount: amount));
        }
        break;
    }
    return trend;
  }

  final weeklyTrend = calculatePeriodTrend(
    expenses,
    startDate,
    endDate,
    period,
  );
  final incomeWeeklyTrend = calculatePeriodTrend(
    incomes,
    startDate,
    endDate,
    period,
  );

  final mappedTransactions = mapTransactions(
    incomes: filteredIncomes,
    expenses: filteredExpenses,
  );

  return StatisticsData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: totalIncome - totalExpense,
    categoryBreakdown: categoryBreakdown,
    incomeCategoryBreakdown: incomeCategoryBreakdown,
    weeklyTrend: weeklyTrend,
    incomeWeeklyTrend: incomeWeeklyTrend,
    percentageChange: 0,
    startDate: startDate,
    endDate: endDate,
    dailyAverage: totalExpense / (endDate.difference(startDate).inDays + 1),
    transactions: mappedTransactions,
    expensesByCategory: expensesMap,
    incomesByCategory: incomesMap,
  );
}

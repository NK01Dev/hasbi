import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hasbi/features/finance/data/models/finance_enums.dart';
import 'package:hasbi/features/finance/data/models/transaction_display_model.dart';
import 'package:hasbi/features/finance/data/models/expense_model.dart';
import 'package:hasbi/features/finance/data/models/income_model.dart';
import 'package:hasbi/features/finance/domain/repositories/finance_repository.dart';
import 'package:hasbi/features/auth/presentation/providers/user_provider.dart';
import 'finance_provider.dart';
import 'transaction_provider.dart';

part 'stats_provider.g.dart';

// --- ENUMS ---
enum StatsPeriod { day, week, month, year }

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

  DailySpending({
    required this.date,
    required this.amount,
  });
}

class StatisticsData {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CategoryStat> categoryBreakdown;
  final List<DailySpending> weeklyTrend;
  final double percentageChange;
  final DateTime startDate;
  final DateTime endDate;
  final String? highestCategory;
  final double? dailyAverage;
  final List<TransactionDisplayModel> transactions;

  StatisticsData({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.categoryBreakdown,
    required this.weeklyTrend,
    required this.percentageChange,
    required this.startDate,
    required this.endDate,
    this.highestCategory,
    this.dailyAverage,
    this.transactions = const [],
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

// --- PROVIDERS (Class-based for better generation) ---

@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  FutureOr<StatisticsData> build(String userId) async {
    final repository = ref.watch(financeRepositoryProvider);
    final period = ref.watch(statisticsControllerProvider);
    final anchorDate = ref.watch(selectedDateProvider);
    final filterMode = ref.watch(statsFilterProvider);
    final customRange = ref.watch(customRangeProvider);

    return _fetchStats(
      repository: repository,
      userId: userId,
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

Future<StatisticsData> _fetchStats({
  required FinanceRepository repository,
  required String userId,
  required StatsPeriod period,
  required DateTime anchorDate,
  required DateFilterMode filterMode,
  DateTimeRange? customRange,
}) async {
  DateTime startDate;
  DateTime endDate;

  if (filterMode == DateFilterMode.customRange && customRange != null) {
    startDate = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
    endDate = DateTime(customRange.end.year, customRange.end.month, customRange.end.day, 23, 59, 59);
  } else {
    switch (period) {
      case StatsPeriod.day:
        startDate = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
        endDate = DateTime(anchorDate.year, anchorDate.month, anchorDate.day, 23, 59, 59);
        break;
      case StatsPeriod.week:
        startDate = anchorDate.subtract(Duration(days: anchorDate.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case StatsPeriod.month:
        startDate = DateTime(anchorDate.year, anchorDate.month, 1);
        endDate = DateTime(anchorDate.year, anchorDate.month + 1, 0, 23, 59, 59);
        break;
      case StatsPeriod.year:
        startDate = DateTime(anchorDate.year, 1, 1);
        endDate = DateTime(anchorDate.year, 12, 31, 23, 59, 59);
        break;
    }
  }

  // Fetch all data
  final incomes = await repository.getIncomes(userId);
  final expenses = await repository.getExpenses(userId);

  // Filter by date
  final filteredIncomes = incomes.where((i) {
    return i.date.isAfter(startDate.subtract(const Duration(milliseconds: 1))) &&
           i.date.isBefore(endDate.add(const Duration(milliseconds: 1)));
  }).toList();

  final filteredExpenses = expenses.where((e) {
    return e.date.isAfter(startDate.subtract(const Duration(milliseconds: 1))) &&
           e.date.isBefore(endDate.add(const Duration(milliseconds: 1)));
  }).toList();

  final totalIncome = filteredIncomes.fold<double>(0, (sum, item) => sum + item.amount);
  final totalExpense = filteredExpenses.fold<double>(0, (sum, item) => sum + item.amount);

  // Category Breakdown
  final Map<String, double> categoryMap = {};
  for (var expense in filteredExpenses) {
    categoryMap[expense.categoryId] = (categoryMap[expense.categoryId] ?? 0) + expense.amount;
  }

  final List<CategoryStat> categoryBreakdown = categoryMap.entries.map((entry) {
    return CategoryStat(
      categoryId: entry.key,
      categoryName: entry.key,
      amount: entry.value,
      color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
      icon: Icons.category,
    );
  }).toList();

  // Trend relative to anchorDate
  final List<DailySpending> weeklyTrend = [];
  final trendStart = anchorDate.subtract(const Duration(days: 6));
  for (int i = 0; i < 7; i++) {
    final date = trendStart.add(Duration(days: i));
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final dayAmount = expenses
        .where((e) => e.date.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
                      e.date.isBefore(dayEnd.add(const Duration(seconds: 1))))
        .fold<double>(0, (sum, item) => sum + item.amount);

    weeklyTrend.add(DailySpending(date: dayStart, amount: dayAmount));
  }

  final mappedTransactions = mapTransactions(
    incomes: filteredIncomes,
    expenses: filteredExpenses,
  );

  return StatisticsData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: totalIncome - totalExpense,
    categoryBreakdown: categoryBreakdown,
    weeklyTrend: weeklyTrend,
    percentageChange: 0,
    startDate: startDate,
    endDate: endDate,
    dailyAverage: totalExpense / (endDate.difference(startDate).inDays + 1),
    transactions: mappedTransactions,
  );
}
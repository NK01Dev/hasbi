import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/states/auth_state.dart';
import '../data/models/expense_model.dart';
import '../data/models/income_model.dart';
import '../data/models/category_model.dart';
import '../domain/repositories/finance_repository.dart';
import 'finance_provider.dart';

part 'stats_provider.g.dart';

// Optimized: Only keep Day and Custom Range
enum DateFilterMode { day, customRange }

/// A display model to unify Income and Expense for the UI
class TransactionDisplayModel {
  final String id;
  final String title;
  final String? note;
  final double amount;
  final bool isExpense;
  final IconData icon;
  final Color color;
  final DateTime date;

  TransactionDisplayModel({
    required this.id,
    required this.title,
    this.note,
    required this.amount,
    required this.isExpense,
    required this.icon,
    required this.color,
    required this.date,
  });
}

@riverpod
class StatsFilter extends _$StatsFilter {
  @override
  DateFilterMode build() => DateFilterMode.day;

  void setMode(DateFilterMode mode) => state = mode;
}

@riverpod
class StatsNotifier extends _$StatsNotifier {
  @override
  Future<List<TransactionDisplayModel>> build() async {
    final authState = ref.watch(authProvider);
    final repository = ref.read(financeRepositoryProvider);

    // Watch Filter Mode
    final filterMode = ref.watch(statsFilterProvider);
    // Watch Selected Date (for Day mode)
    final selectedDate = ref.watch(selectedDateProvider);
    // Watch Date Range (for Custom mode)
    final customRange = ref.watch(customRangeProvider);

    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );

    if (userId.isEmpty) return [];

    // 1. Calculate Start and End dates based on Mode
    DateTime startDay, endDay;

    switch (filterMode) {
      case DateFilterMode.day:
        startDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        endDay = startDay.add(const Duration(days: 1));
        break;
      case DateFilterMode.customRange:
        if (customRange == null) return [];
        startDay = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
        endDay = DateTime(customRange.end.year, customRange.end.month, customRange.end.day)
            .add(const Duration(days: 1));
        break;
    }

    // 2. Fetch Data
    final results = await Future.wait([
      repository.getExpenses(userId),
      repository.getIncomes(userId),
    ]);

    final expenses = results[0] as List<ExpenseModel>;
    final incomes = results[1] as List<IncomeModel>;

    final List<TransactionDisplayModel> transactions = [];

    // 3. Filter and Map Data
    for (var exp in expenses) {
      if (!exp.date.isBefore(startDay) && exp.date.isBefore(endDay)) {
        final cat = _getCategory(exp.categoryId, true);
        transactions.add(TransactionDisplayModel(
          id: exp.id,
          title: cat.name,
          note: exp.note,
          amount: exp.amount,
          isExpense: true,
          icon: cat.icon,
          color: cat.color,
          date: exp.date,
        ));
      }
    }

    for (var inc in incomes) {
      if (!inc.date.isBefore(startDay) && inc.date.isBefore(endDay)) {
        final cat = _getCategory(inc.categoryId, false);
        transactions.add(TransactionDisplayModel(
          id: inc.id,
          title: cat.name,
          note: inc.note,
          amount: inc.amount,
          isExpense: false,
          icon: cat.icon,
          color: cat.color,
          date: inc.date,
        ));
      }
    }

    // Sort by date (newest first)
    return transactions..sort((a, b) => b.date.compareTo(a.date));
  }

  CategoryModel _getCategory(String categoryId, bool isExpense) {
    final categories = isExpense
        ? AppCategories.getExpenseCategories()
        : AppCategories.getIncomeCategories();

    return categories.firstWhere(
          (c) => c.id == categoryId,
      orElse: () => CategoryModel(
        id: 'other',
        name: 'Unknown',
        icon: CupertinoIcons.question_circle,
        colorHex: '#9E9E9E',
      ),
    );
  }
}

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void update(DateTime newDate) => state = newDate;
}

@riverpod
class CustomRange extends _$CustomRange {
  @override
  DateTimeRange? build() => null;

  void setRange(DateTimeRange? range) => state = range;
}
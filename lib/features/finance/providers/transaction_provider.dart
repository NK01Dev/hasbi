import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hasbi/features/finance/data/models/finance_enums.dart';
import 'package:hasbi/features/finance/data/models/transaction_display_model.dart';
import 'package:hasbi/features/finance/data/models/expense_model.dart';
import 'package:hasbi/features/finance/data/models/income_model.dart';
import 'package:hasbi/features/finance/domain/repositories/finance_repository.dart';
import 'package:hasbi/features/auth/presentation/providers/user_provider.dart';
import '../data/models/category_model.dart';
import 'finance_provider.dart';

part 'transaction_provider.g.dart';

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  DateFilterMode build() => DateFilterMode.day;

  void setMode(DateFilterMode mode) => state = mode;
}

@riverpod
class TransactionDate extends _$TransactionDate {
  @override
  DateTime build() => DateTime.now();

  void update(DateTime date) => state = date;
}

@riverpod
class TransactionRange extends _$TransactionRange {
  @override
  DateTimeRange? build() => null;

  void update(DateTimeRange? range) => state = range;
}

@riverpod
class Transactions extends _$Transactions {
  @override
  FutureOr<List<TransactionDisplayModel>> build() async {
    final user = await ref.watch(currentUserProvider.future);
    final userId = user?.id ?? '';
    if (userId.isEmpty) return [];

    final repository = ref.watch(financeRepositoryProvider);
    final filterMode = ref.watch(transactionFilterProvider);
    final selectedDate = ref.watch(transactionDateProvider);
    final customRange = ref.watch(transactionRangeProvider);

    DateTime start;
    DateTime end;

    if (filterMode == DateFilterMode.day) {
      start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      end = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
    } else {
      if (customRange == null) return [];
      start = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
      end = DateTime(customRange.end.year, customRange.end.month, customRange.end.day, 23, 59, 59);
    }

    final incomes = await repository.getIncomes(userId);
    final expenses = await repository.getExpenses(userId);

    final filteredIncomes = incomes.where((i) {
      return i.date.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
             i.date.isBefore(end.add(const Duration(milliseconds: 1)));
    }).toList();

    final filteredExpenses = expenses.where((e) {
      return e.date.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
             e.date.isBefore(end.add(const Duration(milliseconds: 1)));
    }).toList();

    return mapTransactions(incomes: filteredIncomes, expenses: filteredExpenses);
  }
}

List<TransactionDisplayModel> mapTransactions({
  required List<IncomeModel> incomes,
  required List<ExpenseModel> expenses,
}) {
  final List<TransactionDisplayModel> results = [];
  final incomeCategories = AppCategories.getIncomeCategories();
  final expenseCategories = AppCategories.getExpenseCategories();

  // Helper to find category
  CategoryModel getCategory(List<CategoryModel> categories, String id) {
    return categories.firstWhere(
          (c) => c.id == id,
      orElse: () => categories.firstWhere((c) => c.id == 'other' || c.id == 'other_exp', orElse: () => categories.last),
    );
  }

  for (final income in incomes) {
    final category = getCategory(incomeCategories, income.categoryId);
    results.add(TransactionDisplayModel(
      id: income.id,
      title: income.source.isNotEmpty ? income.source : category.name,
      amount: income.amount,
      date: income.date,
      note: income.note,
      color: category.color,
      icon: category.icon,
      isExpense: false,
    ));
  }

  for (final expense in expenses) {
    final category = getCategory(expenseCategories, expense.categoryId);
    results.add(TransactionDisplayModel(
      id: expense.id,
      title: category.name,
      amount: expense.amount,
      date: expense.date,
      note: expense.note,
      color: category.color,
      icon: category.icon,
      isExpense: true,
    ));
  }

  results.sort((a, b) => b.date.compareTo(a.date));
  return results;
}

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hasbi/features/finance/data/models/finance_enums.dart';
import 'package:hasbi/features/finance/data/models/transaction_display_model.dart';
import 'package:hasbi/features/finance/data/models/expense_model.dart';
import 'package:hasbi/features/finance/data/models/income_model.dart';
import 'package:hasbi/features/auth/presentation/providers/user_provider.dart';
import '../data/models/category_model.dart';
import '../../../../core/utils/date_range_helper.dart';
import 'package:hasbi/features/finance/providers/raw_finance_provider.dart';

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
  int _pageSize = 15;
  bool _hasMore = true;

  @override
  FutureOr<List<TransactionDisplayModel>> build() async {
    _pageSize = 15;
    _hasMore = true;
    return _fetchTransactions();
  }

  Future<List<TransactionDisplayModel>> _fetchTransactions() async {
    final user = await ref.watch(currentUserProvider.future);
    final userId = user?.id ?? '';
    if (userId.isEmpty) return [];

    final filterMode = ref.watch(transactionFilterProvider);
    final selectedDate = ref.watch(transactionDateProvider);
    final customRange = ref.watch(transactionRangeProvider);

    if (filterMode == DateFilterMode.customRange && customRange == null) {
      return [];
    }

    final raw = await ref.watch(rawFinanceDataProvider(userId).future);

    final range = DateRangeHelper.resolve(
      period: StatsPeriod.day,
      anchor: selectedDate,
      customRange: filterMode == DateFilterMode.customRange
          ? customRange
          : null,
    );
    DateTime start = range.start;
    DateTime end = range.end;

    final filteredIncomes = raw.incomes.where((i) {
      return i.date.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
          i.date.isBefore(end.add(const Duration(milliseconds: 1)));
    }).toList();

    final filteredExpenses = raw.expenses.where((e) {
      return e.date.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
          e.date.isBefore(end.add(const Duration(milliseconds: 1)));
    }).toList();

    final allResults = mapTransactions(
      incomes: filteredIncomes,
      expenses: filteredExpenses,
    );

    _hasMore = allResults.length > _pageSize;
    return allResults.take(_pageSize).toList();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;

    final user = await ref.read(currentUserProvider.future);
    final userId = user?.id ?? '';
    if (userId.isEmpty) return;

    _pageSize += 15;

    // We refetch/re-filter locally since the raw data is already cached in Riverpod
    final allResults = await _fetchTransactions();

    state = AsyncValue.data(allResults);
  }

  bool get hasMore => _hasMore;
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
      orElse: () => categories.firstWhere(
        (c) => c.id == 'other' || c.id == 'other_exp',
        orElse: () => categories.last,
      ),
    );
  }

  for (final income in incomes) {
    final category = getCategory(incomeCategories, income.categoryId);
    results.add(
      TransactionDisplayModel(
        id: income.id,
        title: income.source.isNotEmpty ? income.source : category.name,
        amount: income.amount,
        date: income.date,
        note: income.note,
        color: category.color,
        icon: category.icon,
        isExpense: false,
      ),
    );
  }

  for (final expense in expenses) {
    final category = getCategory(expenseCategories, expense.categoryId);
    results.add(
      TransactionDisplayModel(
        id: expense.id,
        title: category.name,
        amount: expense.amount,
        date: expense.date,
        note: expense.note,
        color: category.color,
        icon: category.icon,
        isExpense: true,
      ),
    );
  }

  results.sort((a, b) => b.date.compareTo(a.date));
  return results;
}

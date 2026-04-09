import 'package:flutter/material.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';
import 'package:hasbi/features/finance/providers/transaction_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../core/storage/hive_service.dart';
import '../data/models/category_model.dart';
import '../data/models/finance_enums.dart';

import '../data/models/expense_model.dart';
import '../data/models/income_model.dart';
import 'finance_provider.dart';
import 'home_provider.dart';

// ===== UI STATE =====
class AddTransactionState {
  final String? id;
  final CategoryModel? selectedCategory;
  final String amount;
  final String note;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final bool isLoading;
  final String? errorMessage;

  AddTransactionState({
    this.id,
    this.selectedCategory,
    required this.amount,
    required this.note,
    required this.selectedDate,
    required this.selectedTime,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AddTransactionState.initial() {
    return AddTransactionState(
      amount: "",
      note: "",
      selectedDate: DateTime.now(),
      selectedTime: TimeOfDay.now(),
    );
  }

  bool get isValid {
    // Remove formatting characters for validation
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');
    final amountValue = double.tryParse(cleanAmount);
    return selectedCategory != null && amountValue != null && amountValue > 0;
  }

  String? get validationError {
    if (selectedCategory == null) return "Please select a category";
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');
    final amountValue = double.tryParse(cleanAmount);
    if (amountValue == null || amountValue <= 0)
      return "Please enter a valid amount";
    return null;
  }

  AddTransactionState copyWith({
    String? id,
    CategoryModel? selectedCategory,
    String? amount,
    String? note,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddTransactionState(
      id: id ?? this.id,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// ===== VIEW MODEL =====
class AddTransactionNotifier extends StateNotifier<AddTransactionState> {
  final Ref ref;
  final TransactionType transactionType;

  AddTransactionNotifier(this.ref, this.transactionType)
    : super(AddTransactionState.initial());

  // UI Actions
  void setCategory(CategoryModel category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: time);
  }

  void reset() {
    state = AddTransactionState.initial();
  }

  // Load existing transaction
  Future<void> loadTransaction(String transactionId) async {
    final userId = HiveService().userId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(financeRepositoryProvider);

      if (transactionType == TransactionType.income) {
        final incomes = await repository.getIncomes(userId);
        final target = incomes.firstWhere((inc) => inc.id == transactionId);

        state = state.copyWith(
          id: target.id,
          amount: target.amount.toString(),
          note: target.note ?? '',
          selectedDate: target.date,
          selectedTime: TimeOfDay(
            hour: target.date.hour,
            minute: target.date.minute,
          ),
          isLoading: false,
          selectedCategory: AppCategories.getIncomeCategories().firstWhere(
            (c) => c.id == target.categoryId,
            orElse: () => AppCategories.getIncomeCategories().first,
          ),
        );
      } else {
        final expenses = await repository.getExpenses(userId);
        final target = expenses.firstWhere((exp) => exp.id == transactionId);

        state = state.copyWith(
          id: target.id,
          amount: target.amount.toString(),
          note: target.note ?? '',
          selectedDate: target.date,
          selectedTime: TimeOfDay(
            hour: target.date.hour,
            minute: target.date.minute,
          ),
          isLoading: false,
          selectedCategory: AppCategories.getExpenseCategories().firstWhere(
            (c) => c.id == target.categoryId,
            orElse: () => AppCategories.getExpenseCategories().first,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error loading transaction: $e");
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Business Logic
  Future<bool> saveTransaction({
    required String amount,
    required String note,
  }) async {
    final userId = HiveService().userId;
    if (userId == null) return false;

    // Validate amount
    final cleanAmountString = amount.replaceAll(RegExp(r'[^\d.]'), '');
    final amountValue = double.tryParse(cleanAmountString);

    if (state.selectedCategory == null) {
      state = state.copyWith(errorMessage: "Please select a category");
      return false;
    }

    if (amountValue == null || amountValue <= 0) {
      state = state.copyWith(errorMessage: "Please enter a valid amount");
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(financeRepositoryProvider);

      final dateTime = DateTime(
        state.selectedDate.year,
        state.selectedDate.month,
        state.selectedDate.day,
        state.selectedTime.hour,
        state.selectedTime.minute,
      );

      if (transactionType == TransactionType.income) {
        final income = IncomeModel(
          id: state.id ?? '',
          userId: userId,
          amount: amountValue,
          categoryId: state.selectedCategory!.id,
          source: state.selectedCategory!.name,
          date: dateTime,
          isRecurring: false,
          note: note.isEmpty ? null : note,
        );

        if (state.id != null && state.id!.isNotEmpty) {
          await repository.updateIncome(income);
        } else {
          await repository.addIncome(income);
        }
      } else {
        final expense = ExpenseModel(
          id: state.id ?? '',
          userId: userId,
          amount: amountValue,
          categoryId: state.selectedCategory!.id,
          paymentMethod: 'Cash',
          date: dateTime,
          note: note.isEmpty ? null : note,
        );

        if (state.id != null && state.id!.isNotEmpty) {
          await repository.updateExpense(expense);
        } else {
          await repository.addExpense(expense);
        }
      }

      state = state.copyWith(isLoading: false);
      ref.invalidate(homeProvider);
      ref.invalidate(statisticsProvider(userId));
      ref.invalidate(transactionsProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save: ${e.toString()}',
      );
      return false;
    }
  }
}

final addTransactionProvider = StateNotifierProvider.autoDispose
    .family<AddTransactionNotifier, AddTransactionState, TransactionType>((
      ref,
      type,
    ) {
      return AddTransactionNotifier(ref, type);
    });

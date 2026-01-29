import 'package:flutter/material.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../core/storage/hive_service.dart';
import '../data/models/category_model.dart';
import '../data/models/expense_model.dart';
import '../data/models/income_model.dart';
import '../data/repositories/finance_repository_impl.dart';
import '../domain/repositories/finance_repository.dart';
import 'home_provider.dart';

// ===== UI STATE =====
class AddTransactionState {
  final String? id; // ADD THIS: ID is null for new, populated for edit
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
    final amountValue = double.tryParse(amount);
    return selectedCategory != null &&
        amountValue != null &&
        amountValue > 0;
  }

  String? get validationError {
    if (selectedCategory == null) return "Please select a category";
    final amountValue = double.tryParse(amount);
    if (amountValue == null || amountValue <= 0) return "Please enter a valid amount";
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

  void setAmount(String amount) {
    state = state.copyWith(amount: amount);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
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

  // NEW: Load existing transaction for Editing
  Future<void> loadTransaction(String transactionId) async {
    final userId = HiveService().userId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(FinanceRepositoryProvide);

      if (transactionType == TransactionType.income) {
        // Fetch all incomes (since we don't have getById in repo yet) and filter
        final incomes = await repository.getIncomes(userId);
        final target = incomes.firstWhere((inc) => inc.id == transactionId);

        // Update State
        state = state.copyWith(
          id: target.id,
          amount: target.amount.toString(),
          note: target.note ?? '',
          selectedDate: target.date,
          selectedTime: TimeOfDay(hour: target.date.hour, minute: target.date.minute),
          isLoading: false,
          // Category needs to be matched. Assuming ID matches or defaults to first.
          // For simplicity, we match by ID if available in your static list
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
          selectedTime: TimeOfDay(hour: target.date.hour, minute: target.date.minute),
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
  Future<bool> saveTransaction() async {
    final userId = HiveService().userId;
    if (userId == null) return false;

    if (!state.isValid) {
      state = state.copyWith(errorMessage: state.validationError);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(FinanceRepositoryProvide);
      final amount = double.parse(state.amount);

      final dateTime = DateTime(
        state.selectedDate.year,
        state.selectedDate.month,
        state.selectedDate.day,
        state.selectedTime.hour,
        state.selectedTime.minute,
      );

      if (transactionType == TransactionType.income) {
        final income = IncomeModel(
          id: state.id ?? '', // Use existing ID if editing, empty string if creating (Appwrite handles unique ID)
          userId: userId,
          amount: amount,
          categoryId: state.selectedCategory!.id,
          source: state.selectedCategory!.name,
          date: dateTime,
          isRecurring: false,
          note: state.note.isEmpty ? null : state.note,
        );

        // DECIDE: Create vs Update
        if (state.id != null && state.id!.isNotEmpty) {
          await repository.updateIncome(income);
        } else {
          await repository.addIncome(income);
        }

      } else {
        final expense = ExpenseModel(
          id: state.id ?? '',
          userId: userId,
          amount: amount,
          categoryId: state.selectedCategory!.id,
          paymentMethod: 'Cash',
          date: dateTime,
          note: state.note.isEmpty ? null : state.note,
        );

        // DECIDE: Create vs Update
        if (state.id != null && state.id!.isNotEmpty) {
          await repository.updateExpense(expense);
        } else {
          await repository.addExpense(expense);
        }
      }

      state = state.copyWith(isLoading: false);
      ref.invalidate(homeProvider);
      ref.invalidate(statsProvider);
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

final addTransactionProvider =
StateNotifierProvider.autoDispose.family<
    AddTransactionNotifier,
    AddTransactionState,
    TransactionType>((ref, type) {
  return AddTransactionNotifier(ref, type);
});
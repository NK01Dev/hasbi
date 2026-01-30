import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../../core/storage/hive_service.dart';
import '../data/models/finance_enums.dart';
import '../data/models/goal_model.dart';
import '../domain/repositories/finance_repository.dart';
import 'finance_provider.dart';
import 'goals_provider.dart';

// ===== UI STATE =====
class AddGoalState {
  final String? id;
  final String title;
  final String targetAmount;
  final String currentAmount;
  final String categoryId;
  final DateTime deadline;
  final TimeOfDay selectedTime;
  final GoalStatus status;
  final bool isLoading;
  final String? errorMessage;

  AddGoalState({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.categoryId,
    required this.deadline,
    required this.selectedTime,
    required this.status,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AddGoalState.initial() {
    return AddGoalState(
      title: "",
      targetAmount: "",
      currentAmount: "",
      categoryId: "travel", // Default category
      deadline: DateTime.now().add(const Duration(days: 30)),
      selectedTime: TimeOfDay.now(),
      status: GoalStatus.active,
    );
  }

  AddGoalState copyWith({
    String? id,
    String? title,
    String? targetAmount,
    String? currentAmount,
    String? categoryId,
    DateTime? deadline,
    TimeOfDay? selectedTime,
    GoalStatus? status,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddGoalState(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      categoryId: categoryId ?? this.categoryId,
      deadline: deadline ?? this.deadline,
      selectedTime: selectedTime ?? this.selectedTime,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// ===== VIEW MODEL =====
class AddGoalNotifier extends StateNotifier<AddGoalState> {
  final Ref ref;

  AddGoalNotifier(this.ref) : super(AddGoalState.initial());

  // UI Actions
  void setCategoryId(String categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void setDate(DateTime date) {
    state = state.copyWith(deadline: date);
  }

  void setTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: time);
  }

  void setDeadline(DateTime date) {
    state = state.copyWith(deadline: date);
  }
  
  void setStatus(GoalStatus status) {
    state = state.copyWith(status: status);
  }

  void reset() {
    state = AddGoalState.initial();
  }

  // Load existing goal for editing
  Future<void> loadGoal(String goalId) async {
    final userId = HiveService().userId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(financeRepositoryProvider);
      final goals = await repository.getGoals(userId);
      final target = goals.firstWhere((g) => g.id == goalId);

      state = state.copyWith(
        id: target.id,
        title: target.title,
        targetAmount: target.targetAmount.toString(),
        currentAmount: target.currentAmount.toString(),
        categoryId: target.categoryId,
        deadline: target.deadline,
        selectedTime: TimeOfDay(hour: target.deadline.hour, minute: target.deadline.minute),
        status: target.status,
        isLoading: false,
      );
    } catch (e) {
      debugPrint("Error loading goal: $e");
      state = state.copyWith(isLoading: false, errorMessage: "Failed to load goal: ${e.toString()}");
    }
  }

  // Business Logic
  Future<bool> saveGoal({
    required String title,
    required String targetAmount,
    String? currentAmount,
  }) async {
    final userId = HiveService().userId;
    debugPrint("Saving goal with userId: $userId");

    if (userId == null) return false;

    // Validation
    if (title.isEmpty) {
      state = state.copyWith(errorMessage: "Please enter a title");
      return false;
    }

    final cleanTarget = targetAmount.replaceAll(RegExp(r'[^\d.]'), '');
    final targetValue = double.tryParse(cleanTarget);
    if (targetValue == null || targetValue <= 0) {
      state = state.copyWith(errorMessage: "Please enter a valid target amount");
      return false;
    }

    double currentValue = 0.0;
    if (currentAmount != null && currentAmount.isNotEmpty) {
       final cleanCurrent = currentAmount.replaceAll(RegExp(r'[^\d.]'), '');
       currentValue = double.tryParse(cleanCurrent) ?? 0.0;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(financeRepositoryProvider);

      final combinedDeadline = DateTime(
        state.deadline.year,
        state.deadline.month,
        state.deadline.day,
        state.selectedTime.hour,
        state.selectedTime.minute,
      );

      final goal = GoalModel(
        id: state.id ?? '',
        userId: userId,
        title: title,
        targetAmount: targetValue,
        currentAmount: currentValue,
        categoryId: state.categoryId,
        deadline: combinedDeadline,
        status: state.status,
      );

      debugPrint("Saving Goal: ${goal.toJson()}");

      if (state.id != null && state.id!.isNotEmpty) {
        await repository.updateGoal(goal);
      } else {
        await repository.addGoal(goal);
      }

      // Refresh goals list
      await ref.read(goalsProvider.notifier).fetchGoals();

      state = state.copyWith(isLoading: false);
      return true;

    } catch (e, stack) {
      debugPrint("Error in saveGoal: $e");
      debugPrint(stack.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save: ${e.toString()}',
      );
      return false;
    }
  }
}

final addGoalProvider =
    StateNotifierProvider.autoDispose<AddGoalNotifier, AddGoalState>((ref) {
  return AddGoalNotifier(ref);
});

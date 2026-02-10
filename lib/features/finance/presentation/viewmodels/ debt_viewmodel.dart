import 'package:hasbi/features/finance/presentation/viewmodels/debt_state.dart';
import 'package:hasbi/features/finance/providers/finance_provider.dart';
import 'package:hasbi/features/finance/providers/mocking_finance_provider.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/debt_model.dart';
import '../../domain/repositories/finance_repository.dart';
part ' debt_viewmodel.g.dart';
@riverpod
class DebtViewModel extends _$DebtViewModel {
  late FinanceRepository _repository;

  @override
  DebtState build() {
    _repository = ref.watch(financeRepositoryProvider);
    return const DebtState(); // Initial state
  }

  // Method to load all debts
  Future<void> loadDebts(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final debts = await _repository.getDebts(userId);
      state = state.copyWith(
        debts: debts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Method to add debt
  Future<void> addDebt(DebtModel debt, String userId) async {
    try {
      await _repository.addDebt(debt);
      await loadDebts(userId); // Reload debts after adding
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  // Method to delete debt
  Future<void> deleteDebt(String debtId, String userId) async {
    try {
      await _repository.deleteDebt(debtId);
      await loadDebts(userId); // Reload debts after deleting
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  // Get debts I owe (filtered)
  List<DebtModel> getDebtsIOwe() {
    return state.debts.where((debt) => debt.iOwe == true).toList();
  }

  // Get debts owed to me (filtered)
  List<DebtModel> getDebtsOwedToMe() {
    return state.debts.where((debt) => debt.iOwe == false).toList();
  }
}
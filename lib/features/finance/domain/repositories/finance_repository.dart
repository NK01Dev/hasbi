import 'package:hasbi/features/finance/data/models/debt_model.dart';
import 'package:hasbi/features/finance/data/models/summary_model.dart';

import '../../data/models/expense_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/income_model.dart';
import '../../data/models/person_model.dart';

abstract class FinanceRepository {
  // --- Total balance ---
  Future<double> getTotalBalance(String userId);

  // --- Income ---
  Future<List<IncomeModel>> getIncomes(String userId);
  Future<void> addIncome(IncomeModel income);
  Future<void> updateIncome(IncomeModel income);
  Future<void> deleteIncome(String id);
  Future<IncomeModel?> getIncomeById(String id);

  // --- Expenses ---
  Future<List<ExpenseModel>> getExpenses(String userId);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<ExpenseModel?> getExpenseById(String id);

  // --- Debts & People ---
  Future<List<PersonModel>> getPersons(String userId);
  Future<void> addPerson(PersonModel person);
  Future<void> deletePerson(String id);

  Future<List<DebtModel>> getDebts(String userId);
  Future<void> addDebt(DebtModel debt);
  Future<void> updateDebt(DebtModel debt);
  Future<void> deleteDebt(String id);
  Future<List<DebtModel>> getDebtsIOwe(String userId, bool iOwe);

  // --- Goals ---
  Future<List<GoalModel>> getGoals(String userId);
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String id);

  // =========================================================
  // Remote API Actions (consolidated finance-api-v1)
  // =========================================================

  /// Fetches a server-computed financial summary for the given [period].
  Future<SummaryModel> getSummary(
    String userId,
    String period, {
    DateTime? anchor,
  });

  /// Performs a soft-delete, restore, or confirmed hard-delete on a
  /// transaction via the consolidated API.
  Future<void> deleteTransactionRemote({
    required String transactionId,
    required String type,
    required String userId,
    required String subAction,
  });

  /// Records a monetary contribution toward a financial goal.
  Future<void> contributeToGoal({
    required String goalId,
    required String userId,
    required double amount,
  });

  /// Generates a CSV export of the user's transactions.
  Future<String> exportCsv(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

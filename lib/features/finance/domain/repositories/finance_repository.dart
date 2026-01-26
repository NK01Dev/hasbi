

import '../../data/models/category_model.dart';
import '../../data/models/debt_transaction_model.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/income_model.dart';
import '../../data/models/person_model.dart';

abstract class FinanceRepository {
//-- total balance
  Future<double> getTotalBalance(String userId);


  // --- Income ---
  Future<List<IncomeModel>> getIncomes(String userId);
  Future<void> addIncome(IncomeModel income);
  Future<void> updateIncome(IncomeModel income);
  Future<void> deleteIncome(String id);

  // --- Expenses ---
  Future<List<ExpenseModel>> getExpenses(String userId);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);

  // --- Debts & People ---
  Future<List<PersonModel>> getPersons(String userId);
  Future<void> addPerson(PersonModel person);
  Future<void> deletePerson(String id);

  Future<List<DebtTransactionModel>> getDebts(String userId);
  Future<void> addDebt(DebtTransactionModel debt);
  Future<void> updateDebt(DebtTransactionModel debt);
  Future<void> deleteDebt(String id);

  // --- Goals ---
  Future<List<GoalModel>> getGoals(String userId);
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
}
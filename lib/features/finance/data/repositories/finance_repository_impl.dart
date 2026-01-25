import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/appwrite_config.dart';
import '../../../../core/config/db_constants.dart';
import '../../domain/repositories/finance_repository.dart';
import '../models/category_model.dart';
import '../models/debt_transaction_model.dart';
import '../models/expense_model.dart';
import '../models/goal_model.dart';
import '../models/income_model.dart';
import '../models/person_model.dart';
// Use the generated provider from your appwrite_config.dart
final FinanceRepositoryProvide = Provider<FinanceRepository>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  return FinanceRepositoryImpl(databases);
});
class FinanceRepositoryImpl implements FinanceRepository {
  final Databases _databases;

  FinanceRepositoryImpl(this._databases);

  // --- Helper for Error Handling ---
  Exception _handleError(AppwriteException e) {
    throw Exception(e.message);
  }

  // --- Helper to remove system attributes before writing ---
  Map<String, dynamic> _filterOutSystemAttributes(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map.from(json);
    data.remove('\$id');
    data.remove('\$createdAt');
    data.remove('\$updatedAt');
    data.remove('\$permissions');
    data.remove('\$collectionId');
    data.remove('\$databaseId');
    return data;
  }
  // --- Income ---
  @override
  Future<List<IncomeModel>> getIncomes(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        queries: [Query.equal('userId', userId)],
      );
      return result.documents.map((doc) => IncomeModel.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(income.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateIncome(IncomeModel income) async {
    try {
      await _databases.updateDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        documentId: income.id,
        data: _filterOutSystemAttributes(income.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Expenses ---
  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        queries: [Query.equal('userId', userId)],
      );
      return result.documents.map((doc) => ExpenseModel.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(expense.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _databases.updateDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        documentId: expense.id,
        data: _filterOutSystemAttributes(expense.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Debts & People ---
  @override
  Future<List<PersonModel>> getPersons(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.persons,
        queries: [Query.equal('userId', userId)],
      );
      return result.documents.map((doc) => PersonModel.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addPerson(PersonModel person) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.persons,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(person.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deletePerson(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.persons,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<DebtTransactionModel>> getDebts(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        queries: [Query.equal('userId', userId)],
      );
      return result.documents.map((doc) => DebtTransactionModel.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addDebt(DebtTransactionModel debt) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(debt.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateDebt(DebtTransactionModel debt) async {
    try {
      await _databases.updateDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        documentId: debt.id,
        data: _filterOutSystemAttributes(debt.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteDebt(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Goals ---
  @override
  Future<List<GoalModel>> getGoals(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        queries: [Query.equal('userId', userId)],
      );
      return result.documents.map((doc) => GoalModel.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addGoal(GoalModel goal) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(goal.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateGoal(GoalModel goal) async {
    try {
      await _databases.updateDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        documentId: goal.id,
        data: _filterOutSystemAttributes(goal.toJson()),
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }
}
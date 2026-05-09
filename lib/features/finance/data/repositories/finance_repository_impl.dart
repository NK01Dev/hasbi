import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:hasbi/features/finance/data/models/debt_model.dart';
import 'package:hasbi/features/finance/data/models/summary_model.dart';

import '../../../../core/config/db_constants.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/finance_api_service.dart';
import '../models/expense_model.dart';
import '../models/goal_model.dart';
import '../models/income_model.dart';
import '../models/person_model.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final Databases _databases;
  final FinanceApiService _apiService;

  FinanceRepositoryImpl(this._databases, this._apiService);

  // --- Helper for Error Handling ---
  Never _handleError(AppwriteException e) {
    throw AppwriteException(e.message, e.code, e.type, e.response);
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
  Future<IncomeModel?> getIncomeById(String id) async {
    try {
      final result = await _databases.getDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        documentId: id,
      );
      return IncomeModel.fromJson(result.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      throw _handleError(e);
    }
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    try {
      final result = await _databases.getDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        documentId: id,
      );
      return ExpenseModel.fromJson(result.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      throw _handleError(e);
    }
  }

  @override
  Future<List<IncomeModel>> getIncomes(String userId) async {
    try {
      debugPrint('FinanceRepo: Fetching incomes for userId: $userId');
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.incomes,
        queries: [
          Query.equal('userId', userId),
          Query.limit(500),
          Query.orderDesc('date'),
        ],
      );
      debugPrint('FinanceRepo: Found ${result.documents.length} incomes');
      return result.documents
          .map((doc) => IncomeModel.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      debugPrint('FinanceRepo Error: ${e.message}');
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
        permissions: [
          Permission.read(Role.user(income.userId)),
          Permission.update(Role.user(income.userId)),
          Permission.delete(Role.user(income.userId)),
        ],
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
      debugPrint('FinanceRepo: Fetching expenses for userId: $userId');
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.expenses,
        queries: [
          Query.equal('userId', userId),
          Query.limit(500),
          Query.orderDesc('date'),
        ],
      );
      debugPrint('FinanceRepo: Found ${result.documents.length} expenses');
      return result.documents
          .map((doc) => ExpenseModel.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      debugPrint('FinanceRepo Error: ${e.message}');
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
        permissions: [
          Permission.read(Role.user(expense.userId)),
          Permission.update(Role.user(expense.userId)),
          Permission.delete(Role.user(expense.userId)),
        ],
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
        queries: [Query.equal('userId', userId), Query.limit(500)],
      );
      return result.documents
          .map((doc) => PersonModel.fromJson(doc.data))
          .toList();
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
        permissions: [
          Permission.read(Role.user(person.userId)),
          Permission.update(Role.user(person.userId)),
          Permission.delete(Role.user(person.userId)),
        ],
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
  Future<List<DebtModel>> getDebts(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        queries: [Query.equal('userId', userId), Query.limit(500)],
      );
      return result.documents
          .map((doc) => DebtModel.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addDebt(DebtModel debt) async {
    try {
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        documentId: ID.unique(),
        data: _filterOutSystemAttributes(debt.toJson()),
        permissions: [
          Permission.read(Role.user(debt.userId)),
          Permission.update(Role.user(debt.userId)),
          Permission.delete(Role.user(debt.userId)),
        ],
      );
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
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

  @override
  Future<List<DebtModel>> getDebtsIOwe(String userId, bool iOwe) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.debts,
        queries: [
          Query.equal('userId', userId),
          Query.equal('iOwe', iOwe),
          Query.limit(500),
        ],
      );
      debugPrint(
        '${result.documents.length} ${iOwe ? "I owe" : "owed to me"} debts found',
      );
      return result.documents
          .map((doc) => DebtModel.fromJson(doc.data))
          .toList();
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
        queries: [Query.equal('userId', userId), Query.limit(500)],
      );
      return result.documents
          .map((doc) => GoalModel.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addGoal(GoalModel goal) async {
    try {
      final data = _filterOutSystemAttributes(goal.toJson());
      debugPrint("Appwrite creating goal with data: $data");
      await _databases.createDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        documentId: ID.unique(),
        data: data,
        permissions: [
          Permission.read(Role.user(goal.userId)),
          Permission.update(Role.user(goal.userId)),
          Permission.delete(Role.user(goal.userId)),
        ],
      );
    } on AppwriteException catch (e) {
      debugPrint(
        "AppwriteException in addGoal: ${e.message} (Code: ${e.code})",
      );
      throw _handleError(e);
    } catch (e) {
      debugPrint("Unexpected error in addGoal: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateGoal(GoalModel goal) async {
    try {
      final data = _filterOutSystemAttributes(goal.toJson());
      debugPrint("Appwrite updating goal with data: $data");
      await _databases.updateDocument(
        databaseId: DbConstants.databaseId,
        collectionId: DbConstants.goals,
        documentId: goal.id,
        data: data,
      );
    } on AppwriteException catch (e) {
      debugPrint(
        "AppwriteException in updateGoal: ${e.message} (Code: ${e.code})",
      );
      throw _handleError(e);
    } catch (e) {
      debugPrint("Unexpected error in updateGoal: $e");
      rethrow;
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

  @override
  Future<double> getTotalBalance(String userId) async {
    try {
      final results = await Future.wait([
        getIncomes(userId),
        getExpenses(userId),
      ]);

      final incomeList = results[0] as List<IncomeModel>;
      final expenseList = results[1] as List<ExpenseModel>;

      double totalIncome = incomeList.fold<double>(
        0.0,
        (sum, item) => sum + (item.amount as num).toDouble(),
      );

      double totalExpense = expenseList.fold<double>(
        0.0,
        (sum, item) => sum + (item.amount as num).toDouble(),
      );

      return totalIncome - totalExpense;
    } on AppwriteException catch (e) {
      throw _handleError(e);
    }
  }

  // =========================================================
  // Remote API Actions (consolidated finance-api-v1)
  // =========================================================

  @override
  Future<SummaryModel> getSummary(
    String userId,
    String period, {
    DateTime? anchor,
  }) async {
    final data = <String, dynamic>{'userId': userId, 'period': period};
    if (anchor != null) {
      data['anchor'] = anchor.toIso8601String();
    }

    final response = await _apiService.callFinanceApi(
      action: 'getSummary',
      data: data,
      method: 'GET',
    );

    return SummaryModel.fromJson(response);
  }

  @override
  Future<void> deleteTransactionRemote({
    required String transactionId,
    required String type,
    required String userId,
    required String subAction,
  }) async {
    await _apiService.callFinanceApi(
      action: 'deleteTransaction',
      data: {
        'transactionId': transactionId,
        'type': type,
        'userId': userId,
        'subAction': subAction,
      },
    );
  }

  @override
  Future<void> contributeToGoal({
    required String goalId,
    required String userId,
    required double amount,
  }) async {
    await _apiService.callFinanceApi(
      action: 'contributeToGoal',
      data: {'goalId': goalId, 'userId': userId, 'amount': amount},
    );
  }

  @override
  Future<String> exportCsv(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = <String, dynamic>{'userId': userId};
    if (startDate != null) {
      data['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      data['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiService.callFinanceApi(
      action: 'exportCSV',
      data: data,
    );

    return (response['data'] as String?) ?? (response['raw'] as String?) ?? '';
  }
}

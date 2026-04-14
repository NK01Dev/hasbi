import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/expense_model.dart';
import '../data/models/income_model.dart';
import 'finance_provider.dart';
import '../../../core/storage/hive_service.dart';

part 'raw_finance_provider.g.dart';

typedef FinanceRawData = ({
  List<IncomeModel> incomes,
  List<ExpenseModel> expenses,
});

@riverpod
Future<FinanceRawData> rawFinanceData(Ref ref, String userId) async {
  final hive = HiveService();
  final cached = hive.getFinanceCache();

  // Return cache immediately if fresh
  if (cached != null && !hive.isFinanceCacheStale) {
    return _deserializeCache(cached);
  }

  // Fetch from network
  final repo = ref.watch(financeRepositoryProvider);
  try {
    final results = await Future.wait([
      repo.getIncomes(userId),
      repo.getExpenses(userId),
    ]);
    final data = (
      incomes: results[0] as List<IncomeModel>,
      expenses: results[1] as List<ExpenseModel>,
    );

    // Persist to cache
    await hive.setFinanceCache(_serializeCache(data));

    return data;
  } catch (e) {
    // If network fails and we have a stale cache, return it as fallback
    if (cached != null) {
      return _deserializeCache(cached);
    }
    rethrow;
  }
}

Map<String, dynamic> _serializeCache(FinanceRawData data) {
  return {
    'incomes': data.incomes.map((i) => i.toJson()).toList(),
    'expenses': data.expenses.map((e) => e.toJson()).toList(),
  };
}

FinanceRawData _deserializeCache(Map<String, dynamic> json) {
  final incomes = (json['incomes'] as List)
      .map((i) => IncomeModel.fromJson(Map<String, dynamic>.from(i)))
      .toList();
  final expenses = (json['expenses'] as List)
      .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();
  return (incomes: incomes, expenses: expenses);
}

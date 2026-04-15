import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/config/appwrite_config.dart';
import '../domain/repositories/finance_repository.dart';
import '../data/repositories/finance_repository_impl.dart';
import '../data/datasources/finance_api_service.dart';

part 'finance_provider.g.dart';

// Provider for the Database Instance
@riverpod
Databases financeDatabases(Ref ref) {
  return Databases(ref.watch(appwriteClientProvider));
}

// Provider for the consolidated Finance API Service
@riverpod
FinanceApiService financeApiService(Ref ref) {
  return FinanceApiService(
    functions: ref.watch(appwriteFunctionsProvider),
    account: ref.watch(appwriteAccountProvider),
  );
}

// Provider for the Repository Implementation
@riverpod
FinanceRepository financeRepository(Ref ref) {
  final databases = ref.watch(financeDatabasesProvider);
  final apiService = ref.watch(financeApiServiceProvider);
  return FinanceRepositoryImpl(databases, apiService);
}

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/finance_api_exception.dart';
import 'finance_provider.dart';
import 'home_provider.dart';
import 'raw_finance_provider.dart';
import 'transaction_provider.dart';

part 'delete_transaction_provider.g.dart';

/// Manages soft-delete, restore, and confirmed hard-delete of transactions
/// through the consolidated `finance-api-v1` function.
@riverpod
class DeleteTransactionNotifier extends _$DeleteTransactionNotifier {
  @override
  FutureOr<void> build() {
    // No initial state — this is an action-only notifier.
  }

  /// Soft-delete a transaction (marks it as deleted).
  Future<void> markDeleted({
    required String transactionId,
    required String type,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financeRepositoryProvider);
      await repo.deleteTransactionRemote(
        transactionId: transactionId,
        type: type,
        userId: userId,
        subAction: 'mark-deleted',
      );
      _invalidateRelatedProviders(userId);
    });
  }

  /// Restore a previously soft-deleted transaction.
  Future<void> restore({
    required String transactionId,
    required String type,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financeRepositoryProvider);
      await repo.deleteTransactionRemote(
        transactionId: transactionId,
        type: type,
        userId: userId,
        subAction: 'restore',
      );
      _invalidateRelatedProviders(userId);
    });
  }

  /// Permanently delete a transaction (confirmed hard delete).
  Future<void> confirmDeleted({
    required String transactionId,
    required String type,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financeRepositoryProvider);
      await repo.deleteTransactionRemote(
        transactionId: transactionId,
        type: type,
        userId: userId,
        subAction: 'confirm-deleted',
      );
      _invalidateRelatedProviders(userId);
    });
  }

  /// Invalidates providers that depend on transaction data so the UI refreshes.
  void _invalidateRelatedProviders(String userId) {
    ref.invalidate(rawFinanceDataProvider(userId));
    ref.invalidate(homeProvider);
    ref.invalidate(transactionsProvider);
  }
}

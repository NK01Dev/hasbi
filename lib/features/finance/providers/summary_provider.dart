import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/finance_api_exception.dart';
import '../data/models/summary_model.dart';
import 'finance_provider.dart';

part 'summary_provider.g.dart';

/// Fetches a server-computed financial summary from `finance-api-v1`.
///
/// This is a family provider keyed by `(userId, period)`.
/// Optionally, pass an anchor date for custom time ranges.
@riverpod
class SummaryNotifier extends _$SummaryNotifier {
  @override
  FutureOr<SummaryModel> build(String userId, String period) async {
    return _fetchSummary();
  }

  Future<SummaryModel> _fetchSummary({DateTime? anchor}) async {
    final repo = ref.watch(financeRepositoryProvider);
    return await repo.getSummary(userId, period, anchor: anchor);
  }

  /// Refresh the summary with an optional anchor date.
  Future<void> refresh({DateTime? anchor}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSummary(anchor: anchor));
  }
}

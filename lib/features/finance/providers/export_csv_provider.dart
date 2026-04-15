import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/finance_api_exception.dart';
import 'finance_provider.dart';

part 'export_csv_provider.g.dart';

/// Fetches a CSV export of the user's transactions from the consolidated API.
///
/// Returns the raw CSV string content.
@riverpod
Future<String> exportCsv(
  Ref ref, {
  required String userId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repo = ref.watch(financeRepositoryProvider);
  return await repo.exportCsv(userId, startDate: startDate, endDate: endDate);
}

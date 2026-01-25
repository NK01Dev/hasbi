import 'package:freezed_annotation/freezed_annotation.dart';
import 'finance_enums.dart'; // Import Enums

part 'recurring_transaction_model.freezed.dart';
part 'recurring_transaction_model.g.dart';

@freezed
abstract class RecurringTransactionModel with _$RecurringTransactionModel {
  const factory RecurringTransactionModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required TransactionType type, // 'income' | 'expense'
    required double amount,
    required String categoryId,
    required Frequency frequency, // 'daily' | 'weekly' | 'monthly'
    required DateTime startDate,
    DateTime? endDate, // Optional: recurring forever if null
  }) = _RecurringTransactionModel;

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringTransactionModelFromJson(json);
}
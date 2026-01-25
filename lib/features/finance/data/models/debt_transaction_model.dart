import 'package:freezed_annotation/freezed_annotation.dart';
import 'finance_enums.dart';

part 'debt_transaction_model.freezed.dart';
part 'debt_transaction_model.g.dart';

@freezed
abstract class DebtTransactionModel with _$DebtTransactionModel {
  const factory DebtTransactionModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required String personId,
    required double amount, // Positive (+): I lent (they owe me), Negative (-): I borrowed
    required DateTime date,
    @Default(DebtStatus.unpaid) DebtStatus status, // 'unpaid' | 'partial' | 'paid'
    String? note,
  }) = _DebtTransactionModel;

  factory DebtTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$DebtTransactionModelFromJson(json);
}
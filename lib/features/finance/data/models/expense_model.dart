import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required double amount,
    required String categoryId,
    required String paymentMethod, // e.g., "Cash", "Credit Card"
    required DateTime date,
    String? note,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_model.freezed.dart';
part 'income_model.g.dart';

@freezed
abstract class IncomeModel with _$IncomeModel {
  const factory IncomeModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required double amount,
    required String categoryId,
    required String source, // e.g., "Salary", "Freelance", "Gift"
    required DateTime date,
    @Default(false) bool isRecurring,
    String? note,
  }) = _IncomeModel;

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);
}
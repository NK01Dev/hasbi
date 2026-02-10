import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_model.freezed.dart';
part 'debt_model.g.dart';

@freezed
abstract class DebtModel with _$DebtModel {
  const factory DebtModel({
    @JsonKey(name: '\$id') required String id,
    required String fullName,
    required String userId,
    required String phoneNumber,
    required bool iOwe,
    required double amount,
    required DateTime dueDate,
    required double paidAmount,
  }) = _DebtModel;
  factory DebtModel.fromJson(Map<String, dynamic> json) =>
      _$DebtModelFromJson(json);
}


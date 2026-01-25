import 'package:freezed_annotation/freezed_annotation.dart';
import 'finance_enums.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

@freezed
abstract class GoalModel with _$GoalModel {
  const factory GoalModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required String title,
    required double targetAmount,
    @Default(0.0) double currentAmount,
    @Default('travel') String categoryId,

    required DateTime deadline,
    @Default(GoalStatus.active) GoalStatus status,
  }) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);
}
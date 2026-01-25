// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => _GoalModel(
  id: json[r'$id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
  categoryId: json['categoryId'] as String? ?? 'travel',
  deadline: DateTime.parse(json['deadline'] as String),
  status:
      $enumDecodeNullable(_$GoalStatusEnumMap, json['status']) ??
      GoalStatus.active,
);

Map<String, dynamic> _$GoalModelToJson(_GoalModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'categoryId': instance.categoryId,
      'deadline': instance.deadline.toIso8601String(),
      'status': _$GoalStatusEnumMap[instance.status]!,
    };

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.completed: 'completed',
  GoalStatus.cancelled: 'cancelled',
};

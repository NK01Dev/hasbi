// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncomeModel _$IncomeModelFromJson(Map<String, dynamic> json) => _IncomeModel(
  id: json[r'$id'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toDouble(),
  categoryId: json['categoryId'] as String,
  source: json['source'] as String,
  date: DateTime.parse(json['date'] as String),
  isRecurring: json['isRecurring'] as bool? ?? false,
  note: json['note'] as String?,
);

Map<String, dynamic> _$IncomeModelToJson(_IncomeModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'source': instance.source,
      'date': instance.date.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'note': instance.note,
    };

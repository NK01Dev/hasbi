// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringTransactionModel _$RecurringTransactionModelFromJson(
  Map<String, dynamic> json,
) => _RecurringTransactionModel(
  id: json[r'$id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  amount: (json['amount'] as num).toDouble(),
  categoryId: json['categoryId'] as String,
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$RecurringTransactionModelToJson(
  _RecurringTransactionModel instance,
) => <String, dynamic>{
  r'$id': instance.id,
  'userId': instance.userId,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
  TransactionType.goals: 'goals',
};

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
  Frequency.yearly: 'yearly',
};

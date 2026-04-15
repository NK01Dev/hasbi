// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SummaryModel _$SummaryModelFromJson(Map<String, dynamic> json) =>
    _SummaryModel(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      incomesByCategory:
          (json['incomesByCategory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      expensesByCategory:
          (json['expensesByCategory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$SummaryModelToJson(_SummaryModel instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'balance': instance.balance,
      'incomesByCategory': instance.incomesByCategory,
      'expensesByCategory': instance.expensesByCategory,
    };

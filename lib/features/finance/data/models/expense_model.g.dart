// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    _ExpenseModel(
      id: json[r'$id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'paymentMethod': instance.paymentMethod,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
    };

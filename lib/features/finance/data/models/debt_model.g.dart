// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtModel _$DebtModelFromJson(Map<String, dynamic> json) => _DebtModel(
  id: json[r'$id'] as String,
  fullName: json['fullName'] as String,
  userId: json['userId'] as String,
  phoneNumber: json['phoneNumber'] as String,
  iOwe: json['iOwe'] as bool,
  amount: (json['amount'] as num).toDouble(),
  dueDate: DateTime.parse(json['dueDate'] as String),
  paidAmount: (json['paidAmount'] as num).toDouble(),
);

Map<String, dynamic> _$DebtModelToJson(_DebtModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'fullName': instance.fullName,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'iOwe': instance.iOwe,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'paidAmount': instance.paidAmount,
    };

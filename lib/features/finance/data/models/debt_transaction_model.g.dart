// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtTransactionModel _$DebtTransactionModelFromJson(
  Map<String, dynamic> json,
) => _DebtTransactionModel(
  id: json[r'$id'] as String,
  userId: json['userId'] as String,
  personId: json['personId'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  status:
      $enumDecodeNullable(_$DebtStatusEnumMap, json['status']) ??
      DebtStatus.unpaid,
  note: json['note'] as String?,
);

Map<String, dynamic> _$DebtTransactionModelToJson(
  _DebtTransactionModel instance,
) => <String, dynamic>{
  r'$id': instance.id,
  'userId': instance.userId,
  'personId': instance.personId,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'status': _$DebtStatusEnumMap[instance.status]!,
  'note': instance.note,
};

const _$DebtStatusEnumMap = {
  DebtStatus.unpaid: 'unpaid',
  DebtStatus.partial: 'partial',
  DebtStatus.paid: 'paid',
};

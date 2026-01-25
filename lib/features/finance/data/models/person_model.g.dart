// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => _PersonModel(
  id: json[r'$id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$PersonModelToJson(_PersonModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'note': instance.note,
    };

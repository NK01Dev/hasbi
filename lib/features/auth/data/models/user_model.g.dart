// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json[r'$id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as String,
  userAvatar: json['userAvatar'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'age': instance.age,
      'gender': instance.gender,
      'userAvatar': instance.userAvatar,
    };

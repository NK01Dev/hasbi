import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
// ignore: invalid_annotation_target
abstract class UserModel with _$UserModel {
  const factory UserModel({
    // Using \$id to map Appwrite's internal ID to your model
    // ignore: invalid_annotation_target
    @JsonKey(name: '\$id') required String id,
    required String email,
    required String fullName,
    required int age,
    required String gender,
    String? userAvatar,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
abstract class PersonModel with _$PersonModel {
  const factory PersonModel({
    @JsonKey(name: '\$id') required String id,
    required String userId,
    required String name,
    String? phone,
    String? note,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}
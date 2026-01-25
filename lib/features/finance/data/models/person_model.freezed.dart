// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonModel {

@JsonKey(name: '\$id') String get id; String get userId; String get name; String? get phone; String? get note;
/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonModelCopyWith<PersonModel> get copyWith => _$PersonModelCopyWithImpl<PersonModel>(this as PersonModel, _$identity);

  /// Serializes this PersonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phone,note);

@override
String toString() {
  return 'PersonModel(id: $id, userId: $userId, name: $name, phone: $phone, note: $note)';
}


}

/// @nodoc
abstract mixin class $PersonModelCopyWith<$Res>  {
  factory $PersonModelCopyWith(PersonModel value, $Res Function(PersonModel) _then) = _$PersonModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, String name, String? phone, String? note
});




}
/// @nodoc
class _$PersonModelCopyWithImpl<$Res>
    implements $PersonModelCopyWith<$Res> {
  _$PersonModelCopyWithImpl(this._self, this._then);

  final PersonModel _self;
  final $Res Function(PersonModel) _then;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? phone = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonModel].
extension PersonModelPatterns on PersonModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  String name,  String? phone,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  String name,  String? phone,  String? note)  $default,) {final _that = this;
switch (_that) {
case _PersonModel():
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '\$id')  String id,  String userId,  String name,  String? phone,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _PersonModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonModel implements PersonModel {
  const _PersonModel({@JsonKey(name: '\$id') required this.id, required this.userId, required this.name, this.phone, this.note});
  factory _PersonModel.fromJson(Map<String, dynamic> json) => _$PersonModelFromJson(json);

@override@JsonKey(name: '\$id') final  String id;
@override final  String userId;
@override final  String name;
@override final  String? phone;
@override final  String? note;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonModelCopyWith<_PersonModel> get copyWith => __$PersonModelCopyWithImpl<_PersonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phone,note);

@override
String toString() {
  return 'PersonModel(id: $id, userId: $userId, name: $name, phone: $phone, note: $note)';
}


}

/// @nodoc
abstract mixin class _$PersonModelCopyWith<$Res> implements $PersonModelCopyWith<$Res> {
  factory _$PersonModelCopyWith(_PersonModel value, $Res Function(_PersonModel) _then) = __$PersonModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, String name, String? phone, String? note
});




}
/// @nodoc
class __$PersonModelCopyWithImpl<$Res>
    implements _$PersonModelCopyWith<$Res> {
  __$PersonModelCopyWithImpl(this._self, this._then);

  final _PersonModel _self;
  final $Res Function(_PersonModel) _then;

/// Create a copy of PersonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? phone = freezed,Object? note = freezed,}) {
  return _then(_PersonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

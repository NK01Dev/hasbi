// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtTransactionModel {

@JsonKey(name: '\$id') String get id; String get userId; String get personId; double get amount;// Positive (+): I lent (they owe me), Negative (-): I borrowed
 DateTime get date; DebtStatus get status;// 'unpaid' | 'partial' | 'paid'
 String? get note;
/// Create a copy of DebtTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtTransactionModelCopyWith<DebtTransactionModel> get copyWith => _$DebtTransactionModelCopyWithImpl<DebtTransactionModel>(this as DebtTransactionModel, _$identity);

  /// Serializes this DebtTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,personId,amount,date,status,note);

@override
String toString() {
  return 'DebtTransactionModel(id: $id, userId: $userId, personId: $personId, amount: $amount, date: $date, status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class $DebtTransactionModelCopyWith<$Res>  {
  factory $DebtTransactionModelCopyWith(DebtTransactionModel value, $Res Function(DebtTransactionModel) _then) = _$DebtTransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, String personId, double amount, DateTime date, DebtStatus status, String? note
});




}
/// @nodoc
class _$DebtTransactionModelCopyWithImpl<$Res>
    implements $DebtTransactionModelCopyWith<$Res> {
  _$DebtTransactionModelCopyWithImpl(this._self, this._then);

  final DebtTransactionModel _self;
  final $Res Function(DebtTransactionModel) _then;

/// Create a copy of DebtTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? personId = null,Object? amount = null,Object? date = null,Object? status = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DebtStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtTransactionModel].
extension DebtTransactionModelPatterns on DebtTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _DebtTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _DebtTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  String personId,  double amount,  DateTime date,  DebtStatus status,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.personId,_that.amount,_that.date,_that.status,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  String personId,  double amount,  DateTime date,  DebtStatus status,  String? note)  $default,) {final _that = this;
switch (_that) {
case _DebtTransactionModel():
return $default(_that.id,_that.userId,_that.personId,_that.amount,_that.date,_that.status,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '\$id')  String id,  String userId,  String personId,  double amount,  DateTime date,  DebtStatus status,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _DebtTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.personId,_that.amount,_that.date,_that.status,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtTransactionModel implements DebtTransactionModel {
  const _DebtTransactionModel({@JsonKey(name: '\$id') required this.id, required this.userId, required this.personId, required this.amount, required this.date, this.status = DebtStatus.unpaid, this.note});
  factory _DebtTransactionModel.fromJson(Map<String, dynamic> json) => _$DebtTransactionModelFromJson(json);

@override@JsonKey(name: '\$id') final  String id;
@override final  String userId;
@override final  String personId;
@override final  double amount;
// Positive (+): I lent (they owe me), Negative (-): I borrowed
@override final  DateTime date;
@override@JsonKey() final  DebtStatus status;
// 'unpaid' | 'partial' | 'paid'
@override final  String? note;

/// Create a copy of DebtTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtTransactionModelCopyWith<_DebtTransactionModel> get copyWith => __$DebtTransactionModelCopyWithImpl<_DebtTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,personId,amount,date,status,note);

@override
String toString() {
  return 'DebtTransactionModel(id: $id, userId: $userId, personId: $personId, amount: $amount, date: $date, status: $status, note: $note)';
}


}

/// @nodoc
abstract mixin class _$DebtTransactionModelCopyWith<$Res> implements $DebtTransactionModelCopyWith<$Res> {
  factory _$DebtTransactionModelCopyWith(_DebtTransactionModel value, $Res Function(_DebtTransactionModel) _then) = __$DebtTransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, String personId, double amount, DateTime date, DebtStatus status, String? note
});




}
/// @nodoc
class __$DebtTransactionModelCopyWithImpl<$Res>
    implements _$DebtTransactionModelCopyWith<$Res> {
  __$DebtTransactionModelCopyWithImpl(this._self, this._then);

  final _DebtTransactionModel _self;
  final $Res Function(_DebtTransactionModel) _then;

/// Create a copy of DebtTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? personId = null,Object? amount = null,Object? date = null,Object? status = null,Object? note = freezed,}) {
  return _then(_DebtTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DebtStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

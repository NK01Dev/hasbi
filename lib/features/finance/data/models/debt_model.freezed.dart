// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtModel {

@JsonKey(name: '\$id') String get id; String get fullName; String get userId; String get phoneNumber; bool get iOwe; double get amount; DateTime get dueDate; double get paidAmount;
/// Create a copy of DebtModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtModelCopyWith<DebtModel> get copyWith => _$DebtModelCopyWithImpl<DebtModel>(this as DebtModel, _$identity);

  /// Serializes this DebtModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.iOwe, iOwe) || other.iOwe == iOwe)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,userId,phoneNumber,iOwe,amount,dueDate,paidAmount);

@override
String toString() {
  return 'DebtModel(id: $id, fullName: $fullName, userId: $userId, phoneNumber: $phoneNumber, iOwe: $iOwe, amount: $amount, dueDate: $dueDate, paidAmount: $paidAmount)';
}


}

/// @nodoc
abstract mixin class $DebtModelCopyWith<$Res>  {
  factory $DebtModelCopyWith(DebtModel value, $Res Function(DebtModel) _then) = _$DebtModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$id') String id, String fullName, String userId, String phoneNumber, bool iOwe, double amount, DateTime dueDate, double paidAmount
});




}
/// @nodoc
class _$DebtModelCopyWithImpl<$Res>
    implements $DebtModelCopyWith<$Res> {
  _$DebtModelCopyWithImpl(this._self, this._then);

  final DebtModel _self;
  final $Res Function(DebtModel) _then;

/// Create a copy of DebtModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? userId = null,Object? phoneNumber = null,Object? iOwe = null,Object? amount = null,Object? dueDate = null,Object? paidAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,iOwe: null == iOwe ? _self.iOwe : iOwe // ignore: cast_nullable_to_non_nullable
as bool,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtModel].
extension DebtModelPatterns on DebtModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtModel value)  $default,){
final _that = this;
switch (_that) {
case _DebtModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtModel value)?  $default,){
final _that = this;
switch (_that) {
case _DebtModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String fullName,  String userId,  String phoneNumber,  bool iOwe,  double amount,  DateTime dueDate,  double paidAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtModel() when $default != null:
return $default(_that.id,_that.fullName,_that.userId,_that.phoneNumber,_that.iOwe,_that.amount,_that.dueDate,_that.paidAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String fullName,  String userId,  String phoneNumber,  bool iOwe,  double amount,  DateTime dueDate,  double paidAmount)  $default,) {final _that = this;
switch (_that) {
case _DebtModel():
return $default(_that.id,_that.fullName,_that.userId,_that.phoneNumber,_that.iOwe,_that.amount,_that.dueDate,_that.paidAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '\$id')  String id,  String fullName,  String userId,  String phoneNumber,  bool iOwe,  double amount,  DateTime dueDate,  double paidAmount)?  $default,) {final _that = this;
switch (_that) {
case _DebtModel() when $default != null:
return $default(_that.id,_that.fullName,_that.userId,_that.phoneNumber,_that.iOwe,_that.amount,_that.dueDate,_that.paidAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtModel implements DebtModel {
  const _DebtModel({@JsonKey(name: '\$id') required this.id, required this.fullName, required this.userId, required this.phoneNumber, required this.iOwe, required this.amount, required this.dueDate, required this.paidAmount});
  factory _DebtModel.fromJson(Map<String, dynamic> json) => _$DebtModelFromJson(json);

@override@JsonKey(name: '\$id') final  String id;
@override final  String fullName;
@override final  String userId;
@override final  String phoneNumber;
@override final  bool iOwe;
@override final  double amount;
@override final  DateTime dueDate;
@override final  double paidAmount;

/// Create a copy of DebtModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtModelCopyWith<_DebtModel> get copyWith => __$DebtModelCopyWithImpl<_DebtModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.iOwe, iOwe) || other.iOwe == iOwe)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,userId,phoneNumber,iOwe,amount,dueDate,paidAmount);

@override
String toString() {
  return 'DebtModel(id: $id, fullName: $fullName, userId: $userId, phoneNumber: $phoneNumber, iOwe: $iOwe, amount: $amount, dueDate: $dueDate, paidAmount: $paidAmount)';
}


}

/// @nodoc
abstract mixin class _$DebtModelCopyWith<$Res> implements $DebtModelCopyWith<$Res> {
  factory _$DebtModelCopyWith(_DebtModel value, $Res Function(_DebtModel) _then) = __$DebtModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$id') String id, String fullName, String userId, String phoneNumber, bool iOwe, double amount, DateTime dueDate, double paidAmount
});




}
/// @nodoc
class __$DebtModelCopyWithImpl<$Res>
    implements _$DebtModelCopyWith<$Res> {
  __$DebtModelCopyWithImpl(this._self, this._then);

  final _DebtModel _self;
  final $Res Function(_DebtModel) _then;

/// Create a copy of DebtModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? userId = null,Object? phoneNumber = null,Object? iOwe = null,Object? amount = null,Object? dueDate = null,Object? paidAmount = null,}) {
  return _then(_DebtModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,iOwe: null == iOwe ? _self.iOwe : iOwe // ignore: cast_nullable_to_non_nullable
as bool,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

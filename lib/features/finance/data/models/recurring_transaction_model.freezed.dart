// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringTransactionModel {

@JsonKey(name: '\$id') String get id; String get userId; TransactionType get type;// 'income' | 'expense'
 double get amount; String get categoryId; Frequency get frequency;// 'daily' | 'weekly' | 'monthly'
 DateTime get startDate; DateTime? get endDate;
/// Create a copy of RecurringTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTransactionModelCopyWith<RecurringTransactionModel> get copyWith => _$RecurringTransactionModelCopyWithImpl<RecurringTransactionModel>(this as RecurringTransactionModel, _$identity);

  /// Serializes this RecurringTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,amount,categoryId,frequency,startDate,endDate);

@override
String toString() {
  return 'RecurringTransactionModel(id: $id, userId: $userId, type: $type, amount: $amount, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $RecurringTransactionModelCopyWith<$Res>  {
  factory $RecurringTransactionModelCopyWith(RecurringTransactionModel value, $Res Function(RecurringTransactionModel) _then) = _$RecurringTransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, TransactionType type, double amount, String categoryId, Frequency frequency, DateTime startDate, DateTime? endDate
});




}
/// @nodoc
class _$RecurringTransactionModelCopyWithImpl<$Res>
    implements $RecurringTransactionModelCopyWith<$Res> {
  _$RecurringTransactionModelCopyWithImpl(this._self, this._then);

  final RecurringTransactionModel _self;
  final $Res Function(RecurringTransactionModel) _then;

/// Create a copy of RecurringTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTransactionModel].
extension RecurringTransactionModelPatterns on RecurringTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  TransactionType type,  double amount,  String categoryId,  Frequency frequency,  DateTime startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  TransactionType type,  double amount,  String categoryId,  Frequency frequency,  DateTime startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _RecurringTransactionModel():
return $default(_that.id,_that.userId,_that.type,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '\$id')  String id,  String userId,  TransactionType type,  double amount,  String categoryId,  Frequency frequency,  DateTime startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _RecurringTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringTransactionModel implements RecurringTransactionModel {
  const _RecurringTransactionModel({@JsonKey(name: '\$id') required this.id, required this.userId, required this.type, required this.amount, required this.categoryId, required this.frequency, required this.startDate, this.endDate});
  factory _RecurringTransactionModel.fromJson(Map<String, dynamic> json) => _$RecurringTransactionModelFromJson(json);

@override@JsonKey(name: '\$id') final  String id;
@override final  String userId;
@override final  TransactionType type;
// 'income' | 'expense'
@override final  double amount;
@override final  String categoryId;
@override final  Frequency frequency;
// 'daily' | 'weekly' | 'monthly'
@override final  DateTime startDate;
@override final  DateTime? endDate;

/// Create a copy of RecurringTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTransactionModelCopyWith<_RecurringTransactionModel> get copyWith => __$RecurringTransactionModelCopyWithImpl<_RecurringTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,amount,categoryId,frequency,startDate,endDate);

@override
String toString() {
  return 'RecurringTransactionModel(id: $id, userId: $userId, type: $type, amount: $amount, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$RecurringTransactionModelCopyWith<$Res> implements $RecurringTransactionModelCopyWith<$Res> {
  factory _$RecurringTransactionModelCopyWith(_RecurringTransactionModel value, $Res Function(_RecurringTransactionModel) _then) = __$RecurringTransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, TransactionType type, double amount, String categoryId, Frequency frequency, DateTime startDate, DateTime? endDate
});




}
/// @nodoc
class __$RecurringTransactionModelCopyWithImpl<$Res>
    implements _$RecurringTransactionModelCopyWith<$Res> {
  __$RecurringTransactionModelCopyWithImpl(this._self, this._then);

  final _RecurringTransactionModel _self;
  final $Res Function(_RecurringTransactionModel) _then;

/// Create a copy of RecurringTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? endDate = freezed,}) {
  return _then(_RecurringTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

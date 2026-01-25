// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncomeModel {

@JsonKey(name: '\$id') String get id; String get userId; double get amount; String get categoryId; String get source;// e.g., "Salary", "Freelance", "Gift"
 DateTime get date; bool get isRecurring; String? get note;
/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeModelCopyWith<IncomeModel> get copyWith => _$IncomeModelCopyWithImpl<IncomeModel>(this as IncomeModel, _$identity);

  /// Serializes this IncomeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.source, source) || other.source == source)&&(identical(other.date, date) || other.date == date)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,categoryId,source,date,isRecurring,note);

@override
String toString() {
  return 'IncomeModel(id: $id, userId: $userId, amount: $amount, categoryId: $categoryId, source: $source, date: $date, isRecurring: $isRecurring, note: $note)';
}


}

/// @nodoc
abstract mixin class $IncomeModelCopyWith<$Res>  {
  factory $IncomeModelCopyWith(IncomeModel value, $Res Function(IncomeModel) _then) = _$IncomeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, double amount, String categoryId, String source, DateTime date, bool isRecurring, String? note
});




}
/// @nodoc
class _$IncomeModelCopyWithImpl<$Res>
    implements $IncomeModelCopyWith<$Res> {
  _$IncomeModelCopyWithImpl(this._self, this._then);

  final IncomeModel _self;
  final $Res Function(IncomeModel) _then;

/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? categoryId = null,Object? source = null,Object? date = null,Object? isRecurring = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomeModel].
extension IncomeModelPatterns on IncomeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeModel value)  $default,){
final _that = this;
switch (_that) {
case _IncomeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeModel value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  double amount,  String categoryId,  String source,  DateTime date,  bool isRecurring,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.categoryId,_that.source,_that.date,_that.isRecurring,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '\$id')  String id,  String userId,  double amount,  String categoryId,  String source,  DateTime date,  bool isRecurring,  String? note)  $default,) {final _that = this;
switch (_that) {
case _IncomeModel():
return $default(_that.id,_that.userId,_that.amount,_that.categoryId,_that.source,_that.date,_that.isRecurring,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '\$id')  String id,  String userId,  double amount,  String categoryId,  String source,  DateTime date,  bool isRecurring,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.categoryId,_that.source,_that.date,_that.isRecurring,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomeModel implements IncomeModel {
  const _IncomeModel({@JsonKey(name: '\$id') required this.id, required this.userId, required this.amount, required this.categoryId, required this.source, required this.date, this.isRecurring = false, this.note});
  factory _IncomeModel.fromJson(Map<String, dynamic> json) => _$IncomeModelFromJson(json);

@override@JsonKey(name: '\$id') final  String id;
@override final  String userId;
@override final  double amount;
@override final  String categoryId;
@override final  String source;
// e.g., "Salary", "Freelance", "Gift"
@override final  DateTime date;
@override@JsonKey() final  bool isRecurring;
@override final  String? note;

/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeModelCopyWith<_IncomeModel> get copyWith => __$IncomeModelCopyWithImpl<_IncomeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.source, source) || other.source == source)&&(identical(other.date, date) || other.date == date)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,categoryId,source,date,isRecurring,note);

@override
String toString() {
  return 'IncomeModel(id: $id, userId: $userId, amount: $amount, categoryId: $categoryId, source: $source, date: $date, isRecurring: $isRecurring, note: $note)';
}


}

/// @nodoc
abstract mixin class _$IncomeModelCopyWith<$Res> implements $IncomeModelCopyWith<$Res> {
  factory _$IncomeModelCopyWith(_IncomeModel value, $Res Function(_IncomeModel) _then) = __$IncomeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$id') String id, String userId, double amount, String categoryId, String source, DateTime date, bool isRecurring, String? note
});




}
/// @nodoc
class __$IncomeModelCopyWithImpl<$Res>
    implements _$IncomeModelCopyWith<$Res> {
  __$IncomeModelCopyWithImpl(this._self, this._then);

  final _IncomeModel _self;
  final $Res Function(_IncomeModel) _then;

/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? categoryId = null,Object? source = null,Object? date = null,Object? isRecurring = null,Object? note = freezed,}) {
  return _then(_IncomeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

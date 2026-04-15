// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SummaryModel {

 double get totalIncome; double get totalExpense; double get balance; Map<String, double> get incomesByCategory; Map<String, double> get expensesByCategory;
/// Create a copy of SummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryModelCopyWith<SummaryModel> get copyWith => _$SummaryModelCopyWithImpl<SummaryModel>(this as SummaryModel, _$identity);

  /// Serializes this SummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.incomesByCategory, incomesByCategory)&&const DeepCollectionEquality().equals(other.expensesByCategory, expensesByCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,balance,const DeepCollectionEquality().hash(incomesByCategory),const DeepCollectionEquality().hash(expensesByCategory));

@override
String toString() {
  return 'SummaryModel(totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance, incomesByCategory: $incomesByCategory, expensesByCategory: $expensesByCategory)';
}


}

/// @nodoc
abstract mixin class $SummaryModelCopyWith<$Res>  {
  factory $SummaryModelCopyWith(SummaryModel value, $Res Function(SummaryModel) _then) = _$SummaryModelCopyWithImpl;
@useResult
$Res call({
 double totalIncome, double totalExpense, double balance, Map<String, double> incomesByCategory, Map<String, double> expensesByCategory
});




}
/// @nodoc
class _$SummaryModelCopyWithImpl<$Res>
    implements $SummaryModelCopyWith<$Res> {
  _$SummaryModelCopyWithImpl(this._self, this._then);

  final SummaryModel _self;
  final $Res Function(SummaryModel) _then;

/// Create a copy of SummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? balance = null,Object? incomesByCategory = null,Object? expensesByCategory = null,}) {
  return _then(_self.copyWith(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,incomesByCategory: null == incomesByCategory ? _self.incomesByCategory : incomesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,expensesByCategory: null == expensesByCategory ? _self.expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [SummaryModel].
extension SummaryModelPatterns on SummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _SummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double balance,  Map<String, double> incomesByCategory,  Map<String, double> expensesByCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryModel() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.incomesByCategory,_that.expensesByCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double balance,  Map<String, double> incomesByCategory,  Map<String, double> expensesByCategory)  $default,) {final _that = this;
switch (_that) {
case _SummaryModel():
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.incomesByCategory,_that.expensesByCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalIncome,  double totalExpense,  double balance,  Map<String, double> incomesByCategory,  Map<String, double> expensesByCategory)?  $default,) {final _that = this;
switch (_that) {
case _SummaryModel() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.balance,_that.incomesByCategory,_that.expensesByCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SummaryModel implements SummaryModel {
  const _SummaryModel({this.totalIncome = 0.0, this.totalExpense = 0.0, this.balance = 0.0, final  Map<String, double> incomesByCategory = const {}, final  Map<String, double> expensesByCategory = const {}}): _incomesByCategory = incomesByCategory,_expensesByCategory = expensesByCategory;
  factory _SummaryModel.fromJson(Map<String, dynamic> json) => _$SummaryModelFromJson(json);

@override@JsonKey() final  double totalIncome;
@override@JsonKey() final  double totalExpense;
@override@JsonKey() final  double balance;
 final  Map<String, double> _incomesByCategory;
@override@JsonKey() Map<String, double> get incomesByCategory {
  if (_incomesByCategory is EqualUnmodifiableMapView) return _incomesByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_incomesByCategory);
}

 final  Map<String, double> _expensesByCategory;
@override@JsonKey() Map<String, double> get expensesByCategory {
  if (_expensesByCategory is EqualUnmodifiableMapView) return _expensesByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_expensesByCategory);
}


/// Create a copy of SummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryModelCopyWith<_SummaryModel> get copyWith => __$SummaryModelCopyWithImpl<_SummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._incomesByCategory, _incomesByCategory)&&const DeepCollectionEquality().equals(other._expensesByCategory, _expensesByCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,balance,const DeepCollectionEquality().hash(_incomesByCategory),const DeepCollectionEquality().hash(_expensesByCategory));

@override
String toString() {
  return 'SummaryModel(totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance, incomesByCategory: $incomesByCategory, expensesByCategory: $expensesByCategory)';
}


}

/// @nodoc
abstract mixin class _$SummaryModelCopyWith<$Res> implements $SummaryModelCopyWith<$Res> {
  factory _$SummaryModelCopyWith(_SummaryModel value, $Res Function(_SummaryModel) _then) = __$SummaryModelCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, double totalExpense, double balance, Map<String, double> incomesByCategory, Map<String, double> expensesByCategory
});




}
/// @nodoc
class __$SummaryModelCopyWithImpl<$Res>
    implements _$SummaryModelCopyWith<$Res> {
  __$SummaryModelCopyWithImpl(this._self, this._then);

  final _SummaryModel _self;
  final $Res Function(_SummaryModel) _then;

/// Create a copy of SummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? balance = null,Object? incomesByCategory = null,Object? expensesByCategory = null,}) {
  return _then(_SummaryModel(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,incomesByCategory: null == incomesByCategory ? _self._incomesByCategory : incomesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,expensesByCategory: null == expensesByCategory ? _self._expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on

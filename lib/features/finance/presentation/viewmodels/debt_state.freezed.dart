// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DebtState {

 List<DebtModel> get debts; bool get isLoading; String? get errorMessage;
/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtStateCopyWith<DebtState> get copyWith => _$DebtStateCopyWithImpl<DebtState>(this as DebtState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtState&&const DeepCollectionEquality().equals(other.debts, debts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(debts),isLoading,errorMessage);

@override
String toString() {
  return 'DebtState(debts: $debts, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DebtStateCopyWith<$Res>  {
  factory $DebtStateCopyWith(DebtState value, $Res Function(DebtState) _then) = _$DebtStateCopyWithImpl;
@useResult
$Res call({
 List<DebtModel> debts, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$DebtStateCopyWithImpl<$Res>
    implements $DebtStateCopyWith<$Res> {
  _$DebtStateCopyWithImpl(this._self, this._then);

  final DebtState _self;
  final $Res Function(DebtState) _then;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debts = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
debts: null == debts ? _self.debts : debts // ignore: cast_nullable_to_non_nullable
as List<DebtModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtState].
extension DebtStatePatterns on DebtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtState value)  $default,){
final _that = this;
switch (_that) {
case _DebtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtState value)?  $default,){
final _that = this;
switch (_that) {
case _DebtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DebtModel> debts,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtState() when $default != null:
return $default(_that.debts,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DebtModel> debts,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DebtState():
return $default(_that.debts,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DebtModel> debts,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DebtState() when $default != null:
return $default(_that.debts,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DebtState implements DebtState {
  const _DebtState({final  List<DebtModel> debts = const [], this.isLoading = false, this.errorMessage}): _debts = debts;
  

 final  List<DebtModel> _debts;
@override@JsonKey() List<DebtModel> get debts {
  if (_debts is EqualUnmodifiableListView) return _debts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debts);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtStateCopyWith<_DebtState> get copyWith => __$DebtStateCopyWithImpl<_DebtState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtState&&const DeepCollectionEquality().equals(other._debts, _debts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_debts),isLoading,errorMessage);

@override
String toString() {
  return 'DebtState(debts: $debts, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DebtStateCopyWith<$Res> implements $DebtStateCopyWith<$Res> {
  factory _$DebtStateCopyWith(_DebtState value, $Res Function(_DebtState) _then) = __$DebtStateCopyWithImpl;
@override @useResult
$Res call({
 List<DebtModel> debts, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$DebtStateCopyWithImpl<$Res>
    implements _$DebtStateCopyWith<$Res> {
  __$DebtStateCopyWithImpl(this._self, this._then);

  final _DebtState _self;
  final $Res Function(_DebtState) _then;

/// Create a copy of DebtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debts = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_DebtState(
debts: null == debts ? _self._debts : debts // ignore: cast_nullable_to_non_nullable
as List<DebtModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

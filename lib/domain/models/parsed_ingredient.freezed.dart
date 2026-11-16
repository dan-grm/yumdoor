// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsedIngredient {

/// The line as typed.
 String get originalText;/// The food, `null` for a line that couldn't be parsed; its text is then
/// in [note].
 NamedRef? get food;/// `null` for a line without a unit ("2 Eier").
 NamedRef? get unit;/// 0 for a line without an amount ("Salz, nach Geschmack").
 double get amount;/// What follows the food after a comma or in brackets ("geschält").
 String get note;
/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedIngredientCopyWith<ParsedIngredient> get copyWith => _$ParsedIngredientCopyWithImpl<ParsedIngredient>(this as ParsedIngredient, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ParsedIngredient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedIngredient&&(identical(other.originalText, _this.originalText) || other.originalText == _this.originalText)&&(identical(other.food, _this.food) || other.food == _this.food)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as ParsedIngredient;
  return Object.hash(runtimeType,_this.originalText,_this.food,_this.unit,_this.amount,_this.note);
}

@override
String toString() {
  final _this = this as ParsedIngredient;
  return 'ParsedIngredient(originalText: ${_this.originalText}, food: ${_this.food}, unit: ${_this.unit}, amount: ${_this.amount}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $ParsedIngredientCopyWith<$Res>  {
  factory $ParsedIngredientCopyWith(ParsedIngredient value, $Res Function(ParsedIngredient) _then) = _$ParsedIngredientCopyWithImpl;
@useResult
$Res call({
 String originalText, NamedRef? food, NamedRef? unit, double amount, String note
});


$NamedRefCopyWith<$Res>? get food;$NamedRefCopyWith<$Res>? get unit;

}
/// @nodoc
class _$ParsedIngredientCopyWithImpl<$Res>
    implements $ParsedIngredientCopyWith<$Res> {
  _$ParsedIngredientCopyWithImpl(this._self, this._then);

  final ParsedIngredient _self;
  final $Res Function(ParsedIngredient) _then;

/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalText = null,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? note = null,}) {
  return _then(ParsedIngredient(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as NamedRef?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as NamedRef?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParsedIngredient].
extension ParsedIngredientPatterns on ParsedIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedIngredient value)  $default,){
final _that = this;
switch (_that) {
case _ParsedIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalText,  NamedRef? food,  NamedRef? unit,  double amount,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsedIngredient() when $default != null:
return $default(_that.originalText,_that.food,_that.unit,_that.amount,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalText,  NamedRef? food,  NamedRef? unit,  double amount,  String note)  $default,) {final _that = this;
switch (_that) {
case _ParsedIngredient():
return $default(_that.originalText,_that.food,_that.unit,_that.amount,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalText,  NamedRef? food,  NamedRef? unit,  double amount,  String note)?  $default,) {final _that = this;
switch (_that) {
case _ParsedIngredient() when $default != null:
return $default(_that.originalText,_that.food,_that.unit,_that.amount,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _ParsedIngredient extends ParsedIngredient {
  const _ParsedIngredient({required this.originalText, this.food, this.unit, this.amount = 0, this.note = ''}): super._();
  

/// The line as typed.
@override final  String originalText;
/// The food, `null` for a line that couldn't be parsed; its text is then
/// in [note].
@override final  NamedRef? food;
/// `null` for a line without a unit ("2 Eier").
@override final  NamedRef? unit;
/// 0 for a line without an amount ("Salz, nach Geschmack").
@override@JsonKey() final  double amount;
/// What follows the food after a comma or in brackets ("geschält").
@override@JsonKey() final  String note;

/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedIngredientCopyWith<_ParsedIngredient> get copyWith => __$ParsedIngredientCopyWithImpl<_ParsedIngredient>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedIngredient&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.food, food) || other.food == food)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,originalText,food,unit,amount,note);
}

@override
String toString() {
    return 'ParsedIngredient(originalText: $originalText, food: $food, unit: $unit, amount: $amount, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ParsedIngredientCopyWith<$Res> implements $ParsedIngredientCopyWith<$Res> {
  factory _$ParsedIngredientCopyWith(_ParsedIngredient value, $Res Function(_ParsedIngredient) _then) = __$ParsedIngredientCopyWithImpl;
@override @useResult
$Res call({
 String originalText, NamedRef? food, NamedRef? unit, double amount, String note
});


@override $NamedRefCopyWith<$Res>? get food;@override $NamedRefCopyWith<$Res>? get unit;

}
/// @nodoc
class __$ParsedIngredientCopyWithImpl<$Res>
    implements _$ParsedIngredientCopyWith<$Res> {
  __$ParsedIngredientCopyWithImpl(this._self, this._then);

  final _ParsedIngredient _self;
  final $Res Function(_ParsedIngredient) _then;

/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalText = null,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? note = null,}) {
  return _then(_ParsedIngredient(
originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as NamedRef?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as NamedRef?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of ParsedIngredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on

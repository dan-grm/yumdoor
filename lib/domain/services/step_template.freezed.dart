// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StepTextPart {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StepTextPart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StepTextPart()';
}


}

/// @nodoc
class $StepTextPartCopyWith<$Res>  {
$StepTextPartCopyWith(StepTextPart _, $Res Function(StepTextPart) __);
}


/// Adds pattern-matching-related methods to [StepTextPart].
extension StepTextPartPatterns on StepTextPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StepText value)?  text,TResult Function( StepIngredient value)?  ingredient,TResult Function( StepAmount value)?  amount,TResult Function( StepValue value)?  value,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StepText() when text != null:
return text(_that);case StepIngredient() when ingredient != null:
return ingredient(_that);case StepAmount() when amount != null:
return amount(_that);case StepValue() when value != null:
return value(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StepText value)  text,required TResult Function( StepIngredient value)  ingredient,required TResult Function( StepAmount value)  amount,required TResult Function( StepValue value)  value,}){
final _that = this;
switch (_that) {
case StepText():
return text(_that);case StepIngredient():
return ingredient(_that);case StepAmount():
return amount(_that);case StepValue():
return value(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StepText value)?  text,TResult? Function( StepIngredient value)?  ingredient,TResult? Function( StepAmount value)?  amount,TResult? Function( StepValue value)?  value,}){
final _that = this;
switch (_that) {
case StepText() when text != null:
return text(_that);case StepIngredient() when ingredient != null:
return ingredient(_that);case StepAmount() when amount != null:
return amount(_that);case StepValue() when value != null:
return value(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( Quantity? amount,  String unit,  String food)?  ingredient,TResult Function( Quantity? quantity)?  amount,TResult Function( String text)?  value,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StepText() when text != null:
return text(_that.text);case StepIngredient() when ingredient != null:
return ingredient(_that.amount,_that.unit,_that.food);case StepAmount() when amount != null:
return amount(_that.quantity);case StepValue() when value != null:
return value(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( Quantity? amount,  String unit,  String food)  ingredient,required TResult Function( Quantity? quantity)  amount,required TResult Function( String text)  value,}) {final _that = this;
switch (_that) {
case StepText():
return text(_that.text);case StepIngredient():
return ingredient(_that.amount,_that.unit,_that.food);case StepAmount():
return amount(_that.quantity);case StepValue():
return value(_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( Quantity? amount,  String unit,  String food)?  ingredient,TResult? Function( Quantity? quantity)?  amount,TResult? Function( String text)?  value,}) {final _that = this;
switch (_that) {
case StepText() when text != null:
return text(_that.text);case StepIngredient() when ingredient != null:
return ingredient(_that.amount,_that.unit,_that.food);case StepAmount() when amount != null:
return amount(_that.quantity);case StepValue() when value != null:
return value(_that.text);case _:
  return null;

}
}

}

/// @nodoc


class StepText implements StepTextPart {
  const StepText(this.text);
  

 final  String text;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepTextCopyWith<StepText> get copyWith => _$StepTextCopyWithImpl<StepText>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StepText&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'StepTextPart.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $StepTextCopyWith<$Res> implements $StepTextPartCopyWith<$Res> {
  factory $StepTextCopyWith(StepText value, $Res Function(StepText) _then) = _$StepTextCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$StepTextCopyWithImpl<$Res>
    implements $StepTextCopyWith<$Res> {
  _$StepTextCopyWithImpl(this._self, this._then);

  final StepText _self;
  final $Res Function(StepText) _then;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(StepText(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StepIngredient implements StepTextPart {
  const StepIngredient({this.amount, required this.unit, required this.food});
  

 final  Quantity? amount;
 final  String unit;
 final  String food;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepIngredientCopyWith<StepIngredient> get copyWith => _$StepIngredientCopyWithImpl<StepIngredient>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StepIngredient&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.food, food) || other.food == food));
}


@override
int get hashCode {
    return Object.hash(runtimeType,amount,unit,food);
}

@override
String toString() {
    return 'StepTextPart.ingredient(amount: $amount, unit: $unit, food: $food)';
}


}

/// @nodoc
abstract mixin class $StepIngredientCopyWith<$Res> implements $StepTextPartCopyWith<$Res> {
  factory $StepIngredientCopyWith(StepIngredient value, $Res Function(StepIngredient) _then) = _$StepIngredientCopyWithImpl;
@useResult
$Res call({
 Quantity? amount, String unit, String food
});




}
/// @nodoc
class _$StepIngredientCopyWithImpl<$Res>
    implements $StepIngredientCopyWith<$Res> {
  _$StepIngredientCopyWithImpl(this._self, this._then);

  final StepIngredient _self;
  final $Res Function(StepIngredient) _then;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = freezed,Object? unit = null,Object? food = null,}) {
  return _then(StepIngredient(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Quantity?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,food: null == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StepAmount implements StepTextPart {
  const StepAmount(this.quantity);
  

 final  Quantity? quantity;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepAmountCopyWith<StepAmount> get copyWith => _$StepAmountCopyWithImpl<StepAmount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StepAmount&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,quantity);
}

@override
String toString() {
    return 'StepTextPart.amount(quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $StepAmountCopyWith<$Res> implements $StepTextPartCopyWith<$Res> {
  factory $StepAmountCopyWith(StepAmount value, $Res Function(StepAmount) _then) = _$StepAmountCopyWithImpl;
@useResult
$Res call({
 Quantity? quantity
});




}
/// @nodoc
class _$StepAmountCopyWithImpl<$Res>
    implements $StepAmountCopyWith<$Res> {
  _$StepAmountCopyWithImpl(this._self, this._then);

  final StepAmount _self;
  final $Res Function(StepAmount) _then;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? quantity = freezed,}) {
  return _then(StepAmount(
freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity?,
  ));
}


}

/// @nodoc


class StepValue implements StepTextPart {
  const StepValue(this.text);
  

 final  String text;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepValueCopyWith<StepValue> get copyWith => _$StepValueCopyWithImpl<StepValue>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StepValue&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'StepTextPart.value(text: $text)';
}


}

/// @nodoc
abstract mixin class $StepValueCopyWith<$Res> implements $StepTextPartCopyWith<$Res> {
  factory $StepValueCopyWith(StepValue value, $Res Function(StepValue) _then) = _$StepValueCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$StepValueCopyWithImpl<$Res>
    implements $StepValueCopyWith<$Res> {
  _$StepValueCopyWithImpl(this._self, this._then);

  final StepValue _self;
  final $Res Function(StepValue) _then;

/// Create a copy of StepTextPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(StepValue(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

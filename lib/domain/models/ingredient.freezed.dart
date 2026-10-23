// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Ingredient {

 int get id; Food? get food; Unit? get unit;/// For `Recipe.servings`; scale it for other servings. Meaningless if
/// [noAmount] is set.
 double get amount;/// "Salz und Pfeffer": shown without an amount, never scaled.
 bool get noAmount;/// A heading inside the list ("Für den Teig"); its text is in [note].
 bool get isHeader; String get note;/// The line as originally imported, if Tandoor parsed it from text.
 String? get originalText; int get order;
/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientCopyWith<Ingredient> get copyWith => _$IngredientCopyWithImpl<Ingredient>(this as Ingredient, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Ingredient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ingredient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.food, _this.food) || other.food == _this.food)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.noAmount, _this.noAmount) || other.noAmount == _this.noAmount)&&(identical(other.isHeader, _this.isHeader) || other.isHeader == _this.isHeader)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.originalText, _this.originalText) || other.originalText == _this.originalText)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as Ingredient;
  return Object.hash(runtimeType,_this.id,_this.food,_this.unit,_this.amount,_this.noAmount,_this.isHeader,_this.note,_this.originalText,_this.order);
}

@override
String toString() {
  final _this = this as Ingredient;
  return 'Ingredient(id: ${_this.id}, food: ${_this.food}, unit: ${_this.unit}, amount: ${_this.amount}, noAmount: ${_this.noAmount}, isHeader: ${_this.isHeader}, note: ${_this.note}, originalText: ${_this.originalText}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $IngredientCopyWith<$Res>  {
  factory $IngredientCopyWith(Ingredient value, $Res Function(Ingredient) _then) = _$IngredientCopyWithImpl;
@useResult
$Res call({
 int id, Food? food, Unit? unit, double amount, bool noAmount, bool isHeader, String note, String? originalText, int order
});


$FoodCopyWith<$Res>? get food;$UnitCopyWith<$Res>? get unit;

}
/// @nodoc
class _$IngredientCopyWithImpl<$Res>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._self, this._then);

  final Ingredient _self;
  final $Res Function(Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? noAmount = null,Object? isHeader = null,Object? note = null,Object? originalText = freezed,Object? order = null,}) {
  return _then(Ingredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as Food?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,noAmount: null == noAmount ? _self.noAmount : noAmount // ignore: cast_nullable_to_non_nullable
as bool,isHeader: null == isHeader ? _self.isHeader : isHeader // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FoodCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $FoodCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [Ingredient].
extension IngredientPatterns on Ingredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ingredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ingredient value)  $default,){
final _that = this;
switch (_that) {
case _Ingredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ingredient value)?  $default,){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Food? food,  Unit? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Food? food,  Unit? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText,  int order)  $default,) {final _that = this;
switch (_that) {
case _Ingredient():
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Food? food,  Unit? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText,  int order)?  $default,) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _Ingredient implements Ingredient {
  const _Ingredient({required this.id, this.food, this.unit, this.amount = 0, this.noAmount = false, this.isHeader = false, this.note = '', this.originalText, this.order = 0});
  

@override final  int id;
@override final  Food? food;
@override final  Unit? unit;
/// For `Recipe.servings`; scale it for other servings. Meaningless if
/// [noAmount] is set.
@override@JsonKey() final  double amount;
/// "Salz und Pfeffer": shown without an amount, never scaled.
@override@JsonKey() final  bool noAmount;
/// A heading inside the list ("Für den Teig"); its text is in [note].
@override@JsonKey() final  bool isHeader;
@override@JsonKey() final  String note;
/// The line as originally imported, if Tandoor parsed it from text.
@override final  String? originalText;
@override@JsonKey() final  int order;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientCopyWith<_Ingredient> get copyWith => __$IngredientCopyWithImpl<_Ingredient>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ingredient&&(identical(other.id, id) || other.id == id)&&(identical(other.food, food) || other.food == food)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.noAmount, noAmount) || other.noAmount == noAmount)&&(identical(other.isHeader, isHeader) || other.isHeader == isHeader)&&(identical(other.note, note) || other.note == note)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,food,unit,amount,noAmount,isHeader,note,originalText,order);
}

@override
String toString() {
    return 'Ingredient(id: $id, food: $food, unit: $unit, amount: $amount, noAmount: $noAmount, isHeader: $isHeader, note: $note, originalText: $originalText, order: $order)';
}


}

/// @nodoc
abstract mixin class _$IngredientCopyWith<$Res> implements $IngredientCopyWith<$Res> {
  factory _$IngredientCopyWith(_Ingredient value, $Res Function(_Ingredient) _then) = __$IngredientCopyWithImpl;
@override @useResult
$Res call({
 int id, Food? food, Unit? unit, double amount, bool noAmount, bool isHeader, String note, String? originalText, int order
});


@override $FoodCopyWith<$Res>? get food;@override $UnitCopyWith<$Res>? get unit;

}
/// @nodoc
class __$IngredientCopyWithImpl<$Res>
    implements _$IngredientCopyWith<$Res> {
  __$IngredientCopyWithImpl(this._self, this._then);

  final _Ingredient _self;
  final $Res Function(_Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? noAmount = null,Object? isHeader = null,Object? note = null,Object? originalText = freezed,Object? order = null,}) {
  return _then(_Ingredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as Food?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,noAmount: null == noAmount ? _self.noAmount : noAmount // ignore: cast_nullable_to_non_nullable
as bool,isHeader: null == isHeader ? _self.isHeader : isHeader // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FoodCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $FoodCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on

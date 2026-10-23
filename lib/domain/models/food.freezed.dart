// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Food {

 int get id; String get name; String? get pluralName;/// The parent in the food tree, `null` for a root.
 int? get parentId;/// Someone in the household has it at home.
 bool get onHand;/// Never goes on the shopping list (salt, water).
 bool get ignoreShopping;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Food;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pluralName, _this.pluralName) || other.pluralName == _this.pluralName)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.onHand, _this.onHand) || other.onHand == _this.onHand)&&(identical(other.ignoreShopping, _this.ignoreShopping) || other.ignoreShopping == _this.ignoreShopping));
}


@override
int get hashCode {
  final _this = this as Food;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pluralName,_this.parentId,_this.onHand,_this.ignoreShopping);
}

@override
String toString() {
  final _this = this as Food;
  return 'Food(id: ${_this.id}, name: ${_this.name}, pluralName: ${_this.pluralName}, parentId: ${_this.parentId}, onHand: ${_this.onHand}, ignoreShopping: ${_this.ignoreShopping})';
}


}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? pluralName, int? parentId, bool onHand, bool ignoreShopping
});




}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,Object? parentId = freezed,Object? onHand = null,Object? ignoreShopping = null,}) {
  return _then(Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as bool,ignoreShopping: null == ignoreShopping ? _self.ignoreShopping : ignoreShopping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName,  int? parentId,  bool onHand,  bool ignoreShopping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.pluralName,_that.parentId,_that.onHand,_that.ignoreShopping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName,  int? parentId,  bool onHand,  bool ignoreShopping)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.id,_that.name,_that.pluralName,_that.parentId,_that.onHand,_that.ignoreShopping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? pluralName,  int? parentId,  bool onHand,  bool ignoreShopping)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.pluralName,_that.parentId,_that.onHand,_that.ignoreShopping);case _:
  return null;

}
}

}

/// @nodoc


class _Food implements Food {
  const _Food({required this.id, required this.name, this.pluralName, this.parentId, this.onHand = false, this.ignoreShopping = false});
  

@override final  int id;
@override final  String name;
@override final  String? pluralName;
/// The parent in the food tree, `null` for a root.
@override final  int? parentId;
/// Someone in the household has it at home.
@override@JsonKey() final  bool onHand;
/// Never goes on the shopping list (salt, water).
@override@JsonKey() final  bool ignoreShopping;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pluralName, pluralName) || other.pluralName == pluralName)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.onHand, onHand) || other.onHand == onHand)&&(identical(other.ignoreShopping, ignoreShopping) || other.ignoreShopping == ignoreShopping));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pluralName,parentId,onHand,ignoreShopping);
}

@override
String toString() {
    return 'Food(id: $id, name: $name, pluralName: $pluralName, parentId: $parentId, onHand: $onHand, ignoreShopping: $ignoreShopping)';
}


}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? pluralName, int? parentId, bool onHand, bool ignoreShopping
});




}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,Object? parentId = freezed,Object? onHand = null,Object? ignoreShopping = null,}) {
  return _then(_Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as bool,ignoreShopping: null == ignoreShopping ? _self.ignoreShopping : ignoreShopping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

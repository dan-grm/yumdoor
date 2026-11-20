// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealType {

 int get id; String get name;/// Position among the meal types, lowest first. Several can share one.
 int get order;/// The color as `0xRRGGBB`, `null` if none is set.
 int? get color;/// When the meal usually is, as the time after midnight. `null` if not
/// set.
 Duration? get time;
/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealTypeCopyWith<MealType> get copyWith => _$MealTypeCopyWithImpl<MealType>(this as MealType, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MealType;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealType&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.time, _this.time) || other.time == _this.time));
}


@override
int get hashCode {
  final _this = this as MealType;
  return Object.hash(runtimeType,_this.id,_this.name,_this.order,_this.color,_this.time);
}

@override
String toString() {
  final _this = this as MealType;
  return 'MealType(id: ${_this.id}, name: ${_this.name}, order: ${_this.order}, color: ${_this.color}, time: ${_this.time})';
}


}

/// @nodoc
abstract mixin class $MealTypeCopyWith<$Res>  {
  factory $MealTypeCopyWith(MealType value, $Res Function(MealType) _then) = _$MealTypeCopyWithImpl;
@useResult
$Res call({
 int id, String name, int order, int? color, Duration? time
});




}
/// @nodoc
class _$MealTypeCopyWithImpl<$Res>
    implements $MealTypeCopyWith<$Res> {
  _$MealTypeCopyWithImpl(this._self, this._then);

  final MealType _self;
  final $Res Function(MealType) _then;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? color = freezed,Object? time = freezed,}) {
  return _then(MealType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealType].
extension MealTypePatterns on MealType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealType value)  $default,){
final _that = this;
switch (_that) {
case _MealType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealType value)?  $default,){
final _that = this;
switch (_that) {
case _MealType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int order,  int? color,  Duration? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealType() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.color,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int order,  int? color,  Duration? time)  $default,) {final _that = this;
switch (_that) {
case _MealType():
return $default(_that.id,_that.name,_that.order,_that.color,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int order,  int? color,  Duration? time)?  $default,) {final _that = this;
switch (_that) {
case _MealType() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.color,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _MealType implements MealType {
  const _MealType({required this.id, required this.name, this.order = 0, this.color, this.time});
  

@override final  int id;
@override final  String name;
/// Position among the meal types, lowest first. Several can share one.
@override@JsonKey() final  int order;
/// The color as `0xRRGGBB`, `null` if none is set.
@override final  int? color;
/// When the meal usually is, as the time after midnight. `null` if not
/// set.
@override final  Duration? time;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealTypeCopyWith<_MealType> get copyWith => __$MealTypeCopyWithImpl<_MealType>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.color, color) || other.color == color)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,order,color,time);
}

@override
String toString() {
    return 'MealType(id: $id, name: $name, order: $order, color: $color, time: $time)';
}


}

/// @nodoc
abstract mixin class _$MealTypeCopyWith<$Res> implements $MealTypeCopyWith<$Res> {
  factory _$MealTypeCopyWith(_MealType value, $Res Function(_MealType) _then) = __$MealTypeCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int order, int? color, Duration? time
});




}
/// @nodoc
class __$MealTypeCopyWithImpl<$Res>
    implements _$MealTypeCopyWith<$Res> {
  __$MealTypeCopyWithImpl(this._self, this._then);

  final _MealType _self;
  final $Res Function(_MealType) _then;

/// Create a copy of MealType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? color = freezed,Object? time = freezed,}) {
  return _then(_MealType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on

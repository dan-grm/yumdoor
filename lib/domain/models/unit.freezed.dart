// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Unit {

 int get id; String get name; String? get pluralName;
/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitCopyWith<Unit> get copyWith => _$UnitCopyWithImpl<Unit>(this as Unit, _$identity);

  /// Serializes this Unit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Unit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pluralName, _this.pluralName) || other.pluralName == _this.pluralName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Unit;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pluralName);
}

@override
String toString() {
  final _this = this as Unit;
  return 'Unit(id: ${_this.id}, name: ${_this.name}, pluralName: ${_this.pluralName})';
}


}

/// @nodoc
abstract mixin class $UnitCopyWith<$Res>  {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) _then) = _$UnitCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? pluralName
});




}
/// @nodoc
class _$UnitCopyWithImpl<$Res>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._self, this._then);

  final Unit _self;
  final $Res Function(Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,}) {
  return _then(Unit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Unit].
extension UnitPatterns on Unit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unit value)  $default,){
final _that = this;
switch (_that) {
case _Unit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unit value)?  $default,){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.name,_that.pluralName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName)  $default,) {final _that = this;
switch (_that) {
case _Unit():
return $default(_that.id,_that.name,_that.pluralName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? pluralName)?  $default,) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.name,_that.pluralName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Unit implements Unit {
  const _Unit({required this.id, required this.name, this.pluralName});
  factory _Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? pluralName;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitCopyWith<_Unit> get copyWith => __$UnitCopyWithImpl<_Unit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pluralName, pluralName) || other.pluralName == pluralName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pluralName);
}

@override
String toString() {
    return 'Unit(id: $id, name: $name, pluralName: $pluralName)';
}


}

/// @nodoc
abstract mixin class _$UnitCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$UnitCopyWith(_Unit value, $Res Function(_Unit) _then) = __$UnitCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? pluralName
});




}
/// @nodoc
class __$UnitCopyWithImpl<$Res>
    implements _$UnitCopyWith<$Res> {
  __$UnitCopyWithImpl(this._self, this._then);

  final _Unit _self;
  final $Res Function(_Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,}) {
  return _then(_Unit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

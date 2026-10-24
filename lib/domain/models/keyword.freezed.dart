// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyword.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Keyword {

 int get id; String get name;/// The parent in the keyword tree, `null` for a root or when unknown
/// (recipe summaries only carry id and name).
 int? get parentId;
/// Create a copy of Keyword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeywordCopyWith<Keyword> get copyWith => _$KeywordCopyWithImpl<Keyword>(this as Keyword, _$identity);

  /// Serializes this Keyword to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Keyword;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Keyword&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Keyword;
  return Object.hash(runtimeType,_this.id,_this.name,_this.parentId);
}

@override
String toString() {
  final _this = this as Keyword;
  return 'Keyword(id: ${_this.id}, name: ${_this.name}, parentId: ${_this.parentId})';
}


}

/// @nodoc
abstract mixin class $KeywordCopyWith<$Res>  {
  factory $KeywordCopyWith(Keyword value, $Res Function(Keyword) _then) = _$KeywordCopyWithImpl;
@useResult
$Res call({
 int id, String name, int? parentId
});




}
/// @nodoc
class _$KeywordCopyWithImpl<$Res>
    implements $KeywordCopyWith<$Res> {
  _$KeywordCopyWithImpl(this._self, this._then);

  final Keyword _self;
  final $Res Function(Keyword) _then;

/// Create a copy of Keyword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,}) {
  return _then(Keyword(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Keyword].
extension KeywordPatterns on Keyword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Keyword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Keyword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Keyword value)  $default,){
final _that = this;
switch (_that) {
case _Keyword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Keyword value)?  $default,){
final _that = this;
switch (_that) {
case _Keyword() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int? parentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Keyword() when $default != null:
return $default(_that.id,_that.name,_that.parentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int? parentId)  $default,) {final _that = this;
switch (_that) {
case _Keyword():
return $default(_that.id,_that.name,_that.parentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int? parentId)?  $default,) {final _that = this;
switch (_that) {
case _Keyword() when $default != null:
return $default(_that.id,_that.name,_that.parentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Keyword implements Keyword {
  const _Keyword({required this.id, required this.name, this.parentId});
  factory _Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);

@override final  int id;
@override final  String name;
/// The parent in the keyword tree, `null` for a root or when unknown
/// (recipe summaries only carry id and name).
@override final  int? parentId;

/// Create a copy of Keyword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeywordCopyWith<_Keyword> get copyWith => __$KeywordCopyWithImpl<_Keyword>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeywordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Keyword&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,parentId);
}

@override
String toString() {
    return 'Keyword(id: $id, name: $name, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$KeywordCopyWith<$Res> implements $KeywordCopyWith<$Res> {
  factory _$KeywordCopyWith(_Keyword value, $Res Function(_Keyword) _then) = __$KeywordCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int? parentId
});




}
/// @nodoc
class __$KeywordCopyWithImpl<$Res>
    implements _$KeywordCopyWith<$Res> {
  __$KeywordCopyWithImpl(this._self, this._then);

  final _Keyword _self;
  final $Res Function(_Keyword) _then;

/// Create a copy of Keyword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,}) {
  return _then(_Keyword(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

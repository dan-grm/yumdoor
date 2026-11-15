// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedFilter {

 int get id; String get name;/// The search as the search screen shows it: text and filter chips.
/// `null` if it uses parameters the chips can't show (made in Tandoor);
/// such a search is applied as [RecipeQuery.savedFilter].
 RecipeQuery? get query;/// Whether the current user created it. Only they can rename or delete
/// it; the others it is shared with can only use it.
 bool get own;
/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedFilterCopyWith<SavedFilter> get copyWith => _$SavedFilterCopyWithImpl<SavedFilter>(this as SavedFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedFilter&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.own, _this.own) || other.own == _this.own));
}


@override
int get hashCode {
  final _this = this as SavedFilter;
  return Object.hash(runtimeType,_this.id,_this.name,_this.query,_this.own);
}

@override
String toString() {
  final _this = this as SavedFilter;
  return 'SavedFilter(id: ${_this.id}, name: ${_this.name}, query: ${_this.query}, own: ${_this.own})';
}


}

/// @nodoc
abstract mixin class $SavedFilterCopyWith<$Res>  {
  factory $SavedFilterCopyWith(SavedFilter value, $Res Function(SavedFilter) _then) = _$SavedFilterCopyWithImpl;
@useResult
$Res call({
 int id, String name, RecipeQuery? query, bool own
});


$RecipeQueryCopyWith<$Res>? get query;

}
/// @nodoc
class _$SavedFilterCopyWithImpl<$Res>
    implements $SavedFilterCopyWith<$Res> {
  _$SavedFilterCopyWithImpl(this._self, this._then);

  final SavedFilter _self;
  final $Res Function(SavedFilter) _then;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? query = freezed,Object? own = null,}) {
  return _then(SavedFilter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as RecipeQuery?,own: null == own ? _self.own : own // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeQueryCopyWith<$Res>? get query {
    if (_self.query == null) {
    return null;
  }

  return $RecipeQueryCopyWith<$Res>(_self.query!, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedFilter].
extension SavedFilterPatterns on SavedFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedFilter value)  $default,){
final _that = this;
switch (_that) {
case _SavedFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  RecipeQuery? query,  bool own)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
return $default(_that.id,_that.name,_that.query,_that.own);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  RecipeQuery? query,  bool own)  $default,) {final _that = this;
switch (_that) {
case _SavedFilter():
return $default(_that.id,_that.name,_that.query,_that.own);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  RecipeQuery? query,  bool own)?  $default,) {final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
return $default(_that.id,_that.name,_that.query,_that.own);case _:
  return null;

}
}

}

/// @nodoc


class _SavedFilter extends SavedFilter {
  const _SavedFilter({required this.id, required this.name, this.query, this.own = true}): super._();
  

@override final  int id;
@override final  String name;
/// The search as the search screen shows it: text and filter chips.
/// `null` if it uses parameters the chips can't show (made in Tandoor);
/// such a search is applied as [RecipeQuery.savedFilter].
@override final  RecipeQuery? query;
/// Whether the current user created it. Only they can rename or delete
/// it; the others it is shared with can only use it.
@override@JsonKey() final  bool own;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedFilterCopyWith<_SavedFilter> get copyWith => __$SavedFilterCopyWithImpl<_SavedFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedFilter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.query, query) || other.query == query)&&(identical(other.own, own) || other.own == own));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,query,own);
}

@override
String toString() {
    return 'SavedFilter(id: $id, name: $name, query: $query, own: $own)';
}


}

/// @nodoc
abstract mixin class _$SavedFilterCopyWith<$Res> implements $SavedFilterCopyWith<$Res> {
  factory _$SavedFilterCopyWith(_SavedFilter value, $Res Function(_SavedFilter) _then) = __$SavedFilterCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, RecipeQuery? query, bool own
});


@override $RecipeQueryCopyWith<$Res>? get query;

}
/// @nodoc
class __$SavedFilterCopyWithImpl<$Res>
    implements _$SavedFilterCopyWith<$Res> {
  __$SavedFilterCopyWithImpl(this._self, this._then);

  final _SavedFilter _self;
  final $Res Function(_SavedFilter) _then;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? query = freezed,Object? own = null,}) {
  return _then(_SavedFilter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as RecipeQuery?,own: null == own ? _self.own : own // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeQueryCopyWith<$Res>? get query {
    if (_self.query == null) {
    return null;
  }

  return $RecipeQueryCopyWith<$Res>(_self.query!, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}

// dart format on

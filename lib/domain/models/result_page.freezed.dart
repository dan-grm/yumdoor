// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultPage<T> {

 List<T> get items;/// The number of results over all pages.
 int get totalCount;/// Whether there is a next page. Requesting a page past the end fails.
 bool get hasMore;
/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultPageCopyWith<T, ResultPage<T>> get copyWith => _$ResultPageCopyWithImpl<T, ResultPage<T>>(this as ResultPage<T>, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResultPage<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultPage<T>&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore));
}


@override
int get hashCode {
  final _this = this as ResultPage<T>;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.totalCount,_this.hasMore);
}

@override
String toString() {
  final _this = this as ResultPage<T>;
  return 'ResultPage<$T>(items: ${_this.items}, totalCount: ${_this.totalCount}, hasMore: ${_this.hasMore})';
}


}

/// @nodoc
abstract mixin class $ResultPageCopyWith<T,$Res>  {
  factory $ResultPageCopyWith(ResultPage<T> value, $Res Function(ResultPage<T>) _then) = _$ResultPageCopyWithImpl;
@useResult
$Res call({
 List<T> items, int totalCount, bool hasMore
});




}
/// @nodoc
class _$ResultPageCopyWithImpl<T,$Res>
    implements $ResultPageCopyWith<T, $Res> {
  _$ResultPageCopyWithImpl(this._self, this._then);

  final ResultPage<T> _self;
  final $Res Function(ResultPage<T>) _then;

/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? totalCount = null,Object? hasMore = null,}) {
  return _then(ResultPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultPage].
extension ResultPagePatterns<T> on ResultPage<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultPage<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultPage<T> value)  $default,){
final _that = this;
switch (_that) {
case _ResultPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultPage<T> value)?  $default,){
final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  int totalCount,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
return $default(_that.items,_that.totalCount,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  int totalCount,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ResultPage():
return $default(_that.items,_that.totalCount,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  int totalCount,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
return $default(_that.items,_that.totalCount,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _ResultPage<T> implements ResultPage<T> {
  const _ResultPage({required  List<T> items, required this.totalCount, required this.hasMore}): _items = items;
  

 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// The number of results over all pages.
@override final  int totalCount;
/// Whether there is a next page. Requesting a page past the end fails.
@override final  bool hasMore;

/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultPageCopyWith<T, _ResultPage<T>> get copyWith => __$ResultPageCopyWithImpl<T, _ResultPage<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultPage<T>&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),totalCount,hasMore);
}

@override
String toString() {
    return 'ResultPage<$T>(items: $items, totalCount: $totalCount, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ResultPageCopyWith<T,$Res> implements $ResultPageCopyWith<T, $Res> {
  factory _$ResultPageCopyWith(_ResultPage<T> value, $Res Function(_ResultPage<T>) _then) = __$ResultPageCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, int totalCount, bool hasMore
});




}
/// @nodoc
class __$ResultPageCopyWithImpl<T,$Res>
    implements _$ResultPageCopyWith<T, $Res> {
  __$ResultPageCopyWithImpl(this._self, this._then);

  final _ResultPage<T> _self;
  final $Res Function(_ResultPage<T>) _then;

/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? totalCount = null,Object? hasMore = null,}) {
  return _then(_ResultPage<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecipeQuery {

/// Free text. Which fields it searches is the user's Tandoor search
/// preference; by default only recipe names.
 String get text;/// The recipe contains each of these foods, or one of its child foods.
 Set<int> get foodIds;/// The recipe has each of these keywords.
 Set<int> get keywordIds;/// The current user rated it at least this, 1 to 5. Tandoor only counts
/// the user's own cook logs.
 int? get minRating;/// The current user last cooked it on or before this day (the date part
/// counts). Tandoor only counts the user's own cook logs.
 DateTime? get lastCookedBefore;
/// Create a copy of RecipeQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeQueryCopyWith<RecipeQuery> get copyWith => _$RecipeQueryCopyWithImpl<RecipeQuery>(this as RecipeQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecipeQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeQuery&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.foodIds, _this.foodIds)&&const DeepCollectionEquality().equals(other.keywordIds, _this.keywordIds)&&(identical(other.minRating, _this.minRating) || other.minRating == _this.minRating)&&(identical(other.lastCookedBefore, _this.lastCookedBefore) || other.lastCookedBefore == _this.lastCookedBefore));
}


@override
int get hashCode {
  final _this = this as RecipeQuery;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.foodIds),const DeepCollectionEquality().hash(_this.keywordIds),_this.minRating,_this.lastCookedBefore);
}

@override
String toString() {
  final _this = this as RecipeQuery;
  return 'RecipeQuery(text: ${_this.text}, foodIds: ${_this.foodIds}, keywordIds: ${_this.keywordIds}, minRating: ${_this.minRating}, lastCookedBefore: ${_this.lastCookedBefore})';
}


}

/// @nodoc
abstract mixin class $RecipeQueryCopyWith<$Res>  {
  factory $RecipeQueryCopyWith(RecipeQuery value, $Res Function(RecipeQuery) _then) = _$RecipeQueryCopyWithImpl;
@useResult
$Res call({
 String text, Set<int> foodIds, Set<int> keywordIds, int? minRating, DateTime? lastCookedBefore
});




}
/// @nodoc
class _$RecipeQueryCopyWithImpl<$Res>
    implements $RecipeQueryCopyWith<$Res> {
  _$RecipeQueryCopyWithImpl(this._self, this._then);

  final RecipeQuery _self;
  final $Res Function(RecipeQuery) _then;

/// Create a copy of RecipeQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? foodIds = null,Object? keywordIds = null,Object? minRating = freezed,Object? lastCookedBefore = freezed,}) {
  return _then(RecipeQuery(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,foodIds: null == foodIds ? _self.foodIds : foodIds // ignore: cast_nullable_to_non_nullable
as Set<int>,keywordIds: null == keywordIds ? _self.keywordIds : keywordIds // ignore: cast_nullable_to_non_nullable
as Set<int>,minRating: freezed == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as int?,lastCookedBefore: freezed == lastCookedBefore ? _self.lastCookedBefore : lastCookedBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeQuery].
extension RecipeQueryPatterns on RecipeQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeQuery value)  $default,){
final _that = this;
switch (_that) {
case _RecipeQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeQuery value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  Set<int> foodIds,  Set<int> keywordIds,  int? minRating,  DateTime? lastCookedBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeQuery() when $default != null:
return $default(_that.text,_that.foodIds,_that.keywordIds,_that.minRating,_that.lastCookedBefore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  Set<int> foodIds,  Set<int> keywordIds,  int? minRating,  DateTime? lastCookedBefore)  $default,) {final _that = this;
switch (_that) {
case _RecipeQuery():
return $default(_that.text,_that.foodIds,_that.keywordIds,_that.minRating,_that.lastCookedBefore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  Set<int> foodIds,  Set<int> keywordIds,  int? minRating,  DateTime? lastCookedBefore)?  $default,) {final _that = this;
switch (_that) {
case _RecipeQuery() when $default != null:
return $default(_that.text,_that.foodIds,_that.keywordIds,_that.minRating,_that.lastCookedBefore);case _:
  return null;

}
}

}

/// @nodoc


class _RecipeQuery extends RecipeQuery {
  const _RecipeQuery({this.text = '',  Set<int> foodIds = const {},  Set<int> keywordIds = const {}, this.minRating, this.lastCookedBefore}): _foodIds = foodIds,_keywordIds = keywordIds,super._();
  

/// Free text. Which fields it searches is the user's Tandoor search
/// preference; by default only recipe names.
@override@JsonKey() final  String text;
/// The recipe contains each of these foods, or one of its child foods.
 final  Set<int> _foodIds;
/// The recipe contains each of these foods, or one of its child foods.
@override@JsonKey() Set<int> get foodIds {
  if (_foodIds is EqualUnmodifiableSetView) return _foodIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_foodIds);
}

/// The recipe has each of these keywords.
 final  Set<int> _keywordIds;
/// The recipe has each of these keywords.
@override@JsonKey() Set<int> get keywordIds {
  if (_keywordIds is EqualUnmodifiableSetView) return _keywordIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_keywordIds);
}

/// The current user rated it at least this, 1 to 5. Tandoor only counts
/// the user's own cook logs.
@override final  int? minRating;
/// The current user last cooked it on or before this day (the date part
/// counts). Tandoor only counts the user's own cook logs.
@override final  DateTime? lastCookedBefore;

/// Create a copy of RecipeQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeQueryCopyWith<_RecipeQuery> get copyWith => __$RecipeQueryCopyWithImpl<_RecipeQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeQuery&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.foodIds, _foodIds)&&const DeepCollectionEquality().equals(other.keywordIds, _keywordIds)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.lastCookedBefore, lastCookedBefore) || other.lastCookedBefore == lastCookedBefore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_foodIds),const DeepCollectionEquality().hash(_keywordIds),minRating,lastCookedBefore);
}

@override
String toString() {
    return 'RecipeQuery(text: $text, foodIds: $foodIds, keywordIds: $keywordIds, minRating: $minRating, lastCookedBefore: $lastCookedBefore)';
}


}

/// @nodoc
abstract mixin class _$RecipeQueryCopyWith<$Res> implements $RecipeQueryCopyWith<$Res> {
  factory _$RecipeQueryCopyWith(_RecipeQuery value, $Res Function(_RecipeQuery) _then) = __$RecipeQueryCopyWithImpl;
@override @useResult
$Res call({
 String text, Set<int> foodIds, Set<int> keywordIds, int? minRating, DateTime? lastCookedBefore
});




}
/// @nodoc
class __$RecipeQueryCopyWithImpl<$Res>
    implements _$RecipeQueryCopyWith<$Res> {
  __$RecipeQueryCopyWithImpl(this._self, this._then);

  final _RecipeQuery _self;
  final $Res Function(_RecipeQuery) _then;

/// Create a copy of RecipeQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? foodIds = null,Object? keywordIds = null,Object? minRating = freezed,Object? lastCookedBefore = freezed,}) {
  return _then(_RecipeQuery(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,foodIds: null == foodIds ? _self._foodIds : foodIds // ignore: cast_nullable_to_non_nullable
as Set<int>,keywordIds: null == keywordIds ? _self._keywordIds : keywordIds // ignore: cast_nullable_to_non_nullable
as Set<int>,minRating: freezed == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as int?,lastCookedBefore: freezed == lastCookedBefore ? _self.lastCookedBefore : lastCookedBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

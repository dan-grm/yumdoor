// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecipeMatch {

 RecipeSummary get recipe;/// It contains one of these foods, or a child food of one of them, and
/// they match the text. Server results don't say which one.
 List<Food> get foods;/// It has one of these keywords, or a child keyword of one of them, and
/// they match the text.
 List<Keyword> get keywords;
/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeMatchCopyWith<RecipeMatch> get copyWith => _$RecipeMatchCopyWithImpl<RecipeMatch>(this as RecipeMatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecipeMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeMatch&&(identical(other.recipe, _this.recipe) || other.recipe == _this.recipe)&&const DeepCollectionEquality().equals(other.foods, _this.foods)&&const DeepCollectionEquality().equals(other.keywords, _this.keywords));
}


@override
int get hashCode {
  final _this = this as RecipeMatch;
  return Object.hash(runtimeType,_this.recipe,const DeepCollectionEquality().hash(_this.foods),const DeepCollectionEquality().hash(_this.keywords));
}

@override
String toString() {
  final _this = this as RecipeMatch;
  return 'RecipeMatch(recipe: ${_this.recipe}, foods: ${_this.foods}, keywords: ${_this.keywords})';
}


}

/// @nodoc
abstract mixin class $RecipeMatchCopyWith<$Res>  {
  factory $RecipeMatchCopyWith(RecipeMatch value, $Res Function(RecipeMatch) _then) = _$RecipeMatchCopyWithImpl;
@useResult
$Res call({
 RecipeSummary recipe, List<Food> foods, List<Keyword> keywords
});


$RecipeSummaryCopyWith<$Res> get recipe;

}
/// @nodoc
class _$RecipeMatchCopyWithImpl<$Res>
    implements $RecipeMatchCopyWith<$Res> {
  _$RecipeMatchCopyWithImpl(this._self, this._then);

  final RecipeMatch _self;
  final $Res Function(RecipeMatch) _then;

/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipe = null,Object? foods = null,Object? keywords = null,}) {
  return _then(RecipeMatch(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary,foods: null == foods ? _self.foods : foods // ignore: cast_nullable_to_non_nullable
as List<Food>,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,
  ));
}
/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res> get recipe {
  
  return $RecipeSummaryCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecipeMatch].
extension RecipeMatchPatterns on RecipeMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeMatch value)  $default,){
final _that = this;
switch (_that) {
case _RecipeMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeMatch value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecipeSummary recipe,  List<Food> foods,  List<Keyword> keywords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeMatch() when $default != null:
return $default(_that.recipe,_that.foods,_that.keywords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecipeSummary recipe,  List<Food> foods,  List<Keyword> keywords)  $default,) {final _that = this;
switch (_that) {
case _RecipeMatch():
return $default(_that.recipe,_that.foods,_that.keywords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecipeSummary recipe,  List<Food> foods,  List<Keyword> keywords)?  $default,) {final _that = this;
switch (_that) {
case _RecipeMatch() when $default != null:
return $default(_that.recipe,_that.foods,_that.keywords);case _:
  return null;

}
}

}

/// @nodoc


class _RecipeMatch implements RecipeMatch {
  const _RecipeMatch({required this.recipe,  List<Food> foods = const [],  List<Keyword> keywords = const []}): _foods = foods,_keywords = keywords;
  

@override final  RecipeSummary recipe;
/// It contains one of these foods, or a child food of one of them, and
/// they match the text. Server results don't say which one.
 final  List<Food> _foods;
/// It contains one of these foods, or a child food of one of them, and
/// they match the text. Server results don't say which one.
@override@JsonKey() List<Food> get foods {
  if (_foods is EqualUnmodifiableListView) return _foods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foods);
}

/// It has one of these keywords, or a child keyword of one of them, and
/// they match the text.
 final  List<Keyword> _keywords;
/// It has one of these keywords, or a child keyword of one of them, and
/// they match the text.
@override@JsonKey() List<Keyword> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}


/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeMatchCopyWith<_RecipeMatch> get copyWith => __$RecipeMatchCopyWithImpl<_RecipeMatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeMatch&&(identical(other.recipe, recipe) || other.recipe == recipe)&&const DeepCollectionEquality().equals(other.foods, _foods)&&const DeepCollectionEquality().equals(other.keywords, _keywords));
}


@override
int get hashCode {
    return Object.hash(runtimeType,recipe,const DeepCollectionEquality().hash(_foods),const DeepCollectionEquality().hash(_keywords));
}

@override
String toString() {
    return 'RecipeMatch(recipe: $recipe, foods: $foods, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class _$RecipeMatchCopyWith<$Res> implements $RecipeMatchCopyWith<$Res> {
  factory _$RecipeMatchCopyWith(_RecipeMatch value, $Res Function(_RecipeMatch) _then) = __$RecipeMatchCopyWithImpl;
@override @useResult
$Res call({
 RecipeSummary recipe, List<Food> foods, List<Keyword> keywords
});


@override $RecipeSummaryCopyWith<$Res> get recipe;

}
/// @nodoc
class __$RecipeMatchCopyWithImpl<$Res>
    implements _$RecipeMatchCopyWith<$Res> {
  __$RecipeMatchCopyWithImpl(this._self, this._then);

  final _RecipeMatch _self;
  final $Res Function(_RecipeMatch) _then;

/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipe = null,Object? foods = null,Object? keywords = null,}) {
  return _then(_RecipeMatch(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary,foods: null == foods ? _self._foods : foods // ignore: cast_nullable_to_non_nullable
as List<Food>,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,
  ));
}

/// Create a copy of RecipeMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res> get recipe {
  
  return $RecipeSummaryCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}

// dart format on

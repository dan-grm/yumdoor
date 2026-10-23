// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Recipe {

 int get id; String get name; String get description; Uri? get image; List<Keyword> get keywords;/// The servings the ingredient amounts are for.
 int get servings;/// What a serving is ("Stück", "Gläser"), empty if not set.
 String get servingsText; Duration get workingTime; Duration get waitingTime; List<RecipeStep> get steps;/// Where the recipe was imported from, if anywhere.
 Uri? get sourceUrl;/// The current user's average rating from their own cook log, 0 to 5.
 double? get rating;/// When the current user last cooked it.
 DateTime? get lastCooked; UserRef? get createdBy; DateTime? get updatedAt;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Recipe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.image, _this.image) || other.image == _this.image)&&const DeepCollectionEquality().equals(other.keywords, _this.keywords)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.servingsText, _this.servingsText) || other.servingsText == _this.servingsText)&&(identical(other.workingTime, _this.workingTime) || other.workingTime == _this.workingTime)&&(identical(other.waitingTime, _this.waitingTime) || other.waitingTime == _this.waitingTime)&&const DeepCollectionEquality().equals(other.steps, _this.steps)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.lastCooked, _this.lastCooked) || other.lastCooked == _this.lastCooked)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Recipe;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.image,const DeepCollectionEquality().hash(_this.keywords),_this.servings,_this.servingsText,_this.workingTime,_this.waitingTime,const DeepCollectionEquality().hash(_this.steps),_this.sourceUrl,_this.rating,_this.lastCooked,_this.createdBy,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Recipe;
  return 'Recipe(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, image: ${_this.image}, keywords: ${_this.keywords}, servings: ${_this.servings}, servingsText: ${_this.servingsText}, workingTime: ${_this.workingTime}, waitingTime: ${_this.waitingTime}, steps: ${_this.steps}, sourceUrl: ${_this.sourceUrl}, rating: ${_this.rating}, lastCooked: ${_this.lastCooked}, createdBy: ${_this.createdBy}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, Uri? image, List<Keyword> keywords, int servings, String servingsText, Duration workingTime, Duration waitingTime, List<RecipeStep> steps, Uri? sourceUrl, double? rating, DateTime? lastCooked, UserRef? createdBy, DateTime? updatedAt
});


$UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? image = freezed,Object? keywords = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? steps = null,Object? sourceUrl = freezed,Object? rating = freezed,Object? lastCooked = freezed,Object? createdBy = freezed,Object? updatedAt = freezed,}) {
  return _then(Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uri?,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as Uri?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,lastCooked: freezed == lastCooked ? _self.lastCooked : lastCooked // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.createdBy!, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<RecipeStep> steps,  Uri? sourceUrl,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.steps,_that.sourceUrl,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<RecipeStep> steps,  Uri? sourceUrl,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.steps,_that.sourceUrl,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<RecipeStep> steps,  Uri? sourceUrl,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.steps,_that.sourceUrl,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Recipe implements Recipe {
  const _Recipe({required this.id, required this.name, this.description = '', this.image,  List<Keyword> keywords = const [], this.servings = 1, this.servingsText = '', this.workingTime = Duration.zero, this.waitingTime = Duration.zero,  List<RecipeStep> steps = const [], this.sourceUrl, this.rating, this.lastCooked, this.createdBy, this.updatedAt}): _keywords = keywords,_steps = steps;
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  Uri? image;
 final  List<Keyword> _keywords;
@override@JsonKey() List<Keyword> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}

/// The servings the ingredient amounts are for.
@override@JsonKey() final  int servings;
/// What a serving is ("Stück", "Gläser"), empty if not set.
@override@JsonKey() final  String servingsText;
@override@JsonKey() final  Duration workingTime;
@override@JsonKey() final  Duration waitingTime;
 final  List<RecipeStep> _steps;
@override@JsonKey() List<RecipeStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

/// Where the recipe was imported from, if anywhere.
@override final  Uri? sourceUrl;
/// The current user's average rating from their own cook log, 0 to 5.
@override final  double? rating;
/// When the current user last cooked it.
@override final  DateTime? lastCooked;
@override final  UserRef? createdBy;
@override final  DateTime? updatedAt;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.keywords, _keywords)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.servingsText, servingsText) || other.servingsText == servingsText)&&(identical(other.workingTime, workingTime) || other.workingTime == workingTime)&&(identical(other.waitingTime, waitingTime) || other.waitingTime == waitingTime)&&const DeepCollectionEquality().equals(other.steps, _steps)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.lastCooked, lastCooked) || other.lastCooked == lastCooked)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,image,const DeepCollectionEquality().hash(_keywords),servings,servingsText,workingTime,waitingTime,const DeepCollectionEquality().hash(_steps),sourceUrl,rating,lastCooked,createdBy,updatedAt);
}

@override
String toString() {
    return 'Recipe(id: $id, name: $name, description: $description, image: $image, keywords: $keywords, servings: $servings, servingsText: $servingsText, workingTime: $workingTime, waitingTime: $waitingTime, steps: $steps, sourceUrl: $sourceUrl, rating: $rating, lastCooked: $lastCooked, createdBy: $createdBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, Uri? image, List<Keyword> keywords, int servings, String servingsText, Duration workingTime, Duration waitingTime, List<RecipeStep> steps, Uri? sourceUrl, double? rating, DateTime? lastCooked, UserRef? createdBy, DateTime? updatedAt
});


@override $UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? image = freezed,Object? keywords = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? steps = null,Object? sourceUrl = freezed,Object? rating = freezed,Object? lastCooked = freezed,Object? createdBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uri?,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as Uri?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,lastCooked: freezed == lastCooked ? _self.lastCooked : lastCooked // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get createdBy {
    if (_self.createdBy == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.createdBy!, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}

// dart format on

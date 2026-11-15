// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeDraft {

 String get name; String get description; int get servings; String get servingsText;/// Whole minutes; seconds are dropped on save.
 Duration get workingTime; Duration get waitingTime; List<NamedRef> get keywords;/// See [Recipe.sourceUrl]; `null` for none.
 String? get sourceUrl; List<StepDraft> get steps;
/// Create a copy of RecipeDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeDraftCopyWith<RecipeDraft> get copyWith => _$RecipeDraftCopyWithImpl<RecipeDraft>(this as RecipeDraft, _$identity);

  /// Serializes this RecipeDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeDraft&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.servingsText, _this.servingsText) || other.servingsText == _this.servingsText)&&(identical(other.workingTime, _this.workingTime) || other.workingTime == _this.workingTime)&&(identical(other.waitingTime, _this.waitingTime) || other.waitingTime == _this.waitingTime)&&const DeepCollectionEquality().equals(other.keywords, _this.keywords)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&const DeepCollectionEquality().equals(other.steps, _this.steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeDraft;
  return Object.hash(runtimeType,_this.name,_this.description,_this.servings,_this.servingsText,_this.workingTime,_this.waitingTime,const DeepCollectionEquality().hash(_this.keywords),_this.sourceUrl,const DeepCollectionEquality().hash(_this.steps));
}

@override
String toString() {
  final _this = this as RecipeDraft;
  return 'RecipeDraft(name: ${_this.name}, description: ${_this.description}, servings: ${_this.servings}, servingsText: ${_this.servingsText}, workingTime: ${_this.workingTime}, waitingTime: ${_this.waitingTime}, keywords: ${_this.keywords}, sourceUrl: ${_this.sourceUrl}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $RecipeDraftCopyWith<$Res>  {
  factory $RecipeDraftCopyWith(RecipeDraft value, $Res Function(RecipeDraft) _then) = _$RecipeDraftCopyWithImpl;
@useResult
$Res call({
 String name, String description, int servings, String servingsText, Duration workingTime, Duration waitingTime, List<NamedRef> keywords, String? sourceUrl, List<StepDraft> steps
});




}
/// @nodoc
class _$RecipeDraftCopyWithImpl<$Res>
    implements $RecipeDraftCopyWith<$Res> {
  _$RecipeDraftCopyWithImpl(this._self, this._then);

  final RecipeDraft _self;
  final $Res Function(RecipeDraft) _then;

/// Create a copy of RecipeDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? keywords = null,Object? sourceUrl = freezed,Object? steps = null,}) {
  return _then(RecipeDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<NamedRef>,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<StepDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeDraft].
extension RecipeDraftPatterns on RecipeDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeDraft value)  $default,){
final _that = this;
switch (_that) {
case _RecipeDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<NamedRef> keywords,  String? sourceUrl,  List<StepDraft> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeDraft() when $default != null:
return $default(_that.name,_that.description,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.keywords,_that.sourceUrl,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<NamedRef> keywords,  String? sourceUrl,  List<StepDraft> steps)  $default,) {final _that = this;
switch (_that) {
case _RecipeDraft():
return $default(_that.name,_that.description,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.keywords,_that.sourceUrl,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  List<NamedRef> keywords,  String? sourceUrl,  List<StepDraft> steps)?  $default,) {final _that = this;
switch (_that) {
case _RecipeDraft() when $default != null:
return $default(_that.name,_that.description,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.keywords,_that.sourceUrl,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeDraft extends RecipeDraft {
  const _RecipeDraft({this.name = '', this.description = '', this.servings = 1, this.servingsText = '', this.workingTime = Duration.zero, this.waitingTime = Duration.zero,  List<NamedRef> keywords = const [], this.sourceUrl,  List<StepDraft> steps = const []}): _keywords = keywords,_steps = steps,super._();
  factory _RecipeDraft.fromJson(Map<String, dynamic> json) => _$RecipeDraftFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  int servings;
@override@JsonKey() final  String servingsText;
/// Whole minutes; seconds are dropped on save.
@override@JsonKey() final  Duration workingTime;
@override@JsonKey() final  Duration waitingTime;
 final  List<NamedRef> _keywords;
@override@JsonKey() List<NamedRef> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}

/// See [Recipe.sourceUrl]; `null` for none.
@override final  String? sourceUrl;
 final  List<StepDraft> _steps;
@override@JsonKey() List<StepDraft> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of RecipeDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeDraftCopyWith<_RecipeDraft> get copyWith => __$RecipeDraftCopyWithImpl<_RecipeDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.servingsText, servingsText) || other.servingsText == servingsText)&&(identical(other.workingTime, workingTime) || other.workingTime == workingTime)&&(identical(other.waitingTime, waitingTime) || other.waitingTime == waitingTime)&&const DeepCollectionEquality().equals(other.keywords, _keywords)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&const DeepCollectionEquality().equals(other.steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description,servings,servingsText,workingTime,waitingTime,const DeepCollectionEquality().hash(_keywords),sourceUrl,const DeepCollectionEquality().hash(_steps));
}

@override
String toString() {
    return 'RecipeDraft(name: $name, description: $description, servings: $servings, servingsText: $servingsText, workingTime: $workingTime, waitingTime: $waitingTime, keywords: $keywords, sourceUrl: $sourceUrl, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$RecipeDraftCopyWith<$Res> implements $RecipeDraftCopyWith<$Res> {
  factory _$RecipeDraftCopyWith(_RecipeDraft value, $Res Function(_RecipeDraft) _then) = __$RecipeDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, int servings, String servingsText, Duration workingTime, Duration waitingTime, List<NamedRef> keywords, String? sourceUrl, List<StepDraft> steps
});




}
/// @nodoc
class __$RecipeDraftCopyWithImpl<$Res>
    implements _$RecipeDraftCopyWith<$Res> {
  __$RecipeDraftCopyWithImpl(this._self, this._then);

  final _RecipeDraft _self;
  final $Res Function(_RecipeDraft) _then;

/// Create a copy of RecipeDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? keywords = null,Object? sourceUrl = freezed,Object? steps = null,}) {
  return _then(_RecipeDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<NamedRef>,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<StepDraft>,
  ));
}


}


/// @nodoc
mixin _$StepDraft {

 int? get id; String get name;/// Markdown, see [RecipeStep.instruction].
 String get instruction;/// An explicit duration, [Duration.zero] for none. Whole minutes.
 Duration get time; List<IngredientDraft> get ingredients;
/// Create a copy of StepDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepDraftCopyWith<StepDraft> get copyWith => _$StepDraftCopyWithImpl<StepDraft>(this as StepDraft, _$identity);

  /// Serializes this StepDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StepDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepDraft&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.instruction, _this.instruction) || other.instruction == _this.instruction)&&(identical(other.time, _this.time) || other.time == _this.time)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StepDraft;
  return Object.hash(runtimeType,_this.id,_this.name,_this.instruction,_this.time,const DeepCollectionEquality().hash(_this.ingredients));
}

@override
String toString() {
  final _this = this as StepDraft;
  return 'StepDraft(id: ${_this.id}, name: ${_this.name}, instruction: ${_this.instruction}, time: ${_this.time}, ingredients: ${_this.ingredients})';
}


}

/// @nodoc
abstract mixin class $StepDraftCopyWith<$Res>  {
  factory $StepDraftCopyWith(StepDraft value, $Res Function(StepDraft) _then) = _$StepDraftCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String instruction, Duration time, List<IngredientDraft> ingredients
});




}
/// @nodoc
class _$StepDraftCopyWithImpl<$Res>
    implements $StepDraftCopyWith<$Res> {
  _$StepDraftCopyWithImpl(this._self, this._then);

  final StepDraft _self;
  final $Res Function(StepDraft) _then;

/// Create a copy of StepDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? instruction = null,Object? time = null,Object? ingredients = null,}) {
  return _then(StepDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [StepDraft].
extension StepDraftPatterns on StepDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepDraft value)  $default,){
final _that = this;
switch (_that) {
case _StepDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepDraft value)?  $default,){
final _that = this;
switch (_that) {
case _StepDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String instruction,  Duration time,  List<IngredientDraft> ingredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepDraft() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.time,_that.ingredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String instruction,  Duration time,  List<IngredientDraft> ingredients)  $default,) {final _that = this;
switch (_that) {
case _StepDraft():
return $default(_that.id,_that.name,_that.instruction,_that.time,_that.ingredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String instruction,  Duration time,  List<IngredientDraft> ingredients)?  $default,) {final _that = this;
switch (_that) {
case _StepDraft() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.time,_that.ingredients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepDraft implements StepDraft {
  const _StepDraft({this.id, this.name = '', this.instruction = '', this.time = Duration.zero,  List<IngredientDraft> ingredients = const []}): _ingredients = ingredients;
  factory _StepDraft.fromJson(Map<String, dynamic> json) => _$StepDraftFromJson(json);

@override final  int? id;
@override@JsonKey() final  String name;
/// Markdown, see [RecipeStep.instruction].
@override@JsonKey() final  String instruction;
/// An explicit duration, [Duration.zero] for none. Whole minutes.
@override@JsonKey() final  Duration time;
 final  List<IngredientDraft> _ingredients;
@override@JsonKey() List<IngredientDraft> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}


/// Create a copy of StepDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepDraftCopyWith<_StepDraft> get copyWith => __$StepDraftCopyWithImpl<_StepDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,instruction,time,const DeepCollectionEquality().hash(_ingredients));
}

@override
String toString() {
    return 'StepDraft(id: $id, name: $name, instruction: $instruction, time: $time, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class _$StepDraftCopyWith<$Res> implements $StepDraftCopyWith<$Res> {
  factory _$StepDraftCopyWith(_StepDraft value, $Res Function(_StepDraft) _then) = __$StepDraftCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String instruction, Duration time, List<IngredientDraft> ingredients
});




}
/// @nodoc
class __$StepDraftCopyWithImpl<$Res>
    implements _$StepDraftCopyWith<$Res> {
  __$StepDraftCopyWithImpl(this._self, this._then);

  final _StepDraft _self;
  final $Res Function(_StepDraft) _then;

/// Create a copy of StepDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? instruction = null,Object? time = null,Object? ingredients = null,}) {
  return _then(_StepDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientDraft>,
  ));
}


}


/// @nodoc
mixin _$IngredientDraft {

 int? get id; NamedRef? get food; NamedRef? get unit;/// See [Ingredient.amount].
 double get amount; bool get noAmount;/// A heading inside the list; its text is in [note].
 bool get isHeader; String get note;/// The line as originally imported. Tandoor keeps it only when the
/// ingredient is created; later saves don't change it.
 String? get originalText;
/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientDraftCopyWith<IngredientDraft> get copyWith => _$IngredientDraftCopyWithImpl<IngredientDraft>(this as IngredientDraft, _$identity);

  /// Serializes this IngredientDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IngredientDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientDraft&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.food, _this.food) || other.food == _this.food)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.noAmount, _this.noAmount) || other.noAmount == _this.noAmount)&&(identical(other.isHeader, _this.isHeader) || other.isHeader == _this.isHeader)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.originalText, _this.originalText) || other.originalText == _this.originalText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IngredientDraft;
  return Object.hash(runtimeType,_this.id,_this.food,_this.unit,_this.amount,_this.noAmount,_this.isHeader,_this.note,_this.originalText);
}

@override
String toString() {
  final _this = this as IngredientDraft;
  return 'IngredientDraft(id: ${_this.id}, food: ${_this.food}, unit: ${_this.unit}, amount: ${_this.amount}, noAmount: ${_this.noAmount}, isHeader: ${_this.isHeader}, note: ${_this.note}, originalText: ${_this.originalText})';
}


}

/// @nodoc
abstract mixin class $IngredientDraftCopyWith<$Res>  {
  factory $IngredientDraftCopyWith(IngredientDraft value, $Res Function(IngredientDraft) _then) = _$IngredientDraftCopyWithImpl;
@useResult
$Res call({
 int? id, NamedRef? food, NamedRef? unit, double amount, bool noAmount, bool isHeader, String note, String? originalText
});


$NamedRefCopyWith<$Res>? get food;$NamedRefCopyWith<$Res>? get unit;

}
/// @nodoc
class _$IngredientDraftCopyWithImpl<$Res>
    implements $IngredientDraftCopyWith<$Res> {
  _$IngredientDraftCopyWithImpl(this._self, this._then);

  final IngredientDraft _self;
  final $Res Function(IngredientDraft) _then;

/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? noAmount = null,Object? isHeader = null,Object? note = null,Object? originalText = freezed,}) {
  return _then(IngredientDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as NamedRef?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as NamedRef?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,noAmount: null == noAmount ? _self.noAmount : noAmount // ignore: cast_nullable_to_non_nullable
as bool,isHeader: null == isHeader ? _self.isHeader : isHeader // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [IngredientDraft].
extension IngredientDraftPatterns on IngredientDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientDraft value)  $default,){
final _that = this;
switch (_that) {
case _IngredientDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientDraft value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  NamedRef? food,  NamedRef? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientDraft() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  NamedRef? food,  NamedRef? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText)  $default,) {final _that = this;
switch (_that) {
case _IngredientDraft():
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  NamedRef? food,  NamedRef? unit,  double amount,  bool noAmount,  bool isHeader,  String note,  String? originalText)?  $default,) {final _that = this;
switch (_that) {
case _IngredientDraft() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.noAmount,_that.isHeader,_that.note,_that.originalText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IngredientDraft implements IngredientDraft {
  const _IngredientDraft({this.id, this.food, this.unit, this.amount = 0, this.noAmount = false, this.isHeader = false, this.note = '', this.originalText});
  factory _IngredientDraft.fromJson(Map<String, dynamic> json) => _$IngredientDraftFromJson(json);

@override final  int? id;
@override final  NamedRef? food;
@override final  NamedRef? unit;
/// See [Ingredient.amount].
@override@JsonKey() final  double amount;
@override@JsonKey() final  bool noAmount;
/// A heading inside the list; its text is in [note].
@override@JsonKey() final  bool isHeader;
@override@JsonKey() final  String note;
/// The line as originally imported. Tandoor keeps it only when the
/// ingredient is created; later saves don't change it.
@override final  String? originalText;

/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientDraftCopyWith<_IngredientDraft> get copyWith => __$IngredientDraftCopyWithImpl<_IngredientDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.food, food) || other.food == food)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.noAmount, noAmount) || other.noAmount == noAmount)&&(identical(other.isHeader, isHeader) || other.isHeader == isHeader)&&(identical(other.note, note) || other.note == note)&&(identical(other.originalText, originalText) || other.originalText == originalText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,food,unit,amount,noAmount,isHeader,note,originalText);
}

@override
String toString() {
    return 'IngredientDraft(id: $id, food: $food, unit: $unit, amount: $amount, noAmount: $noAmount, isHeader: $isHeader, note: $note, originalText: $originalText)';
}


}

/// @nodoc
abstract mixin class _$IngredientDraftCopyWith<$Res> implements $IngredientDraftCopyWith<$Res> {
  factory _$IngredientDraftCopyWith(_IngredientDraft value, $Res Function(_IngredientDraft) _then) = __$IngredientDraftCopyWithImpl;
@override @useResult
$Res call({
 int? id, NamedRef? food, NamedRef? unit, double amount, bool noAmount, bool isHeader, String note, String? originalText
});


@override $NamedRefCopyWith<$Res>? get food;@override $NamedRefCopyWith<$Res>? get unit;

}
/// @nodoc
class __$IngredientDraftCopyWithImpl<$Res>
    implements _$IngredientDraftCopyWith<$Res> {
  __$IngredientDraftCopyWithImpl(this._self, this._then);

  final _IngredientDraft _self;
  final $Res Function(_IngredientDraft) _then;

/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? food = freezed,Object? unit = freezed,Object? amount = null,Object? noAmount = null,Object? isHeader = null,Object? note = null,Object? originalText = freezed,}) {
  return _then(_IngredientDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as NamedRef?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as NamedRef?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,noAmount: null == noAmount ? _self.noAmount : noAmount // ignore: cast_nullable_to_non_nullable
as bool,isHeader: null == isHeader ? _self.isHeader : isHeader // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of IngredientDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// @nodoc
mixin _$NamedRef {

 int? get id; String get name;
/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamedRefCopyWith<NamedRef> get copyWith => _$NamedRefCopyWithImpl<NamedRef>(this as NamedRef, _$identity);

  /// Serializes this NamedRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NamedRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamedRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NamedRef;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as NamedRef;
  return 'NamedRef(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $NamedRefCopyWith<$Res>  {
  factory $NamedRefCopyWith(NamedRef value, $Res Function(NamedRef) _then) = _$NamedRefCopyWithImpl;
@useResult
$Res call({
 int? id, String name
});




}
/// @nodoc
class _$NamedRefCopyWithImpl<$Res>
    implements $NamedRefCopyWith<$Res> {
  _$NamedRefCopyWithImpl(this._self, this._then);

  final NamedRef _self;
  final $Res Function(NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,}) {
  return _then(NamedRef(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NamedRef].
extension NamedRefPatterns on NamedRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamedRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamedRef value)  $default,){
final _that = this;
switch (_that) {
case _NamedRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamedRef value)?  $default,){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name)  $default,) {final _that = this;
switch (_that) {
case _NamedRef():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamedRef implements NamedRef {
  const _NamedRef({this.id, required this.name});
  factory _NamedRef.fromJson(Map<String, dynamic> json) => _$NamedRefFromJson(json);

@override final  int? id;
@override final  String name;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamedRefCopyWith<_NamedRef> get copyWith => __$NamedRefCopyWithImpl<_NamedRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamedRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamedRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'NamedRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NamedRefCopyWith<$Res> implements $NamedRefCopyWith<$Res> {
  factory _$NamedRefCopyWith(_NamedRef value, $Res Function(_NamedRef) _then) = __$NamedRefCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name
});




}
/// @nodoc
class __$NamedRefCopyWithImpl<$Res>
    implements _$NamedRefCopyWith<$Res> {
  __$NamedRefCopyWithImpl(this._self, this._then);

  final _NamedRef _self;
  final $Res Function(_NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,}) {
  return _then(_NamedRef(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

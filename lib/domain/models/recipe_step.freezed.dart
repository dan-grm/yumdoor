// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecipeStep {

 int get id; String get name;/// Markdown as written on the server. Untrusted; may contain templates such
/// as `{{ ingredients[0] }}` or `{{ scale(100) }}`.
 String get instruction; List<Ingredient> get ingredients;/// An explicit duration for the step, [Duration.zero] if none.
 Duration get time; int get order; bool get showAsHeader;
/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeStepCopyWith<RecipeStep> get copyWith => _$RecipeStepCopyWithImpl<RecipeStep>(this as RecipeStep, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecipeStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeStep&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.instruction, _this.instruction) || other.instruction == _this.instruction)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.showAsHeader, _this.showAsHeader) || other.showAsHeader == _this.showAsHeader));
}


@override
int get hashCode {
  final _this = this as RecipeStep;
  return Object.hash(runtimeType,_this.id,_this.name,_this.instruction,const DeepCollectionEquality().hash(_this.ingredients),_this.time,_this.order,_this.showAsHeader);
}

@override
String toString() {
  final _this = this as RecipeStep;
  return 'RecipeStep(id: ${_this.id}, name: ${_this.name}, instruction: ${_this.instruction}, ingredients: ${_this.ingredients}, time: ${_this.time}, order: ${_this.order}, showAsHeader: ${_this.showAsHeader})';
}


}

/// @nodoc
abstract mixin class $RecipeStepCopyWith<$Res>  {
  factory $RecipeStepCopyWith(RecipeStep value, $Res Function(RecipeStep) _then) = _$RecipeStepCopyWithImpl;
@useResult
$Res call({
 int id, String name, String instruction, List<Ingredient> ingredients, Duration time, int order, bool showAsHeader
});




}
/// @nodoc
class _$RecipeStepCopyWithImpl<$Res>
    implements $RecipeStepCopyWith<$Res> {
  _$RecipeStepCopyWithImpl(this._self, this._then);

  final RecipeStep _self;
  final $Res Function(RecipeStep) _then;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? instruction = null,Object? ingredients = null,Object? time = null,Object? order = null,Object? showAsHeader = null,}) {
  return _then(RecipeStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,showAsHeader: null == showAsHeader ? _self.showAsHeader : showAsHeader // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeStep].
extension RecipeStepPatterns on RecipeStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeStep value)  $default,){
final _that = this;
switch (_that) {
case _RecipeStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeStep value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String instruction,  List<Ingredient> ingredients,  Duration time,  int order,  bool showAsHeader)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.ingredients,_that.time,_that.order,_that.showAsHeader);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String instruction,  List<Ingredient> ingredients,  Duration time,  int order,  bool showAsHeader)  $default,) {final _that = this;
switch (_that) {
case _RecipeStep():
return $default(_that.id,_that.name,_that.instruction,_that.ingredients,_that.time,_that.order,_that.showAsHeader);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String instruction,  List<Ingredient> ingredients,  Duration time,  int order,  bool showAsHeader)?  $default,) {final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.ingredients,_that.time,_that.order,_that.showAsHeader);case _:
  return null;

}
}

}

/// @nodoc


class _RecipeStep implements RecipeStep {
  const _RecipeStep({required this.id, this.name = '', this.instruction = '',  List<Ingredient> ingredients = const [], this.time = Duration.zero, this.order = 0, this.showAsHeader = false}): _ingredients = ingredients;
  

@override final  int id;
@override@JsonKey() final  String name;
/// Markdown as written on the server. Untrusted; may contain templates such
/// as `{{ ingredients[0] }}` or `{{ scale(100) }}`.
@override@JsonKey() final  String instruction;
 final  List<Ingredient> _ingredients;
@override@JsonKey() List<Ingredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

/// An explicit duration for the step, [Duration.zero] if none.
@override@JsonKey() final  Duration time;
@override@JsonKey() final  int order;
@override@JsonKey() final  bool showAsHeader;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeStepCopyWith<_RecipeStep> get copyWith => __$RecipeStepCopyWithImpl<_RecipeStep>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeStep&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients)&&(identical(other.time, time) || other.time == time)&&(identical(other.order, order) || other.order == order)&&(identical(other.showAsHeader, showAsHeader) || other.showAsHeader == showAsHeader));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,instruction,const DeepCollectionEquality().hash(_ingredients),time,order,showAsHeader);
}

@override
String toString() {
    return 'RecipeStep(id: $id, name: $name, instruction: $instruction, ingredients: $ingredients, time: $time, order: $order, showAsHeader: $showAsHeader)';
}


}

/// @nodoc
abstract mixin class _$RecipeStepCopyWith<$Res> implements $RecipeStepCopyWith<$Res> {
  factory _$RecipeStepCopyWith(_RecipeStep value, $Res Function(_RecipeStep) _then) = __$RecipeStepCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String instruction, List<Ingredient> ingredients, Duration time, int order, bool showAsHeader
});




}
/// @nodoc
class __$RecipeStepCopyWithImpl<$Res>
    implements _$RecipeStepCopyWith<$Res> {
  __$RecipeStepCopyWithImpl(this._self, this._then);

  final _RecipeStep _self;
  final $Res Function(_RecipeStep) _then;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? instruction = null,Object? ingredients = null,Object? time = null,Object? order = null,Object? showAsHeader = null,}) {
  return _then(_RecipeStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,showAsHeader: null == showAsHeader ? _self.showAsHeader : showAsHeader // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

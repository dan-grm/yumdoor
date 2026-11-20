// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealPlan {

 int get id;/// `null` for a plan with only a [title], such as "Pizza bestellen".
 RecipeSummary? get recipe;/// Empty if not set; plans with a recipe usually have none.
 String get title; double get servings;/// Plain text or Markdown, empty if there is none.
 String get note;/// The first day, on this device's calendar.
 CalendarDay get fromDay;/// The last day, the same as [fromDay] for a plan of one day.
 CalendarDay get toDay; MealType get mealType;/// Whether its ingredients are on the shopping list.
 bool get onShoppingList;/// The id of the user who planned it.
 int get createdBy;
/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPlanCopyWith<MealPlan> get copyWith => _$MealPlanCopyWithImpl<MealPlan>(this as MealPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MealPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealPlan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recipe, _this.recipe) || other.recipe == _this.recipe)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.fromDay, _this.fromDay) || other.fromDay == _this.fromDay)&&(identical(other.toDay, _this.toDay) || other.toDay == _this.toDay)&&(identical(other.mealType, _this.mealType) || other.mealType == _this.mealType)&&(identical(other.onShoppingList, _this.onShoppingList) || other.onShoppingList == _this.onShoppingList)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy));
}


@override
int get hashCode {
  final _this = this as MealPlan;
  return Object.hash(runtimeType,_this.id,_this.recipe,_this.title,_this.servings,_this.note,_this.fromDay,_this.toDay,_this.mealType,_this.onShoppingList,_this.createdBy);
}

@override
String toString() {
  final _this = this as MealPlan;
  return 'MealPlan(id: ${_this.id}, recipe: ${_this.recipe}, title: ${_this.title}, servings: ${_this.servings}, note: ${_this.note}, fromDay: ${_this.fromDay}, toDay: ${_this.toDay}, mealType: ${_this.mealType}, onShoppingList: ${_this.onShoppingList}, createdBy: ${_this.createdBy})';
}


}

/// @nodoc
abstract mixin class $MealPlanCopyWith<$Res>  {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) _then) = _$MealPlanCopyWithImpl;
@useResult
$Res call({
 int id, RecipeSummary? recipe, String title, double servings, String note, CalendarDay fromDay, CalendarDay toDay, MealType mealType, bool onShoppingList, int createdBy
});


$RecipeSummaryCopyWith<$Res>? get recipe;$MealTypeCopyWith<$Res> get mealType;

}
/// @nodoc
class _$MealPlanCopyWithImpl<$Res>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._self, this._then);

  final MealPlan _self;
  final $Res Function(MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipe = freezed,Object? title = null,Object? servings = null,Object? note = null,Object? fromDay = null,Object? toDay = null,Object? mealType = null,Object? onShoppingList = null,Object? createdBy = null,}) {
  return _then(MealPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recipe: freezed == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,fromDay: null == fromDay ? _self.fromDay : fromDay // ignore: cast_nullable_to_non_nullable
as CalendarDay,toDay: null == toDay ? _self.toDay : toDay // ignore: cast_nullable_to_non_nullable
as CalendarDay,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,onShoppingList: null == onShoppingList ? _self.onShoppingList : onShoppingList // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res>? get recipe {
    if (_self.recipe == null) {
    return null;
  }

  return $RecipeSummaryCopyWith<$Res>(_self.recipe!, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealTypeCopyWith<$Res> get mealType {
  
  return $MealTypeCopyWith<$Res>(_self.mealType, (value) {
    return _then(_self.copyWith(mealType: value));
  });
}
}


/// Adds pattern-matching-related methods to [MealPlan].
extension MealPlanPatterns on MealPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPlan value)  $default,){
final _that = this;
switch (_that) {
case _MealPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPlan value)?  $default,){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  RecipeSummary? recipe,  String title,  double servings,  String note,  CalendarDay fromDay,  CalendarDay toDay,  MealType mealType,  bool onShoppingList,  int createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.id,_that.recipe,_that.title,_that.servings,_that.note,_that.fromDay,_that.toDay,_that.mealType,_that.onShoppingList,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  RecipeSummary? recipe,  String title,  double servings,  String note,  CalendarDay fromDay,  CalendarDay toDay,  MealType mealType,  bool onShoppingList,  int createdBy)  $default,) {final _that = this;
switch (_that) {
case _MealPlan():
return $default(_that.id,_that.recipe,_that.title,_that.servings,_that.note,_that.fromDay,_that.toDay,_that.mealType,_that.onShoppingList,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  RecipeSummary? recipe,  String title,  double servings,  String note,  CalendarDay fromDay,  CalendarDay toDay,  MealType mealType,  bool onShoppingList,  int createdBy)?  $default,) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.id,_that.recipe,_that.title,_that.servings,_that.note,_that.fromDay,_that.toDay,_that.mealType,_that.onShoppingList,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc


class _MealPlan extends MealPlan {
  const _MealPlan({required this.id, this.recipe, this.title = '', required this.servings, this.note = '', required this.fromDay, required this.toDay, required this.mealType, this.onShoppingList = false, required this.createdBy}): super._();
  

@override final  int id;
/// `null` for a plan with only a [title], such as "Pizza bestellen".
@override final  RecipeSummary? recipe;
/// Empty if not set; plans with a recipe usually have none.
@override@JsonKey() final  String title;
@override final  double servings;
/// Plain text or Markdown, empty if there is none.
@override@JsonKey() final  String note;
/// The first day, on this device's calendar.
@override final  CalendarDay fromDay;
/// The last day, the same as [fromDay] for a plan of one day.
@override final  CalendarDay toDay;
@override final  MealType mealType;
/// Whether its ingredients are on the shopping list.
@override@JsonKey() final  bool onShoppingList;
/// The id of the user who planned it.
@override final  int createdBy;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPlanCopyWith<_MealPlan> get copyWith => __$MealPlanCopyWithImpl<_MealPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.recipe, recipe) || other.recipe == recipe)&&(identical(other.title, title) || other.title == title)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.note, note) || other.note == note)&&(identical(other.fromDay, fromDay) || other.fromDay == fromDay)&&(identical(other.toDay, toDay) || other.toDay == toDay)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.onShoppingList, onShoppingList) || other.onShoppingList == onShoppingList)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,recipe,title,servings,note,fromDay,toDay,mealType,onShoppingList,createdBy);
}

@override
String toString() {
    return 'MealPlan(id: $id, recipe: $recipe, title: $title, servings: $servings, note: $note, fromDay: $fromDay, toDay: $toDay, mealType: $mealType, onShoppingList: $onShoppingList, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$MealPlanCopyWith<$Res> implements $MealPlanCopyWith<$Res> {
  factory _$MealPlanCopyWith(_MealPlan value, $Res Function(_MealPlan) _then) = __$MealPlanCopyWithImpl;
@override @useResult
$Res call({
 int id, RecipeSummary? recipe, String title, double servings, String note, CalendarDay fromDay, CalendarDay toDay, MealType mealType, bool onShoppingList, int createdBy
});


@override $RecipeSummaryCopyWith<$Res>? get recipe;@override $MealTypeCopyWith<$Res> get mealType;

}
/// @nodoc
class __$MealPlanCopyWithImpl<$Res>
    implements _$MealPlanCopyWith<$Res> {
  __$MealPlanCopyWithImpl(this._self, this._then);

  final _MealPlan _self;
  final $Res Function(_MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipe = freezed,Object? title = null,Object? servings = null,Object? note = null,Object? fromDay = null,Object? toDay = null,Object? mealType = null,Object? onShoppingList = null,Object? createdBy = null,}) {
  return _then(_MealPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recipe: freezed == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,fromDay: null == fromDay ? _self.fromDay : fromDay // ignore: cast_nullable_to_non_nullable
as CalendarDay,toDay: null == toDay ? _self.toDay : toDay // ignore: cast_nullable_to_non_nullable
as CalendarDay,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,onShoppingList: null == onShoppingList ? _self.onShoppingList : onShoppingList // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res>? get recipe {
    if (_self.recipe == null) {
    return null;
  }

  return $RecipeSummaryCopyWith<$Res>(_self.recipe!, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealTypeCopyWith<$Res> get mealType {
  
  return $MealTypeCopyWith<$Res>(_self.mealType, (value) {
    return _then(_self.copyWith(mealType: value));
  });
}
}

// dart format on

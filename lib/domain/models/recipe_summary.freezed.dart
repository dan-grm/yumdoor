// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecipeSummary {

 int get id; String get name; String get description; Uri? get image; List<Keyword> get keywords; int get servings;/// What a serving is ("Stück", "Gläser"), empty if not set.
 String get servingsText; Duration get workingTime; Duration get waitingTime;/// The current user's average rating from their own cook log, 0 to 5.
 double? get rating;/// When the current user last cooked it.
 DateTime? get lastCooked; UserRef? get createdBy; DateTime? get updatedAt;
/// Create a copy of RecipeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<RecipeSummary> get copyWith => _$RecipeSummaryCopyWithImpl<RecipeSummary>(this as RecipeSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecipeSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.image, _this.image) || other.image == _this.image)&&const DeepCollectionEquality().equals(other.keywords, _this.keywords)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.servingsText, _this.servingsText) || other.servingsText == _this.servingsText)&&(identical(other.workingTime, _this.workingTime) || other.workingTime == _this.workingTime)&&(identical(other.waitingTime, _this.waitingTime) || other.waitingTime == _this.waitingTime)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.lastCooked, _this.lastCooked) || other.lastCooked == _this.lastCooked)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as RecipeSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.image,const DeepCollectionEquality().hash(_this.keywords),_this.servings,_this.servingsText,_this.workingTime,_this.waitingTime,_this.rating,_this.lastCooked,_this.createdBy,_this.updatedAt);
}

@override
String toString() {
  final _this = this as RecipeSummary;
  return 'RecipeSummary(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, image: ${_this.image}, keywords: ${_this.keywords}, servings: ${_this.servings}, servingsText: ${_this.servingsText}, workingTime: ${_this.workingTime}, waitingTime: ${_this.waitingTime}, rating: ${_this.rating}, lastCooked: ${_this.lastCooked}, createdBy: ${_this.createdBy}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RecipeSummaryCopyWith<$Res>  {
  factory $RecipeSummaryCopyWith(RecipeSummary value, $Res Function(RecipeSummary) _then) = _$RecipeSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, Uri? image, List<Keyword> keywords, int servings, String servingsText, Duration workingTime, Duration waitingTime, double? rating, DateTime? lastCooked, UserRef? createdBy, DateTime? updatedAt
});


$UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class _$RecipeSummaryCopyWithImpl<$Res>
    implements $RecipeSummaryCopyWith<$Res> {
  _$RecipeSummaryCopyWithImpl(this._self, this._then);

  final RecipeSummary _self;
  final $Res Function(RecipeSummary) _then;

/// Create a copy of RecipeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? image = freezed,Object? keywords = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? rating = freezed,Object? lastCooked = freezed,Object? createdBy = freezed,Object? updatedAt = freezed,}) {
  return _then(RecipeSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uri?,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,lastCooked: freezed == lastCooked ? _self.lastCooked : lastCooked // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of RecipeSummary
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


/// Adds pattern-matching-related methods to [RecipeSummary].
extension RecipeSummaryPatterns on RecipeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeSummary value)  $default,){
final _that = this;
switch (_that) {
case _RecipeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeSummary() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RecipeSummary():
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  Uri? image,  List<Keyword> keywords,  int servings,  String servingsText,  Duration workingTime,  Duration waitingTime,  double? rating,  DateTime? lastCooked,  UserRef? createdBy,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecipeSummary() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.image,_that.keywords,_that.servings,_that.servingsText,_that.workingTime,_that.waitingTime,_that.rating,_that.lastCooked,_that.createdBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RecipeSummary implements RecipeSummary {
  const _RecipeSummary({required this.id, required this.name, this.description = '', this.image,  List<Keyword> keywords = const [], this.servings = 1, this.servingsText = '', this.workingTime = Duration.zero, this.waitingTime = Duration.zero, this.rating, this.lastCooked, this.createdBy, this.updatedAt}): _keywords = keywords;
  

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

@override@JsonKey() final  int servings;
/// What a serving is ("Stück", "Gläser"), empty if not set.
@override@JsonKey() final  String servingsText;
@override@JsonKey() final  Duration workingTime;
@override@JsonKey() final  Duration waitingTime;
/// The current user's average rating from their own cook log, 0 to 5.
@override final  double? rating;
/// When the current user last cooked it.
@override final  DateTime? lastCooked;
@override final  UserRef? createdBy;
@override final  DateTime? updatedAt;

/// Create a copy of RecipeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeSummaryCopyWith<_RecipeSummary> get copyWith => __$RecipeSummaryCopyWithImpl<_RecipeSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.keywords, _keywords)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.servingsText, servingsText) || other.servingsText == servingsText)&&(identical(other.workingTime, workingTime) || other.workingTime == workingTime)&&(identical(other.waitingTime, waitingTime) || other.waitingTime == waitingTime)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.lastCooked, lastCooked) || other.lastCooked == lastCooked)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,image,const DeepCollectionEquality().hash(_keywords),servings,servingsText,workingTime,waitingTime,rating,lastCooked,createdBy,updatedAt);
}

@override
String toString() {
    return 'RecipeSummary(id: $id, name: $name, description: $description, image: $image, keywords: $keywords, servings: $servings, servingsText: $servingsText, workingTime: $workingTime, waitingTime: $waitingTime, rating: $rating, lastCooked: $lastCooked, createdBy: $createdBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeSummaryCopyWith<$Res> implements $RecipeSummaryCopyWith<$Res> {
  factory _$RecipeSummaryCopyWith(_RecipeSummary value, $Res Function(_RecipeSummary) _then) = __$RecipeSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, Uri? image, List<Keyword> keywords, int servings, String servingsText, Duration workingTime, Duration waitingTime, double? rating, DateTime? lastCooked, UserRef? createdBy, DateTime? updatedAt
});


@override $UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class __$RecipeSummaryCopyWithImpl<$Res>
    implements _$RecipeSummaryCopyWith<$Res> {
  __$RecipeSummaryCopyWithImpl(this._self, this._then);

  final _RecipeSummary _self;
  final $Res Function(_RecipeSummary) _then;

/// Create a copy of RecipeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? image = freezed,Object? keywords = null,Object? servings = null,Object? servingsText = null,Object? workingTime = null,Object? waitingTime = null,Object? rating = freezed,Object? lastCooked = freezed,Object? createdBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_RecipeSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uri?,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<Keyword>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,servingsText: null == servingsText ? _self.servingsText : servingsText // ignore: cast_nullable_to_non_nullable
as String,workingTime: null == workingTime ? _self.workingTime : workingTime // ignore: cast_nullable_to_non_nullable
as Duration,waitingTime: null == waitingTime ? _self.waitingTime : waitingTime // ignore: cast_nullable_to_non_nullable
as Duration,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,lastCooked: freezed == lastCooked ? _self.lastCooked : lastCooked // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of RecipeSummary
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

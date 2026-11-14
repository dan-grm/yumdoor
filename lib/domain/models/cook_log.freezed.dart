// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cook_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CookLog {

 int get id; int get recipeId;/// The servings that were cooked, `null` if not recorded.
 int? get servings;/// 1 to 5 stars, `null` if not rated.
 int? get rating;/// `null` if there is none.
 String? get comment; UserRef? get createdBy; DateTime get createdAt;
/// Create a copy of CookLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookLogCopyWith<CookLog> get copyWith => _$CookLogCopyWithImpl<CookLog>(this as CookLog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CookLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CookLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as CookLog;
  return Object.hash(runtimeType,_this.id,_this.recipeId,_this.servings,_this.rating,_this.comment,_this.createdBy,_this.createdAt);
}

@override
String toString() {
  final _this = this as CookLog;
  return 'CookLog(id: ${_this.id}, recipeId: ${_this.recipeId}, servings: ${_this.servings}, rating: ${_this.rating}, comment: ${_this.comment}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CookLogCopyWith<$Res>  {
  factory $CookLogCopyWith(CookLog value, $Res Function(CookLog) _then) = _$CookLogCopyWithImpl;
@useResult
$Res call({
 int id, int recipeId, int? servings, int? rating, String? comment, UserRef? createdBy, DateTime createdAt
});


$UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class _$CookLogCopyWithImpl<$Res>
    implements $CookLogCopyWith<$Res> {
  _$CookLogCopyWithImpl(this._self, this._then);

  final CookLog _self;
  final $Res Function(CookLog) _then;

/// Create a copy of CookLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeId = null,Object? servings = freezed,Object? rating = freezed,Object? comment = freezed,Object? createdBy = freezed,Object? createdAt = null,}) {
  return _then(CookLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CookLog
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


/// Adds pattern-matching-related methods to [CookLog].
extension CookLogPatterns on CookLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CookLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CookLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CookLog value)  $default,){
final _that = this;
switch (_that) {
case _CookLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CookLog value)?  $default,){
final _that = this;
switch (_that) {
case _CookLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int recipeId,  int? servings,  int? rating,  String? comment,  UserRef? createdBy,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CookLog() when $default != null:
return $default(_that.id,_that.recipeId,_that.servings,_that.rating,_that.comment,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int recipeId,  int? servings,  int? rating,  String? comment,  UserRef? createdBy,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CookLog():
return $default(_that.id,_that.recipeId,_that.servings,_that.rating,_that.comment,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int recipeId,  int? servings,  int? rating,  String? comment,  UserRef? createdBy,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CookLog() when $default != null:
return $default(_that.id,_that.recipeId,_that.servings,_that.rating,_that.comment,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CookLog implements CookLog {
  const _CookLog({required this.id, required this.recipeId, this.servings, this.rating, this.comment, this.createdBy, required this.createdAt});
  

@override final  int id;
@override final  int recipeId;
/// The servings that were cooked, `null` if not recorded.
@override final  int? servings;
/// 1 to 5 stars, `null` if not rated.
@override final  int? rating;
/// `null` if there is none.
@override final  String? comment;
@override final  UserRef? createdBy;
@override final  DateTime createdAt;

/// Create a copy of CookLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookLogCopyWith<_CookLog> get copyWith => __$CookLogCopyWithImpl<_CookLog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CookLog&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,recipeId,servings,rating,comment,createdBy,createdAt);
}

@override
String toString() {
    return 'CookLog(id: $id, recipeId: $recipeId, servings: $servings, rating: $rating, comment: $comment, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CookLogCopyWith<$Res> implements $CookLogCopyWith<$Res> {
  factory _$CookLogCopyWith(_CookLog value, $Res Function(_CookLog) _then) = __$CookLogCopyWithImpl;
@override @useResult
$Res call({
 int id, int recipeId, int? servings, int? rating, String? comment, UserRef? createdBy, DateTime createdAt
});


@override $UserRefCopyWith<$Res>? get createdBy;

}
/// @nodoc
class __$CookLogCopyWithImpl<$Res>
    implements _$CookLogCopyWith<$Res> {
  __$CookLogCopyWithImpl(this._self, this._then);

  final _CookLog _self;
  final $Res Function(_CookLog) _then;

/// Create a copy of CookLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeId = null,Object? servings = freezed,Object? rating = freezed,Object? comment = freezed,Object? createdBy = freezed,Object? createdAt = null,}) {
  return _then(_CookLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CookLog
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

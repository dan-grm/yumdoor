// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Recommendation {

 RecipeSummary get recipe;/// 0 to 1, higher is a better fit. Only comparable between
/// recommendations of the same provider. Providers keep it in range
/// themselves: it is asserted, not checked in release builds.
 double get score;/// Why it is suggested, most important first. The UI words them in the
/// user's language.
 List<RecommendationReason> get reasons;
/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationCopyWith<Recommendation> get copyWith => _$RecommendationCopyWithImpl<Recommendation>(this as Recommendation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Recommendation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recommendation&&(identical(other.recipe, _this.recipe) || other.recipe == _this.recipe)&&(identical(other.score, _this.score) || other.score == _this.score)&&const DeepCollectionEquality().equals(other.reasons, _this.reasons));
}


@override
int get hashCode {
  final _this = this as Recommendation;
  return Object.hash(runtimeType,_this.recipe,_this.score,const DeepCollectionEquality().hash(_this.reasons));
}

@override
String toString() {
  final _this = this as Recommendation;
  return 'Recommendation(recipe: ${_this.recipe}, score: ${_this.score}, reasons: ${_this.reasons})';
}


}

/// @nodoc
abstract mixin class $RecommendationCopyWith<$Res>  {
  factory $RecommendationCopyWith(Recommendation value, $Res Function(Recommendation) _then) = _$RecommendationCopyWithImpl;
@useResult
$Res call({
 RecipeSummary recipe, double score, List<RecommendationReason> reasons
});


$RecipeSummaryCopyWith<$Res> get recipe;

}
/// @nodoc
class _$RecommendationCopyWithImpl<$Res>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._self, this._then);

  final Recommendation _self;
  final $Res Function(Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipe = null,Object? score = null,Object? reasons = null,}) {
  return _then(Recommendation(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<RecommendationReason>,
  ));
}
/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res> get recipe {
  
  return $RecipeSummaryCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}


/// Adds pattern-matching-related methods to [Recommendation].
extension RecommendationPatterns on Recommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recommendation value)  $default,){
final _that = this;
switch (_that) {
case _Recommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recommendation value)?  $default,){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecipeSummary recipe,  double score,  List<RecommendationReason> reasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.recipe,_that.score,_that.reasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecipeSummary recipe,  double score,  List<RecommendationReason> reasons)  $default,) {final _that = this;
switch (_that) {
case _Recommendation():
return $default(_that.recipe,_that.score,_that.reasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecipeSummary recipe,  double score,  List<RecommendationReason> reasons)?  $default,) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.recipe,_that.score,_that.reasons);case _:
  return null;

}
}

}

/// @nodoc


class _Recommendation implements Recommendation {
  const _Recommendation({required this.recipe, required this.score,  List<RecommendationReason> reasons = const []}): assert(score >= 0 && score <= 1, 'score must be 0 to 1'),_reasons = reasons;
  

@override final  RecipeSummary recipe;
/// 0 to 1, higher is a better fit. Only comparable between
/// recommendations of the same provider. Providers keep it in range
/// themselves: it is asserted, not checked in release builds.
@override final  double score;
/// Why it is suggested, most important first. The UI words them in the
/// user's language.
 final  List<RecommendationReason> _reasons;
/// Why it is suggested, most important first. The UI words them in the
/// user's language.
@override@JsonKey() List<RecommendationReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}


/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationCopyWith<_Recommendation> get copyWith => __$RecommendationCopyWithImpl<_Recommendation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recommendation&&(identical(other.recipe, recipe) || other.recipe == recipe)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.reasons, _reasons));
}


@override
int get hashCode {
    return Object.hash(runtimeType,recipe,score,const DeepCollectionEquality().hash(_reasons));
}

@override
String toString() {
    return 'Recommendation(recipe: $recipe, score: $score, reasons: $reasons)';
}


}

/// @nodoc
abstract mixin class _$RecommendationCopyWith<$Res> implements $RecommendationCopyWith<$Res> {
  factory _$RecommendationCopyWith(_Recommendation value, $Res Function(_Recommendation) _then) = __$RecommendationCopyWithImpl;
@override @useResult
$Res call({
 RecipeSummary recipe, double score, List<RecommendationReason> reasons
});


@override $RecipeSummaryCopyWith<$Res> get recipe;

}
/// @nodoc
class __$RecommendationCopyWithImpl<$Res>
    implements _$RecommendationCopyWith<$Res> {
  __$RecommendationCopyWithImpl(this._self, this._then);

  final _Recommendation _self;
  final $Res Function(_Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipe = null,Object? score = null,Object? reasons = null,}) {
  return _then(_Recommendation(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<RecommendationReason>,
  ));
}

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res> get recipe {
  
  return $RecipeSummaryCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}

/// @nodoc
mixin _$RecommendationReason {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationReason);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RecommendationReason()';
}


}

/// @nodoc
class $RecommendationReasonCopyWith<$Res>  {
$RecommendationReasonCopyWith(RecommendationReason _, $Res Function(RecommendationReason) __);
}


/// Adds pattern-matching-related methods to [RecommendationReason].
extension RecommendationReasonPatterns on RecommendationReason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HighlyRated value)?  highlyRated,TResult Function( NotCookedSince value)?  notCookedSince,TResult Function( InSeason value)?  inSeason,TResult Function( CookedRecentlyBy value)?  cookedRecentlyBy,TResult Function( SimilarTo value)?  similarTo,TResult Function( FreeTextReason value)?  freeText,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HighlyRated() when highlyRated != null:
return highlyRated(_that);case NotCookedSince() when notCookedSince != null:
return notCookedSince(_that);case InSeason() when inSeason != null:
return inSeason(_that);case CookedRecentlyBy() when cookedRecentlyBy != null:
return cookedRecentlyBy(_that);case SimilarTo() when similarTo != null:
return similarTo(_that);case FreeTextReason() when freeText != null:
return freeText(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HighlyRated value)  highlyRated,required TResult Function( NotCookedSince value)  notCookedSince,required TResult Function( InSeason value)  inSeason,required TResult Function( CookedRecentlyBy value)  cookedRecentlyBy,required TResult Function( SimilarTo value)  similarTo,required TResult Function( FreeTextReason value)  freeText,}){
final _that = this;
switch (_that) {
case HighlyRated():
return highlyRated(_that);case NotCookedSince():
return notCookedSince(_that);case InSeason():
return inSeason(_that);case CookedRecentlyBy():
return cookedRecentlyBy(_that);case SimilarTo():
return similarTo(_that);case FreeTextReason():
return freeText(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HighlyRated value)?  highlyRated,TResult? Function( NotCookedSince value)?  notCookedSince,TResult? Function( InSeason value)?  inSeason,TResult? Function( CookedRecentlyBy value)?  cookedRecentlyBy,TResult? Function( SimilarTo value)?  similarTo,TResult? Function( FreeTextReason value)?  freeText,}){
final _that = this;
switch (_that) {
case HighlyRated() when highlyRated != null:
return highlyRated(_that);case NotCookedSince() when notCookedSince != null:
return notCookedSince(_that);case InSeason() when inSeason != null:
return inSeason(_that);case CookedRecentlyBy() when cookedRecentlyBy != null:
return cookedRecentlyBy(_that);case SimilarTo() when similarTo != null:
return similarTo(_that);case FreeTextReason() when freeText != null:
return freeText(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double rating)?  highlyRated,TResult Function( DateTime date)?  notCookedSince,TResult Function( Keyword keyword)?  inSeason,TResult Function( UserRef user,  DateTime date)?  cookedRecentlyBy,TResult Function( RecipeSummary recipe)?  similarTo,TResult Function( String text)?  freeText,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HighlyRated() when highlyRated != null:
return highlyRated(_that.rating);case NotCookedSince() when notCookedSince != null:
return notCookedSince(_that.date);case InSeason() when inSeason != null:
return inSeason(_that.keyword);case CookedRecentlyBy() when cookedRecentlyBy != null:
return cookedRecentlyBy(_that.user,_that.date);case SimilarTo() when similarTo != null:
return similarTo(_that.recipe);case FreeTextReason() when freeText != null:
return freeText(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double rating)  highlyRated,required TResult Function( DateTime date)  notCookedSince,required TResult Function( Keyword keyword)  inSeason,required TResult Function( UserRef user,  DateTime date)  cookedRecentlyBy,required TResult Function( RecipeSummary recipe)  similarTo,required TResult Function( String text)  freeText,}) {final _that = this;
switch (_that) {
case HighlyRated():
return highlyRated(_that.rating);case NotCookedSince():
return notCookedSince(_that.date);case InSeason():
return inSeason(_that.keyword);case CookedRecentlyBy():
return cookedRecentlyBy(_that.user,_that.date);case SimilarTo():
return similarTo(_that.recipe);case FreeTextReason():
return freeText(_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double rating)?  highlyRated,TResult? Function( DateTime date)?  notCookedSince,TResult? Function( Keyword keyword)?  inSeason,TResult? Function( UserRef user,  DateTime date)?  cookedRecentlyBy,TResult? Function( RecipeSummary recipe)?  similarTo,TResult? Function( String text)?  freeText,}) {final _that = this;
switch (_that) {
case HighlyRated() when highlyRated != null:
return highlyRated(_that.rating);case NotCookedSince() when notCookedSince != null:
return notCookedSince(_that.date);case InSeason() when inSeason != null:
return inSeason(_that.keyword);case CookedRecentlyBy() when cookedRecentlyBy != null:
return cookedRecentlyBy(_that.user,_that.date);case SimilarTo() when similarTo != null:
return similarTo(_that.recipe);case FreeTextReason() when freeText != null:
return freeText(_that.text);case _:
  return null;

}
}

}

/// @nodoc


class HighlyRated implements RecommendationReason {
  const HighlyRated(this.rating);
  

 final  double rating;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighlyRatedCopyWith<HighlyRated> get copyWith => _$HighlyRatedCopyWithImpl<HighlyRated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HighlyRated&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode {
    return Object.hash(runtimeType,rating);
}

@override
String toString() {
    return 'RecommendationReason.highlyRated(rating: $rating)';
}


}

/// @nodoc
abstract mixin class $HighlyRatedCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $HighlyRatedCopyWith(HighlyRated value, $Res Function(HighlyRated) _then) = _$HighlyRatedCopyWithImpl;
@useResult
$Res call({
 double rating
});




}
/// @nodoc
class _$HighlyRatedCopyWithImpl<$Res>
    implements $HighlyRatedCopyWith<$Res> {
  _$HighlyRatedCopyWithImpl(this._self, this._then);

  final HighlyRated _self;
  final $Res Function(HighlyRated) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rating = null,}) {
  return _then(HighlyRated(
null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class NotCookedSince implements RecommendationReason {
  const NotCookedSince(this.date);
  

 final  DateTime date;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotCookedSinceCopyWith<NotCookedSince> get copyWith => _$NotCookedSinceCopyWithImpl<NotCookedSince>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotCookedSince&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString() {
    return 'RecommendationReason.notCookedSince(date: $date)';
}


}

/// @nodoc
abstract mixin class $NotCookedSinceCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $NotCookedSinceCopyWith(NotCookedSince value, $Res Function(NotCookedSince) _then) = _$NotCookedSinceCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$NotCookedSinceCopyWithImpl<$Res>
    implements $NotCookedSinceCopyWith<$Res> {
  _$NotCookedSinceCopyWithImpl(this._self, this._then);

  final NotCookedSince _self;
  final $Res Function(NotCookedSince) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(NotCookedSince(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class InSeason implements RecommendationReason {
  const InSeason(this.keyword);
  

 final  Keyword keyword;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InSeasonCopyWith<InSeason> get copyWith => _$InSeasonCopyWithImpl<InSeason>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InSeason&&(identical(other.keyword, keyword) || other.keyword == keyword));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyword);
}

@override
String toString() {
    return 'RecommendationReason.inSeason(keyword: $keyword)';
}


}

/// @nodoc
abstract mixin class $InSeasonCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $InSeasonCopyWith(InSeason value, $Res Function(InSeason) _then) = _$InSeasonCopyWithImpl;
@useResult
$Res call({
 Keyword keyword
});


$KeywordCopyWith<$Res> get keyword;

}
/// @nodoc
class _$InSeasonCopyWithImpl<$Res>
    implements $InSeasonCopyWith<$Res> {
  _$InSeasonCopyWithImpl(this._self, this._then);

  final InSeason _self;
  final $Res Function(InSeason) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? keyword = null,}) {
  return _then(InSeason(
null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as Keyword,
  ));
}

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KeywordCopyWith<$Res> get keyword {
  
  return $KeywordCopyWith<$Res>(_self.keyword, (value) {
    return _then(_self.copyWith(keyword: value));
  });
}
}

/// @nodoc


class CookedRecentlyBy implements RecommendationReason {
  const CookedRecentlyBy(this.user, this.date);
  

 final  UserRef user;
 final  DateTime date;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookedRecentlyByCopyWith<CookedRecentlyBy> get copyWith => _$CookedRecentlyByCopyWithImpl<CookedRecentlyBy>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CookedRecentlyBy&&(identical(other.user, user) || other.user == user)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,date);
}

@override
String toString() {
    return 'RecommendationReason.cookedRecentlyBy(user: $user, date: $date)';
}


}

/// @nodoc
abstract mixin class $CookedRecentlyByCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $CookedRecentlyByCopyWith(CookedRecentlyBy value, $Res Function(CookedRecentlyBy) _then) = _$CookedRecentlyByCopyWithImpl;
@useResult
$Res call({
 UserRef user, DateTime date
});


$UserRefCopyWith<$Res> get user;

}
/// @nodoc
class _$CookedRecentlyByCopyWithImpl<$Res>
    implements $CookedRecentlyByCopyWith<$Res> {
  _$CookedRecentlyByCopyWithImpl(this._self, this._then);

  final CookedRecentlyBy _self;
  final $Res Function(CookedRecentlyBy) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? date = null,}) {
  return _then(CookedRecentlyBy(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserRef,null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res> get user {
  
  return $UserRefCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class SimilarTo implements RecommendationReason {
  const SimilarTo(this.recipe);
  

 final  RecipeSummary recipe;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimilarToCopyWith<SimilarTo> get copyWith => _$SimilarToCopyWithImpl<SimilarTo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SimilarTo&&(identical(other.recipe, recipe) || other.recipe == recipe));
}


@override
int get hashCode {
    return Object.hash(runtimeType,recipe);
}

@override
String toString() {
    return 'RecommendationReason.similarTo(recipe: $recipe)';
}


}

/// @nodoc
abstract mixin class $SimilarToCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $SimilarToCopyWith(SimilarTo value, $Res Function(SimilarTo) _then) = _$SimilarToCopyWithImpl;
@useResult
$Res call({
 RecipeSummary recipe
});


$RecipeSummaryCopyWith<$Res> get recipe;

}
/// @nodoc
class _$SimilarToCopyWithImpl<$Res>
    implements $SimilarToCopyWith<$Res> {
  _$SimilarToCopyWithImpl(this._self, this._then);

  final SimilarTo _self;
  final $Res Function(SimilarTo) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recipe = null,}) {
  return _then(SimilarTo(
null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as RecipeSummary,
  ));
}

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeSummaryCopyWith<$Res> get recipe {
  
  return $RecipeSummaryCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}

/// @nodoc


class FreeTextReason implements RecommendationReason {
  const FreeTextReason(this.text);
  

 final  String text;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreeTextReasonCopyWith<FreeTextReason> get copyWith => _$FreeTextReasonCopyWithImpl<FreeTextReason>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FreeTextReason&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'RecommendationReason.freeText(text: $text)';
}


}

/// @nodoc
abstract mixin class $FreeTextReasonCopyWith<$Res> implements $RecommendationReasonCopyWith<$Res> {
  factory $FreeTextReasonCopyWith(FreeTextReason value, $Res Function(FreeTextReason) _then) = _$FreeTextReasonCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$FreeTextReasonCopyWithImpl<$Res>
    implements $FreeTextReasonCopyWith<$Res> {
  _$FreeTextReasonCopyWithImpl(this._self, this._then);

  final FreeTextReason _self;
  final $Res Function(FreeTextReason) _then;

/// Create a copy of RecommendationReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(FreeTextReason(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RecommendationContext {

/// The day to suggest for, on this device's calendar. Decides the season
/// and what counts as recent.
 CalendarDay get today;/// The id of the current user, to tell their own cook logs from other
/// people's.
 int get userId;/// This week's meal plans, so planned recipes aren't suggested again.
 List<MealPlan> get mealPlans;/// What the user feels like, in their own words; `null` if they didn't
/// say. Providers that can't use free text ignore it.
 String? get wish;
/// Create a copy of RecommendationContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationContextCopyWith<RecommendationContext> get copyWith => _$RecommendationContextCopyWithImpl<RecommendationContext>(this as RecommendationContext, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecommendationContext;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationContext&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&const DeepCollectionEquality().equals(other.mealPlans, _this.mealPlans)&&(identical(other.wish, _this.wish) || other.wish == _this.wish));
}


@override
int get hashCode {
  final _this = this as RecommendationContext;
  return Object.hash(runtimeType,_this.today,_this.userId,const DeepCollectionEquality().hash(_this.mealPlans),_this.wish);
}

@override
String toString() {
  final _this = this as RecommendationContext;
  return 'RecommendationContext(today: ${_this.today}, userId: ${_this.userId}, mealPlans: ${_this.mealPlans}, wish: ${_this.wish})';
}


}

/// @nodoc
abstract mixin class $RecommendationContextCopyWith<$Res>  {
  factory $RecommendationContextCopyWith(RecommendationContext value, $Res Function(RecommendationContext) _then) = _$RecommendationContextCopyWithImpl;
@useResult
$Res call({
 CalendarDay today, int userId, List<MealPlan> mealPlans, String? wish
});




}
/// @nodoc
class _$RecommendationContextCopyWithImpl<$Res>
    implements $RecommendationContextCopyWith<$Res> {
  _$RecommendationContextCopyWithImpl(this._self, this._then);

  final RecommendationContext _self;
  final $Res Function(RecommendationContext) _then;

/// Create a copy of RecommendationContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? today = null,Object? userId = null,Object? mealPlans = null,Object? wish = freezed,}) {
  return _then(RecommendationContext(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as CalendarDay,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mealPlans: null == mealPlans ? _self.mealPlans : mealPlans // ignore: cast_nullable_to_non_nullable
as List<MealPlan>,wish: freezed == wish ? _self.wish : wish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationContext].
extension RecommendationContextPatterns on RecommendationContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationContext value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationContext value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDay today,  int userId,  List<MealPlan> mealPlans,  String? wish)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationContext() when $default != null:
return $default(_that.today,_that.userId,_that.mealPlans,_that.wish);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDay today,  int userId,  List<MealPlan> mealPlans,  String? wish)  $default,) {final _that = this;
switch (_that) {
case _RecommendationContext():
return $default(_that.today,_that.userId,_that.mealPlans,_that.wish);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDay today,  int userId,  List<MealPlan> mealPlans,  String? wish)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationContext() when $default != null:
return $default(_that.today,_that.userId,_that.mealPlans,_that.wish);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendationContext implements RecommendationContext {
  const _RecommendationContext({required this.today, required this.userId,  List<MealPlan> mealPlans = const [], this.wish}): _mealPlans = mealPlans;
  

/// The day to suggest for, on this device's calendar. Decides the season
/// and what counts as recent.
@override final  CalendarDay today;
/// The id of the current user, to tell their own cook logs from other
/// people's.
@override final  int userId;
/// This week's meal plans, so planned recipes aren't suggested again.
 final  List<MealPlan> _mealPlans;
/// This week's meal plans, so planned recipes aren't suggested again.
@override@JsonKey() List<MealPlan> get mealPlans {
  if (_mealPlans is EqualUnmodifiableListView) return _mealPlans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mealPlans);
}

/// What the user feels like, in their own words; `null` if they didn't
/// say. Providers that can't use free text ignore it.
@override final  String? wish;

/// Create a copy of RecommendationContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationContextCopyWith<_RecommendationContext> get copyWith => __$RecommendationContextCopyWithImpl<_RecommendationContext>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationContext&&(identical(other.today, today) || other.today == today)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.mealPlans, _mealPlans)&&(identical(other.wish, wish) || other.wish == wish));
}


@override
int get hashCode {
    return Object.hash(runtimeType,today,userId,const DeepCollectionEquality().hash(_mealPlans),wish);
}

@override
String toString() {
    return 'RecommendationContext(today: $today, userId: $userId, mealPlans: $mealPlans, wish: $wish)';
}


}

/// @nodoc
abstract mixin class _$RecommendationContextCopyWith<$Res> implements $RecommendationContextCopyWith<$Res> {
  factory _$RecommendationContextCopyWith(_RecommendationContext value, $Res Function(_RecommendationContext) _then) = __$RecommendationContextCopyWithImpl;
@override @useResult
$Res call({
 CalendarDay today, int userId, List<MealPlan> mealPlans, String? wish
});




}
/// @nodoc
class __$RecommendationContextCopyWithImpl<$Res>
    implements _$RecommendationContextCopyWith<$Res> {
  __$RecommendationContextCopyWithImpl(this._self, this._then);

  final _RecommendationContext _self;
  final $Res Function(_RecommendationContext) _then;

/// Create a copy of RecommendationContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? today = null,Object? userId = null,Object? mealPlans = null,Object? wish = freezed,}) {
  return _then(_RecommendationContext(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as CalendarDay,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mealPlans: null == mealPlans ? _self._mealPlans : mealPlans // ignore: cast_nullable_to_non_nullable
as List<MealPlan>,wish: freezed == wish ? _self.wish : wish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupermarketCategory {

 int get id; String get name;
/// Create a copy of SupermarketCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupermarketCategoryCopyWith<SupermarketCategory> get copyWith => _$SupermarketCategoryCopyWithImpl<SupermarketCategory>(this as SupermarketCategory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SupermarketCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupermarketCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as SupermarketCategory;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as SupermarketCategory;
  return 'SupermarketCategory(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $SupermarketCategoryCopyWith<$Res>  {
  factory $SupermarketCategoryCopyWith(SupermarketCategory value, $Res Function(SupermarketCategory) _then) = _$SupermarketCategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$SupermarketCategoryCopyWithImpl<$Res>
    implements $SupermarketCategoryCopyWith<$Res> {
  _$SupermarketCategoryCopyWithImpl(this._self, this._then);

  final SupermarketCategory _self;
  final $Res Function(SupermarketCategory) _then;

/// Create a copy of SupermarketCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(SupermarketCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SupermarketCategory].
extension SupermarketCategoryPatterns on SupermarketCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupermarketCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupermarketCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupermarketCategory value)  $default,){
final _that = this;
switch (_that) {
case _SupermarketCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupermarketCategory value)?  $default,){
final _that = this;
switch (_that) {
case _SupermarketCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupermarketCategory() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SupermarketCategory():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SupermarketCategory() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _SupermarketCategory implements SupermarketCategory {
  const _SupermarketCategory({required this.id, required this.name});
  

@override final  int id;
@override final  String name;

/// Create a copy of SupermarketCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupermarketCategoryCopyWith<_SupermarketCategory> get copyWith => __$SupermarketCategoryCopyWithImpl<_SupermarketCategory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupermarketCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'SupermarketCategory(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SupermarketCategoryCopyWith<$Res> implements $SupermarketCategoryCopyWith<$Res> {
  factory _$SupermarketCategoryCopyWith(_SupermarketCategory value, $Res Function(_SupermarketCategory) _then) = __$SupermarketCategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$SupermarketCategoryCopyWithImpl<$Res>
    implements _$SupermarketCategoryCopyWith<$Res> {
  __$SupermarketCategoryCopyWithImpl(this._self, this._then);

  final _SupermarketCategory _self;
  final $Res Function(_SupermarketCategory) _then;

/// Create a copy of SupermarketCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SupermarketCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Supermarket {

 int get id; String get name;/// The ids of its categories, in the order they come in the store.
/// Categories not in it come after these.
 List<int> get categoryIds;
/// Create a copy of Supermarket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupermarketCopyWith<Supermarket> get copyWith => _$SupermarketCopyWithImpl<Supermarket>(this as Supermarket, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Supermarket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supermarket&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.categoryIds, _this.categoryIds));
}


@override
int get hashCode {
  final _this = this as Supermarket;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.categoryIds));
}

@override
String toString() {
  final _this = this as Supermarket;
  return 'Supermarket(id: ${_this.id}, name: ${_this.name}, categoryIds: ${_this.categoryIds})';
}


}

/// @nodoc
abstract mixin class $SupermarketCopyWith<$Res>  {
  factory $SupermarketCopyWith(Supermarket value, $Res Function(Supermarket) _then) = _$SupermarketCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<int> categoryIds
});




}
/// @nodoc
class _$SupermarketCopyWithImpl<$Res>
    implements $SupermarketCopyWith<$Res> {
  _$SupermarketCopyWithImpl(this._self, this._then);

  final Supermarket _self;
  final $Res Function(Supermarket) _then;

/// Create a copy of Supermarket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryIds = null,}) {
  return _then(Supermarket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [Supermarket].
extension SupermarketPatterns on Supermarket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Supermarket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Supermarket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Supermarket value)  $default,){
final _that = this;
switch (_that) {
case _Supermarket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Supermarket value)?  $default,){
final _that = this;
switch (_that) {
case _Supermarket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<int> categoryIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Supermarket() when $default != null:
return $default(_that.id,_that.name,_that.categoryIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<int> categoryIds)  $default,) {final _that = this;
switch (_that) {
case _Supermarket():
return $default(_that.id,_that.name,_that.categoryIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<int> categoryIds)?  $default,) {final _that = this;
switch (_that) {
case _Supermarket() when $default != null:
return $default(_that.id,_that.name,_that.categoryIds);case _:
  return null;

}
}

}

/// @nodoc


class _Supermarket implements Supermarket {
  const _Supermarket({required this.id, required this.name,  List<int> categoryIds = const <int>[]}): _categoryIds = categoryIds;
  

@override final  int id;
@override final  String name;
/// The ids of its categories, in the order they come in the store.
/// Categories not in it come after these.
 final  List<int> _categoryIds;
/// The ids of its categories, in the order they come in the store.
/// Categories not in it come after these.
@override@JsonKey() List<int> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}


/// Create a copy of Supermarket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupermarketCopyWith<_Supermarket> get copyWith => __$SupermarketCopyWithImpl<_Supermarket>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supermarket&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.categoryIds, _categoryIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_categoryIds));
}

@override
String toString() {
    return 'Supermarket(id: $id, name: $name, categoryIds: $categoryIds)';
}


}

/// @nodoc
abstract mixin class _$SupermarketCopyWith<$Res> implements $SupermarketCopyWith<$Res> {
  factory _$SupermarketCopyWith(_Supermarket value, $Res Function(_Supermarket) _then) = __$SupermarketCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<int> categoryIds
});




}
/// @nodoc
class __$SupermarketCopyWithImpl<$Res>
    implements _$SupermarketCopyWith<$Res> {
  __$SupermarketCopyWithImpl(this._self, this._then);

  final _Supermarket _self;
  final $Res Function(_Supermarket) _then;

/// Create a copy of Supermarket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryIds = null,}) {
  return _then(_Supermarket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$ShoppingFood {

 int get id; String get name; String? get pluralName;/// `null` for a food without one; it is grouped as uncategorized.
 SupermarketCategory? get category;
/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingFoodCopyWith<ShoppingFood> get copyWith => _$ShoppingFoodCopyWithImpl<ShoppingFood>(this as ShoppingFood, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShoppingFood;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingFood&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pluralName, _this.pluralName) || other.pluralName == _this.pluralName)&&(identical(other.category, _this.category) || other.category == _this.category));
}


@override
int get hashCode {
  final _this = this as ShoppingFood;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pluralName,_this.category);
}

@override
String toString() {
  final _this = this as ShoppingFood;
  return 'ShoppingFood(id: ${_this.id}, name: ${_this.name}, pluralName: ${_this.pluralName}, category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $ShoppingFoodCopyWith<$Res>  {
  factory $ShoppingFoodCopyWith(ShoppingFood value, $Res Function(ShoppingFood) _then) = _$ShoppingFoodCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? pluralName, SupermarketCategory? category
});


$SupermarketCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$ShoppingFoodCopyWithImpl<$Res>
    implements $ShoppingFoodCopyWith<$Res> {
  _$ShoppingFoodCopyWithImpl(this._self, this._then);

  final ShoppingFood _self;
  final $Res Function(ShoppingFood) _then;

/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,Object? category = freezed,}) {
  return _then(ShoppingFood(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SupermarketCategory?,
  ));
}
/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupermarketCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $SupermarketCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShoppingFood].
extension ShoppingFoodPatterns on ShoppingFood {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingFood value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingFood() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingFood value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingFood():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingFood value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingFood() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName,  SupermarketCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingFood() when $default != null:
return $default(_that.id,_that.name,_that.pluralName,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? pluralName,  SupermarketCategory? category)  $default,) {final _that = this;
switch (_that) {
case _ShoppingFood():
return $default(_that.id,_that.name,_that.pluralName,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? pluralName,  SupermarketCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingFood() when $default != null:
return $default(_that.id,_that.name,_that.pluralName,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingFood implements ShoppingFood {
  const _ShoppingFood({required this.id, required this.name, this.pluralName, this.category});
  

@override final  int id;
@override final  String name;
@override final  String? pluralName;
/// `null` for a food without one; it is grouped as uncategorized.
@override final  SupermarketCategory? category;

/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingFoodCopyWith<_ShoppingFood> get copyWith => __$ShoppingFoodCopyWithImpl<_ShoppingFood>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingFood&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pluralName, pluralName) || other.pluralName == pluralName)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pluralName,category);
}

@override
String toString() {
    return 'ShoppingFood(id: $id, name: $name, pluralName: $pluralName, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ShoppingFoodCopyWith<$Res> implements $ShoppingFoodCopyWith<$Res> {
  factory _$ShoppingFoodCopyWith(_ShoppingFood value, $Res Function(_ShoppingFood) _then) = __$ShoppingFoodCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? pluralName, SupermarketCategory? category
});


@override $SupermarketCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$ShoppingFoodCopyWithImpl<$Res>
    implements _$ShoppingFoodCopyWith<$Res> {
  __$ShoppingFoodCopyWithImpl(this._self, this._then);

  final _ShoppingFood _self;
  final $Res Function(_ShoppingFood) _then;

/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pluralName = freezed,Object? category = freezed,}) {
  return _then(_ShoppingFood(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pluralName: freezed == pluralName ? _self.pluralName : pluralName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SupermarketCategory?,
  ));
}

/// Create a copy of ShoppingFood
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupermarketCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $SupermarketCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

/// @nodoc
mixin _$ShoppingEntrySource {

/// The recipe on the shopping list (Tandoor's `ShoppingListRecipe`). All
/// entries added for the recipe at once share it.
 int get listRecipeId;/// `null` if Tandoor links no recipe.
 int? get recipeId;/// The recipe's name; empty if Tandoor sends none.
 String get recipeName;/// The servings the amounts were scaled to.
 double get servings;/// The meal plan it was added for, if any.
 MealPlan? get mealPlan;
/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingEntrySourceCopyWith<ShoppingEntrySource> get copyWith => _$ShoppingEntrySourceCopyWithImpl<ShoppingEntrySource>(this as ShoppingEntrySource, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShoppingEntrySource;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingEntrySource&&(identical(other.listRecipeId, _this.listRecipeId) || other.listRecipeId == _this.listRecipeId)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.recipeName, _this.recipeName) || other.recipeName == _this.recipeName)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.mealPlan, _this.mealPlan) || other.mealPlan == _this.mealPlan));
}


@override
int get hashCode {
  final _this = this as ShoppingEntrySource;
  return Object.hash(runtimeType,_this.listRecipeId,_this.recipeId,_this.recipeName,_this.servings,_this.mealPlan);
}

@override
String toString() {
  final _this = this as ShoppingEntrySource;
  return 'ShoppingEntrySource(listRecipeId: ${_this.listRecipeId}, recipeId: ${_this.recipeId}, recipeName: ${_this.recipeName}, servings: ${_this.servings}, mealPlan: ${_this.mealPlan})';
}


}

/// @nodoc
abstract mixin class $ShoppingEntrySourceCopyWith<$Res>  {
  factory $ShoppingEntrySourceCopyWith(ShoppingEntrySource value, $Res Function(ShoppingEntrySource) _then) = _$ShoppingEntrySourceCopyWithImpl;
@useResult
$Res call({
 int listRecipeId, int? recipeId, String recipeName, double servings, MealPlan? mealPlan
});


$MealPlanCopyWith<$Res>? get mealPlan;

}
/// @nodoc
class _$ShoppingEntrySourceCopyWithImpl<$Res>
    implements $ShoppingEntrySourceCopyWith<$Res> {
  _$ShoppingEntrySourceCopyWithImpl(this._self, this._then);

  final ShoppingEntrySource _self;
  final $Res Function(ShoppingEntrySource) _then;

/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listRecipeId = null,Object? recipeId = freezed,Object? recipeName = null,Object? servings = null,Object? mealPlan = freezed,}) {
  return _then(ShoppingEntrySource(
listRecipeId: null == listRecipeId ? _self.listRecipeId : listRecipeId // ignore: cast_nullable_to_non_nullable
as int,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int?,recipeName: null == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as MealPlan?,
  ));
}
/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealPlanCopyWith<$Res>? get mealPlan {
    if (_self.mealPlan == null) {
    return null;
  }

  return $MealPlanCopyWith<$Res>(_self.mealPlan!, (value) {
    return _then(_self.copyWith(mealPlan: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShoppingEntrySource].
extension ShoppingEntrySourcePatterns on ShoppingEntrySource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingEntrySource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingEntrySource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingEntrySource value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingEntrySource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingEntrySource value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingEntrySource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int listRecipeId,  int? recipeId,  String recipeName,  double servings,  MealPlan? mealPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingEntrySource() when $default != null:
return $default(_that.listRecipeId,_that.recipeId,_that.recipeName,_that.servings,_that.mealPlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int listRecipeId,  int? recipeId,  String recipeName,  double servings,  MealPlan? mealPlan)  $default,) {final _that = this;
switch (_that) {
case _ShoppingEntrySource():
return $default(_that.listRecipeId,_that.recipeId,_that.recipeName,_that.servings,_that.mealPlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int listRecipeId,  int? recipeId,  String recipeName,  double servings,  MealPlan? mealPlan)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingEntrySource() when $default != null:
return $default(_that.listRecipeId,_that.recipeId,_that.recipeName,_that.servings,_that.mealPlan);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingEntrySource implements ShoppingEntrySource {
  const _ShoppingEntrySource({required this.listRecipeId, this.recipeId, this.recipeName = '', required this.servings, this.mealPlan});
  

/// The recipe on the shopping list (Tandoor's `ShoppingListRecipe`). All
/// entries added for the recipe at once share it.
@override final  int listRecipeId;
/// `null` if Tandoor links no recipe.
@override final  int? recipeId;
/// The recipe's name; empty if Tandoor sends none.
@override@JsonKey() final  String recipeName;
/// The servings the amounts were scaled to.
@override final  double servings;
/// The meal plan it was added for, if any.
@override final  MealPlan? mealPlan;

/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingEntrySourceCopyWith<_ShoppingEntrySource> get copyWith => __$ShoppingEntrySourceCopyWithImpl<_ShoppingEntrySource>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingEntrySource&&(identical(other.listRecipeId, listRecipeId) || other.listRecipeId == listRecipeId)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.mealPlan, mealPlan) || other.mealPlan == mealPlan));
}


@override
int get hashCode {
    return Object.hash(runtimeType,listRecipeId,recipeId,recipeName,servings,mealPlan);
}

@override
String toString() {
    return 'ShoppingEntrySource(listRecipeId: $listRecipeId, recipeId: $recipeId, recipeName: $recipeName, servings: $servings, mealPlan: $mealPlan)';
}


}

/// @nodoc
abstract mixin class _$ShoppingEntrySourceCopyWith<$Res> implements $ShoppingEntrySourceCopyWith<$Res> {
  factory _$ShoppingEntrySourceCopyWith(_ShoppingEntrySource value, $Res Function(_ShoppingEntrySource) _then) = __$ShoppingEntrySourceCopyWithImpl;
@override @useResult
$Res call({
 int listRecipeId, int? recipeId, String recipeName, double servings, MealPlan? mealPlan
});


@override $MealPlanCopyWith<$Res>? get mealPlan;

}
/// @nodoc
class __$ShoppingEntrySourceCopyWithImpl<$Res>
    implements _$ShoppingEntrySourceCopyWith<$Res> {
  __$ShoppingEntrySourceCopyWithImpl(this._self, this._then);

  final _ShoppingEntrySource _self;
  final $Res Function(_ShoppingEntrySource) _then;

/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listRecipeId = null,Object? recipeId = freezed,Object? recipeName = null,Object? servings = null,Object? mealPlan = freezed,}) {
  return _then(_ShoppingEntrySource(
listRecipeId: null == listRecipeId ? _self.listRecipeId : listRecipeId // ignore: cast_nullable_to_non_nullable
as int,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int?,recipeName: null == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as MealPlan?,
  ));
}

/// Create a copy of ShoppingEntrySource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealPlanCopyWith<$Res>? get mealPlan {
    if (_self.mealPlan == null) {
    return null;
  }

  return $MealPlanCopyWith<$Res>(_self.mealPlan!, (value) {
    return _then(_self.copyWith(mealPlan: value));
  });
}
}

/// @nodoc
mixin _$ShoppingEntry {

 int get id; ShoppingFood get food;/// `null` for an entry without a unit, such as "2 Eier".
 Unit? get unit;/// 0 for an entry without an amount.
 double get amount; bool get checked;/// When it was checked off; `null` while it is unchecked.
 DateTime? get completedAt;/// When it last changed on the server, including being checked off.
 DateTime get updatedAt; UserRef get createdBy;/// `null` for an item added by hand.
 ShoppingEntrySource? get source;
/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingEntryCopyWith<ShoppingEntry> get copyWith => _$ShoppingEntryCopyWithImpl<ShoppingEntry>(this as ShoppingEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShoppingEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.food, _this.food) || other.food == _this.food)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.checked, _this.checked) || other.checked == _this.checked)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.source, _this.source) || other.source == _this.source));
}


@override
int get hashCode {
  final _this = this as ShoppingEntry;
  return Object.hash(runtimeType,_this.id,_this.food,_this.unit,_this.amount,_this.checked,_this.completedAt,_this.updatedAt,_this.createdBy,_this.source);
}

@override
String toString() {
  final _this = this as ShoppingEntry;
  return 'ShoppingEntry(id: ${_this.id}, food: ${_this.food}, unit: ${_this.unit}, amount: ${_this.amount}, checked: ${_this.checked}, completedAt: ${_this.completedAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $ShoppingEntryCopyWith<$Res>  {
  factory $ShoppingEntryCopyWith(ShoppingEntry value, $Res Function(ShoppingEntry) _then) = _$ShoppingEntryCopyWithImpl;
@useResult
$Res call({
 int id, ShoppingFood food, Unit? unit, double amount, bool checked, DateTime? completedAt, DateTime updatedAt, UserRef createdBy, ShoppingEntrySource? source
});


$ShoppingFoodCopyWith<$Res> get food;$UnitCopyWith<$Res>? get unit;$UserRefCopyWith<$Res> get createdBy;$ShoppingEntrySourceCopyWith<$Res>? get source;

}
/// @nodoc
class _$ShoppingEntryCopyWithImpl<$Res>
    implements $ShoppingEntryCopyWith<$Res> {
  _$ShoppingEntryCopyWithImpl(this._self, this._then);

  final ShoppingEntry _self;
  final $Res Function(ShoppingEntry) _then;

/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? food = null,Object? unit = freezed,Object? amount = null,Object? checked = null,Object? completedAt = freezed,Object? updatedAt = null,Object? createdBy = null,Object? source = freezed,}) {
  return _then(ShoppingEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,food: null == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as ShoppingFood,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ShoppingEntrySource?,
  ));
}
/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShoppingFoodCopyWith<$Res> get food {
  
  return $ShoppingFoodCopyWith<$Res>(_self.food, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res> get createdBy {
  
  return $UserRefCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShoppingEntrySourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $ShoppingEntrySourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShoppingEntry].
extension ShoppingEntryPatterns on ShoppingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingEntry value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ShoppingFood food,  Unit? unit,  double amount,  bool checked,  DateTime? completedAt,  DateTime updatedAt,  UserRef createdBy,  ShoppingEntrySource? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingEntry() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.checked,_that.completedAt,_that.updatedAt,_that.createdBy,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ShoppingFood food,  Unit? unit,  double amount,  bool checked,  DateTime? completedAt,  DateTime updatedAt,  UserRef createdBy,  ShoppingEntrySource? source)  $default,) {final _that = this;
switch (_that) {
case _ShoppingEntry():
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.checked,_that.completedAt,_that.updatedAt,_that.createdBy,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ShoppingFood food,  Unit? unit,  double amount,  bool checked,  DateTime? completedAt,  DateTime updatedAt,  UserRef createdBy,  ShoppingEntrySource? source)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingEntry() when $default != null:
return $default(_that.id,_that.food,_that.unit,_that.amount,_that.checked,_that.completedAt,_that.updatedAt,_that.createdBy,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingEntry implements ShoppingEntry {
  const _ShoppingEntry({required this.id, required this.food, this.unit, required this.amount, this.checked = false, this.completedAt, required this.updatedAt, required this.createdBy, this.source});
  

@override final  int id;
@override final  ShoppingFood food;
/// `null` for an entry without a unit, such as "2 Eier".
@override final  Unit? unit;
/// 0 for an entry without an amount.
@override final  double amount;
@override@JsonKey() final  bool checked;
/// When it was checked off; `null` while it is unchecked.
@override final  DateTime? completedAt;
/// When it last changed on the server, including being checked off.
@override final  DateTime updatedAt;
@override final  UserRef createdBy;
/// `null` for an item added by hand.
@override final  ShoppingEntrySource? source;

/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingEntryCopyWith<_ShoppingEntry> get copyWith => __$ShoppingEntryCopyWithImpl<_ShoppingEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.food, food) || other.food == food)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,food,unit,amount,checked,completedAt,updatedAt,createdBy,source);
}

@override
String toString() {
    return 'ShoppingEntry(id: $id, food: $food, unit: $unit, amount: $amount, checked: $checked, completedAt: $completedAt, updatedAt: $updatedAt, createdBy: $createdBy, source: $source)';
}


}

/// @nodoc
abstract mixin class _$ShoppingEntryCopyWith<$Res> implements $ShoppingEntryCopyWith<$Res> {
  factory _$ShoppingEntryCopyWith(_ShoppingEntry value, $Res Function(_ShoppingEntry) _then) = __$ShoppingEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, ShoppingFood food, Unit? unit, double amount, bool checked, DateTime? completedAt, DateTime updatedAt, UserRef createdBy, ShoppingEntrySource? source
});


@override $ShoppingFoodCopyWith<$Res> get food;@override $UnitCopyWith<$Res>? get unit;@override $UserRefCopyWith<$Res> get createdBy;@override $ShoppingEntrySourceCopyWith<$Res>? get source;

}
/// @nodoc
class __$ShoppingEntryCopyWithImpl<$Res>
    implements _$ShoppingEntryCopyWith<$Res> {
  __$ShoppingEntryCopyWithImpl(this._self, this._then);

  final _ShoppingEntry _self;
  final $Res Function(_ShoppingEntry) _then;

/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? food = null,Object? unit = freezed,Object? amount = null,Object? checked = null,Object? completedAt = freezed,Object? updatedAt = null,Object? createdBy = null,Object? source = freezed,}) {
  return _then(_ShoppingEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,food: null == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as ShoppingFood,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserRef,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ShoppingEntrySource?,
  ));
}

/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShoppingFoodCopyWith<$Res> get food {
  
  return $ShoppingFoodCopyWith<$Res>(_self.food, (value) {
    return _then(_self.copyWith(food: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res> get createdBy {
  
  return $UserRefCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}/// Create a copy of ShoppingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShoppingEntrySourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $ShoppingEntrySourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

/// @nodoc
mixin _$ShoppingListSnapshot {

/// Unchecked entries and entries checked within the user's "recent days"
/// setting, oldest first. After an incremental read, only the entries
/// changed since then.
 List<ShoppingEntry> get entries;/// Pass this as `updatedAfter` to the next read to get only what changed
/// since this one. A minute before the read, so nothing is missed;
/// entries may come again.
 DateTime get syncedAt;/// Whether the list reached [maxShoppingEntries], where the server cuts
/// it off. It keeps the oldest entries, so the newest may be missing; a
/// list of exactly that many entries looks the same.
 bool get truncated;
/// Create a copy of ShoppingListSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingListSnapshotCopyWith<ShoppingListSnapshot> get copyWith => _$ShoppingListSnapshotCopyWithImpl<ShoppingListSnapshot>(this as ShoppingListSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShoppingListSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingListSnapshot&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.syncedAt, _this.syncedAt) || other.syncedAt == _this.syncedAt)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}


@override
int get hashCode {
  final _this = this as ShoppingListSnapshot;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.syncedAt,_this.truncated);
}

@override
String toString() {
  final _this = this as ShoppingListSnapshot;
  return 'ShoppingListSnapshot(entries: ${_this.entries}, syncedAt: ${_this.syncedAt}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $ShoppingListSnapshotCopyWith<$Res>  {
  factory $ShoppingListSnapshotCopyWith(ShoppingListSnapshot value, $Res Function(ShoppingListSnapshot) _then) = _$ShoppingListSnapshotCopyWithImpl;
@useResult
$Res call({
 List<ShoppingEntry> entries, DateTime syncedAt, bool truncated
});




}
/// @nodoc
class _$ShoppingListSnapshotCopyWithImpl<$Res>
    implements $ShoppingListSnapshotCopyWith<$Res> {
  _$ShoppingListSnapshotCopyWithImpl(this._self, this._then);

  final ShoppingListSnapshot _self;
  final $Res Function(ShoppingListSnapshot) _then;

/// Create a copy of ShoppingListSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? syncedAt = null,Object? truncated = null,}) {
  return _then(ShoppingListSnapshot(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<ShoppingEntry>,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingListSnapshot].
extension ShoppingListSnapshotPatterns on ShoppingListSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingListSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingListSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingListSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingListSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingListSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingListSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ShoppingEntry> entries,  DateTime syncedAt,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingListSnapshot() when $default != null:
return $default(_that.entries,_that.syncedAt,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ShoppingEntry> entries,  DateTime syncedAt,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _ShoppingListSnapshot():
return $default(_that.entries,_that.syncedAt,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ShoppingEntry> entries,  DateTime syncedAt,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingListSnapshot() when $default != null:
return $default(_that.entries,_that.syncedAt,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingListSnapshot implements ShoppingListSnapshot {
  const _ShoppingListSnapshot({required  List<ShoppingEntry> entries, required this.syncedAt, this.truncated = false}): _entries = entries;
  

/// Unchecked entries and entries checked within the user's "recent days"
/// setting, oldest first. After an incremental read, only the entries
/// changed since then.
 final  List<ShoppingEntry> _entries;
/// Unchecked entries and entries checked within the user's "recent days"
/// setting, oldest first. After an incremental read, only the entries
/// changed since then.
@override List<ShoppingEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

/// Pass this as `updatedAfter` to the next read to get only what changed
/// since this one. A minute before the read, so nothing is missed;
/// entries may come again.
@override final  DateTime syncedAt;
/// Whether the list reached [maxShoppingEntries], where the server cuts
/// it off. It keeps the oldest entries, so the newest may be missing; a
/// list of exactly that many entries looks the same.
@override@JsonKey() final  bool truncated;

/// Create a copy of ShoppingListSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingListSnapshotCopyWith<_ShoppingListSnapshot> get copyWith => __$ShoppingListSnapshotCopyWithImpl<_ShoppingListSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingListSnapshot&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),syncedAt,truncated);
}

@override
String toString() {
    return 'ShoppingListSnapshot(entries: $entries, syncedAt: $syncedAt, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$ShoppingListSnapshotCopyWith<$Res> implements $ShoppingListSnapshotCopyWith<$Res> {
  factory _$ShoppingListSnapshotCopyWith(_ShoppingListSnapshot value, $Res Function(_ShoppingListSnapshot) _then) = __$ShoppingListSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<ShoppingEntry> entries, DateTime syncedAt, bool truncated
});




}
/// @nodoc
class __$ShoppingListSnapshotCopyWithImpl<$Res>
    implements _$ShoppingListSnapshotCopyWith<$Res> {
  __$ShoppingListSnapshotCopyWithImpl(this._self, this._then);

  final _ShoppingListSnapshot _self;
  final $Res Function(_ShoppingListSnapshot) _then;

/// Create a copy of ShoppingListSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? syncedAt = null,Object? truncated = null,}) {
  return _then(_ShoppingListSnapshot(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<ShoppingEntry>,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_flat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeFlat extends RecipeFlat {
  @override
  final int? id;
  @override
  final String? image;
  @override
  final String? name;

  factory _$RecipeFlat([void Function(RecipeFlatBuilder)? updates]) =>
      (RecipeFlatBuilder()..update(updates))._build();

  _$RecipeFlat._({this.id, this.image, this.name}) : super._();
  @override
  RecipeFlat rebuild(void Function(RecipeFlatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeFlatBuilder toBuilder() => RecipeFlatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeFlat &&
        id == other.id &&
        image == other.image &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeFlat')
          ..add('id', id)
          ..add('image', image)
          ..add('name', name))
        .toString();
  }
}

class RecipeFlatBuilder implements Builder<RecipeFlat, RecipeFlatBuilder> {
  _$RecipeFlat? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RecipeFlatBuilder() {
    RecipeFlat._defaults(this);
  }

  RecipeFlatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _image = $v.image;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeFlat other) {
    _$v = other as _$RecipeFlat;
  }

  @override
  void update(void Function(RecipeFlatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeFlat build() => _build();

  _$RecipeFlat _build() {
    final _$result = _$v ?? _$RecipeFlat._(id: id, image: image, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_supermarket_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedSupermarketCategory extends PatchedSupermarketCategory {
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? openDataSlug;

  factory _$PatchedSupermarketCategory([
    void Function(PatchedSupermarketCategoryBuilder)? updates,
  ]) => (PatchedSupermarketCategoryBuilder()..update(updates))._build();

  _$PatchedSupermarketCategory._({
    this.description,
    this.id,
    this.name,
    this.openDataSlug,
  }) : super._();
  @override
  PatchedSupermarketCategory rebuild(
    void Function(PatchedSupermarketCategoryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedSupermarketCategoryBuilder toBuilder() =>
      PatchedSupermarketCategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedSupermarketCategory &&
        description == other.description &&
        id == other.id &&
        name == other.name &&
        openDataSlug == other.openDataSlug;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedSupermarketCategory')
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug))
        .toString();
  }
}

class PatchedSupermarketCategoryBuilder
    implements
        Builder<PatchedSupermarketCategory, PatchedSupermarketCategoryBuilder> {
  _$PatchedSupermarketCategory? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _openDataSlug;
  String? get openDataSlug => _$this._openDataSlug;
  set openDataSlug(String? openDataSlug) => _$this._openDataSlug = openDataSlug;

  PatchedSupermarketCategoryBuilder() {
    PatchedSupermarketCategory._defaults(this);
  }

  PatchedSupermarketCategoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _id = $v.id;
      _name = $v.name;
      _openDataSlug = $v.openDataSlug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedSupermarketCategory other) {
    _$v = other as _$PatchedSupermarketCategory;
  }

  @override
  void update(void Function(PatchedSupermarketCategoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedSupermarketCategory build() => _build();

  _$PatchedSupermarketCategory _build() {
    final _$result =
        _$v ??
        _$PatchedSupermarketCategory._(
          description: description,
          id: id,
          name: name,
          openDataSlug: openDataSlug,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

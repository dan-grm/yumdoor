// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supermarket_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupermarketCategory extends SupermarketCategory {
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? openDataSlug;

  factory _$SupermarketCategory([
    void Function(SupermarketCategoryBuilder)? updates,
  ]) => (SupermarketCategoryBuilder()..update(updates))._build();

  _$SupermarketCategory._({
    this.description,
    this.id,
    required this.name,
    this.openDataSlug,
  }) : super._();
  @override
  SupermarketCategory rebuild(
    void Function(SupermarketCategoryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SupermarketCategoryBuilder toBuilder() =>
      SupermarketCategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupermarketCategory &&
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
    return (newBuiltValueToStringHelper(r'SupermarketCategory')
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug))
        .toString();
  }
}

class SupermarketCategoryBuilder
    implements Builder<SupermarketCategory, SupermarketCategoryBuilder> {
  _$SupermarketCategory? _$v;

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

  SupermarketCategoryBuilder() {
    SupermarketCategory._defaults(this);
  }

  SupermarketCategoryBuilder get _$this {
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
  void replace(SupermarketCategory other) {
    _$v = other as _$SupermarketCategory;
  }

  @override
  void update(void Function(SupermarketCategoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupermarketCategory build() => _build();

  _$SupermarketCategory _build() {
    final _$result =
        _$v ??
        _$SupermarketCategory._(
          description: description,
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SupermarketCategory',
            'name',
          ),
          openDataSlug: openDataSlug,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

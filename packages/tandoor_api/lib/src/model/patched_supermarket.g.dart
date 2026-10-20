// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_supermarket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedSupermarket extends PatchedSupermarket {
  @override
  final BuiltList<SupermarketCategoryRelation>? categoryToSupermarket;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? openDataSlug;
  @override
  final BuiltList<ShoppingList>? shoppingLists;

  factory _$PatchedSupermarket([
    void Function(PatchedSupermarketBuilder)? updates,
  ]) => (PatchedSupermarketBuilder()..update(updates))._build();

  _$PatchedSupermarket._({
    this.categoryToSupermarket,
    this.description,
    this.id,
    this.name,
    this.openDataSlug,
    this.shoppingLists,
  }) : super._();
  @override
  PatchedSupermarket rebuild(
    void Function(PatchedSupermarketBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedSupermarketBuilder toBuilder() =>
      PatchedSupermarketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedSupermarket &&
        categoryToSupermarket == other.categoryToSupermarket &&
        description == other.description &&
        id == other.id &&
        name == other.name &&
        openDataSlug == other.openDataSlug &&
        shoppingLists == other.shoppingLists;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryToSupermarket.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jc(_$hash, shoppingLists.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedSupermarket')
          ..add('categoryToSupermarket', categoryToSupermarket)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug)
          ..add('shoppingLists', shoppingLists))
        .toString();
  }
}

class PatchedSupermarketBuilder
    implements Builder<PatchedSupermarket, PatchedSupermarketBuilder> {
  _$PatchedSupermarket? _$v;

  ListBuilder<SupermarketCategoryRelation>? _categoryToSupermarket;
  ListBuilder<SupermarketCategoryRelation> get categoryToSupermarket =>
      _$this._categoryToSupermarket ??=
          ListBuilder<SupermarketCategoryRelation>();
  set categoryToSupermarket(
    ListBuilder<SupermarketCategoryRelation>? categoryToSupermarket,
  ) => _$this._categoryToSupermarket = categoryToSupermarket;

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

  ListBuilder<ShoppingList>? _shoppingLists;
  ListBuilder<ShoppingList> get shoppingLists =>
      _$this._shoppingLists ??= ListBuilder<ShoppingList>();
  set shoppingLists(ListBuilder<ShoppingList>? shoppingLists) =>
      _$this._shoppingLists = shoppingLists;

  PatchedSupermarketBuilder() {
    PatchedSupermarket._defaults(this);
  }

  PatchedSupermarketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryToSupermarket = $v.categoryToSupermarket?.toBuilder();
      _description = $v.description;
      _id = $v.id;
      _name = $v.name;
      _openDataSlug = $v.openDataSlug;
      _shoppingLists = $v.shoppingLists?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedSupermarket other) {
    _$v = other as _$PatchedSupermarket;
  }

  @override
  void update(void Function(PatchedSupermarketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedSupermarket build() => _build();

  _$PatchedSupermarket _build() {
    _$PatchedSupermarket _$result;
    try {
      _$result =
          _$v ??
          _$PatchedSupermarket._(
            categoryToSupermarket: _categoryToSupermarket?.build(),
            description: description,
            id: id,
            name: name,
            openDataSlug: openDataSlug,
            shoppingLists: _shoppingLists?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryToSupermarket';
        _categoryToSupermarket?.build();

        _$failedField = 'shoppingLists';
        _shoppingLists?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedSupermarket',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

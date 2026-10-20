// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supermarket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Supermarket extends Supermarket {
  @override
  final BuiltList<SupermarketCategoryRelation>? categoryToSupermarket;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? openDataSlug;
  @override
  final BuiltList<ShoppingList>? shoppingLists;

  factory _$Supermarket([void Function(SupermarketBuilder)? updates]) =>
      (SupermarketBuilder()..update(updates))._build();

  _$Supermarket._({
    this.categoryToSupermarket,
    this.description,
    this.id,
    required this.name,
    this.openDataSlug,
    this.shoppingLists,
  }) : super._();
  @override
  Supermarket rebuild(void Function(SupermarketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupermarketBuilder toBuilder() => SupermarketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Supermarket &&
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
    return (newBuiltValueToStringHelper(r'Supermarket')
          ..add('categoryToSupermarket', categoryToSupermarket)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug)
          ..add('shoppingLists', shoppingLists))
        .toString();
  }
}

class SupermarketBuilder implements Builder<Supermarket, SupermarketBuilder> {
  _$Supermarket? _$v;

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

  SupermarketBuilder() {
    Supermarket._defaults(this);
  }

  SupermarketBuilder get _$this {
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
  void replace(Supermarket other) {
    _$v = other as _$Supermarket;
  }

  @override
  void update(void Function(SupermarketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Supermarket build() => _build();

  _$Supermarket _build() {
    _$Supermarket _$result;
    try {
      _$result =
          _$v ??
          _$Supermarket._(
            categoryToSupermarket: _categoryToSupermarket?.build(),
            description: description,
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Supermarket',
              'name',
            ),
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
          r'Supermarket',
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

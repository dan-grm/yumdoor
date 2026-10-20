// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_shopping.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodShopping extends FoodShopping {
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? pluralName;
  @override
  final BuiltList<ShoppingList>? shoppingLists;
  @override
  final SupermarketCategory? supermarketCategory;

  factory _$FoodShopping([void Function(FoodShoppingBuilder)? updates]) =>
      (FoodShoppingBuilder()..update(updates))._build();

  _$FoodShopping._({
    this.id,
    required this.name,
    this.pluralName,
    this.shoppingLists,
    this.supermarketCategory,
  }) : super._();
  @override
  FoodShopping rebuild(void Function(FoodShoppingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodShoppingBuilder toBuilder() => FoodShoppingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodShopping &&
        id == other.id &&
        name == other.name &&
        pluralName == other.pluralName &&
        shoppingLists == other.shoppingLists &&
        supermarketCategory == other.supermarketCategory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, pluralName.hashCode);
    _$hash = $jc(_$hash, shoppingLists.hashCode);
    _$hash = $jc(_$hash, supermarketCategory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodShopping')
          ..add('id', id)
          ..add('name', name)
          ..add('pluralName', pluralName)
          ..add('shoppingLists', shoppingLists)
          ..add('supermarketCategory', supermarketCategory))
        .toString();
  }
}

class FoodShoppingBuilder
    implements Builder<FoodShopping, FoodShoppingBuilder> {
  _$FoodShopping? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _pluralName;
  String? get pluralName => _$this._pluralName;
  set pluralName(String? pluralName) => _$this._pluralName = pluralName;

  ListBuilder<ShoppingList>? _shoppingLists;
  ListBuilder<ShoppingList> get shoppingLists =>
      _$this._shoppingLists ??= ListBuilder<ShoppingList>();
  set shoppingLists(ListBuilder<ShoppingList>? shoppingLists) =>
      _$this._shoppingLists = shoppingLists;

  SupermarketCategoryBuilder? _supermarketCategory;
  SupermarketCategoryBuilder get supermarketCategory =>
      _$this._supermarketCategory ??= SupermarketCategoryBuilder();
  set supermarketCategory(SupermarketCategoryBuilder? supermarketCategory) =>
      _$this._supermarketCategory = supermarketCategory;

  FoodShoppingBuilder() {
    FoodShopping._defaults(this);
  }

  FoodShoppingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _pluralName = $v.pluralName;
      _shoppingLists = $v.shoppingLists?.toBuilder();
      _supermarketCategory = $v.supermarketCategory?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodShopping other) {
    _$v = other as _$FoodShopping;
  }

  @override
  void update(void Function(FoodShoppingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodShopping build() => _build();

  _$FoodShopping _build() {
    _$FoodShopping _$result;
    try {
      _$result =
          _$v ??
          _$FoodShopping._(
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'FoodShopping',
              'name',
            ),
            pluralName: pluralName,
            shoppingLists: _shoppingLists?.build(),
            supermarketCategory: _supermarketCategory?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shoppingLists';
        _shoppingLists?.build();
        _$failedField = 'supermarketCategory';
        _supermarketCategory?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FoodShopping',
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

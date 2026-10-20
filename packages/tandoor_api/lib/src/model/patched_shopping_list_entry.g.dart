// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_shopping_list_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedShoppingListEntry extends PatchedShoppingListEntry {
  @override
  final double? amount;
  @override
  final bool? checked;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
  @override
  final DateTime? delayUntil;
  @override
  final FoodShopping? food;
  @override
  final int? id;
  @override
  final int? ingredient;
  @override
  final int? listRecipe;
  @override
  final ShoppingListRecipe? listRecipeData;
  @override
  final int? mealplanId;
  @override
  final int? order;
  @override
  final BuiltList<ShoppingList>? shoppingLists;
  @override
  final Unit? unit;
  @override
  final DateTime? updatedAt;

  factory _$PatchedShoppingListEntry([
    void Function(PatchedShoppingListEntryBuilder)? updates,
  ]) => (PatchedShoppingListEntryBuilder()..update(updates))._build();

  _$PatchedShoppingListEntry._({
    this.amount,
    this.checked,
    this.completedAt,
    this.createdAt,
    this.createdBy,
    this.delayUntil,
    this.food,
    this.id,
    this.ingredient,
    this.listRecipe,
    this.listRecipeData,
    this.mealplanId,
    this.order,
    this.shoppingLists,
    this.unit,
    this.updatedAt,
  }) : super._();
  @override
  PatchedShoppingListEntry rebuild(
    void Function(PatchedShoppingListEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedShoppingListEntryBuilder toBuilder() =>
      PatchedShoppingListEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedShoppingListEntry &&
        amount == other.amount &&
        checked == other.checked &&
        completedAt == other.completedAt &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        delayUntil == other.delayUntil &&
        food == other.food &&
        id == other.id &&
        ingredient == other.ingredient &&
        listRecipe == other.listRecipe &&
        listRecipeData == other.listRecipeData &&
        mealplanId == other.mealplanId &&
        order == other.order &&
        shoppingLists == other.shoppingLists &&
        unit == other.unit &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, checked.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, delayUntil.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ingredient.hashCode);
    _$hash = $jc(_$hash, listRecipe.hashCode);
    _$hash = $jc(_$hash, listRecipeData.hashCode);
    _$hash = $jc(_$hash, mealplanId.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, shoppingLists.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedShoppingListEntry')
          ..add('amount', amount)
          ..add('checked', checked)
          ..add('completedAt', completedAt)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('delayUntil', delayUntil)
          ..add('food', food)
          ..add('id', id)
          ..add('ingredient', ingredient)
          ..add('listRecipe', listRecipe)
          ..add('listRecipeData', listRecipeData)
          ..add('mealplanId', mealplanId)
          ..add('order', order)
          ..add('shoppingLists', shoppingLists)
          ..add('unit', unit)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PatchedShoppingListEntryBuilder
    implements
        Builder<PatchedShoppingListEntry, PatchedShoppingListEntryBuilder> {
  _$PatchedShoppingListEntry? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  bool? _checked;
  bool? get checked => _$this._checked;
  set checked(bool? checked) => _$this._checked = checked;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  DateTime? _delayUntil;
  DateTime? get delayUntil => _$this._delayUntil;
  set delayUntil(DateTime? delayUntil) => _$this._delayUntil = delayUntil;

  FoodShoppingBuilder? _food;
  FoodShoppingBuilder get food => _$this._food ??= FoodShoppingBuilder();
  set food(FoodShoppingBuilder? food) => _$this._food = food;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _ingredient;
  int? get ingredient => _$this._ingredient;
  set ingredient(int? ingredient) => _$this._ingredient = ingredient;

  int? _listRecipe;
  int? get listRecipe => _$this._listRecipe;
  set listRecipe(int? listRecipe) => _$this._listRecipe = listRecipe;

  ShoppingListRecipeBuilder? _listRecipeData;
  ShoppingListRecipeBuilder get listRecipeData =>
      _$this._listRecipeData ??= ShoppingListRecipeBuilder();
  set listRecipeData(ShoppingListRecipeBuilder? listRecipeData) =>
      _$this._listRecipeData = listRecipeData;

  int? _mealplanId;
  int? get mealplanId => _$this._mealplanId;
  set mealplanId(int? mealplanId) => _$this._mealplanId = mealplanId;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  ListBuilder<ShoppingList>? _shoppingLists;
  ListBuilder<ShoppingList> get shoppingLists =>
      _$this._shoppingLists ??= ListBuilder<ShoppingList>();
  set shoppingLists(ListBuilder<ShoppingList>? shoppingLists) =>
      _$this._shoppingLists = shoppingLists;

  UnitBuilder? _unit;
  UnitBuilder get unit => _$this._unit ??= UnitBuilder();
  set unit(UnitBuilder? unit) => _$this._unit = unit;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PatchedShoppingListEntryBuilder() {
    PatchedShoppingListEntry._defaults(this);
  }

  PatchedShoppingListEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _checked = $v.checked;
      _completedAt = $v.completedAt;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
      _delayUntil = $v.delayUntil;
      _food = $v.food?.toBuilder();
      _id = $v.id;
      _ingredient = $v.ingredient;
      _listRecipe = $v.listRecipe;
      _listRecipeData = $v.listRecipeData?.toBuilder();
      _mealplanId = $v.mealplanId;
      _order = $v.order;
      _shoppingLists = $v.shoppingLists?.toBuilder();
      _unit = $v.unit?.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedShoppingListEntry other) {
    _$v = other as _$PatchedShoppingListEntry;
  }

  @override
  void update(void Function(PatchedShoppingListEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedShoppingListEntry build() => _build();

  _$PatchedShoppingListEntry _build() {
    _$PatchedShoppingListEntry _$result;
    try {
      _$result =
          _$v ??
          _$PatchedShoppingListEntry._(
            amount: amount,
            checked: checked,
            completedAt: completedAt,
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            delayUntil: delayUntil,
            food: _food?.build(),
            id: id,
            ingredient: ingredient,
            listRecipe: listRecipe,
            listRecipeData: _listRecipeData?.build(),
            mealplanId: mealplanId,
            order: order,
            shoppingLists: _shoppingLists?.build(),
            unit: _unit?.build(),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();

        _$failedField = 'food';
        _food?.build();

        _$failedField = 'listRecipeData';
        _listRecipeData?.build();

        _$failedField = 'shoppingLists';
        _shoppingLists?.build();
        _$failedField = 'unit';
        _unit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedShoppingListEntry',
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

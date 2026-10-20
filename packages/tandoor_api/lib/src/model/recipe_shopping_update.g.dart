// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_shopping_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeShoppingUpdate extends RecipeShoppingUpdate {
  @override
  final int? id;
  @override
  final BuiltList<int?> ingredients;
  @override
  final int? listRecipe;
  @override
  final int? servings;

  factory _$RecipeShoppingUpdate([
    void Function(RecipeShoppingUpdateBuilder)? updates,
  ]) => (RecipeShoppingUpdateBuilder()..update(updates))._build();

  _$RecipeShoppingUpdate._({
    this.id,
    required this.ingredients,
    this.listRecipe,
    this.servings,
  }) : super._();
  @override
  RecipeShoppingUpdate rebuild(
    void Function(RecipeShoppingUpdateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RecipeShoppingUpdateBuilder toBuilder() =>
      RecipeShoppingUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeShoppingUpdate &&
        id == other.id &&
        ingredients == other.ingredients &&
        listRecipe == other.listRecipe &&
        servings == other.servings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ingredients.hashCode);
    _$hash = $jc(_$hash, listRecipe.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeShoppingUpdate')
          ..add('id', id)
          ..add('ingredients', ingredients)
          ..add('listRecipe', listRecipe)
          ..add('servings', servings))
        .toString();
  }
}

class RecipeShoppingUpdateBuilder
    implements Builder<RecipeShoppingUpdate, RecipeShoppingUpdateBuilder> {
  _$RecipeShoppingUpdate? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<int?>? _ingredients;
  ListBuilder<int?> get ingredients =>
      _$this._ingredients ??= ListBuilder<int?>();
  set ingredients(ListBuilder<int?>? ingredients) =>
      _$this._ingredients = ingredients;

  int? _listRecipe;
  int? get listRecipe => _$this._listRecipe;
  set listRecipe(int? listRecipe) => _$this._listRecipe = listRecipe;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  RecipeShoppingUpdateBuilder() {
    RecipeShoppingUpdate._defaults(this);
  }

  RecipeShoppingUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ingredients = $v.ingredients.toBuilder();
      _listRecipe = $v.listRecipe;
      _servings = $v.servings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeShoppingUpdate other) {
    _$v = other as _$RecipeShoppingUpdate;
  }

  @override
  void update(void Function(RecipeShoppingUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeShoppingUpdate build() => _build();

  _$RecipeShoppingUpdate _build() {
    _$RecipeShoppingUpdate _$result;
    try {
      _$result =
          _$v ??
          _$RecipeShoppingUpdate._(
            id: id,
            ingredients: ingredients.build(),
            listRecipe: listRecipe,
            servings: servings,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ingredients';
        ingredients.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeShoppingUpdate',
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

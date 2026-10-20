// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_shopping_list_recipe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedShoppingListRecipe extends PatchedShoppingListRecipe {
  @override
  final User? createdBy;
  @override
  final int? id;
  @override
  final MealPlan? mealPlanData;
  @override
  final int? mealplan;
  @override
  final String? name;
  @override
  final int? recipe;
  @override
  final RecipeOverview? recipeData;
  @override
  final double? servings;

  factory _$PatchedShoppingListRecipe([
    void Function(PatchedShoppingListRecipeBuilder)? updates,
  ]) => (PatchedShoppingListRecipeBuilder()..update(updates))._build();

  _$PatchedShoppingListRecipe._({
    this.createdBy,
    this.id,
    this.mealPlanData,
    this.mealplan,
    this.name,
    this.recipe,
    this.recipeData,
    this.servings,
  }) : super._();
  @override
  PatchedShoppingListRecipe rebuild(
    void Function(PatchedShoppingListRecipeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedShoppingListRecipeBuilder toBuilder() =>
      PatchedShoppingListRecipeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedShoppingListRecipe &&
        createdBy == other.createdBy &&
        id == other.id &&
        mealPlanData == other.mealPlanData &&
        mealplan == other.mealplan &&
        name == other.name &&
        recipe == other.recipe &&
        recipeData == other.recipeData &&
        servings == other.servings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mealPlanData.hashCode);
    _$hash = $jc(_$hash, mealplan.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, recipeData.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedShoppingListRecipe')
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('mealPlanData', mealPlanData)
          ..add('mealplan', mealplan)
          ..add('name', name)
          ..add('recipe', recipe)
          ..add('recipeData', recipeData)
          ..add('servings', servings))
        .toString();
  }
}

class PatchedShoppingListRecipeBuilder
    implements
        Builder<PatchedShoppingListRecipe, PatchedShoppingListRecipeBuilder> {
  _$PatchedShoppingListRecipe? _$v;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  MealPlanBuilder? _mealPlanData;
  MealPlanBuilder get mealPlanData =>
      _$this._mealPlanData ??= MealPlanBuilder();
  set mealPlanData(MealPlanBuilder? mealPlanData) =>
      _$this._mealPlanData = mealPlanData;

  int? _mealplan;
  int? get mealplan => _$this._mealplan;
  set mealplan(int? mealplan) => _$this._mealplan = mealplan;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _recipe;
  int? get recipe => _$this._recipe;
  set recipe(int? recipe) => _$this._recipe = recipe;

  RecipeOverviewBuilder? _recipeData;
  RecipeOverviewBuilder get recipeData =>
      _$this._recipeData ??= RecipeOverviewBuilder();
  set recipeData(RecipeOverviewBuilder? recipeData) =>
      _$this._recipeData = recipeData;

  double? _servings;
  double? get servings => _$this._servings;
  set servings(double? servings) => _$this._servings = servings;

  PatchedShoppingListRecipeBuilder() {
    PatchedShoppingListRecipe._defaults(this);
  }

  PatchedShoppingListRecipeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy?.toBuilder();
      _id = $v.id;
      _mealPlanData = $v.mealPlanData?.toBuilder();
      _mealplan = $v.mealplan;
      _name = $v.name;
      _recipe = $v.recipe;
      _recipeData = $v.recipeData?.toBuilder();
      _servings = $v.servings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedShoppingListRecipe other) {
    _$v = other as _$PatchedShoppingListRecipe;
  }

  @override
  void update(void Function(PatchedShoppingListRecipeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedShoppingListRecipe build() => _build();

  _$PatchedShoppingListRecipe _build() {
    _$PatchedShoppingListRecipe _$result;
    try {
      _$result =
          _$v ??
          _$PatchedShoppingListRecipe._(
            createdBy: _createdBy?.build(),
            id: id,
            mealPlanData: _mealPlanData?.build(),
            mealplan: mealplan,
            name: name,
            recipe: recipe,
            recipeData: _recipeData?.build(),
            servings: servings,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();

        _$failedField = 'mealPlanData';
        _mealPlanData?.build();

        _$failedField = 'recipeData';
        _recipeData?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedShoppingListRecipe',
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

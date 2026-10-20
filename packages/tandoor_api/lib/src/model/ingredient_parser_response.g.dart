// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_parser_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientParserResponse extends IngredientParserResponse {
  @override
  final IngredientSimple? ingredient;
  @override
  final BuiltList<IngredientSimple> ingredients;

  factory _$IngredientParserResponse([
    void Function(IngredientParserResponseBuilder)? updates,
  ]) => (IngredientParserResponseBuilder()..update(updates))._build();

  _$IngredientParserResponse._({this.ingredient, required this.ingredients})
    : super._();
  @override
  IngredientParserResponse rebuild(
    void Function(IngredientParserResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  IngredientParserResponseBuilder toBuilder() =>
      IngredientParserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientParserResponse &&
        ingredient == other.ingredient &&
        ingredients == other.ingredients;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ingredient.hashCode);
    _$hash = $jc(_$hash, ingredients.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientParserResponse')
          ..add('ingredient', ingredient)
          ..add('ingredients', ingredients))
        .toString();
  }
}

class IngredientParserResponseBuilder
    implements
        Builder<IngredientParserResponse, IngredientParserResponseBuilder> {
  _$IngredientParserResponse? _$v;

  IngredientSimpleBuilder? _ingredient;
  IngredientSimpleBuilder get ingredient =>
      _$this._ingredient ??= IngredientSimpleBuilder();
  set ingredient(IngredientSimpleBuilder? ingredient) =>
      _$this._ingredient = ingredient;

  ListBuilder<IngredientSimple>? _ingredients;
  ListBuilder<IngredientSimple> get ingredients =>
      _$this._ingredients ??= ListBuilder<IngredientSimple>();
  set ingredients(ListBuilder<IngredientSimple>? ingredients) =>
      _$this._ingredients = ingredients;

  IngredientParserResponseBuilder() {
    IngredientParserResponse._defaults(this);
  }

  IngredientParserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredient = $v.ingredient?.toBuilder();
      _ingredients = $v.ingredients.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientParserResponse other) {
    _$v = other as _$IngredientParserResponse;
  }

  @override
  void update(void Function(IngredientParserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientParserResponse build() => _build();

  _$IngredientParserResponse _build() {
    _$IngredientParserResponse _$result;
    try {
      _$result =
          _$v ??
          _$IngredientParserResponse._(
            ingredient: _ingredient?.build(),
            ingredients: ingredients.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ingredient';
        _ingredient?.build();
        _$failedField = 'ingredients';
        ingredients.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'IngredientParserResponse',
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

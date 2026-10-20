// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_parser_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientParserRequest extends IngredientParserRequest {
  @override
  final String? ingredient;
  @override
  final BuiltList<String>? ingredients;

  factory _$IngredientParserRequest([
    void Function(IngredientParserRequestBuilder)? updates,
  ]) => (IngredientParserRequestBuilder()..update(updates))._build();

  _$IngredientParserRequest._({this.ingredient, this.ingredients}) : super._();
  @override
  IngredientParserRequest rebuild(
    void Function(IngredientParserRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  IngredientParserRequestBuilder toBuilder() =>
      IngredientParserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientParserRequest &&
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
    return (newBuiltValueToStringHelper(r'IngredientParserRequest')
          ..add('ingredient', ingredient)
          ..add('ingredients', ingredients))
        .toString();
  }
}

class IngredientParserRequestBuilder
    implements
        Builder<IngredientParserRequest, IngredientParserRequestBuilder> {
  _$IngredientParserRequest? _$v;

  String? _ingredient;
  String? get ingredient => _$this._ingredient;
  set ingredient(String? ingredient) => _$this._ingredient = ingredient;

  ListBuilder<String>? _ingredients;
  ListBuilder<String> get ingredients =>
      _$this._ingredients ??= ListBuilder<String>();
  set ingredients(ListBuilder<String>? ingredients) =>
      _$this._ingredients = ingredients;

  IngredientParserRequestBuilder() {
    IngredientParserRequest._defaults(this);
  }

  IngredientParserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredient = $v.ingredient;
      _ingredients = $v.ingredients?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientParserRequest other) {
    _$v = other as _$IngredientParserRequest;
  }

  @override
  void update(void Function(IngredientParserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientParserRequest build() => _build();

  _$IngredientParserRequest _build() {
    _$IngredientParserRequest _$result;
    try {
      _$result =
          _$v ??
          _$IngredientParserRequest._(
            ingredient: ingredient,
            ingredients: _ingredients?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ingredients';
        _ingredients?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'IngredientParserRequest',
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

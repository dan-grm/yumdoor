// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_from_source_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeFromSourceResponse extends RecipeFromSourceResponse {
  @override
  final BuiltList<SourceImportDuplicate>? duplicates;
  @override
  final bool? error;
  @override
  final BuiltList<String>? images;
  @override
  final String? msg;
  @override
  final SourceImportRecipe? recipe;
  @override
  final int? recipeId;

  factory _$RecipeFromSourceResponse([
    void Function(RecipeFromSourceResponseBuilder)? updates,
  ]) => (RecipeFromSourceResponseBuilder()..update(updates))._build();

  _$RecipeFromSourceResponse._({
    this.duplicates,
    this.error,
    this.images,
    this.msg,
    this.recipe,
    this.recipeId,
  }) : super._();
  @override
  RecipeFromSourceResponse rebuild(
    void Function(RecipeFromSourceResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RecipeFromSourceResponseBuilder toBuilder() =>
      RecipeFromSourceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeFromSourceResponse &&
        duplicates == other.duplicates &&
        error == other.error &&
        images == other.images &&
        msg == other.msg &&
        recipe == other.recipe &&
        recipeId == other.recipeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duplicates.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, recipeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeFromSourceResponse')
          ..add('duplicates', duplicates)
          ..add('error', error)
          ..add('images', images)
          ..add('msg', msg)
          ..add('recipe', recipe)
          ..add('recipeId', recipeId))
        .toString();
  }
}

class RecipeFromSourceResponseBuilder
    implements
        Builder<RecipeFromSourceResponse, RecipeFromSourceResponseBuilder> {
  _$RecipeFromSourceResponse? _$v;

  ListBuilder<SourceImportDuplicate>? _duplicates;
  ListBuilder<SourceImportDuplicate> get duplicates =>
      _$this._duplicates ??= ListBuilder<SourceImportDuplicate>();
  set duplicates(ListBuilder<SourceImportDuplicate>? duplicates) =>
      _$this._duplicates = duplicates;

  bool? _error;
  bool? get error => _$this._error;
  set error(bool? error) => _$this._error = error;

  ListBuilder<String>? _images;
  ListBuilder<String> get images => _$this._images ??= ListBuilder<String>();
  set images(ListBuilder<String>? images) => _$this._images = images;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  SourceImportRecipeBuilder? _recipe;
  SourceImportRecipeBuilder get recipe =>
      _$this._recipe ??= SourceImportRecipeBuilder();
  set recipe(SourceImportRecipeBuilder? recipe) => _$this._recipe = recipe;

  int? _recipeId;
  int? get recipeId => _$this._recipeId;
  set recipeId(int? recipeId) => _$this._recipeId = recipeId;

  RecipeFromSourceResponseBuilder() {
    RecipeFromSourceResponse._defaults(this);
  }

  RecipeFromSourceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duplicates = $v.duplicates?.toBuilder();
      _error = $v.error;
      _images = $v.images?.toBuilder();
      _msg = $v.msg;
      _recipe = $v.recipe?.toBuilder();
      _recipeId = $v.recipeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeFromSourceResponse other) {
    _$v = other as _$RecipeFromSourceResponse;
  }

  @override
  void update(void Function(RecipeFromSourceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeFromSourceResponse build() => _build();

  _$RecipeFromSourceResponse _build() {
    _$RecipeFromSourceResponse _$result;
    try {
      _$result =
          _$v ??
          _$RecipeFromSourceResponse._(
            duplicates: _duplicates?.build(),
            error: error,
            images: _images?.build(),
            msg: msg,
            recipe: _recipe?.build(),
            recipeId: recipeId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'duplicates';
        _duplicates?.build();

        _$failedField = 'images';
        _images?.build();

        _$failedField = 'recipe';
        _recipe?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeFromSourceResponse',
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

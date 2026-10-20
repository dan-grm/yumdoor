// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_recipe_book_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedRecipeBookEntry extends PatchedRecipeBookEntry {
  @override
  final int? book;
  @override
  final RecipeBook? bookContent;
  @override
  final int? id;
  @override
  final int? recipe;
  @override
  final RecipeOverview? recipeContent;

  factory _$PatchedRecipeBookEntry([
    void Function(PatchedRecipeBookEntryBuilder)? updates,
  ]) => (PatchedRecipeBookEntryBuilder()..update(updates))._build();

  _$PatchedRecipeBookEntry._({
    this.book,
    this.bookContent,
    this.id,
    this.recipe,
    this.recipeContent,
  }) : super._();
  @override
  PatchedRecipeBookEntry rebuild(
    void Function(PatchedRecipeBookEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedRecipeBookEntryBuilder toBuilder() =>
      PatchedRecipeBookEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedRecipeBookEntry &&
        book == other.book &&
        bookContent == other.bookContent &&
        id == other.id &&
        recipe == other.recipe &&
        recipeContent == other.recipeContent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, book.hashCode);
    _$hash = $jc(_$hash, bookContent.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, recipeContent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedRecipeBookEntry')
          ..add('book', book)
          ..add('bookContent', bookContent)
          ..add('id', id)
          ..add('recipe', recipe)
          ..add('recipeContent', recipeContent))
        .toString();
  }
}

class PatchedRecipeBookEntryBuilder
    implements Builder<PatchedRecipeBookEntry, PatchedRecipeBookEntryBuilder> {
  _$PatchedRecipeBookEntry? _$v;

  int? _book;
  int? get book => _$this._book;
  set book(int? book) => _$this._book = book;

  RecipeBookBuilder? _bookContent;
  RecipeBookBuilder get bookContent =>
      _$this._bookContent ??= RecipeBookBuilder();
  set bookContent(RecipeBookBuilder? bookContent) =>
      _$this._bookContent = bookContent;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _recipe;
  int? get recipe => _$this._recipe;
  set recipe(int? recipe) => _$this._recipe = recipe;

  RecipeOverviewBuilder? _recipeContent;
  RecipeOverviewBuilder get recipeContent =>
      _$this._recipeContent ??= RecipeOverviewBuilder();
  set recipeContent(RecipeOverviewBuilder? recipeContent) =>
      _$this._recipeContent = recipeContent;

  PatchedRecipeBookEntryBuilder() {
    PatchedRecipeBookEntry._defaults(this);
  }

  PatchedRecipeBookEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _book = $v.book;
      _bookContent = $v.bookContent?.toBuilder();
      _id = $v.id;
      _recipe = $v.recipe;
      _recipeContent = $v.recipeContent?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedRecipeBookEntry other) {
    _$v = other as _$PatchedRecipeBookEntry;
  }

  @override
  void update(void Function(PatchedRecipeBookEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedRecipeBookEntry build() => _build();

  _$PatchedRecipeBookEntry _build() {
    _$PatchedRecipeBookEntry _$result;
    try {
      _$result =
          _$v ??
          _$PatchedRecipeBookEntry._(
            book: book,
            bookContent: _bookContent?.build(),
            id: id,
            recipe: recipe,
            recipeContent: _recipeContent?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bookContent';
        _bookContent?.build();

        _$failedField = 'recipeContent';
        _recipeContent?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedRecipeBookEntry',
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

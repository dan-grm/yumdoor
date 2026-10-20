// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_book_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeBookEntry extends RecipeBookEntry {
  @override
  final int book;
  @override
  final RecipeBook? bookContent;
  @override
  final int? id;
  @override
  final int recipe;
  @override
  final RecipeOverview? recipeContent;

  factory _$RecipeBookEntry([void Function(RecipeBookEntryBuilder)? updates]) =>
      (RecipeBookEntryBuilder()..update(updates))._build();

  _$RecipeBookEntry._({
    required this.book,
    this.bookContent,
    this.id,
    required this.recipe,
    this.recipeContent,
  }) : super._();
  @override
  RecipeBookEntry rebuild(void Function(RecipeBookEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeBookEntryBuilder toBuilder() => RecipeBookEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeBookEntry &&
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
    return (newBuiltValueToStringHelper(r'RecipeBookEntry')
          ..add('book', book)
          ..add('bookContent', bookContent)
          ..add('id', id)
          ..add('recipe', recipe)
          ..add('recipeContent', recipeContent))
        .toString();
  }
}

class RecipeBookEntryBuilder
    implements Builder<RecipeBookEntry, RecipeBookEntryBuilder> {
  _$RecipeBookEntry? _$v;

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

  RecipeBookEntryBuilder() {
    RecipeBookEntry._defaults(this);
  }

  RecipeBookEntryBuilder get _$this {
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
  void replace(RecipeBookEntry other) {
    _$v = other as _$RecipeBookEntry;
  }

  @override
  void update(void Function(RecipeBookEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeBookEntry build() => _build();

  _$RecipeBookEntry _build() {
    _$RecipeBookEntry _$result;
    try {
      _$result =
          _$v ??
          _$RecipeBookEntry._(
            book: BuiltValueNullFieldError.checkNotNull(
              book,
              r'RecipeBookEntry',
              'book',
            ),
            bookContent: _bookContent?.build(),
            id: id,
            recipe: BuiltValueNullFieldError.checkNotNull(
              recipe,
              r'RecipeBookEntry',
              'recipe',
            ),
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
          r'RecipeBookEntry',
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

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_book.freezed.dart';

/// A recipe book the current user owns or that is shared with them.
@freezed
abstract class RecipeBook with _$RecipeBook {
  const factory RecipeBook({
    required int id,
    required String name,

    /// The book has a saved search: besides the recipes added to it, it
    /// holds every recipe that search finds (Tandoor shows both).
    @Default(false) bool isDynamic,
  }) = _RecipeBook;
}

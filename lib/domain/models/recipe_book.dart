import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_book.freezed.dart';

/// A recipe book the current user owns or that is shared with them.
@freezed
abstract class RecipeBook with _$RecipeBook {
  const factory RecipeBook({required int id, required String name}) =
      _RecipeBook;
}

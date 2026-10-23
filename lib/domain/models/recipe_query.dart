import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_query.freezed.dart';

/// A recipe search. All parts must match.
@freezed
abstract class RecipeQuery with _$RecipeQuery {
  const factory RecipeQuery({
    /// Free text. Which fields it searches is the user's Tandoor search
    /// preference; by default only recipe names.
    @Default('') String text,

    /// The recipe contains each of these foods, or one of its child foods.
    @Default({}) Set<int> foodIds,

    /// The recipe has each of these keywords.
    @Default({}) Set<int> keywordIds,
  }) = _RecipeQuery;
}

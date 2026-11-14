import 'package:freezed_annotation/freezed_annotation.dart';

import 'food.dart';
import 'keyword.dart';
import 'recipe_summary.dart';

part 'recipe_match.freezed.dart';

/// A search result and why it matched the search text.
///
/// Neither list is set when the name matched, or when the search had no text.
@freezed
abstract class RecipeMatch with _$RecipeMatch {
  const factory RecipeMatch({
    required RecipeSummary recipe,

    /// It contains one of these foods, or a child food of one of them, and
    /// they match the text. Server results don't say which one.
    @Default([]) List<Food> foods,

    /// It has one of these keywords, or a child keyword of one of them, and
    /// they match the text.
    @Default([]) List<Keyword> keywords,
  }) = _RecipeMatch;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import 'keyword.dart';
import 'user_ref.dart';

part 'recipe_summary.freezed.dart';

/// A recipe in a list, such as a search result. Has no steps; load the
/// [Recipe] for those.
@freezed
abstract class RecipeSummary with _$RecipeSummary {
  const factory RecipeSummary({
    required int id,
    required String name,
    @Default('') String description,
    Uri? image,
    @Default([]) List<Keyword> keywords,
    @Default(1) int servings,

    /// What a serving is ("Stück", "Gläser"), empty if not set.
    @Default('') String servingsText,
    @Default(Duration.zero) Duration workingTime,
    @Default(Duration.zero) Duration waitingTime,

    /// The current user's average rating from their own cook log, 0 to 5.
    double? rating,

    /// When the current user last cooked it.
    DateTime? lastCooked,
    UserRef? createdBy,
    DateTime? updatedAt,
  }) = _RecipeSummary;
}

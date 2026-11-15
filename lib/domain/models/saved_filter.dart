import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_query.dart';

part 'saved_filter.freezed.dart';

/// A saved search (Tandoor's `CustomFilter`), made in Yumdoor or in
/// Tandoor.
@freezed
abstract class SavedFilter with _$SavedFilter {
  const factory SavedFilter({
    required int id,
    required String name,

    /// The search as the search screen shows it: text and filter chips.
    /// `null` if it uses parameters the chips can't show (made in Tandoor);
    /// such a search is applied as [RecipeQuery.savedFilter].
    RecipeQuery? query,

    /// Whether the current user created it. Only they can rename or delete
    /// it; the others it is shared with can only use it.
    @Default(true) bool own,
  }) = _SavedFilter;

  const SavedFilter._();

  /// The search that applies it, replacing the current one.
  RecipeQuery get search => query ?? RecipeQuery(savedFilter: id);
}

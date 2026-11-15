import '../../core/failures.dart';
import '../models/recipe_query.dart';
import '../models/saved_filter.dart';

/// The current user's saved searches and those shared with them. Methods
/// throw a [Failure].
abstract interface class SavedFilterRepository {
  /// Every saved search the user can use, by name. Includes the saved
  /// searches of dynamic books, which Tandoor stores the same way.
  Future<List<SavedFilter>> savedFilters();

  /// Saves [query] as [name]. Its sort order is saved too.
  ///
  /// [RecipeQuery.savedFilter] can't be saved within another saved search;
  /// throws an [ArgumentError] if it is set.
  Future<SavedFilter> create(String name, RecipeQuery query);

  /// Renames a saved search of the user's own.
  Future<SavedFilter> rename(int id, String name);

  /// Deletes a saved search of the user's own.
  Future<void> delete(int id);
}

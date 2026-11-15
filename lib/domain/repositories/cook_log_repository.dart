import '../../core/failures.dart';
import '../models/cook_log.dart';

/// The cook log of the current space. Methods throw a [Failure].
abstract interface class CookLogRepository {
  /// Saves [entry] as the current user's, cooked now.
  Future<CookLog> create(NewCookLog entry);

  /// Deletes one of the current user's entries. Throws [NotFoundFailure] if
  /// it doesn't exist and [UnauthorizedFailure] if it is someone else's.
  Future<void> delete(int id);

  /// When the current user last cooked the recipe, `null` if never.
  Future<DateTime?> lastCooked(int recipeId);
}

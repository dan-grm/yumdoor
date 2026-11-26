import '../../core/failures.dart';
import '../models/cook_log.dart';

/// The cook log of the current space. Methods throw a [Failure].
abstract interface class CookLogRepository {
  /// Saves [entry] as the current user's, cooked now.
  Future<CookLog> create(NewCookLog entry);

  /// Deletes one of the current user's entries. Throws [NotFoundFailure] if
  /// it doesn't exist and [UnauthorizedFailure] if it is someone else's.
  Future<void> delete(int id);

  /// What everyone in the space cooked recently, newest first: at most
  /// [limit] entries, none from before [since]. Entries whose recipe is gone
  /// or that the current user can't see (someone else's private recipe) are
  /// left out. Online only: throws [OfflineFailure] when the server can't be
  /// reached.
  Future<List<RecentCookLog>> recent({int limit = 20, DateTime? since});

  /// When the current user last cooked the recipe, `null` if never.
  Future<DateTime?> lastCooked(int recipeId);
}

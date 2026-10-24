import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/keyword.dart';

/// Keywords of the current space. Methods throw a [Failure].
abstract interface class KeywordRepository {
  /// Up to [limit] keywords whose name matches [query], best matches first.
  /// [cancel] aborts the request.
  Future<List<Keyword>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  });

  /// Throws [NotFoundFailure] if the keyword doesn't exist.
  Future<Keyword> fetchKeyword(int id);
}

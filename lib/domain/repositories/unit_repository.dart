import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/unit.dart';

/// Units of measurement of the current space. Methods throw a [Failure].
abstract interface class UnitRepository {
  /// Up to [limit] units whose name contains [query] (ignoring case and
  /// accents), best matches first. [cancel] aborts the request.
  ///
  /// Units the server suggests for a fuzzy search preference whose name
  /// doesn't contain the text are left out. The plural name isn't searched
  /// (Tandoor doesn't search it either).
  Future<List<Unit>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  });

  /// Creates a unit called [name] (trimmed). If a unit with that name or
  /// plural name already exists (ignoring case), returns it unchanged instead.
  /// Fails with an [ArgumentError] if [name] is blank.
  Future<Unit> create(String name);
}

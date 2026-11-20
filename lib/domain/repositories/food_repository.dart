import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/food.dart';

/// Foods of the current space. Methods throw a [Failure].
abstract interface class FoodRepository {
  /// Up to [limit] foods whose name matches [query], best matches first.
  /// [cancel] aborts the request.
  Future<List<Food>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  });

  /// Throws [NotFoundFailure] if the food doesn't exist.
  Future<Food> fetchFood(int id);

  /// Creates a food called [name] (trimmed). If a food with that name or
  /// plural name already exists (ignoring case), returns it unchanged instead.
  /// Fails with an [ArgumentError] if [name] is blank.
  Future<Food> create(String name);

  /// Marks the food with [foodId] as on hand ([onHand] `true`) or not, for
  /// the whole household, and returns it. Throws [NotFoundFailure] if the
  /// food doesn't exist.
  Future<Food> setOnHand(int foodId, {required bool onHand});
}

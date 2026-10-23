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
}

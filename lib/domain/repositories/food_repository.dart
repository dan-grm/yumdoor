import '../../core/failures.dart';
import '../models/food.dart';

/// Foods of the current space. Methods throw a [Failure].
abstract interface class FoodRepository {
  /// Up to [limit] foods whose name matches [query], best matches first.
  Future<List<Food>> autocomplete(String query, {int limit = 10});
}

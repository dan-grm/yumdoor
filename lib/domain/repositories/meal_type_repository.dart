import '../../core/failures.dart';
import '../models/meal_type.dart';

/// The meal types of the current space. Methods throw a [Failure].
abstract interface class MealTypeRepository {
  /// All meal types, sorted with [compareMealTypes].
  Future<List<MealType>> list();

  /// Creates a meal type called [name] (trimmed), after the existing ones. If
  /// one with that name already exists (ignoring case), returns it unchanged
  /// instead. Fails with an [ArgumentError] if [name] is blank.
  Future<MealType> create(String name);
}

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/repositories/meal_type_repository.dart';

/// [MealTypeRepository] for tests that keeps the types in [types]. Set
/// [failure] to make every call throw it.
class FakeMealTypeRepository implements MealTypeRepository {
  FakeMealTypeRepository([List<MealType> types = const []])
    : types = [...types];

  final List<MealType> types;
  Failure? failure;

  @override
  Future<List<MealType>> list() async {
    if (failure case final failure?) throw failure;
    return [...types]..sort(compareMealTypes);
  }

  @override
  Future<MealType> create(String name) async {
    if (failure case final failure?) throw failure;
    final trimmed = name.trim();
    for (final type in types) {
      if (type.name.toLowerCase() == trimmed.toLowerCase()) return type;
    }
    final type = MealType(
      id: 100 + types.length,
      name: trimmed,
      order: types.length,
    );
    types.add(type);
    return type;
  }
}

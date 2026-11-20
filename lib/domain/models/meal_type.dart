import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_type.freezed.dart';

/// A kind of meal a plan is for, such as breakfast or dinner. Meal types
/// belong to the space: every member sees and can use all of them.
@freezed
abstract class MealType with _$MealType {
  const factory MealType({
    required int id,
    required String name,

    /// Position among the meal types, lowest first. Several can share one.
    @Default(0) int order,

    /// The color as `0xRRGGBB`, `null` if none is set.
    int? color,

    /// When the meal usually is, as the time after midnight. `null` if not
    /// set.
    Duration? time,
  }) = _MealType;
}

/// The most characters (code points) Tandoor stores in a meal type's name.
const maxMealTypeNameLength = 128;

/// Sorts meal types by [MealType.order], then by name (ignoring case), then
/// by id.
int compareMealTypes(MealType a, MealType b) {
  final byOrder = a.order.compareTo(b.order);
  if (byOrder != 0) return byOrder;
  final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
  if (byName != 0) return byName;
  return a.id.compareTo(b.id);
}

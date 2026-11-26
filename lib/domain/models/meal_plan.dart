import 'package:freezed_annotation/freezed_annotation.dart';

import 'calendar_day.dart';
import 'meal_type.dart';
import 'recipe_summary.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

/// A planned meal: a recipe or just a title, for one or more days. Everyone
/// in the creator's household sees and can change it.
@freezed
abstract class MealPlan with _$MealPlan {
  const factory MealPlan({
    required int id,

    /// `null` for a plan with only a [title], such as "Pizza bestellen".
    RecipeSummary? recipe,

    /// Empty if not set; plans with a recipe usually have none.
    @Default('') String title,
    required double servings,

    /// Plain text or Markdown, empty if there is none.
    @Default('') String note,

    /// The first day, on this device's calendar.
    @CalendarDayConverter() required CalendarDay fromDay,

    /// The last day, the same as [fromDay] for a plan of one day.
    @CalendarDayConverter() required CalendarDay toDay,
    required MealType mealType,

    /// Whether its ingredients are on the shopping list.
    @Default(false) bool onShoppingList,

    /// The id of the user who planned it.
    required int createdBy,
  }) = _MealPlan;

  const MealPlan._();

  /// For storing in the offline cache. The format follows the fields, so a
  /// change to this model or the ones it contains needs a new cache version.
  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);

  /// What to call the plan: its title, or else its recipe's name.
  String get label => switch (title.trim()) {
    '' => recipe?.name ?? '',
    final title => title,
  };

  /// Whether the plan is on [day].
  bool isOn(CalendarDay day) => !day.isBefore(fromDay) && !day.isAfter(toDay);

  /// The number of days the plan spans, at least 1.
  int get days => toDay.differenceInDays(fromDay) + 1;

  /// [servings] as the recipe screen and cooking mode take them: whole
  /// servings, rounded, at least 1.
  int get wholeServings => servings < 1 ? 1 : servings.round();
}

/// The meal plans of some days, as the meal plan repository lists them.
@freezed
abstract class MealPlanList with _$MealPlanList {
  const factory MealPlanList({
    required List<MealPlan> plans,

    /// When the plans were read from the server, if they come from the
    /// offline cache because it can't be reached; `null` for plans read just
    /// now.
    DateTime? cachedAt,
  }) = _MealPlanList;
}

/// A meal plan to create, for one day.
class NewMealPlan {
  /// Throws an [ArgumentError] for [servings] [checkMealPlanServings]
  /// rejects, for a
  /// plan with neither [recipeId] nor a [title], or for a [title] longer than
  /// [maxMealPlanTitleLength]. [title] and [note] are trimmed.
  factory NewMealPlan({
    int? recipeId,
    String title = '',
    required double servings,
    String note = '',
    required CalendarDay day,
    required MealType mealType,
  }) {
    checkMealPlanServings(servings);
    final trimmedTitle = title.trim();
    if (recipeId == null && trimmedTitle.isEmpty) {
      throw ArgumentError('A meal plan needs a recipe or a title.');
    }
    if (trimmedTitle.runes.length > maxMealPlanTitleLength) {
      throw ArgumentError.value(
        title,
        'title',
        'is longer than $maxMealPlanTitleLength characters',
      );
    }
    return NewMealPlan._(
      recipeId,
      trimmedTitle,
      servings,
      note.trim(),
      day,
      mealType,
    );
  }

  const NewMealPlan._(
    this.recipeId,
    this.title,
    this.servings,
    this.note,
    this.day,
    this.mealType,
  );

  final int? recipeId;
  final String title;
  final double servings;
  final String note;
  final CalendarDay day;
  final MealType mealType;

  @override
  bool operator ==(Object other) =>
      other is NewMealPlan &&
      other.recipeId == recipeId &&
      other.title == title &&
      other.servings == servings &&
      other.note == note &&
      other.day == day &&
      other.mealType == mealType;

  @override
  int get hashCode =>
      Object.hash(recipeId, title, servings, note, day, mealType);

  @override
  String toString() =>
      'NewMealPlan(recipeId: $recipeId, title: $title, servings: $servings, '
      'note: $note, day: $day, mealType: ${mealType.name})';
}

/// Changes to a meal plan; `null` leaves a field as it is.
class MealPlanChanges {
  /// Throws an [ArgumentError] for [servings] [checkMealPlanServings]
  /// rejects. [note] is trimmed.
  factory MealPlanChanges({
    CalendarDay? day,
    MealType? mealType,
    double? servings,
    String? note,
  }) {
    if (servings != null) checkMealPlanServings(servings);
    return MealPlanChanges._(day, mealType, servings, note?.trim());
  }

  const MealPlanChanges._(this.day, this.mealType, this.servings, this.note);

  /// The new first day. A plan of several days keeps its length.
  final CalendarDay? day;
  final MealType? mealType;
  final double? servings;
  final String? note;

  @override
  bool operator ==(Object other) =>
      other is MealPlanChanges &&
      other.day == day &&
      other.mealType == mealType &&
      other.servings == servings &&
      other.note == note;

  @override
  int get hashCode => Object.hash(day, mealType, servings, note);

  @override
  String toString() =>
      'MealPlanChanges(day: $day, mealType: ${mealType?.name}, '
      'servings: $servings, note: $note)';
}

/// The most characters (code points) Tandoor stores in a meal plan's title.
const maxMealPlanTitleLength = 64;

/// Throws an [ArgumentError] unless [servings] is a number Tandoor can store
/// as servings: above 0 and below 10000.
void checkMealPlanServings(double servings) {
  // Tandoor stores up to 9999.9999 with 4 decimal places.
  if (!(servings >= 0.0001 && servings < 10000)) {
    throw ArgumentError.value(
      servings,
      'servings',
      'must be from 0.0001 to below 10000',
    );
  }
}

import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/meal_type.dart';
import 'mapping.dart';
import 'recipe_mapper.dart';

// Meal plan dates are datetimes in Tandoor. Like Tandoor's own frontend,
// Yumdoor reads and writes them in this device's time zone: a plan is on the
// day its datetime falls on here, and a new plan is at its meal type's time
// (noon without one) here. See docs/TANDOOR_API.md#meal-plans.

/// The time of a new plan whose meal type has none, like Tandoor's frontend.
const _noon = Duration(hours: 12);

extension MealTypeMapper on api.MealType {
  MealType toDomain() => MealType(
    id: requireId(id, 'MealType'),
    name: name,
    order: order ?? 0,
    color: _parseColor(color),
    time: _parseTime(time),
  );
}

/// `#rrggbb` (Tandoor's color picker) as `0xRRGGBB`; `null` for anything
/// else.
int? _parseColor(String? value) {
  final match = RegExp(r'^#([0-9a-fA-F]{6})$').firstMatch(value?.trim() ?? '');
  return match == null ? null : int.parse(match.group(1)!, radix: 16);
}

/// `HH:MM:SS` or `HH:MM` as the time after midnight; `null` for anything else.
Duration? _parseTime(String? value) {
  final match = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2})(?:\.\d+)?)?$')
      .firstMatch(value?.trim() ?? '');
  if (match == null) return null;
  final hours = int.parse(match.group(1)!);
  final minutes = int.parse(match.group(2)!);
  final seconds = int.parse(match.group(3) ?? '0');
  if (hours > 23 || minutes > 59 || seconds > 59) return null;
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

extension MealPlanMapper on api.MealPlan {
  MealPlan toDomain() {
    final from = _localDay(fromDate);
    final to = _localDay(toDate ?? fromDate);
    return MealPlan(
      id: requireId(id, 'MealPlan'),
      recipe: recipe?.toDomain(),
      title: title ?? '',
      servings: servings,
      note: note ?? '',
      fromDay: from,
      // Tandoor doesn't check the order; a plan never ends before it starts.
      toDay: to.isBefore(from) ? from : to,
      mealType: mealType.toDomain(),
      onShoppingList: shopping ?? false,
      createdBy:
          createdBy ?? (throw const FormatException('MealPlan without owner')),
    );
  }
}

CalendarDay _localDay(DateTime dateTime) => CalendarDay.of(dateTime.toLocal());

/// How Tandoor expects a datetime: ISO 8601 in UTC.
String _wire(DateTime dateTime) => dateTime.toUtc().toIso8601String();

extension NewMealPlanMapper on NewMealPlan {
  /// The request body for `POST /api/meal-plan/`.
  ///
  /// Recipe and meal type go as plain ids: a nested meal type renames it to
  /// the name sent (docs/TANDOOR_API.md#meal-plans), and the generated
  /// `MealPlan` can't send an id alone.
  Map<String, Object?> toJson() {
    final at = _wire(day.atLocalTime(mealType.time ?? _noon));
    return {
      'recipe': recipeId,
      'title': title,
      'servings': _decimal(servings),
      'note': note,
      'from_date': at,
      'to_date': at,
      'meal_type': mealType.id,
    };
  }
}

extension MealPlanChangesMapper on MealPlanChanges {
  /// The request body for `PATCH /api/meal-plan/{id}/` that applies these
  /// changes to [current].
  ///
  /// Always sends `servings`: Tandoor fails with 500 without it when the plan
  /// is on the shopping list. A new [day] keeps the plan's times and length; a
  /// new [mealType] moves it to that type's time, if the type has one.
  Map<String, Object?> toJson(api.MealPlan current) {
    final newType = switch (mealType) {
      final type? when type.id != current.mealType.id => type,
      _ => null,
    };
    final body = <String, Object?>{
      'servings': _decimal(servings ?? current.servings),
      'note': ?note,
      if (newType != null) 'meal_type': newType.id,
    };
    if (day == null && newType?.time == null) return body;

    final from = current.fromDate.toLocal();
    final to = (current.toDate ?? current.fromDate).toLocal();
    final fromDay = CalendarDay.of(from);
    final length = CalendarDay.of(to).differenceInDays(fromDay);
    final newFromDay = day ?? fromDay;
    final newToDay = newFromDay.addDays(length < 0 ? 0 : length);
    return {
      ...body,
      'from_date': _wire(
        newFromDay.atLocalTime(newType?.time ?? _timeOfDay(from)),
      ),
      'to_date': _wire(newToDay.atLocalTime(newType?.time ?? _timeOfDay(to))),
    };
  }
}

/// Tandoor stores servings with 4 decimal places and rejects more.
double _decimal(double value) => (value * 10000).round() / 10000;

Duration _timeOfDay(DateTime local) =>
    Duration(hours: local.hour, minutes: local.minute, seconds: local.second);

import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/meal_plan_mapper.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  List<api.MealPlan> recordedPlans() => api.standardSerializers
      .deserializeWith(
        api.PaginatedMealPlanList.serializer,
        tandoorFixture('meal_plan_list.json'),
      )!
      .results
      .toList();

  /// The day [iso] falls on in this device's time zone, so the tests pass in
  /// any time zone.
  CalendarDay localDay(String iso) =>
      CalendarDay.of(DateTime.parse(iso).toLocal());

  group('MealTypeMapper', () {
    test('maps the recorded meal types', () {
      final types = api.standardSerializers
          .deserializeWith(
            api.PaginatedMealTypeList.serializer,
            tandoorFixture('meal_type_list.json'),
          )!
          .results
          .map((dto) => dto.toDomain())
          .toList();

      expect(
        types.first,
        const MealType(
          id: 12,
          name: 'Frühstück',
          color: 0xe8b04a,
          time: Duration(hours: 8),
        ),
      );
      expect(
        types.last,
        const MealType(
          id: 14,
          name: 'Abendessen',
          order: 2,
          color: 0xc26a4a,
          time: Duration(hours: 18, minutes: 30),
        ),
      );
    });

    test('maps a missing or unexpected color and time to null', () {
      api.MealType type(String? color, String? time) => api.MealType(
        (b) => b
          ..id = 1
          ..name = 'Snack'
          ..color = color
          ..time = time,
      );

      expect(type(null, null).toDomain().color, isNull);
      expect(type('', '').toDomain().time, isNull);
      expect(type('red', '25:00:00').toDomain().color, isNull);
      expect(type('red', '25:00:00').toDomain().time, isNull);
      expect(type('#FFFFFF', '7:05').toDomain().color, 0xffffff);
      expect(
        type('#FFFFFF', '7:05').toDomain().time,
        const Duration(hours: 7, minutes: 5),
      );
      expect(
        type(null, '21:15:30.5').toDomain().time,
        const Duration(hours: 21, minutes: 15, seconds: 30),
      );
    });
  });

  group('MealPlanMapper', () {
    test('maps a plan with a recipe', () {
      final plan = recordedPlans().first.toDomain();

      expect(plan.id, 37);
      expect(plan.recipe?.id, 143);
      expect(plan.recipe?.name, 'Gemüsepfanne mit Reis');
      expect(plan.title, '');
      expect(plan.label, 'Gemüsepfanne mit Reis');
      expect(plan.servings, 2);
      expect(plan.note, '');
      expect(plan.fromDay, localDay('2026-11-16T18:30:00+01:00'));
      expect(plan.toDay, plan.fromDay);
      expect(plan.mealType.name, 'Abendessen');
      expect(plan.mealType.time, const Duration(hours: 18, minutes: 30));
      expect(plan.onShoppingList, isFalse);
      expect(plan.createdBy, 11);
    });

    test('maps a plan without a recipe', () {
      // Tandoor leaves `recipe_name` out entirely here.
      final plan = recordedPlans()[3].toDomain();

      expect(plan.recipe, isNull);
      expect(plan.title, 'Reste vom Mittwoch');
      expect(plan.label, 'Reste vom Mittwoch');
      expect(plan.note, 'Suppe aufwärmen');
      expect(plan.mealType.name, 'Mittagessen');
      expect(plan.fromDay, localDay('2026-11-19T12:30:00+01:00'));
    });

    test('maps a plan over two days', () {
      final plan = recordedPlans()[7].toDomain();

      expect(plan.recipe?.name, 'Rindergulasch');
      expect(plan.servings, 6);
      expect(plan.fromDay, localDay('2026-11-21T18:30:00+01:00'));
      expect(plan.toDay, localDay('2026-11-22T18:30:00+01:00'));
      expect(plan.days, 2);
    });

    test('maps the shopping flag and the creator', () {
      final plans = recordedPlans().map((dto) => dto.toDomain()).toList();

      expect(plans[1].onShoppingList, isTrue);
      expect(plans[1].createdBy, 12);
      expect(
        [for (final plan in plans) plan.onShoppingList],
        [false, true, true, false, true, false, false, false, false],
      );
    });

    test('takes the day in this device\'s time zone', () {
      final late = DateTime(2026, 11, 20, 23, 30);
      final plan = _dto(from: late.toUtc(), to: null).toDomain();

      expect(plan.fromDay, CalendarDay(2026, 11, 20));
      expect(plan.toDay, CalendarDay(2026, 11, 20));
    });

    test('never ends before it starts', () {
      final plan = _dto(
        from: DateTime(2026, 11, 20, 12).toUtc(),
        to: DateTime(2026, 11, 18, 12).toUtc(),
      ).toDomain();

      expect(plan.toDay, plan.fromDay);
    });

    test('rejects a plan without a creator', () {
      expect(
        () => _dto(
          from: DateTime.utc(2026, 11, 20, 12),
          to: null,
          createdBy: null,
        ).toDomain(),
        throwsFormatException,
      );
    });
  });

  group('NewMealPlanMapper', () {
    const dinner = MealType(
      id: 14,
      name: 'Abendessen',
      time: Duration(hours: 18, minutes: 30),
    );

    test('sends ids and the meal type\'s time on this device', () {
      final body = NewMealPlan(
        recipeId: 140,
        servings: 2.5,
        note: 'Gäste',
        day: CalendarDay(2026, 11, 23),
        mealType: dinner,
      ).toJson();

      expect(body, {
        'recipe': 140,
        'title': '',
        'servings': 2.5,
        'note': 'Gäste',
        'from_date': body['from_date'],
        'to_date': body['from_date'],
        'meal_type': 14,
      });
      final from = body['from_date']! as String;
      expect(from, endsWith('Z'));
      expect(DateTime.parse(from).toLocal(), DateTime(2026, 11, 23, 18, 30));
    });

    test('rounds servings to the 4 decimal places Tandoor stores', () {
      NewMealPlan make(double servings) => NewMealPlan(
        recipeId: 1,
        servings: servings,
        day: CalendarDay(2026, 11, 23),
        mealType: dinner,
      );

      expect(make(2 / 3).toJson()['servings'], 0.6667);
      expect(make(0.1 + 0.2).toJson()['servings'], 0.3);
      expect(
        MealPlanChanges(servings: 1 / 3).toJson(
          _dto(from: DateTime.utc(2026, 11, 20, 12), to: null),
        )['servings'],
        0.3333,
      );
    });

    test('plans at noon for a meal type without a time', () {
      final body = NewMealPlan(
        title: 'Pizza',
        servings: 2,
        day: CalendarDay(2026, 11, 23),
        mealType: const MealType(id: 15, name: 'Snack'),
      ).toJson();

      expect(body['recipe'], isNull);
      expect(body['title'], 'Pizza');
      expect(
        DateTime.parse(body['from_date']! as String).toLocal(),
        DateTime(2026, 11, 23, 12),
      );
    });
  });

  group('MealPlanChangesMapper', () {
    const breakfast = MealType(
      id: 12,
      name: 'Frühstück',
      time: Duration(hours: 8),
    );
    // Saturday 18:30 to Sunday 18:45, on this device.
    final current = _dto(
      from: DateTime(2026, 11, 21, 18, 30).toUtc(),
      to: DateTime(2026, 11, 22, 18, 45).toUtc(),
      servings: 6,
    );

    DateTime local(Map<String, Object?> body, String key) =>
        DateTime.parse(body[key]! as String).toLocal();

    test('always sends the servings', () {
      expect(MealPlanChanges().toJson(current), {'servings': 6.0});
      expect(MealPlanChanges(servings: 3).toJson(current), {'servings': 3.0});
      expect(MealPlanChanges(note: 'Neu').toJson(current), {
        'servings': 6.0,
        'note': 'Neu',
      });
    });

    test('moves to another day, keeping the times and the length', () {
      final body = MealPlanChanges(day: CalendarDay(2026, 11, 24))
          .toJson(current);

      expect(body.keys, unorderedEquals(['servings', 'from_date', 'to_date']));
      expect(local(body, 'from_date'), DateTime(2026, 11, 24, 18, 30));
      expect(local(body, 'to_date'), DateTime(2026, 11, 25, 18, 45));
    });

    test('moves to another meal type and its time', () {
      final body = MealPlanChanges(mealType: breakfast).toJson(current);

      expect(body['meal_type'], 12);
      expect(local(body, 'from_date'), DateTime(2026, 11, 21, 8));
      expect(local(body, 'to_date'), DateTime(2026, 11, 22, 8));
    });

    test('keeps the times for a meal type without one', () {
      final body = MealPlanChanges(
        mealType: const MealType(id: 15, name: 'Snack'),
      ).toJson(current);

      expect(body, {'servings': 6.0, 'meal_type': 15});
    });

    test('leaves out an unchanged meal type', () {
      final body = MealPlanChanges(
        mealType: const MealType(id: 14, name: 'Abendessen', time: Duration()),
      ).toJson(current);

      expect(body, {'servings': 6.0});
    });

    test('moves day and meal type together', () {
      final body = MealPlanChanges(
        day: CalendarDay(2026, 11, 30),
        mealType: breakfast,
      ).toJson(current);

      expect(body['meal_type'], 12);
      expect(local(body, 'from_date'), DateTime(2026, 11, 30, 8));
      expect(local(body, 'to_date'), DateTime(2026, 12, 1, 8));
    });
  });
}

api.MealPlan _dto({
  required DateTime from,
  required DateTime? to,
  double servings = 2,
  int? createdBy = 11,
}) => api.MealPlan(
  (b) => b
    ..id = 1
    ..title = 'Pizza'
    ..servings = servings
    ..fromDate = from
    ..toDate = to
    ..createdBy = createdBy
    ..mealType.replace(
      api.MealType(
        (t) => t
          ..id = 14
          ..name = 'Abendessen'
          ..time = '18:30:00',
      ),
    ),
);

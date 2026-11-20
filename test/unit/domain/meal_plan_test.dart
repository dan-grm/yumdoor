import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';

void main() {
  const dinner = MealType(id: 3, name: 'Abendessen', order: 2);
  final saturday = CalendarDay(2026, 11, 21);

  MealPlan plan({String title = '', RecipeSummary? recipe, CalendarDay? to}) =>
      MealPlan(
        id: 1,
        recipe: recipe,
        title: title,
        servings: 2,
        fromDay: saturday,
        toDay: to ?? saturday,
        mealType: dinner,
        createdBy: 7,
      );

  group('MealPlan', () {
    test('is labeled by its title, or else its recipe', () {
      const recipe = RecipeSummary(id: 4, name: 'Rindergulasch');

      expect(plan(title: 'Pizza bestellen').label, 'Pizza bestellen');
      expect(plan(recipe: recipe).label, 'Rindergulasch');
      expect(plan(title: '  ', recipe: recipe).label, 'Rindergulasch');
      expect(plan(title: 'Gulasch', recipe: recipe).label, 'Gulasch');
      expect(plan().label, '');
    });

    test('is on every day from its first to its last', () {
      final twoDays = plan(to: saturday.addDays(1));

      expect(twoDays.days, 2);
      expect(twoDays.isOn(saturday.addDays(-1)), isFalse);
      expect(twoDays.isOn(saturday), isTrue);
      expect(twoDays.isOn(saturday.addDays(1)), isTrue);
      expect(twoDays.isOn(saturday.addDays(2)), isFalse);
      expect(plan().days, 1);
    });
  });

  group('NewMealPlan', () {
    test('trims title and note', () {
      final plan = NewMealPlan(
        title: ' Pizza ',
        note: ' bestellen\n',
        servings: 2,
        day: saturday,
        mealType: dinner,
      );

      expect(plan.title, 'Pizza');
      expect(plan.note, 'bestellen');
      expect(plan.recipeId, isNull);
    });

    test('needs a recipe or a title', () {
      expect(
        () => NewMealPlan(
          title: '  ',
          servings: 2,
          day: saturday,
          mealType: dinner,
        ),
        throwsArgumentError,
      );
      expect(
        NewMealPlan(
          recipeId: 4,
          servings: 2,
          day: saturday,
          mealType: dinner,
        ).title,
        '',
      );
    });

    test('needs servings above 0', () {
      for (final servings in [0.0, -1.0, double.nan, double.infinity]) {
        expect(
          () => NewMealPlan(
            recipeId: 4,
            servings: servings,
            day: saturday,
            mealType: dinner,
          ),
          throwsArgumentError,
          reason: '$servings',
        );
      }
      expect(
        NewMealPlan(
          recipeId: 4,
          servings: 0.5,
          day: saturday,
          mealType: dinner,
        ).servings,
        0.5,
      );
    });

    test('compares by value', () {
      NewMealPlan make() => NewMealPlan(
        recipeId: 4,
        servings: 2,
        day: CalendarDay(2026, 11, 21),
        mealType: dinner,
      );

      expect(make(), make());
      expect(make().hashCode, make().hashCode);
    });
  });

  group('MealPlanChanges', () {
    test('trims the note and checks servings', () {
      expect(MealPlanChanges(note: ' Gäste ').note, 'Gäste');
      expect(() => MealPlanChanges(servings: 0), throwsArgumentError);
      expect(MealPlanChanges(), MealPlanChanges());
    });
  });

  test('meal types sort by order, then name, then id', () {
    const types = [
      MealType(id: 5, name: 'snack', order: 1),
      MealType(id: 1, name: 'Abendessen', order: 2),
      MealType(id: 4, name: 'Mittagessen', order: 1),
      MealType(id: 2, name: 'Frühstück'),
      MealType(id: 3, name: 'mittagessen', order: 1),
    ];

    expect([...types]..sort(compareMealTypes), [
      types[3],
      types[4],
      types[2],
      types[0],
      types[1],
    ]);
  });
}

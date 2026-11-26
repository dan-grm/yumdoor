import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

void main() {
  const lentils = RecipeSummary(id: 1, name: 'Linsen-Bolognese');
  const soup = RecipeSummary(id: 2, name: 'Kürbissuppe');
  const anna = UserRef(id: 2, name: 'Anna');
  final tuesday = DateTime.utc(2026, 11, 24, 18);

  group('RecommendationReason', () {
    test('each kind is equal by value', () {
      List<RecommendationReason> reasons() => [
        const RecommendationReason.highlyRated(4.5),
        RecommendationReason.notCookedSince(tuesday),
        const RecommendationReason.inSeason(Keyword(id: 3, name: 'Herbst')),
        RecommendationReason.cookedRecentlyBy(anna, tuesday),
        const RecommendationReason.similarTo(lentils),
        const RecommendationReason.freeText('Wärmt bei Regen.'),
      ];

      final a = reasons();
      final b = reasons();
      for (var i = 0; i < a.length; i++) {
        expect(a[i], b[i]);
        expect(a[i].hashCode, b[i].hashCode);
        for (var j = 0; j < a.length; j++) {
          if (i != j) expect(a[i], isNot(b[j]));
        }
      }
    });

    test('differs by its values', () {
      expect(
        const RecommendationReason.highlyRated(4.5),
        isNot(const RecommendationReason.highlyRated(4)),
      );
      expect(
        RecommendationReason.notCookedSince(tuesday),
        isNot(
          RecommendationReason.notCookedSince(
            tuesday.add(const Duration(days: 1)),
          ),
        ),
      );
      expect(
        RecommendationReason.cookedRecentlyBy(anna, tuesday),
        isNot(
          RecommendationReason.cookedRecentlyBy(
            const UserRef(id: 3, name: 'Ben'),
            tuesday,
          ),
        ),
      );
      expect(
        const RecommendationReason.similarTo(lentils),
        isNot(const RecommendationReason.similarTo(soup)),
      );
    });

    test('can be told apart exhaustively', () {
      String describe(RecommendationReason reason) => switch (reason) {
        HighlyRated(:final rating) => '$rating ★',
        NotCookedSince(:final date) => 'seit ${date.day}.',
        InSeason(:final keyword) => keyword.name,
        CookedRecentlyBy(:final user) => user.name,
        SimilarTo(:final recipe) => recipe.name,
        FreeTextReason(:final text) => text,
      };

      expect(describe(const RecommendationReason.highlyRated(4.5)), '4.5 ★');
      expect(
        describe(RecommendationReason.cookedRecentlyBy(anna, tuesday)),
        'Anna',
      );
    });
  });

  group('Recommendation', () {
    test('is equal by value, reasons included', () {
      Recommendation make({double score = 0.8}) => Recommendation(
        recipe: lentils,
        score: score,
        reasons: [
          const RecommendationReason.highlyRated(5),
          RecommendationReason.notCookedSince(tuesday),
        ],
      );

      expect(make(), make());
      expect(make().hashCode, make().hashCode);
      expect(make(), isNot(make(score: 0.5)));
      expect(make(), isNot(make().copyWith(reasons: [make().reasons.first])));
      expect(make(), isNot(make().copyWith(recipe: soup)));
    });

    test('has no reasons by default', () {
      expect(const Recommendation(recipe: soup, score: 0).reasons, isEmpty);
    });

    test('score must be 0 to 1', () {
      expect(const Recommendation(recipe: soup, score: 1).score, 1);
      expect(
        () => Recommendation(recipe: soup, score: 1.1),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => Recommendation(recipe: soup, score: -0.1),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('RecommendationContext', () {
    test('is equal by value, meal plans included', () {
      RecommendationContext make({String? wish}) => RecommendationContext(
        today: CalendarDay(2026, 11, 26),
        userId: 1,
        mealPlans: [
          MealPlan(
            id: 5,
            recipe: lentils,
            servings: 2,
            fromDay: CalendarDay(2026, 11, 27),
            toDay: CalendarDay(2026, 11, 27),
            mealType: const MealType(id: 1, name: 'Abendessen'),
            createdBy: 1,
          ),
        ],
        wish: wish,
      );

      expect(make(), make());
      expect(make().hashCode, make().hashCode);
      expect(make(), isNot(make(wish: 'etwas mit Kürbis')));
      expect(make(), isNot(make().copyWith(userId: 2)));
      expect(make(), isNot(make().copyWith(mealPlans: [])));
      expect(make(), isNot(make().copyWith(today: CalendarDay(2026, 11, 27))));
    });

    test('has no meal plans and no wish by default', () {
      final context = RecommendationContext(
        today: CalendarDay(2026, 11, 26),
        userId: 1,
      );

      expect(context.mealPlans, isEmpty);
      expect(context.wish, isNull);
    });
  });
}

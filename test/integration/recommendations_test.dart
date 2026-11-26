@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/domain/services/rule_based_recommendation_provider.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
  });
  tearDown(() => anna.close());

  // Reads only: other test files write cook logs at the same time.
  test('Anna gets recommendations with reasons', () async {
    final today = CalendarDay.today();
    final annaId = await anna.users.currentUserId();
    // The keyword most seeded recipes have, in season this month.
    final recipes = await anna.recipes.search(
      const RecipeQuery(),
      pageSize: 100,
    );
    final counts = <int, int>{};
    for (final recipe in recipes.items) {
      for (final keyword in recipe.keywords) {
        counts[keyword.id] = (counts[keyword.id] ?? 0) + 1;
      }
    }
    final keyword = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    final provider = RuleBasedRecommendationProvider(
      recipes: anna.recipes,
      cookLogs: anna.cookLogs,
      keywords: anna.keywords,
      seasonalKeywords: () async => SeasonalKeywords({
        today.month: [keyword],
      }),
    );
    final result = await provider.recommend(
      RecommendationContext(today: today, userId: annaId),
      limit: 100,
    );
    printOnFailure(
      [for (final r in result) '${r.recipe.name} ${r.score} ${r.reasons}']
          .join('\n'),
    );

    expect(result, isNotEmpty);
    for (final recommendation in result) {
      expect(recommendation.reasons, isNotEmpty);
      expect(recommendation.score, inInclusiveRange(0, 1));
    }
    final reasons = [for (final r in result) ...r.reasons];
    expect(
      reasons,
      contains(isA<InSeason>().having((r) => r.keyword.id, 'keyword', keyword)),
    );
    // Seeded cook logs: Anna's own ratings, and Ben's cooking by name.
    expect(reasons, contains(isA<HighlyRated>()));
    for (final reason in reasons.whereType<CookedRecentlyBy>()) {
      expect(reason.user.name, 'Ben');
    }
  });
}

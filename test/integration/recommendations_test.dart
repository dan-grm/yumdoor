@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/domain/services/rule_based_recommendation_provider.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
  });
  tearDown(() {
    anna.close();
    ben.close();
  });

  test('Anna gets recommendations with reasons', () async {
    final today = CalendarDay.today();
    final annaId = await anna.users.currentUserId();
    // A recipe Anna didn't cook this week, which Ben cooks now.
    final annaCooked = {
      for (final log in await anna.cookLogs.recent(
        limit: 100,
        since: today.addDays(-7).atLocalTime(),
      ))
        if (log.entry.createdBy?.id == annaId) log.recipe.id,
    };
    final recipes = await anna.recipes.search(const RecipeQuery());
    final recipe = recipes.items.firstWhere((r) => !annaCooked.contains(r.id));
    final entry = await ben.cookLogs.create(
      NewCookLog(recipeId: recipe.id, servings: 2),
    );
    addTearDown(() => ben.cookLogs.delete(entry.id));

    final provider = RuleBasedRecommendationProvider(
      recipes: anna.recipes,
      cookLogs: anna.cookLogs,
      keywords: anna.keywords,
      seasonalKeywords: () async => const SeasonalKeywords.empty(),
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
    }
    final bens = result.firstWhere((r) => r.recipe.id == recipe.id);
    expect(
      bens.reasons,
      contains(
        isA<CookedRecentlyBy>().having((r) => r.user.name, 'name', 'Ben'),
      ),
    );
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/domain/services/rule_based_recommendation_provider.dart';
import 'package:yumdoor/features/recommendations/recommendation_providers.dart';
import 'package:yumdoor/features/recommendations/seasonal_keyword_providers.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_book_user_repositories.dart';
import '../../../fakes/fake_recipe_repository.dart';
import '../../../fakes/in_memory_local_store.dart';

void main() {
  const autumn = Keyword(id: 3, name: 'Herbst');
  const soup = Recipe(id: 1, name: 'Kürbissuppe', keywords: [autumn]);

  test('suggests with the rules and the current seasonal mapping', () async {
    final container = ProviderContainer(
      overrides: appOverrides(
        tokenStore: loggedInTokenStore(),
        users: FakeUserRepository(const [], 1),
        localStore: InMemoryLocalStore(),
        recipes: FakeRecipeRepository([soup]),
      ),
    );
    addTearDown(container.dispose);
    final context = RecommendationContext(
      today: CalendarDay(2026, 11, 26),
      userId: 1,
    );

    final listened = container.listen(recommenderProvider, (_, _) {});
    final rules = listened.read();
    expect(rules.id, RuleBasedRecommendationProvider.providerId);
    expect(await rules.recommend(context), isEmpty);

    await container
        .read(seasonalKeywordMappingProvider.notifier)
        .setMapping(
          SeasonalKeywords({
            11: [autumn.id],
          }),
        );
    // Rebuilt with the new mapping while it is being watched.
    expect(listened.read(), isNot(same(rules)));
    final result = await listened.read().recommend(context);

    expect(result.single.reasons, [
      const RecommendationReason.inSeason(autumn),
    ]);
  });
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/recommendation.dart';
import '../../domain/services/recommendation_provider.dart';
import '../../domain/services/rule_based_recommendation_provider.dart';
import 'seasonal_keyword_providers.dart';

part 'recommendation_providers.g.dart';

/// Where recipe suggestions come from: the rules for now. Rebuilt when the
/// session or the seasonal keyword mapping changes.
@riverpod
RecommendationProvider recommender(Ref ref) {
  final seasonal = ref.watch(seasonalKeywordMappingProvider.future);
  return RuleBasedRecommendationProvider(
    recipes: ref.watch(recipeRepositoryProvider),
    cookLogs: ref.watch(cookLogRepositoryProvider),
    keywords: ref.watch(keywordRepositoryProvider),
    seasonalKeywords: () => seasonal,
  );
}

/// How many suggestions are computed: the list screen shows all of them, the
/// start screen the first [homeRecommendationCount].
const recommendationCount = 20;

/// How many suggestions the start screen shows.
const homeRecommendationCount = 10;

/// The suggestions for [day], best first, computed once per day: the start
/// screen and the list screen share them, and visiting either again doesn't
/// compute them again. Invalidate it to compute them anew (pull to refresh);
/// it also is when the seasonal keywords change, and once the server can be
/// reached again after a failure.
///
/// Failures aren't retried; the screens show them with a button.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<List<Recommendation>> recommendations(Ref ref, CalendarDay day) async {
  ref.listen(isOfflineProvider, (was, offline) {
    if (was == true && !offline) ref.invalidateSelf();
  });
  final userId = await ref.watch(userRepositoryProvider).currentUserId();
  // So recipes planned this week aren't suggested. Without the plans the
  // suggestions are still worth showing.
  List<MealPlan> plans;
  try {
    final list = await ref
        .watch(mealPlanRepositoryProvider)
        .list(day, day.addDays(6));
    plans = list.plans;
  } on Failure {
    plans = const [];
  }
  return ref
      .watch(recommenderProvider)
      .recommend(
        RecommendationContext(today: day, userId: userId, mealPlans: plans),
        limit: recommendationCount,
      );
}

const _seasonalHintKey = 'home.seasonal-hint-dismissed';

/// Whether the user dismissed the hint to set up seasonal keywords, kept on
/// this device.
@Riverpod(keepAlive: true)
class SeasonalHintDismissed extends _$SeasonalHintDismissed {
  @override
  bool build() =>
      ref.watch(localStoreProvider).read(_seasonalHintKey) == 'true';

  void dismiss() {
    state = true;
    ref.read(localStoreProvider).write(_seasonalHintKey, 'true');
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

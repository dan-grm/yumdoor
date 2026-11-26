import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
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

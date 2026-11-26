import '../../core/failures.dart';
import '../models/recommendation.dart';

/// A source of recipe suggestions, such as the rule-based one or, later, a
/// language model. The UI shows every provider's suggestions the same way.
abstract interface class RecommendationProvider {
  /// Identifies the provider, e.g. in settings. Stable across versions.
  String get id;

  /// At most [limit] suggestions for [context], best first, at most one per
  /// recipe. Throws a [Failure].
  Future<List<Recommendation>> recommend(
    RecommendationContext context, {
    int limit = 10,
  });
}

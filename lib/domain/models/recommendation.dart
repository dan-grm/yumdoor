import 'package:freezed_annotation/freezed_annotation.dart';

import 'calendar_day.dart';
import 'keyword.dart';
import 'meal_plan.dart';
import 'recipe_summary.dart';
import 'user_ref.dart';

part 'recommendation.freezed.dart';

/// A recipe suggested by a recommendation provider, with why.
@freezed
abstract class Recommendation with _$Recommendation {
  @Assert('score >= 0 && score <= 1', 'score must be 0 to 1')
  const factory Recommendation({
    required RecipeSummary recipe,

    /// 0 to 1, higher is a better fit. Only comparable between
    /// recommendations of the same provider. Providers keep it in range
    /// themselves: it is asserted, not checked in release builds.
    required double score,

    /// Why it is suggested, most important first. The UI words them in the
    /// user's language.
    @Default([]) List<RecommendationReason> reasons,
  }) = _Recommendation;
}

/// Why a recipe is suggested.
@freezed
sealed class RecommendationReason with _$RecommendationReason {
  /// The current user rated it highly in their cook log: [rating] is the
  /// average of their ratings, 1 to 5 stars ([RecipeSummary.rating]).
  const factory RecommendationReason.highlyRated(double rating) = HighlyRated;

  /// The current user last cooked it on [date], a while ago.
  const factory RecommendationReason.notCookedSince(DateTime date) =
      NotCookedSince;

  /// It has [keyword], which the user mapped to the current month.
  const factory RecommendationReason.inSeason(Keyword keyword) = InSeason;

  /// [user], someone else in the space, cooked it on [date].
  const factory RecommendationReason.cookedRecentlyBy(
    UserRef user,
    DateTime date,
  ) = CookedRecentlyBy;

  /// It resembles [recipe], which the current user cooked recently.
  const factory RecommendationReason.similarTo(RecipeSummary recipe) =
      SimilarTo;

  /// A reason in words, e.g. from a language model. Untrusted text: show it
  /// as plain text, never as Markdown or HTML.
  const factory RecommendationReason.freeText(String text) = FreeTextReason;
}

/// What a recommendation provider knows about the situation it suggests for.
@freezed
abstract class RecommendationContext with _$RecommendationContext {
  const factory RecommendationContext({
    /// The day to suggest for, on this device's calendar. Decides the season
    /// and what counts as recent.
    required CalendarDay today,

    /// The id of the current user, to tell their own cook logs from other
    /// people's.
    required int userId,

    /// This week's meal plans, so planned recipes aren't suggested again.
    @Default([]) List<MealPlan> mealPlans,

    /// What the user feels like, in their own words; `null` if they didn't
    /// say. Providers that can't use free text ignore it.
    String? wish,
  }) = _RecommendationContext;
}

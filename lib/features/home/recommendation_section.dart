import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/recommendation.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/recipe_image.dart';
import '../recipe/recipe_screen.dart';
import '../recommendations/reason_text.dart';
import '../recommendations/recommendation_providers.dart';
import '../recommendations/recommendations_screen.dart';
import '../recommendations/seasonal_keyword_providers.dart';
import '../settings/settings_screen.dart';

/// "Vorschläge für dich" on the start screen: what to cook next, each with
/// the first reason why, in a row of cards that scrolls sideways, and "Mehr"
/// for the full list.
///
/// It loads on its own, so a failure shows here and leaves the rest of the
/// start screen alone. Suggestions need the server, so offline it is one
/// line saying so. Without seasonal keywords a hint offers to set them up,
/// until the user dismisses it.
class RecommendationSection extends ConsumerWidget {
  const RecommendationSection({super.key, required this.today});

  final CalendarDay today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    if (ref.watch(isOfflineProvider)) {
      return Text(
        l10n.homeSuggestionsOffline,
        style: t.caption.copyWith(color: t.inkMuted),
      );
    }

    final suggestions = ref.watch(recommendationsProvider(today));
    final mapping = ref.watch(seasonalKeywordMappingProvider).value;
    final showHint =
        mapping != null &&
        mapping.isEmpty &&
        !ref.watch(seasonalHintDismissedProvider);

    final Widget body = switch (suggestions) {
      AsyncData(:final value) when value.isEmpty => const SizedBox.shrink(),
      AsyncData(:final value) => _Cards(
        recommendations: value.take(homeRecommendationCount).toList(),
        today: today,
      ),
      AsyncError(:final error) => _Failed(
        error: error,
        onRetry: () => ref.invalidate(recommendationsProvider(today)),
      ),
      _ => const _Placeholders(),
    };
    final hasSuggestions = switch (suggestions) {
      AsyncData(:final value) => value.isNotEmpty,
      _ => true,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasSuggestions) ...[
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.homeSuggestions,
                    style: t.titleS.copyWith(color: t.ink),
                  ),
                ),
              ),
              if (suggestions.hasValue)
                TextButton(
                  onPressed: () => unawaited(context.push(recommendationsPath)),
                  child: Text(
                    l10n.homeSuggestionsMore,
                    style: t.label.copyWith(color: t.sage),
                  ),
                ),
            ],
          ),
          SizedBox(height: t.space2),
          body,
        ],
        if (showHint) ...[
          if (hasSuggestions) SizedBox(height: t.space4),
          const _SeasonalHint(),
        ],
      ],
    );
  }
}

/// The recommendations as cards in a row that scrolls sideways.
class _Cards extends StatelessWidget {
  const _Cards({required this.recommendations, required this.today});

  final List<Recommendation> recommendations;
  final CalendarDay today;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Part of the next card shows, so it is clear that the row scrolls.
        final width = constraints.maxWidth * 0.62;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, recommendation) in recommendations.indexed) ...[
                  if (i > 0) SizedBox(width: t.space3),
                  SizedBox(
                    width: width,
                    child: _SuggestionCard(
                      recommendation: recommendation,
                      today: today,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.recommendation, required this.today});

  final Recommendation recommendation;
  final CalendarDay today;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final recipe = recommendation.recipe;
    final reasons = reasonLines(context, recommendation.reasons, today);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusL),
      side: BorderSide(color: t.line),
    );
    return Material(
      color: t.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => unawaited(context.push(recipeLocation(recipe.id))),
        customBorder: shape,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: ColoredBox(
                color: t.sageSoft,
                child: RecipeImage(
                  url: recipe.image,
                  placeholder: Center(
                    child: Icon(
                      Icons.soup_kitchen_outlined,
                      size: t.titleL.fontSize,
                      color: t.sage,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(t.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleS.copyWith(color: t.ink),
                  ),
                  if (reasons.isNotEmpty) ...[
                    SizedBox(height: t.space1),
                    DefaultTextStyle.merge(
                      style: t.caption.copyWith(color: t.inkMuted),
                      child: ReasonText(
                        reasons.first,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grey-green boxes where the cards will be, while they load.
class _Placeholders extends StatelessWidget {
  const _Placeholders();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * 0.62;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                for (var i = 0; i < 2; i++) ...[
                  if (i > 0) SizedBox(width: t.space3),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: t.sageSoft,
                      borderRadius: BorderRadius.circular(t.radiusL),
                    ),
                    child: SizedBox(width: width, height: width * 0.9),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The suggestions could not be loaded; the start screen goes on without.
class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Text(
            '${l10n.homeSuggestionsFailed} ${failureMessage(context, error)}',
            style: t.caption.copyWith(color: t.inkMuted),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(l10n.retry, style: t.label.copyWith(color: t.sage)),
        ),
      ],
    );
  }
}

/// Offers to set up the seasonal keywords, with a button that dismisses it
/// for good.
class _SeasonalHint extends ConsumerWidget {
  const _SeasonalHint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.sageSoft,
        borderRadius: BorderRadius.circular(t.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(t.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeSeasonalHint,
                    style: t.body.copyWith(color: t.ink),
                  ),
                  SizedBox(height: t.space3),
                  PillButton(
                    label: l10n.homeSeasonalHintOpen,
                    kind: PillButtonKind.secondary,
                    compact: true,
                    onPressed: () =>
                        unawaited(context.push(settingsSeasonalLocation)),
                  ),
                ],
              ),
            ),
            RoundIconButton(
              icon: Icons.close_rounded,
              label: l10n.homeSeasonalHintDismiss,
              onPressed: () =>
                  ref.read(seasonalHintDismissedProvider.notifier).dismiss(),
            ),
          ],
        ),
      ),
    );
  }
}

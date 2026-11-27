import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/recipe_card.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/up_scope.dart';
import '../recipe/recipe_screen.dart';
import 'reason_text.dart';
import 'recommendation_providers.dart';

/// Where [RecommendationsScreen] is.
const recommendationsPath = '/recommendations';

/// All of today's suggestions, up to [recommendationCount], each with all
/// its reasons. Opened with "Mehr" on the start screen; shares the
/// suggestions with it, so opening it doesn't compute them again.
class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final suggestions = ref.watch(recommendationsProvider(today));
    final offline = ref.watch(isOfflineProvider);

    Future<void> refresh() async {
      ref.invalidate(recommendationsProvider(today));
      try {
        await ref.read(recommendationsProvider(today).future);
      } on Object {
        // The screen shows the failure.
      }
    }

    final List<Widget> content = switch (suggestions) {
      _ when offline => [
        Text(
          l10n.homeSuggestionsOffline,
          style: t.body.copyWith(color: t.inkMuted),
        ),
      ],
      AsyncData(:final value) when value.isEmpty => [
        Text(l10n.suggestionsEmpty, style: t.body.copyWith(color: t.inkMuted)),
      ],
      AsyncData(:final value) => [
        for (final (i, recommendation) in value.indexed) ...[
          if (i > 0) SizedBox(height: t.space3),
          RecipeCard(
            title: recommendation.recipe.name,
            image: recommendation.recipe.image,
            onTap: () => unawaited(
              context.push(recipeLocation(recommendation.recipe.id)),
            ),
            meta: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in reasonLines(
                  context,
                  recommendation.reasons,
                  today,
                ))
                  ReasonText(line),
              ],
            ),
          ),
        ],
      ],
      AsyncError(:final error) => [
        FailureView(
          error: error,
          onRetry: () => ref.invalidate(recommendationsProvider(today)),
        ),
      ],
      _ => [
        Padding(
          padding: EdgeInsets.all(t.space6),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    };

    return UpScope(
      onUp: () => context.go('/'),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                t.space5,
                t.space3,
                t.space5,
                t.space6,
              ),
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: t.sizeWide),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            RoundIconButton(
                              icon: Icons.arrow_back_rounded,
                              label: l10n.back,
                              onPressed: () => context.canPop()
                                  ? context.pop()
                                  : context.go('/'),
                            ),
                            SizedBox(width: t.space3),
                            Expanded(
                              child: Semantics(
                                header: true,
                                child: Text(
                                  l10n.suggestionsTitle,
                                  style: t.titleL.copyWith(color: t.ink),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: t.space5),
                        ...content,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

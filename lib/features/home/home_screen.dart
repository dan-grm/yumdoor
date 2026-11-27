import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/services/recipe_shopping.dart';
import '../../domain/services/week_plan.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_as_of.dart';
import '../common/offline_disabled.dart';
import '../common/recipe_image.dart';
import '../cooking/cooking_screen.dart';
import '../planner/planner_providers.dart';
import '../planner/week_labels.dart';
import '../recipe/ingredient_lines.dart';
import '../recipe/recipe_screen.dart';
import '../recommendations/recommendation_providers.dart';
import '../search/search_location.dart';
import '../settings/settings_screen.dart';
import 'home_providers.dart';
import 'activity_section.dart';
import 'recommendation_section.dart';

/// The start screen (mockup 02-start): a greeting, today's date and what is
/// planned for today. The next meal ([todaysMeals]) is shown large, with
/// buttons that open its recipe and cooking mode for the planned servings;
/// the day's other meals are listed below it.
///
/// Today's plans come from the week the planner shows, so offline they come
/// from the same cache, with the time they were loaded.
///
/// The tab stays open in the background, so the screen follows the clock
/// (greeting, day, next meal) once a minute, and counts what is missing
/// again each time it is shown: the shopping list may have changed what is
/// on hand.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final Timer _clockTimer;

  /// Whether the tab was shown at the last change of dependencies.
  bool? _shown;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hidden tabs have their tickers off (TabStack).
    final shown = TickerMode.valuesOf(context).enabled;
    if (shown && _shown == false) {
      // Not while building.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Plans may have changed on another device, on-hand foods on the
        // shopping list.
        ref
          ..invalidate(weekPlansProvider)
          ..invalidate(plannedRecipeProvider)
          ..invalidate(othersActivityProvider);
      });
    }
    _shown = shown;
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final now = ref.watch(clockProvider)();
    final today = CalendarDay.of(now);
    final week = startOfWeek(today, firstWeekdayOf(context));
    final plans = ref.watch(weekPlansProvider(week));

    Future<void> refresh() async {
      ref
        ..invalidate(weekPlansProvider(week))
        ..invalidate(plannedRecipeProvider)
        ..invalidate(recommendationsProvider(today))
        ..invalidate(othersActivityProvider);
      try {
        await Future.wait([
          ref.read(weekPlansProvider(week).future),
          ref.read(othersActivityProvider.future),
        ]);
      } on Object {
        // The screen shows the failure.
      }
    }

    final List<Widget> content = switch (plans) {
      AsyncData(:final value) => [
        if (value.cachedAt case final cachedAt?) ...[
          OfflineAsOf(cachedAt: cachedAt, now: now),
          SizedBox(height: t.space3),
        ],
        ..._today(todaysMeals(value.plans, now), today),
      ],
      AsyncError(:final error) => [
        FailureView(
          error: error,
          onRetry: () => ref.invalidate(weekPlansProvider(week)),
        ),
      ],
      _ => [
        Padding(
          padding: EdgeInsets.all(t.space6),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
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
              // On wide layouts, a column in the middle.
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: t.sizeWide),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(now: now),
                      SizedBox(height: t.space5),
                      ...content,
                      SizedBox(height: t.space6),
                      RecommendationSection(today: today),
                      SizedBox(height: t.space6),
                      ActivitySection(now: now),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _today(TodaysMeals? meals, CalendarDay today) {
    final t = context.tokens;
    if (meals == null) return [_NothingPlanned(today: today)];
    return [
      _NextMealCard(plan: meals.next),
      if (meals.others.isNotEmpty) ...[
        SizedBox(height: t.space5),
        Semantics(
          header: true,
          child: Text(
            context.l10n.homeAlsoToday,
            style: t.titleS.copyWith(color: t.ink),
          ),
        ),
        for (final plan in meals.others) ...[
          SizedBox(height: t.space2),
          _OtherMeal(plan: plan),
        ],
      ],
    ];
  }
}

/// The greeting for the time of day, today's date and the profile button
/// that opens the settings.
class _Header extends StatelessWidget {
  const _Header({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final greeting = switch (now.hour) {
      >= 5 && < 11 => l10n.homeGreetingMorning,
      >= 11 && < 18 => l10n.homeGreetingDay,
      _ => l10n.homeGreetingEvening,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(greeting, style: t.titleL.copyWith(color: t.ink)),
              ),
              Text(
                l10n.homeDate(
                  format.weekdayLong(now),
                  format.dayMonthLong(now),
                ),
                style: t.body.copyWith(color: t.inkMuted),
              ),
            ],
          ),
        ),
        SizedBox(width: t.space3),
        RoundIconButton(
          icon: Icons.person_outline_rounded,
          label: l10n.settingsOpen,
          onPressed: () => unawaited(context.push(settingsPath)),
        ),
      ],
    );
  }
}

/// A card on the start screen: `surface` with a `line` border.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusL),
        border: Border.all(color: t.line),
      ),
      child: Padding(padding: EdgeInsets.all(t.space5), child: child),
    );
  }
}

/// The recipe's image, or a placeholder for a plan without one.
class _PlanImage extends StatelessWidget {
  const _PlanImage({required this.plan, required this.size});

  final MealPlan plan;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final recipe = plan.recipe;
    return ClipRRect(
      borderRadius: BorderRadius.circular(t.radiusM),
      child: SizedBox.square(
        dimension: size,
        child: ColoredBox(
          color: t.sageSoft,
          child: RecipeImage(
            url: recipe?.image,
            placeholder: Center(
              child: Icon(
                recipe == null
                    ? Icons.edit_note_rounded
                    : Icons.soup_kitchen_outlined,
                size: size / 2,
                color: t.sage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Today's next meal: "Heute · Abendessen", the planned servings, the
/// recipe with its time and what is missing, and buttons to view and cook
/// it for the planned servings. A plan without a recipe shows its title.
class _NextMealCard extends ConsumerWidget {
  const _NextMealCard({required this.plan});

  final MealPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipe = plan.recipe;
    final servings = plan.wholeServings;

    final String? missing;
    final bool hasSteps;
    if (recipe == null) {
      missing = null;
      hasSteps = false;
    } else {
      final loaded = ref.watch(plannedRecipeProvider(recipe.id));
      final full = loaded.value;
      // While it loads, cooking mode can load it itself; if it can't be
      // loaded, cooking mode couldn't either.
      hasSteps = switch (loaded) {
        AsyncValue(value: final full?) => full.steps.isNotEmpty,
        AsyncError() => false,
        _ => true,
      };
      missing = switch (full) {
        null => null,
        final full => switch (buildRecipeShopping(
          full,
          servings: plan.servings,
        )) {
          RecipeShopping(neededCount: 0, onHandCount: 0) => null,
          RecipeShopping(neededCount: 0) => l10n.homeAllAtHome,
          final shopping => l10n.homeMissing(shopping.neededCount),
        },
      };
    }
    final minutes = switch (recipe) {
      final recipe? => (recipe.workingTime + recipe.waitingTime).inMinutes,
      null => 0,
    };
    final meta = [
      if (minutes > 0) l10n.recipeMinutes(minutes),
      ?missing,
    ].join(' · ');

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: t.space3,
            runSpacing: t.space2,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: t.butter,
                  borderRadius: BorderRadius.circular(t.radiusFull),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: t.space3,
                    vertical: t.space1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: t.label.fontSize,
                        color: t.onButter,
                      ),
                      SizedBox(width: t.space1),
                      Flexible(
                        child: Text(
                          l10n.homeToday(plan.mealType.name),
                          style: t.label.copyWith(color: t.onButter),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                servingsLabel(context, servings, recipe?.servingsText ?? ''),
                style: t.caption.copyWith(color: t.inkMuted),
              ),
            ],
          ),
          SizedBox(height: t.space4),
          Row(
            children: [
              _PlanImage(plan: plan, size: t.sizeTouch + t.space3),
              SizedBox(width: t.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.label, style: t.titleM.copyWith(color: t.ink)),
                    if (meta.isNotEmpty)
                      Text(meta, style: t.caption.copyWith(color: t.inkMuted)),
                  ],
                ),
              ),
            ],
          ),
          if (recipe != null) ...[
            SizedBox(height: t.space4),
            Row(
              children: [
                Expanded(
                  child: PillButton(
                    label: l10n.homeViewRecipe,
                    kind: PillButtonKind.secondary,
                    compact: true,
                    onPressed: () => context.push(
                      recipeLocation(recipe.id, servings: servings),
                    ),
                  ),
                ),
                SizedBox(width: t.space3),
                Expanded(
                  child: PillButton(
                    label: l10n.homeStartCooking,
                    icon: Icons.play_arrow_rounded,
                    compact: true,
                    onPressed: hasSteps
                        ? () =>
                              context.push(cookingLocation(recipe.id, servings))
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Another meal of today, in a row that opens its recipe for the planned
/// servings.
class _OtherMeal extends StatelessWidget {
  const _OtherMeal({required this.plan});

  final MealPlan plan;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final recipe = plan.recipe;
    return Material(
      color: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.radiusM),
        side: BorderSide(color: t.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: recipe == null
            ? null
            : () => context.push(
                recipeLocation(recipe.id, servings: plan.wholeServings),
              ),
        child: Padding(
          padding: EdgeInsets.all(t.space2),
          child: Row(
            children: [
              _PlanImage(plan: plan, size: t.sizeTouch),
              SizedBox(width: t.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.planMealLine(
                        plan.mealType.name,
                        LocaleFormat.of(context).integer(plan.wholeServings),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: t.inkMuted),
                    ),
                    Text(
                      plan.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.label.copyWith(color: t.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nothing planned for today: a short line and a button that opens the
/// planner's recipe picker for [today].
class _NothingPlanned extends StatelessWidget {
  const _NothingPlanned({required this.today});

  final CalendarDay today;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.homeNothingPlanned, style: t.body.copyWith(color: t.ink)),
          SizedBox(height: t.space4),
          OfflineDisabled(
            builder: (context, enabled) => PillButton(
              label: l10n.planAddRecipe,
              icon: Icons.add_rounded,
              kind: PillButtonKind.secondary,
              compact: true,
              onPressed: enabled
                  ? () => context.push(
                      pickRecipeLocation(const RecipeQuery(), today),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

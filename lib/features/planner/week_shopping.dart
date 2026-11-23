import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/services/recipe_shopping.dart';
import '../../l10n/l10n.dart';
import '../common/offline_disabled.dart';
import '../shell/app_shell.dart';
import 'planner_providers.dart';

part 'week_shopping.g.dart';

/// What putting the week on the shopping list would add.
typedef WeekShoppingPreview = ({
  /// The meals with a recipe that aren't on the list yet and have
  /// ingredients to add, in the planner's order.
  List<MealPlan> open,

  /// Ingredients that would go on the list.
  int needed,

  /// Ingredients left out because they are at home.
  int onHand,

  /// Whether the week has any meal with a recipe.
  bool hasRecipes,
});

/// Counts the ingredients the meals of the week from [start] still need, as
/// adding them would ([buildRecipeShopping]): meals with a recipe that
/// aren't on the shopping list yet. The whole household's meals count, as the
/// list is the household's.
///
/// Failures are shown on the card instead of retrying on their own.
@Riverpod(retry: _noRetry)
Future<WeekShoppingPreview> weekShopping(Ref ref, CalendarDay start) async {
  final plans = (await ref.watch(weekPlansProvider(start).future)).plans;
  final recipes = ref.watch(recipeRepositoryProvider);
  final withRecipe = [
    for (final plan in plans)
      if (plan.recipe != null) plan,
  ];
  final candidates = [
    for (final plan in withRecipe)
      if (!plan.onShoppingList) plan,
  ];
  // Not through the recipe screen's provider: counting isn't a view.
  final loaded = await Future.wait([
    for (final id in {for (final plan in candidates) plan.recipe!.id})
      recipes.fetchRecipe(id),
  ]);
  final byId = {for (final recipe in loaded) recipe.id: recipe};
  final open = <MealPlan>[];
  var needed = 0;
  var onHand = 0;
  for (final plan in candidates) {
    final shopping = buildRecipeShopping(
      byId[plan.recipe!.id]!,
      servings: plan.servings,
    );
    onHand += shopping.onHandCount;
    if (shopping.isEmpty) continue;
    needed += shopping.neededCount;
    open.add(plan);
  }
  return (
    open: open,
    needed: needed,
    onHand: onHand,
    hasRecipes: withRecipe.isNotEmpty,
  );
}

Duration? _noRetry(int retryCount, Object error) => null;

/// The card under the week planner (mockup 10-wochenplan): how many
/// ingredients the week's meals need, a button that puts them all on the
/// shopping list and one that opens the list.
///
/// Adding goes meal by meal with the recipe read fresh, so what is at home
/// now is respected; a meal that fails is named and the others stay on the
/// list. It shows nothing while the week has no meal with a recipe, and
/// can't add anything offline.
class WeekShoppingCard extends ConsumerStatefulWidget {
  const WeekShoppingCard({super.key, required this.start});

  /// The first day of the week.
  final CalendarDay start;

  @override
  ConsumerState<WeekShoppingCard> createState() => _WeekShoppingCardState();
}

class _WeekShoppingCardState extends ConsumerState<WeekShoppingCard> {
  /// How many meals are done and how many there are, while adding.
  ({int done, int total})? _progress;

  /// The names of the meals the last attempt couldn't add.
  List<String> _failed = const [];

  @override
  void didUpdateWidget(WeekShoppingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start) _failed = const [];
  }

  Future<void> _add(List<MealPlan> open) async {
    if (_progress != null) return;
    // Read before the first await: the planner may be left meanwhile, and the
    // adding goes on.
    final container = ProviderScope.containerOf(context, listen: false);
    final recipes = ref.read(recipeRepositoryProvider);
    final shoppingList = ref.read(shoppingRepositoryProvider);
    setState(() {
      _failed = const [];
      _progress = (done: 0, total: open.length);
    });
    final failed = <String>[];
    for (final (index, plan) in open.indexed) {
      try {
        // Freshly read: what is at home may have changed since the count.
        final recipe = await recipes.fetchRecipe(plan.recipe!.id);
        await shoppingList.addRecipe(
          recipe,
          plan.servings,
          mealPlanId: plan.id,
        );
      } on Failure {
        failed.add(plan.label);
      }
      if (mounted) {
        setState(() => _progress = (done: index + 1, total: open.length));
      }
    }
    // Plans added to the list are marked, so the counts start over.
    container.invalidate(weekPlansProvider);
    if (!mounted) return;
    setState(() {
      _progress = null;
      _failed = failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final preview = ref.watch(weekShoppingProvider(widget.start));
    final progress = _progress;
    final data = preview.value;
    if (data != null && !data.hasRecipes && progress == null) {
      return const SizedBox.shrink();
    }
    final open = data?.open ?? const <MealPlan>[];

    final String status;
    if (progress != null) {
      status = l10n.planWeekShoppingProgress(
        (progress.done + 1).clamp(1, progress.total),
        progress.total,
      );
    } else if (data != null) {
      status = open.isEmpty
          ? l10n.planWeekShoppingDone
          : l10n.planWeekShoppingCount(data.needed, data.onHand);
    } else if (preview.hasError) {
      status = l10n.planWeekShoppingCountFailed;
    } else {
      status = l10n.planWeekShoppingCounting;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space3),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          child: Container(
            padding: EdgeInsets.all(t.space4),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(t.radiusL),
              border: Border.all(color: t.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.planWeekShoppingTitle,
                    style: t.titleS.copyWith(color: t.ink),
                  ),
                ),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    status,
                    style: t.caption.copyWith(color: t.inkMuted),
                  ),
                ),
                if (progress != null) ...[
                  SizedBox(height: t.space2),
                  LinearProgressIndicator(
                    value: progress.done / progress.total,
                    color: t.sage,
                    backgroundColor: t.sageSoft,
                  ),
                ],
                if (_failed.isNotEmpty) ...[
                  SizedBox(height: t.space2),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.planWeekShoppingFailed(_failed.join(', ')),
                      style: t.caption.copyWith(color: t.danger),
                    ),
                  ),
                ],
                SizedBox(height: t.space3),
                Wrap(
                  spacing: t.space2,
                  runSpacing: t.space2,
                  children: [
                    if (open.isNotEmpty)
                      OfflineDisabled(
                        builder: (context, enabled) => PillButton(
                          label: l10n.planWeekShoppingAdd,
                          icon: Icons.add_shopping_cart_rounded,
                          compact: true,
                          onPressed: enabled && progress == null
                              ? () => _add(open)
                              : null,
                        ),
                      ),
                    PillButton(
                      label: l10n.planWeekShoppingOpen,
                      icon: Icons.shopping_basket_outlined,
                      compact: true,
                      kind: open.isEmpty
                          ? PillButtonKind.accent
                          : PillButtonKind.secondary,
                      onPressed: () => context.go(shoppingPath),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

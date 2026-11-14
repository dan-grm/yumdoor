import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/components/step_dots.dart';
import '../../design/design.dart';
import '../../domain/models/cooking_progress.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../domain/services/step_template.dart';
import '../../l10n/l10n.dart';
import '../../platform/wake_lock/wake_lock_service.dart';
import '../common/failure_view.dart';
import '../common/layout.dart';
import '../common/markdown_text.dart';
import '../common/step_text.dart';
import '../recipe/ingredient_lines.dart';
import '../recipe/recipe_providers.dart';
import 'cooking_providers.dart';

/// Cooking mode: one step per page with its scaled ingredients
/// (mockup `05-kochmodus`).
///
/// [servings] were chosen on the recipe screen and are read-only here. The
/// screen is kept on while this screen is open.
class CookingScreen extends ConsumerStatefulWidget {
  const CookingScreen({super.key, required this.recipeId, this.servings});

  final int recipeId;

  /// `null` means the recipe's own servings.
  final int? servings;

  @override
  ConsumerState<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends ConsumerState<CookingScreen> {
  late final WakeLockService _wakeLock;
  late final StreamSubscription<WakeLockStatus> _wakeLockChanges;
  late WakeLockStatus _wakeLockStatus;

  @override
  void initState() {
    super.initState();
    _wakeLock = ref.read(wakeLockServiceProvider);
    _wakeLockStatus = _wakeLock.status;
    _wakeLockChanges = _wakeLock.statusChanges.listen(
      (status) => setState(() => _wakeLockStatus = status),
    );
    unawaited(_keepScreenOn());
  }

  @override
  void dispose() {
    unawaited(_wakeLockChanges.cancel());
    unawaited(_wakeLock.release());
    super.dispose();
  }

  Future<void> _keepScreenOn() async {
    final status = await _wakeLock.acquire();
    if (!mounted) return;
    setState(() => _wakeLockStatus = status);
    final refused =
        status == WakeLockStatus.unsupported || status == WakeLockStatus.denied;
    if (refused && !ref.read(wakeLockHintShownProvider)) {
      ref.read(wakeLockHintShownProvider.notifier).markShown();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.cookingWakeLockHint)));
    }
  }

  void _toggleWakeLock() => _wakeLockStatus == WakeLockStatus.active
      ? unawaited(_wakeLock.release())
      : unawaited(_keepScreenOn());

  /// "Fertig": the ticked-off ingredients are forgotten.
  void _finish() {
    ref
        .read(cookingProgressControllerProvider(widget.recipeId).notifier)
        .forget();
    _leave();
  }

  void _leave() => context.canPop()
      ? context.pop()
      : context.go('/recipe/${widget.recipeId}');

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final recipe = ref.watch(recipeProvider(widget.recipeId));
    // Kept alive while cooking, also on steps without ingredients; the step
    // pages watch it themselves.
    ref.listen(cookingProgressControllerProvider(widget.recipeId), (_, _) {});
    final closeButton = RoundIconButton(
      icon: Icons.close_rounded,
      label: context.l10n.cookingClose,
      onPressed: _leave,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, t.space6),
          child: switch (recipe) {
            AsyncData(:final value) => _CookingView(
              recipe: value,
              servings: widget.servings ?? math.max(value.servings, 1),
              closeButton: closeButton,
              wakeLockButton: _WakeLockButton(
                status: _wakeLockStatus,
                onToggle: _toggleWakeLock,
              ),
              onDone: _finish,
            ),
            AsyncError(:final error) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                closeButton,
                Expanded(
                  child: FailureView(
                    error: error,
                    notFoundMessage: context.l10n.recipeNotFound,
                    onRetry: () =>
                        ref.invalidate(recipeProvider(widget.recipeId)),
                  ),
                ),
              ],
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _WakeLockButton extends StatelessWidget {
  const _WakeLockButton({required this.status, required this.onToggle});

  final WakeLockStatus status;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RoundIconButton(
      icon: Icons.light_mode_outlined,
      label: switch (status) {
        WakeLockStatus.active => l10n.cookingScreenOn,
        WakeLockStatus.unsupported => l10n.cookingScreenUnavailable,
        WakeLockStatus.inactive ||
        WakeLockStatus.denied => l10n.cookingScreenOff,
      },
      selected: status == WakeLockStatus.active,
      onPressed: status == WakeLockStatus.unsupported ? null : onToggle,
    );
  }
}

class _CookingView extends StatefulWidget {
  const _CookingView({
    required this.recipe,
    required this.servings,
    required this.closeButton,
    required this.wakeLockButton,
    required this.onDone,
  });

  final Recipe recipe;
  final int servings;
  final Widget closeButton;
  final Widget wakeLockButton;
  final VoidCallback onDone;

  @override
  State<_CookingView> createState() => _CookingViewState();
}

class _CookingViewState extends State<_CookingView> {
  final _pages = PageController();
  var _page = 0;
  var _allIngredients = false;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _pages.jumpToPage(page);
    } else {
      unawaited(
        _pages.animateToPage(
          page,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipe = widget.recipe;
    final steps = recipe.steps;
    final scaling = ScalingService(
      recipeServings: recipe.servings,
      servings: widget.servings,
    );
    final servings = servingsLabel(
      context,
      widget.servings,
      recipe.servingsText,
    );
    final last = _page == steps.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: t.sizeButton,
          child: Row(
            children: [
              widget.closeButton,
              SizedBox(width: t.space2),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: t.inkMuted),
                    ),
                    if (steps.isNotEmpty)
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.cookingStepOf(_page + 1, steps.length),
                          style: t.titleS.copyWith(color: t.ink),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: t.space2),
              widget.wakeLockButton,
            ],
          ),
        ),
        if (steps.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                l10n.cookingNoSteps,
                style: t.body.copyWith(color: t.inkMuted),
              ),
            ),
          )
        else ...[
          SizedBox(height: t.space2),
          Align(
            alignment: Alignment.centerLeft,
            child: StepDots(
              count: steps.length,
              current: _page,
              onSelected: _goTo,
            ),
          ),
          SizedBox(height: t.space2),
          Expanded(
            child: PageView(
              controller: _pages,
              onPageChanged: (page) => setState(() => _page = page),
              children: [
                for (final (index, step) in steps.indexed)
                  _StepPage(
                    recipeId: widget.recipe.id,
                    steps: steps,
                    allIngredients: _allIngredients,
                    onAllIngredientsChanged: (value) =>
                        setState(() => _allIngredients = value),
                    step: step,
                    number: index + 1,
                    isLast: index == steps.length - 1,
                    scaling: scaling,
                    servings: servings,
                  ),
              ],
            ),
          ),
          SizedBox(height: t.space4),
          Row(
            children: [
              RoundIconButton(
                icon: Icons.chevron_left_rounded,
                label: l10n.cookingPrevious(math.max(_page, 1)),
                size: t.sizeButton,
                outlined: true,
                onPressed: _page > 0 ? () => _goTo(_page - 1) : null,
              ),
              SizedBox(width: t.space3),
              Expanded(
                child: last
                    ? PillButton(
                        label: l10n.cookingDone,
                        icon: Icons.check_rounded,
                        onPressed: widget.onDone,
                      )
                    : PillButton(
                        label: l10n.cookingNext(_page + 2),
                        kind: PillButtonKind.primary,
                        trailingIcon: Icons.arrow_forward_rounded,
                        onPressed: () => _goTo(_page + 1),
                      ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// One step: its text in a card, then its ingredients for the servings.
class _StepPage extends StatelessWidget {
  const _StepPage({
    required this.recipeId,
    required this.steps,
    required this.step,
    required this.number,
    required this.isLast,
    required this.scaling,
    required this.servings,
    required this.allIngredients,
    required this.onAllIngredientsChanged,
  });

  final int recipeId;

  /// All steps of the recipe, for the "Alle" ingredients in the wide layout.
  final List<RecipeStep> steps;
  final RecipeStep step;
  final int number;
  final bool isLast;
  final ScalingService scaling;
  final String servings;

  /// Wide layout: the right column lists every step's ingredients.
  final bool allIngredients;
  final ValueChanged<bool> onAllIngredientsChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (!isWideLayout(context)) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: t.space2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stepCard(context),
            if (step.ingredients.isNotEmpty) ...[
              SizedBox(height: t.space5),
              _ingredientsHeader(context),
              SizedBox(height: t.space2),
              _ingredients([step]),
            ],
          ],
        ),
      );
    }
    // Wide: the step left, its ingredients (or all of them) right.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: t.space2),
            child: _stepCard(context),
          ),
        ),
        SizedBox(width: t.space8),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: t.space2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ingredientsHeader(context),
                SizedBox(height: t.space1),
                _ingredientsToggle(context),
                SizedBox(height: t.space2),
                if (allIngredients)
                  _ingredients(steps, titled: true)
                else if (step.ingredients.isEmpty)
                  Text(
                    context.l10n.cookingNoStepIngredients,
                    style: t.body.copyWith(color: t.inkMuted),
                  )
                else
                  _ingredients([step]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepCard(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final name = step.name.trim();
    final instruction = step.instruction.trim();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(t.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(t.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (isLast
                      ? l10n.cookingLastStep(number)
                      : l10n.recipeStepTitle(number))
                  .toUpperCase(),
              style: t.overline.copyWith(color: t.sage),
            ),
            if (name.isNotEmpty) ...[
              SizedBox(height: t.space1),
              Text(name, style: t.titleS.copyWith(color: t.ink)),
            ],
            if (instruction.isNotEmpty) ...[
              SizedBox(height: t.space2),
              MarkdownText(
                instruction,
                style: t.step.copyWith(color: t.ink),
                spanBuilder: stepTemplateSpans(
                  context,
                  StepTemplate(ingredients: step.ingredients, scaling: scaling),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ingredientsHeader(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: t.space3,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.recipeIngredients,
            style: t.titleS.copyWith(color: t.ink),
          ),
        ),
        Text(
          l10n.cookingForServings(servings),
          style: t.body.copyWith(color: t.inkMuted),
        ),
      ],
    );
  }

  Widget _ingredientsToggle(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Wrap(
      spacing: t.space2,
      children: [
        ChoiceFilterChip(
          label: l10n.cookingIngredientsOfStep,
          selected: !allIngredients,
          onSelected: () => onAllIngredientsChanged(false),
        ),
        ChoiceFilterChip(
          label: l10n.cookingIngredientsAll,
          selected: allIngredients,
          onSelected: () => onAllIngredientsChanged(true),
        ),
      ],
    );
  }

  /// The ingredients of [steps], tickable per step.
  Widget _ingredients(
    List<RecipeStep> steps, {
    bool titled = false,
  }) => Consumer(
    builder: (context, ref, _) {
      final progress = ref.watch(cookingProgressControllerProvider(recipeId));
      IngredientOccurrence occurrence(RecipeStep step, Ingredient ingredient) =>
          (stepId: step.id, ingredientId: ingredient.id);
      return IngredientGroups(
        steps: steps,
        scaling: scaling,
        alwaysTitled: titled,
        isDone: (step, ingredient) =>
            progress.isDone(occurrence(step, ingredient)),
        onToggle: (step, ingredient) => ref
            .read(cookingProgressControllerProvider(recipeId).notifier)
            .toggle(occurrence(step, ingredient)),
      );
    },
  );
}

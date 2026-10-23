import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/step_dots.dart';
import '../../design/design.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/l10n.dart';
import '../../platform/wake_lock/wake_lock_service.dart';
import '../common/failure_view.dart';
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

  void _leave() => context.canPop()
      ? context.pop()
      : context.go('/recipe/${widget.recipeId}');

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final recipe = ref.watch(recipeProvider(widget.recipeId));
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
              onDone: _leave,
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
    required this.step,
    required this.number,
    required this.isLast,
    required this.scaling,
    required this.servings,
  });

  final RecipeStep step;
  final int number;
  final bool isLast;
  final ScalingService scaling;
  final String servings;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final name = step.name.trim();
    final instruction = step.instruction.trim();

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: t.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
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
                    // Plain text until markdown, templates and timers (M2).
                    Text(instruction, style: t.step.copyWith(color: t.ink)),
                  ],
                ],
              ),
            ),
          ),
          if (step.ingredients.isNotEmpty) ...[
            SizedBox(height: t.space5),
            Wrap(
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
            ),
            SizedBox(height: t.space2),
            IngredientLines(ingredients: step.ingredients, scaling: scaling),
          ],
        ],
      ),
    );
  }
}

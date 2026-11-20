import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../design/components/buttons.dart';
import '../../design/components/servings_picker.dart';
import '../../design/design.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../domain/services/step_template.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/layout.dart';
import '../common/markdown_text.dart';
import '../common/offline_disabled.dart';
import '../common/recipe_image.dart';
import '../common/step_text.dart';
import '../cook_log/cook_log_screen.dart';
import '../editor/editor_screen.dart';
import '../planner/plan_sheet.dart';
import 'ingredient_lines.dart';
import 'recipe_meta.dart';
import 'recipe_providers.dart';

/// Height of the image above the title (mockup 04-rezept).
const _imageHeight = 200.0;

/// A recipe with the servings picker and its scaled ingredients
/// (mockup `04-rezept`). "Kochen starten" opens cooking mode with the chosen
/// servings.
class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider(recipeId));
    return Scaffold(
      // While it reloads (after a cook log entry was saved) the recipe
      // stays, and so do the chosen servings; a failed reload keeps it too.
      body: switch (recipe) {
        AsyncValue(value: final value?) => _RecipeView(recipe: value),
        AsyncError(:final error) => SafeArea(
          child: Stack(
            children: [
              FailureView(
                error: error,
                notFoundMessage: context.l10n.recipeNotFound,
                onRetry: () => ref.invalidate(recipeProvider(recipeId)),
              ),
              const _BackButton(),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _RecipeView extends StatefulWidget {
  const _RecipeView({required this.recipe});

  final Recipe recipe;

  @override
  State<_RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<_RecipeView> {
  late int _servings = math.max(widget.recipe.servings, 1);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipe = widget.recipe;
    final scaling = ScalingService(
      recipeServings: recipe.servings,
      servings: _servings,
    );
    String servings(int count) =>
        servingsLabel(context, count, recipe.servingsText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(recipe: recipe),
                // Content clear of notches in landscape; the image stays
                // edge to edge.
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      t.space5,
                      t.space4,
                      t.space5,
                      t.space6,
                    ),
                    child: Builder(
                      builder: (context) {
                        final details = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _TitleBlock(recipe: recipe),
                            SizedBox(height: t.space4),
                            _WriteActions(
                              onCooked: () => context.push(
                                cookLogLocation(recipe.id, _servings),
                              ),
                              onPlan: () => showPlanSheet(
                                context,
                                recipeId: recipe.id,
                                recipeName: recipe.name,
                                servings: _servings,
                                servingsText: recipe.servingsText,
                              ),
                              onEdit: () =>
                                  context.push(editLocation(recipe.id)),
                            ),
                            SizedBox(height: t.space5),
                            Divider(height: 1, thickness: 1, color: t.line),
                            SizedBox(height: t.space4),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: t.space3,
                              runSpacing: t.space2,
                              children: [
                                Semantics(
                                  header: true,
                                  child: Text(
                                    l10n.recipeIngredients,
                                    style: t.titleM.copyWith(color: t.ink),
                                  ),
                                ),
                                ServingsPicker(
                                  servings: _servings,
                                  label: servings(_servings),
                                  onChanged: (value) =>
                                      setState(() => _servings = value),
                                ),
                              ],
                            ),
                            if (scaling.factor != 1) ...[
                              SizedBox(height: t.space1),
                              Text(
                                l10n.recipeScaledFrom(
                                  servings(math.max(recipe.servings, 1)),
                                ),
                                style: t.caption.copyWith(color: t.inkMuted),
                              ),
                            ],
                            SizedBox(height: t.space2),
                            IngredientGroups(
                              steps: recipe.steps,
                              scaling: scaling,
                              dividers: true,
                            ),
                          ],
                        );
                        if (!isWideLayout(context) ||
                            !recipe.steps.any(_Steps.hasText)) {
                          return details;
                        }
                        // Wide: the steps next to the ingredients.
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: details),
                            SizedBox(width: t.space8),
                            Expanded(
                              child: _Steps(
                                steps: recipe.steps,
                                scaling: scaling,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: t.surface,
            border: Border(top: BorderSide(color: t.line)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                t.space5,
                t.space4,
                t.space5,
                t.space6,
              ),
              child: PillButton(
                label: l10n.recipeStartCooking(servings(_servings)),
                icon: Icons.play_arrow_rounded,
                onPressed: recipe.steps.isEmpty
                    ? null
                    : () => context.push(
                        Uri(
                          path: '/recipe/${recipe.id}/cook',
                          queryParameters: {'servings': '$_servings'},
                        ).toString(),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The image (or a placeholder) with the back button over it. A copy from
/// the offline cache is preferred over the network.
class _Header extends StatelessWidget {
  const _Header({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final placeholder = Center(
      child: Icon(
        Icons.soup_kitchen_outlined,
        size: t.sizeButton + t.space4,
        color: t.sage,
      ),
    );

    return SizedBox(
      height: _imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: t.sageSoft,
            child: RecipeImage(url: recipe.image, placeholder: placeholder),
          ),
          const SafeArea(child: _BackButton()),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(t.space5, t.space4, 0, 0),
        child: RoundIconButton(
          icon: Icons.chevron_left_rounded,
          label: context.l10n.back,
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
    );
  }
}

/// Name, meta line, keywords and description.
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final time = recipe.workingTime + recipe.waitingTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(recipe.name, style: t.titleL.copyWith(color: t.ink)),
        ),
        if (time.inMinutes > 0 ||
            recipe.rating != null ||
            recipe.lastCooked != null) ...[
          SizedBox(height: t.space1),
          DefaultTextStyle.merge(
            style: t.caption.copyWith(color: t.inkMuted),
            child: RecipeMetaLine(
              time: time,
              rating: recipe.rating,
              lastCooked: recipe.lastCooked,
            ),
          ),
        ],
        if (recipe.keywords.isNotEmpty) ...[
          SizedBox(height: t.space3),
          Wrap(
            spacing: t.space2,
            runSpacing: t.space2,
            children: [
              for (final keyword in recipe.keywords)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.surfaceSunken,
                    borderRadius: BorderRadius.circular(t.radiusFull),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: t.space3,
                      vertical: t.space1,
                    ),
                    child: Text(
                      keyword.name,
                      style: t.caption.copyWith(color: t.inkMuted),
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (recipe.description.trim().isNotEmpty) ...[
          SizedBox(height: t.space4),
          MarkdownText(
            recipe.description.trim(),
            style: t.body.copyWith(color: t.ink),
          ),
        ],
      ],
    );
  }
}

/// "Als gekocht eintragen", then plan, shop and edit. Shop is visible but
/// disabled until it is built. All of them are disabled while offline.
class _WriteActions extends ConsumerWidget {
  const _WriteActions({
    required this.onCooked,
    required this.onPlan,
    required this.onEdit,
  });

  /// Opens the cook log screen for the chosen servings.
  final VoidCallback onCooked;

  /// Opens the plan sheet for the chosen servings.
  final VoidCallback onPlan;

  /// Opens the editor.
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final offline = ref.watch(isOfflineProvider);
    // Shop isn't built yet, so it is disabled online too.
    final actions = [
      (Icons.calendar_today_outlined, l10n.recipePlan, onPlan),
      (Icons.shopping_cart_outlined, l10n.recipeShop, null),
      (Icons.edit_outlined, l10n.recipeEdit, onEdit),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OfflineDisabled(
          builder: (context, enabled) => PillButton(
            label: l10n.recipeCooked,
            icon: Icons.check_rounded,
            kind: PillButtonKind.secondary,
            compact: true,
            onPressed: enabled ? onCooked : null,
          ),
        ),
        SizedBox(height: t.space2),
        Row(
          children: [
            for (final (index, (icon, label, onPressed))
                in actions.indexed) ...[
              if (index > 0) SizedBox(width: t.space2),
              Expanded(
                child: OfflineDisabled(
                  builder: (context, enabled) => PillButton(
                    label: label,
                    icon: icon,
                    kind: PillButtonKind.secondary,
                    compact: true,
                    onPressed: enabled ? onPressed : null,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: t.space2),
        Text(
          offline ? l10n.offlineWriteDisabled : l10n.recipeShopComingSoon,
          style: t.caption.copyWith(color: t.inkMuted),
        ),
      ],
    );
  }
}

/// The steps with their text, as a column next to the ingredients in the wide
/// layout. Templates are scaled to the chosen servings.
class _Steps extends StatelessWidget {
  const _Steps({required this.steps, required this.scaling});

  final List<RecipeStep> steps;
  final ScalingService scaling;

  /// Steps with neither name nor text (only ingredients) are left out.
  static bool hasText(RecipeStep step) =>
      step.name.trim().isNotEmpty || step.instruction.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.recipeMethod,
            style: t.titleM.copyWith(color: t.ink),
          ),
        ),
        for (final (index, step) in steps.indexed)
          if (hasText(step)) ...[
            SizedBox(height: t.space4),
            // Numbered like cooking mode, with the step's name below.
            Semantics(
              header: true,
              child: Text(
                l10n.recipeStepTitle(index + 1).toUpperCase(),
                style: t.overline.copyWith(color: t.sage),
              ),
            ),
            if (step.name.trim().isNotEmpty)
              Text(step.name.trim(), style: t.bodyL.copyWith(color: t.ink)),
            if (step.instruction.trim().isNotEmpty) ...[
              SizedBox(height: t.space1),
              MarkdownText(
                step.instruction.trim(),
                style: t.body.copyWith(color: t.ink),
                spanBuilder: stepTemplateSpans(
                  context,
                  StepTemplate(ingredients: step.ingredients, scaling: scaling),
                ),
              ),
            ],
          ],
      ],
    );
  }
}

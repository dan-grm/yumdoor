import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/buttons.dart';
import '../../design/components/servings_picker.dart';
import '../../design/design.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
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
      body: switch (recipe) {
        AsyncData(:final value) => _RecipeView(recipe: value),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    t.space5,
                    t.space4,
                    t.space5,
                    t.space6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TitleBlock(recipe: recipe),
                      SizedBox(height: t.space4),
                      const _WriteActions(),
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
                      _Ingredients(steps: recipe.steps, scaling: scaling),
                    ],
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

/// The image (or a placeholder) with the back button over it.
class _Header extends StatelessWidget {
  const _Header({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final image = recipe.image;
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
            child:
                image != null &&
                    (image.isScheme('https') || image.isScheme('http'))
                ? Image.network(
                    image.toString(),
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) => placeholder,
                  )
                : placeholder,
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
          // Plain text until the markdown renderer lands (M2).
          Text(recipe.description.trim(), style: t.body.copyWith(color: t.ink)),
        ],
      ],
    );
  }
}

/// Plan, shop and edit: visible but disabled until their milestones.
class _WriteActions extends StatelessWidget {
  const _WriteActions();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final actions = [
      (Icons.calendar_today_outlined, l10n.recipePlan),
      (Icons.shopping_cart_outlined, l10n.recipeShop),
      (Icons.edit_outlined, l10n.recipeEdit),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (index, (icon, label)) in actions.indexed) ...[
              if (index > 0) SizedBox(width: t.space2),
              Expanded(
                child: PillButton(
                  label: label,
                  icon: icon,
                  kind: PillButtonKind.secondary,
                  compact: true,
                  onPressed: null,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: t.space2),
        Text(
          l10n.recipeActionsComingSoon,
          style: t.caption.copyWith(color: t.inkMuted),
        ),
      ],
    );
  }
}

/// The ingredients grouped by step. Step titles only appear when more than
/// one step has ingredients.
class _Ingredients extends StatelessWidget {
  const _Ingredients({required this.steps, required this.scaling});

  final List<RecipeStep> steps;
  final ScalingService scaling;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final groups = [
      for (final (index, step) in steps.indexed)
        if (step.ingredients.isNotEmpty) (index, step),
    ];
    if (groups.isEmpty) {
      return Text(
        l10n.recipeNoIngredients,
        style: t.body.copyWith(color: t.inkMuted),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, step) in groups) ...[
          if (groups.length > 1)
            Padding(
              padding: EdgeInsets.only(top: t.space4, bottom: t.space1),
              child: Text(
                (step.name.trim().isEmpty
                        ? l10n.recipeStepTitle(index + 1)
                        : step.name.trim())
                    .toUpperCase(),
                style: t.overline.copyWith(color: t.sage),
              ),
            ),
          IngredientLines(
            ingredients: step.ingredients,
            scaling: scaling,
            dividers: true,
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../design/components/ingredient_row.dart';
import '../../design/design.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/step_text.dart';

/// [count] servings in words, with the recipe's own serving unit if it has one:
/// "4 Portionen", "12 Stück".
String servingsLabel(BuildContext context, int count, String servingsText) =>
    servingsText.trim().isEmpty
    ? context.l10n.servings(count)
    : context.l10n.servingsCustom(count, servingsText.trim());

/// Ingredients scaled by [scaling], as [IngredientRow]s with header lines
/// ("Für den Teig") between them.
class IngredientLines extends StatelessWidget {
  const IngredientLines({
    super.key,
    required this.ingredients,
    required this.scaling,
    this.dividers = false,
    this.isDone,
    this.onToggle,
  });

  final List<Ingredient> ingredients;
  final ScalingService scaling;

  /// Hairlines between the rows, as on the recipe screen.
  final bool dividers;

  /// Whether a row is ticked off; only used with [onToggle].
  final bool Function(Ingredient ingredient)? isDone;

  /// Makes the rows tickable (cooking mode).
  final void Function(Ingredient ingredient)? onToggle;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final format = LocaleFormat.of(context);
    final lines = [for (final i in ingredients) scaling.scale(i)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, line) in lines.indexed) ...[
          if (dividers && index > 0 && !line.isHeader)
            Divider(height: 1, thickness: 1, color: t.line),
          if (line.isHeader)
            Padding(
              padding: EdgeInsets.only(top: t.space4, bottom: t.space1),
              child: Semantics(
                header: true,
                child: Text(line.name, style: t.titleS.copyWith(color: t.ink)),
              ),
            )
          else
            IngredientRow(
              name: line.name,
              note: line.note,
              done:
                  onToggle != null && (isDone?.call(line.ingredient) ?? false),
              onToggle: onToggle == null
                  ? null
                  : () => onToggle!(line.ingredient),
              toggleLabel: onToggle == null
                  ? ''
                  : context.l10n.ingredientTickOff(line.name),
              amount: [
                if (line.amount case final amount?) format.quantity(amount),
                line.unit,
              ].where((part) => part.isNotEmpty).join(' '),
            ),
        ],
      ],
    );
  }
}

/// The ingredients of [steps], grouped by step. Step titles only appear when
/// more than one step has ingredients.
///
/// [steps] is either all of the recipe's steps, which are numbered by their
/// position, or a single step, which gets no title.
///
/// With [onToggle], rows can be ticked off per step (cooking mode).
class IngredientGroups extends StatelessWidget {
  const IngredientGroups({
    super.key,
    required this.steps,
    required this.scaling,
    this.dividers = false,
    this.alwaysTitled = false,
    this.isDone,
    this.onToggle,
  });

  final List<RecipeStep> steps;

  /// Titles even when only one step has ingredients, so they can't be taken
  /// for another step's (cooking mode's "Alle").
  final bool alwaysTitled;
  final ScalingService scaling;
  final bool dividers;
  final bool Function(RecipeStep step, Ingredient ingredient)? isDone;
  final void Function(RecipeStep step, Ingredient ingredient)? onToggle;

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

    final isDone = this.isDone;
    final onToggle = this.onToggle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, step) in groups) ...[
          if (alwaysTitled || groups.length > 1)
            Padding(
              padding: EdgeInsets.only(top: t.space4, bottom: t.space1),
              child: Semantics(
                header: true,
                child: Text(
                  stepTitle(context, step, index).toUpperCase(),
                  style: t.overline.copyWith(color: t.sage),
                ),
              ),
            ),
          IngredientLines(
            ingredients: step.ingredients,
            scaling: scaling,
            dividers: dividers,
            isDone: isDone == null ? null : (i) => isDone(step, i),
            onToggle: onToggle == null ? null : (i) => onToggle(step, i),
          ),
        ],
      ],
    );
  }
}

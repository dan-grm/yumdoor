import 'package:flutter/material.dart';

import '../../design/components/ingredient_row.dart';
import '../../design/design.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';

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

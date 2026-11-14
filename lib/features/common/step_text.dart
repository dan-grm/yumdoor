import 'package:flutter/material.dart';

import '../../domain/services/scaling_service.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/step_template.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import 'markdown_text.dart';

/// A [MarkdownSpanBuilder] that replaces step templates with their scaled
/// values, emphasized so they stand out like the amounts in the ingredient
/// list.
MarkdownSpanBuilder stepTemplateSpans(
  BuildContext context,
  StepTemplate template,
) {
  final format = LocaleFormat.of(context);
  String quantity(Quantity? value) =>
      value == null ? '' : format.quantity(value);

  return (text, style) {
    final valueStyle = style.copyWith(fontWeight: FontWeight.w800);
    return [
      for (final part in template.resolve(text))
        switch (part) {
          StepText(:final text) => TextSpan(text: text, style: style),
          StepIngredient(:final amount, :final unit, :final food) => TextSpan(
            text: [
              quantity(amount),
              unit,
              food,
            ].where((piece) => piece.isNotEmpty).join(' '),
            style: valueStyle,
          ),
          StepAmount(quantity: final value) => TextSpan(
            text: quantity(value),
            style: valueStyle,
          ),
          StepValue(:final text) => TextSpan(text: text, style: valueStyle),
        },
    ];
  };
}

/// The step's own name, or "Schritt 3" for [index] 2.
String stepTitle(BuildContext context, RecipeStep step, int index) =>
    step.name.trim().isEmpty
    ? context.l10n.recipeStepTitle(index + 1)
    : step.name.trim();

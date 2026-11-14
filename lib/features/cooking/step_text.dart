import 'package:flutter/material.dart';

import '../../domain/services/step_template.dart';
import '../../l10n/formatting.dart';
import '../common/markdown_text.dart';
import '../recipe/ingredient_lines.dart';

/// A [MarkdownSpanBuilder] that replaces step templates with their scaled
/// values, emphasized so they stand out like the amounts in the ingredient
/// list.
MarkdownSpanBuilder stepTemplateSpans(
  BuildContext context,
  StepTemplate template,
) {
  final format = LocaleFormat.of(context);
  return (text, style) {
    final valueStyle = style.copyWith(fontWeight: FontWeight.w800);
    return [
      for (final part in template.resolve(text))
        switch (part) {
          StepText(:final text) => TextSpan(text: text, style: style),
          StepIngredient(:final line) => TextSpan(
            text: [
              ingredientAmount(format, line),
              line.name,
            ].where((part) => part.isNotEmpty).join(' '),
            style: valueStyle,
          ),
          StepAmount(:final quantity) => TextSpan(
            text: quantity == null ? '' : format.quantity(quantity),
            style: valueStyle,
          ),
          StepValue(:final text) => TextSpan(text: text, style: valueStyle),
        },
    ];
  };
}

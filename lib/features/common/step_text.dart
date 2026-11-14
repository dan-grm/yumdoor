import 'package:flutter/material.dart';

import '../../design/components/timer_chip.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/services/scaling_service.dart';
import '../../domain/services/step_template.dart';
import '../../domain/services/timer_detection.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import 'markdown_text.dart';

/// A [MarkdownSpanBuilder] that replaces step templates with their scaled
/// values, emphasized so they stand out like the amounts in the ingredient
/// list.
///
/// With [onDuration], durations in the text around them ("25 Minuten") are
/// highlighted, and tapping one calls it.
MarkdownSpanBuilder stepTemplateSpans(
  BuildContext context,
  StepTemplate template, {
  ValueChanged<Duration>? onDuration,
}) {
  final format = LocaleFormat.of(context);
  final l10n = context.l10n;
  String quantity(Quantity? value) =>
      value == null ? '' : format.quantity(value);

  List<InlineSpan> textSpans(String text, TextStyle style) {
    if (onDuration == null) return [TextSpan(text: text, style: style)];
    final spans = <InlineSpan>[];
    var position = 0;
    for (final found in TimerDetection.find(text)) {
      if (found.start > position) {
        spans.add(
          TextSpan(text: text.substring(position, found.start), style: style),
        );
      }
      final phrase = text.substring(found.start, found.end);
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          style: style,
          child: TimerHighlight(
            text: phrase,
            style: style,
            semanticsLabel: l10n.timerHighlight(phrase),
            onTap: () => onDuration(found.duration),
          ),
        ),
      );
      position = found.end;
    }
    if (position < text.length) {
      spans.add(TextSpan(text: text.substring(position), style: style));
    }
    return spans;
  }

  return (text, style) {
    final valueStyle = style.copyWith(fontWeight: FontWeight.w800);
    return [
      for (final part in template.resolve(text))
        ...switch (part) {
          StepText(:final text) => textSpans(text, style),
          StepIngredient(:final amount, :final unit, :final food) => [
            TextSpan(
              text: [
                quantity(amount),
                unit,
                food,
              ].where((piece) => piece.isNotEmpty).join(' '),
              style: valueStyle,
            ),
          ],
          StepAmount(quantity: final value) => [
            TextSpan(text: quantity(value), style: valueStyle),
          ],
          StepValue(:final text) => [TextSpan(text: text, style: valueStyle)],
        },
    ];
  };
}

/// The durations [stepTemplateSpans] highlights in [instruction], in order.
List<Duration> stepDurations(String instruction, StepTemplate template) => [
  for (final run in markdownTextRuns(instruction))
    for (final part in template.resolve(run))
      if (part case StepText(:final text))
        for (final found in TimerDetection.find(text)) found.duration,
];

/// "Schritt 3" for [index] 2, with the step's name if it has one:
/// "Schritt 3 · Anrichten". The number matches cooking mode.
String stepTitle(BuildContext context, RecipeStep step, int index) {
  final number = context.l10n.recipeStepTitle(index + 1);
  final name = step.name.trim();
  return name.isEmpty ? number : '$number · $name';
}

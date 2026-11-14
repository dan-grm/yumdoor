import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/ingredient.dart';
import 'scaling_service.dart';

part 'step_template.freezed.dart';

/// Resolves the template subset Tandoor allows in step text, so the values
/// scale with the chosen servings:
///
/// - `{{ ingredients[n] }}`: amount, unit and food of the step's n-th
///   ingredient (without the note, as in Tandoor);
/// - `{{ ingredients[n].amount }}`, `.unit`, `.food`, `.note`: one part;
/// - `{{ scale(x) }}`: the number x, scaled.
///
/// `n` counts the step's ingredients in their order on the server, headers
/// included, and may be negative like a Python index (Tandoor 2.6.15,
/// `cookbook/helper/template_helper.py`). Headers render empty. Nothing is
/// evaluated: anything else between `{{ }}`, an index out of range or broken
/// braces stays in the text as written, where Tandoor would replace the whole
/// step with an error message.
///
/// Units and foods are singular or plural like the ingredient rows (plural
/// above a scaled amount of 1).
class StepTemplate {
  const StepTemplate({required this.ingredients, required this.scaling});

  /// The step's ingredients, in server order.
  final List<Ingredient> ingredients;
  final ScalingService scaling;

  /// `{{ … }}` without another `{{` inside, so a stray opening brace doesn't
  /// swallow the expression after it. May span lines, as in Jinja.
  static final _expression = RegExp(r'\{\{((?:(?!\{\{).)*?)\}\}', dotAll: true);

  /// At most 9 digits, so the index always fits in an int.
  static final _ingredient = RegExp(
    r'^ingredients\s*\[\s*(-?\d{1,9})\s*\](?:\s*\.\s*(amount|unit|food|note))?$',
  );
  static final _scale = RegExp(
    r'''^scale\s*\(\s*(['"]?)(\d+(?:\.\d*)?|\.\d+)\1\s*\)$''',
  );

  /// [text] split into plain text and resolved template values.
  List<StepTextPart> resolve(String text) {
    final parts = <StepTextPart>[];
    var position = 0;
    for (final match in _expression.allMatches(text)) {
      final value = _value(match.group(1)!.trim());
      if (value == null) continue;
      if (match.start > position) {
        parts.add(StepTextPart.text(text.substring(position, match.start)));
      }
      parts.add(value);
      position = match.end;
    }
    if (position < text.length) {
      parts.add(StepTextPart.text(text.substring(position)));
    }
    return parts;
  }

  StepTextPart? _value(String expression) {
    if (_ingredient.firstMatch(expression) case final match?) {
      var index = int.parse(match.group(1)!);
      if (index < 0) index += ingredients.length;
      if (index < 0 || index >= ingredients.length) return null;
      return _ingredientValue(ingredients[index], match.group(2));
    }
    if (_scale.firstMatch(expression) case final match?) {
      final number = double.parse(match.group(2)!);
      return StepTextPart.amount(Quantity.of(number * scaling.factor));
    }
    return null;
  }

  StepTextPart _ingredientValue(Ingredient ingredient, String? field) {
    if (ingredient.isHeader) return const StepTextPart.value('');

    // Like Tandoor: an amount of 0 is shown as 0, only `noAmount` hides it;
    // unit and food are shown whenever the ingredient has them.
    final scaled = ingredient.noAmount
        ? null
        : ingredient.amount * scaling.factor;
    final amount = scaled == null ? null : Quantity.of(scaled);
    final plural = scaled != null && scaled > 1;
    final unit = switch (ingredient.unit) {
      final unit? => ScalingService.pickName(
        unit.name,
        unit.pluralName,
        plural: plural,
      ),
      null => '',
    };
    final food = switch (ingredient.food) {
      final food? => ScalingService.pickName(
        food.name,
        food.pluralName,
        plural: plural,
      ),
      null => '',
    };

    return switch (field) {
      null => StepTextPart.ingredient(amount: amount, unit: unit, food: food),
      'amount' => StepTextPart.amount(amount),
      'unit' => StepTextPart.value(unit),
      'food' => StepTextPart.value(food),
      _ => StepTextPart.value(ingredient.note),
    };
  }
}

/// A piece of resolved step text.
@freezed
sealed class StepTextPart with _$StepTextPart {
  /// Text as written, including unresolved `{{ }}` expressions.
  const factory StepTextPart.text(String text) = StepText;

  /// `{{ ingredients[n] }}`: "600 g Karotten". Empty pieces are left out when
  /// shown.
  const factory StepTextPart.ingredient({
    Quantity? amount,
    required String unit,
    required String food,
  }) = StepIngredient;

  /// A scaled number; `null` if the ingredient has no amount.
  const factory StepTextPart.amount(Quantity? quantity) = StepAmount;

  /// A unit, food or note, already in singular or plural.
  const factory StepTextPart.value(String text) = StepValue;
}

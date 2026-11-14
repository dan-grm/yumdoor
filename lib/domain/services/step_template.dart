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

  /// Numbers have at most 9 digits, so they always parse to a finite value.
  static final _ingredient = RegExp(
    r'^ingredients\s*\[\s*(-?\d{1,9})\s*\](?:\s*\.\s*(amount|unit|food|note))?$',
  );
  static final _scale = RegExp(
    r'''^scale\s*\(\s*(['"]?)(\d{1,9}(?:\.\d{0,9})?|\.\d{1,9})\1\s*\)$''',
  );

  /// [text] split into plain text and resolved template values.
  ///
  /// Values that resolve to nothing (a header, a missing unit) are left out
  /// together with one of the spaces around them, so "mit
  /// {{ ingredients[0].amount }} Salz" doesn't read "mit  Salz".
  List<StepTextPart> resolve(String text) {
    final parts = <StepTextPart>[];
    var pending = '';
    var trimLeading = false;
    var position = 0;
    for (final match in _expression.allMatches(text)) {
      final value = _value(match.group(1)!.trim());
      if (value == null) continue;
      var before = text.substring(position, match.start);
      if (trimLeading && before.startsWith(' ')) before = before.substring(1);
      trimLeading = false;
      pending += before;
      position = match.end;

      if (_isEmpty(value)) {
        if (text.startsWith(' ', match.end)) {
          if (pending.endsWith(' ')) {
            pending = pending.substring(0, pending.length - 1);
          } else if (pending.isEmpty && parts.isEmpty) {
            trimLeading = true;
          }
        }
        continue;
      }
      if (pending.isNotEmpty) parts.add(StepTextPart.text(pending));
      pending = '';
      parts.add(value);
    }
    var rest = text.substring(position);
    if (trimLeading && rest.startsWith(' ')) rest = rest.substring(1);
    pending += rest;
    if (pending.isNotEmpty) parts.add(StepTextPart.text(pending));
    return parts;
  }

  static bool _isEmpty(StepTextPart part) => switch (part) {
    StepText(:final text) || StepValue(:final text) => text.isEmpty,
    StepAmount(:final quantity) => quantity == null,
    StepIngredient(:final amount, :final unit, :final food) =>
      amount == null && unit.isEmpty && food.isEmpty,
  };

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
    final amount = ingredient.noAmount
        ? null
        : Quantity.of(ingredient.amount * scaling.factor);
    final plural = ScalingService.isPlural(amount);
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

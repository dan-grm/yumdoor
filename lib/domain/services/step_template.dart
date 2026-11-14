import '../models/ingredient.dart';
import 'scaling_service.dart';

/// Resolves the template subset Tandoor allows in step text, so the values
/// scale with the chosen servings:
///
/// - `{{ ingredients[n] }}`: amount, unit and food of the step's n-th
///   ingredient, like its ingredient row (the note is left out, as in Tandoor);
/// - `{{ ingredients[n].amount }}`, `.unit`, `.food`, `.note`: one part;
/// - `{{ scale(x) }}`: the number x, scaled.
///
/// `n` counts the step's ingredients in their order on the server, headers
/// included (Tandoor 2.6.15, `cookbook/helper/template_helper.py`). Nothing is
/// evaluated: anything else between `{{ }}`, an index out of range or broken
/// braces stays in the text as written. Tandoor would replace the whole step
/// with an error message instead.
class StepTemplate {
  const StepTemplate({required this.ingredients, required this.scaling});

  /// The step's ingredients, in server order.
  final List<Ingredient> ingredients;
  final ScalingService scaling;

  /// `{{ … }}` without another `{{` inside, so a stray opening brace doesn't
  /// swallow the expression after it.
  static final _expression = RegExp(r'\{\{((?:(?!\{\{).)*?)\}\}');
  static final _ingredient = RegExp(
    r'^ingredients\s*\[\s*(\d+)\s*\](?:\s*\.\s*(amount|unit|food|note))?$',
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
        parts.add(StepText(text.substring(position, match.start)));
      }
      parts.add(value);
      position = match.end;
    }
    if (position < text.length) parts.add(StepText(text.substring(position)));
    return parts;
  }

  StepTextPart? _value(String expression) {
    if (_ingredient.firstMatch(expression) case final match?) {
      final index = int.parse(match.group(1)!);
      if (index >= ingredients.length) return null;
      final line = scaling.scale(ingredients[index]);
      // A header renders empty in Tandoor, whatever the field.
      if (line.isHeader) return const StepValue('');
      return switch (match.group(2)) {
        null => StepIngredient(line),
        'amount' => StepAmount(line.amount),
        'unit' => StepValue(line.unit),
        'food' => StepValue(line.name),
        _ => StepValue(line.ingredient.note),
      };
    }
    if (_scale.firstMatch(expression) case final match?) {
      final number = double.parse(match.group(2)!);
      return StepAmount(Quantity.of(number * scaling.factor));
    }
    return null;
  }
}

/// A piece of resolved step text.
sealed class StepTextPart {
  const StepTextPart();
}

/// Text as written, including unresolved `{{ }}` expressions.
final class StepText extends StepTextPart {
  const StepText(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is StepText && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'StepText($text)';
}

/// `{{ ingredients[n] }}`: shown like the ingredient row, "600 g Karotten".
final class StepIngredient extends StepTextPart {
  const StepIngredient(this.line);

  final ScaledIngredient line;

  @override
  bool operator ==(Object other) =>
      other is StepIngredient &&
      other.line.ingredient == line.ingredient &&
      other.line.name == line.name &&
      other.line.amount == line.amount &&
      other.line.unit == line.unit;

  @override
  int get hashCode => Object.hash(line.ingredient, line.amount);

  @override
  String toString() =>
      'StepIngredient(${line.amount} ${line.unit} ${line.name})';
}

/// A scaled number; `null` if the ingredient has no amount.
final class StepAmount extends StepTextPart {
  const StepAmount(this.quantity);

  final Quantity? quantity;

  @override
  bool operator ==(Object other) =>
      other is StepAmount && other.quantity == quantity;

  @override
  int get hashCode => quantity.hashCode;

  @override
  String toString() => 'StepAmount($quantity)';
}

/// A unit, food or note, already in singular or plural.
final class StepValue extends StepTextPart {
  const StepValue(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is StepValue && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'StepValue($text)';
}

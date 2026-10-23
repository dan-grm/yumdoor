import 'dart:math' as math;

import '../models/ingredient.dart';

/// Scales a recipe's ingredients from the servings it was written for to the
/// servings chosen on the recipe screen.
class ScalingService {
  /// [recipeServings] below 1 (a recipe without a yield) count as 1, so its
  /// amounts are shown unchanged at 1 serving.
  const ScalingService({required int recipeServings, required this._servings})
    : _recipeServings = recipeServings < 1 ? 1 : recipeServings;

  final int _recipeServings;
  final int _servings;

  /// What every amount is multiplied by.
  double get factor => _servings / _recipeServings;

  /// [ingredient] as it is shown for the chosen servings. Headers and
  /// `noAmount` ingredients are never scaled.
  ScaledIngredient scale(Ingredient ingredient) {
    final food = ingredient.food;
    if (ingredient.isHeader) {
      return ScaledIngredient(ingredient, name: ingredient.note);
    }
    if (food == null) {
      // A free-text line: "etwas Wasser".
      final text = ingredient.note.isNotEmpty
          ? ingredient.note
          : ingredient.originalText ?? '';
      return ScaledIngredient(ingredient, name: text);
    }

    final amount = ingredient.noAmount || ingredient.amount <= 0
        ? null
        : ingredient.amount * factor;
    final plural = amount != null && amount > 1;
    final unit = ingredient.unit;
    return ScaledIngredient(
      ingredient,
      name: _pick(food.name, food.pluralName, plural: plural),
      note: ingredient.note,
      amount: amount == null ? null : Quantity.of(amount),
      unit: ingredient.noAmount || unit == null
          ? ''
          : _pick(unit.name, unit.pluralName, plural: plural),
    );
  }

  static String _pick(
    String singular,
    String? pluralName, {
    required bool plural,
  }) => plural && pluralName != null && pluralName.isNotEmpty
      ? pluralName
      : singular;
}

/// An ingredient line ready to display.
class ScaledIngredient {
  const ScaledIngredient(
    this.ingredient, {
    required this.name,
    this.note = '',
    this.amount,
    this.unit = '',
  });

  final Ingredient ingredient;

  /// The food in singular or plural; for a header, its title.
  final String name;

  /// Extra text such as "geschält", empty if none.
  final String note;

  /// `null` if the line has no amount.
  final Quantity? amount;

  /// The unit in singular or plural, empty if none.
  final String unit;

  bool get isHeader => ingredient.isHeader;
}

/// An amount rounded for a cook to read: `1½`, `0,3`, `37,5`, `600`.
///
/// Formatted for a locale by `LocaleFormat.quantity` in `lib/l10n/`.
sealed class Quantity {
  const Quantity();

  /// [value] rounded for display:
  ///
  /// - below 10, close to a common fraction: `whole` plus [Fraction] (`1½`);
  /// - below 1 otherwise: two significant digits (`0,13`, `0,004`);
  /// - below 100: one decimal (`2,4`, `37,5`);
  /// - from 100: a whole number (`1250`).
  ///
  /// Zero, negative and non-finite values become `0`.
  factory Quantity.of(double value) {
    if (!value.isFinite || value <= 0) return const DecimalQuantity(0);
    if (value < 10) {
      final whole = value.floor();
      final rest = value - whole;
      if (rest <= _tolerance && whole > 0) return DecimalQuantity(whole + 0.0);
      if (rest >= 1 - _tolerance) return DecimalQuantity(whole + 1.0);
      for (final fraction in Fraction.values) {
        if ((rest - fraction.value).abs() <= _tolerance) {
          return FractionQuantity(whole, fraction);
        }
      }
      if (value < 1) return DecimalQuantity(_significant(value, 2));
    }
    if (value < 100) return DecimalQuantity(_round(value, 1));
    return DecimalQuantity(value.roundToDouble());
  }

  /// How far an amount may be from a fraction to be shown as one.
  static const _tolerance = 0.02;

  /// The amount as a number.
  double get value;

  static double _round(double value, int decimals) {
    final scale = math.pow(10, decimals);
    return (value * scale).round() / scale;
  }

  static double _significant(double value, int digits) {
    final magnitude = (math.log(value) / math.ln10).floor();
    return _round(value, digits - 1 - magnitude);
  }
}

/// A whole number plus a common fraction: `1½`, or `¼` when [whole] is 0.
final class FractionQuantity extends Quantity {
  const FractionQuantity(this.whole, this.fraction);

  final int whole;
  final Fraction fraction;

  @override
  double get value => whole + fraction.value;

  @override
  bool operator ==(Object other) =>
      other is FractionQuantity &&
      other.whole == whole &&
      other.fraction == fraction;

  @override
  int get hashCode => Object.hash(whole, fraction);

  @override
  String toString() => 'FractionQuantity($whole${fraction.symbol})';
}

/// A rounded decimal, formatted with the locale's separator.
final class DecimalQuantity extends Quantity {
  const DecimalQuantity(this.value);

  @override
  final double value;

  @override
  bool operator ==(Object other) =>
      other is DecimalQuantity && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'DecimalQuantity($value)';
}

/// Fractions cooks use, with their Unicode vulgar fraction.
///
/// No thirds: the bundled Nunito has no `⅓` and `⅔`, and a missing glyph
/// makes the web build fetch a fallback font from a CDN.
enum Fraction {
  quarter(1 / 4, '¼'),
  half(1 / 2, '½'),
  threeQuarters(3 / 4, '¾');

  const Fraction(this.value, this.symbol);

  final double value;
  final String symbol;
}

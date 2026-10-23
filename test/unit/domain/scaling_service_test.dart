import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/services/scaling_service.dart';

void main() {
  const carrot = Food(id: 1, name: 'Karotte', pluralName: 'Karotten');
  const gram = Unit(id: 1, name: 'g');
  const bunch = Unit(id: 2, name: 'Bund', pluralName: 'Bünde');

  group('factor', () {
    test('is chosen over recipe servings', () {
      expect(const ScalingService(recipeServings: 2, servings: 4).factor, 2);
      expect(const ScalingService(recipeServings: 4, servings: 1).factor, 0.25);
    });

    test('a recipe with 0 servings counts as 1 serving', () {
      expect(const ScalingService(recipeServings: 0, servings: 1).factor, 1);
      expect(const ScalingService(recipeServings: 0, servings: 3).factor, 3);
      expect(const ScalingService(recipeServings: -2, servings: 2).factor, 2);
    });
  });

  group('scale', () {
    test('multiplies the amount and keeps the unit', () {
      final line = const ScalingService(
        recipeServings: 2,
        servings: 4,
      ).scale(const Ingredient(id: 1, food: carrot, unit: gram, amount: 300));
      expect(line.amount, const DecimalQuantity(600));
      expect(line.unit, 'g');
    });

    test('uses plural names above 1 and singular up to 1', () {
      const ingredient = Ingredient(
        id: 1,
        food: carrot,
        unit: bunch,
        amount: 1,
      );
      final one = const ScalingService(
        recipeServings: 2,
        servings: 2,
      ).scale(ingredient);
      expect((one.name, one.unit), ('Karotte', 'Bund'));

      final two = const ScalingService(
        recipeServings: 2,
        servings: 4,
      ).scale(ingredient);
      expect((two.name, two.unit), ('Karotten', 'Bünde'));

      final half = const ScalingService(
        recipeServings: 2,
        servings: 1,
      ).scale(ingredient);
      expect((half.name, half.unit), ('Karotte', 'Bund'));
      expect(half.amount, const FractionQuantity(0, Fraction.half));
    });

    test('falls back to the singular when there is no plural name', () {
      final line = const ScalingService(recipeServings: 1, servings: 3).scale(
        const Ingredient(
          id: 1,
          food: Food(id: 2, name: 'Feta', pluralName: ''),
          unit: gram,
          amount: 100,
        ),
      );
      expect(line.name, 'Feta');
    });

    test('leaves noAmount ingredients unscaled and without unit', () {
      final line = const ScalingService(recipeServings: 2, servings: 8).scale(
        const Ingredient(
          id: 1,
          food: Food(id: 3, name: 'Salz'),
          unit: gram,
          amount: 5,
          noAmount: true,
          note: 'nach Geschmack',
        ),
      );
      expect(line.amount, isNull);
      expect(line.unit, '');
      expect(line.name, 'Salz');
      expect(line.note, 'nach Geschmack');
    });

    test('treats an amount of 0 as no amount but keeps the unit', () {
      final line = const ScalingService(recipeServings: 2, servings: 4).scale(
        const Ingredient(
          id: 1,
          food: Food(id: 4, name: 'Pfeffer'),
          unit: Unit(id: 3, name: 'Prise'),
        ),
      );
      expect(line.amount, isNull);
      expect(line.unit, 'Prise');
    });

    test('leaves headers untouched, with their title from the note', () {
      final line = const ScalingService(recipeServings: 2, servings: 4).scale(
        const Ingredient(
          id: 1,
          isHeader: true,
          noAmount: true,
          note: 'Für den Teig',
        ),
      );
      expect(line.isHeader, isTrue);
      expect(line.name, 'Für den Teig');
      expect(line.amount, isNull);
    });

    test('shows free-text lines without food by their note or text', () {
      const scaling = ScalingService(recipeServings: 1, servings: 1);
      expect(
        scaling.scale(const Ingredient(id: 1, note: 'etwas Wasser')).name,
        'etwas Wasser',
      );
      expect(
        scaling
            .scale(const Ingredient(id: 2, originalText: '1 Schuss Essig'))
            .name,
        '1 Schuss Essig',
      );
    });

    test('handles huge factors', () {
      final line = const ScalingService(
        recipeServings: 1,
        servings: 10000,
      ).scale(const Ingredient(id: 1, food: carrot, unit: gram, amount: 250));
      expect(line.amount, const DecimalQuantity(2500000));
    });

    test('scales decimals without float noise', () {
      final line = const ScalingService(
        recipeServings: 3,
        servings: 1,
      ).scale(const Ingredient(id: 1, food: carrot, unit: gram, amount: 100));
      expect(line.amount, const DecimalQuantity(33.3));
    });
  });

  group('Quantity.of', () {
    test('uses common fractions below 10', () {
      expect(Quantity.of(0.25), const FractionQuantity(0, Fraction.quarter));
      expect(Quantity.of(0.5), const FractionQuantity(0, Fraction.half));
      expect(Quantity.of(1.5), const FractionQuantity(1, Fraction.half));
      expect(Quantity.of(0.26), const FractionQuantity(0, Fraction.quarter));
      expect(
        Quantity.of(2.75),
        const FractionQuantity(2, Fraction.threeQuarters),
      );
    });

    test('shows thirds as decimals (no glyph in the bundled font)', () {
      expect(Quantity.of(1 / 3), const DecimalQuantity(0.33));
      expect(Quantity.of(2 / 3), const DecimalQuantity(0.67));
      expect(Quantity.of(4 / 3), const DecimalQuantity(1.3));
    });

    test('rounds near-whole numbers', () {
      expect(Quantity.of(2), const DecimalQuantity(2));
      expect(Quantity.of(2.01), const DecimalQuantity(2));
      expect(Quantity.of(2.99), const DecimalQuantity(3));
      expect(Quantity.of(0.99), const DecimalQuantity(1));
    });

    test('keeps two significant digits for small amounts', () {
      expect(Quantity.of(0.125), const DecimalQuantity(0.13));
      expect(Quantity.of(0.1), const DecimalQuantity(0.1));
      expect(Quantity.of(0.004), const DecimalQuantity(0.004));
      expect(Quantity.of(0.01234), const DecimalQuantity(0.012));
    });

    test('uses one decimal below 100 and whole numbers above', () {
      expect(Quantity.of(1.2), const DecimalQuantity(1.2));
      expect(Quantity.of(2.4), const DecimalQuantity(2.4));
      expect(Quantity.of(12.5), const DecimalQuantity(12.5));
      expect(Quantity.of(37.333), const DecimalQuantity(37.3));
      expect(Quantity.of(133.33), const DecimalQuantity(133));
      expect(Quantity.of(1249.6), const DecimalQuantity(1250));
    });

    test('does not use fractions from 10 on', () {
      expect(Quantity.of(10.5), const DecimalQuantity(10.5));
    });

    test('maps zero, negative and non-finite values to 0', () {
      expect(Quantity.of(0), const DecimalQuantity(0));
      expect(Quantity.of(-1), const DecimalQuantity(0));
      expect(Quantity.of(double.nan), const DecimalQuantity(0));
      expect(Quantity.of(double.infinity), const DecimalQuantity(0));
    });
  });
}

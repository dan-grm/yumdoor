import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/services/scaling_service.dart';
import 'package:yumdoor/domain/services/step_template.dart';

void main() {
  const karotten = Ingredient(
    id: 1,
    food: Food(id: 1, name: 'Karotte', pluralName: 'Karotten'),
    unit: Unit(id: 1, name: 'g'),
    amount: 300,
    note: 'geschält',
  );
  const header = Ingredient(
    id: 2,
    isHeader: true,
    noAmount: true,
    note: 'Für die Soße',
  );
  const ei = Ingredient(
    id: 3,
    food: Food(id: 2, name: 'Ei', pluralName: 'Eier'),
    amount: 1,
  );
  const salz = Ingredient(
    id: 4,
    food: Food(id: 3, name: 'Salz'),
    noAmount: true,
  );
  const ingredients = [karotten, header, ei, salz];

  StepTemplate template({int servings = 2}) => StepTemplate(
    ingredients: ingredients,
    scaling: ScalingService(recipeServings: 2, servings: servings),
  );

  List<StepTextPart> resolve(String text, {int servings = 2}) =>
      template(servings: servings).resolve(text);

  test('text without templates is one part', () {
    expect(resolve('Ofen vorheizen.'), [const StepText('Ofen vorheizen.')]);
    expect(resolve(''), isEmpty);
  });

  group('ingredients[n]', () {
    test('is the whole ingredient line', () {
      final parts = resolve('{{ ingredients[0] }} schälen.');

      expect(parts, hasLength(2));
      final line = (parts.first as StepIngredient).line;
      expect(line.amount, const DecimalQuantity(300));
      expect(line.unit, 'g');
      expect(line.name, 'Karotten');
      expect(parts.last, const StepText(' schälen.'));
    });

    test('counts headers, as Tandoor does', () {
      final parts = resolve('{{ ingredients[2] }}');

      expect((parts.single as StepIngredient).line.name, 'Ei');
    });

    test('works without spaces inside the braces', () {
      expect(resolve('{{ingredients[2]}}').single, isA<StepIngredient>());
    });
  });

  group('ingredients[n].field', () {
    test('amount, unit, food and note', () {
      expect(resolve('{{ ingredients[0].amount }}'), [
        const StepAmount(DecimalQuantity(300)),
      ]);
      expect(resolve('{{ ingredients[0].unit }}'), [const StepValue('g')]);
      expect(resolve('{{ ingredients[0].food }}'), [
        const StepValue('Karotten'),
      ]);
      expect(resolve('{{ ingredients[0].note }}'), [
        const StepValue('geschält'),
      ]);
    });

    test('an ingredient without amount has an empty amount and unit', () {
      expect(resolve('{{ ingredients[3].amount }}'), [const StepAmount(null)]);
      expect(resolve('{{ ingredients[3].unit }}'), [const StepValue('')]);
      expect(resolve('{{ ingredients[3].food }}'), [const StepValue('Salz')]);
    });

    test('a header is empty, as in Tandoor', () {
      expect(resolve('{{ ingredients[1] }}'), [const StepValue('')]);
      expect(resolve('{{ ingredients[1].food }}'), [const StepValue('')]);
      expect(resolve('{{ ingredients[1].note }}'), [const StepValue('')]);
    });
  });

  group('scale(x)', () {
    test('scales the number', () {
      expect(resolve('{{ scale(30) }}'), [
        const StepAmount(DecimalQuantity(30)),
      ]);
      expect(resolve('{{ scale(30) }}', servings: 4), [
        const StepAmount(DecimalQuantity(60)),
      ]);
      expect(resolve('{{ scale(1.5) }}', servings: 4), [
        const StepAmount(DecimalQuantity(3)),
      ]);
      expect(resolve('{{ scale("100") }}', servings: 1), [
        const StepAmount(DecimalQuantity(50)),
      ]);
    });
  });

  group('scaling', () {
    test('at 2× the amounts double and the food stays plural', () {
      final parts = resolve(
        '{{ ingredients[0] }}, {{ ingredients[2] }}',
        servings: 4,
      );

      final karotte = (parts[0] as StepIngredient).line;
      expect(karotte.amount, const DecimalQuantity(600));
      final eier = (parts[2] as StepIngredient).line;
      expect(eier.amount, const DecimalQuantity(2));
      expect(eier.name, 'Eier');
    });

    test('at ½× the amounts halve and become fractions', () {
      final parts = resolve(
        '{{ ingredients[0].amount }} {{ ingredients[2] }}',
        servings: 1,
      );

      expect(parts.first, const StepAmount(DecimalQuantity(150)));
      final ei = (parts.last as StepIngredient).line;
      expect(ei.amount, const FractionQuantity(0, Fraction.half));
      expect(ei.name, 'Ei');
    });
  });

  group('stays as written', () {
    for (final text in [
      '{{ ingredients[4] }}',
      '{{ ingredients[-1] }}',
      '{{ ingredients[0].price }}',
      '{{ ingredients }}',
      '{{ scale() }}',
      '{{ scale(1, 2) }}',
      '{{ scale(abc) }}',
      '{{ 7 * 7 }}',
      "{{ ''.__class__ }}",
      '{% for i in ingredients %}x{% endfor %}',
      '{{ ingredients[0] }',
      '{ ingredients[0] }}',
      '{{}}',
    ]) {
      test(text, () => expect(resolve(text), [StepText(text)]));
    }

    test('a stray opening brace keeps the next template working', () {
      final parts = resolve('{{ kaputt {{ scale(2) }} cm');

      expect(parts, [
        const StepText('{{ kaputt '),
        const StepAmount(DecimalQuantity(2)),
        const StepText(' cm'),
      ]);
    });

    test('unknown expressions between known ones', () {
      final parts = resolve('{{ scale(2) }} und {{ foo }} und {{ scale(3) }}');

      expect(parts, [
        const StepAmount(DecimalQuantity(2)),
        const StepText(' und {{ foo }} und '),
        const StepAmount(DecimalQuantity(3)),
      ]);
    });
  });
}

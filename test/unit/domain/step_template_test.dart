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
    unit: Unit(id: 2, name: 'Prise'),
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
    test('is amount, unit and food, without the note', () {
      expect(resolve('{{ ingredients[0] }} schälen.'), [
        const StepIngredient(
          amount: DecimalQuantity(300),
          unit: 'g',
          food: 'Karotten',
        ),
        const StepText(' schälen.'),
      ]);
    });

    test('counts headers, as Tandoor does', () {
      expect(resolve('{{ ingredients[2] }}'), [
        const StepIngredient(amount: DecimalQuantity(1), unit: '', food: 'Ei'),
      ]);
    });

    test('negative indexes count from the end, like in Python', () {
      expect(resolve('{{ ingredients[-4].food }}'), [
        const StepValue('Karotten'),
      ]);
      expect(resolve('{{ ingredients[-1].food }}'), [const StepValue('Salz')]);
    });

    test('works without spaces and across lines', () {
      expect(resolve('{{ingredients[2]}}').single, isA<StepIngredient>());
      expect(resolve('{{ ingredients[2]\n}}').single, isA<StepIngredient>());
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

    test('noAmount hides the amount but keeps the unit', () {
      expect(resolve('{{ ingredients[3].amount }}'), isEmpty);
      expect(resolve('{{ ingredients[3].unit }}'), [const StepValue('Prise')]);
      expect(resolve('{{ ingredients[3] }}'), [
        const StepIngredient(unit: 'Prise', food: 'Salz'),
      ]);
    });

    test('an amount of 0 is shown as 0, as in Tandoor', () {
      final parts = StepTemplate(
        ingredients: const [Ingredient(id: 9, food: Food(id: 9, name: 'Öl'))],
        scaling: const ScalingService(recipeServings: 2, servings: 4),
      ).resolve('{{ ingredients[0].amount }}');

      expect(parts, [const StepAmount(DecimalQuantity(0))]);
    });

    test('an ingredient without food keeps amount and unit', () {
      final parts = StepTemplate(
        ingredients: const [
          Ingredient(
            id: 9,
            unit: Unit(id: 9, name: 'ml'),
            amount: 200,
            note: 'lauwarm',
          ),
        ],
        scaling: const ScalingService(recipeServings: 2, servings: 2),
      ).resolve('{{ ingredients[0] }}|{{ ingredients[0].food }}');

      expect(parts, [
        const StepIngredient(
          amount: DecimalQuantity(200),
          unit: 'ml',
          food: '',
        ),
        const StepText('|'),
      ]);
    });

    test('a header is empty, as in Tandoor', () {
      expect(resolve('{{ ingredients[1] }}'), isEmpty);
      expect(resolve('{{ ingredients[1].food }}'), isEmpty);
      expect(resolve('{{ ingredients[1].note }}'), isEmpty);
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
      expect(
        resolve('{{ ingredients[0] }}, {{ ingredients[2] }}', servings: 4),
        [
          const StepIngredient(
            amount: DecimalQuantity(600),
            unit: 'g',
            food: 'Karotten',
          ),
          const StepText(', '),
          const StepIngredient(
            amount: DecimalQuantity(2),
            unit: '',
            food: 'Eier',
          ),
        ],
      );
    });

    test('at ½× the amounts halve and become fractions', () {
      expect(
        resolve(
          '{{ ingredients[0].amount }} {{ ingredients[2] }}',
          servings: 1,
        ),
        [
          const StepAmount(DecimalQuantity(150)),
          const StepText(' '),
          const StepIngredient(
            amount: FractionQuantity(0, Fraction.half),
            unit: '',
            food: 'Ei',
          ),
        ],
      );
    });
  });

  group('empty values', () {
    test('take one of the spaces around them along', () {
      expect(resolve('Mit {{ ingredients[3].amount }} Prise Salz'), [
        const StepText('Mit Prise Salz'),
      ]);
      expect(resolve('{{ ingredients[1] }} Mehl'), [const StepText('Mehl')]);
      expect(resolve('Dann {{ ingredients[1] }}'), [const StepText('Dann ')]);
      expect(resolve('{{ scale(2) }} {{ ingredients[1] }} cm'), [
        const StepAmount(DecimalQuantity(2)),
        const StepText(' cm'),
      ]);
    });

    test('next to punctuation keep the text as is', () {
      expect(resolve('Salz ({{ ingredients[1] }})'), [
        const StepText('Salz ()'),
      ]);
    });
  });

  test('food and unit plural follow the rounded amount', () {
    final parts = StepTemplate(
      ingredients: const [
        Ingredient(
          id: 9,
          food: Food(id: 9, name: 'Ei', pluralName: 'Eier'),
          amount: 0.505,
        ),
      ],
      scaling: const ScalingService(recipeServings: 1, servings: 2),
    ).resolve('{{ ingredients[0] }}');

    expect(parts, [
      const StepIngredient(amount: DecimalQuantity(1), unit: '', food: 'Ei'),
    ]);
  });

  group('stays as written', () {
    for (final text in [
      '{{ ingredients[4] }}',
      '{{ ingredients[-5] }}',
      '{{ ingredients[99999999999999999999] }}',
      '{{ scale(${'9' * 400}) }}',
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

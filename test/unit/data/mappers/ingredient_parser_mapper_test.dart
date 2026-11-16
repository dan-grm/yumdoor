import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/ingredient_parser_mapper.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  /// The recorded response, by line.
  Map<String, ParsedIngredient> recorded() {
    final response = api.standardSerializers.deserializeWith(
      api.IngredientParserResponse.serializer,
      tandoorFixture('ingredient_parser.json'),
    )!;
    return {
      for (final ingredient in response.ingredients)
        ingredient.originalText!: ingredient.toParsed(ingredient.originalText!),
    };
  }

  const karotte = NamedRef(id: 91, name: 'Karotte');
  const salz = NamedRef(id: 141, name: 'Salz');
  const butter = NamedRef(id: 107, name: 'Butter');
  const tsp = NamedRef(id: 35, name: 'tsp');

  test('maps amount, unit, food and note of a German line', () {
    expect(
      recorded()['200 g Karotten, geschält'],
      const ParsedIngredient(
        originalText: '200 g Karotten, geschält',
        // Found by its plural name.
        food: karotte,
        unit: NamedRef(id: 20, name: 'g'),
        amount: 200,
        note: 'geschält',
      ),
    );
  });

  test('maps an English line', () {
    expect(
      recorded()['2 tbsp olive oil'],
      const ParsedIngredient(
        originalText: '2 tbsp olive oil',
        food: NamedRef(id: 169, name: 'olive oil'),
        unit: NamedRef(id: 36, name: 'tbsp'),
        amount: 2,
      ),
    );
    expect(
      recorded()['2 carrots, peeled and diced'],
      const ParsedIngredient(
        originalText: '2 carrots, peeled and diced',
        food: NamedRef(id: 144, name: 'carrot'),
        amount: 2,
        note: 'peeled and diced',
      ),
    );
  });

  test('maps fractions and a decimal comma', () {
    final lines = recorded();

    expect(lines['½ TL Salz']!.amount, 0.5);
    expect(lines['½ TL Salz']!.unit, const NamedRef(id: 25, name: 'TL'));
    expect(lines['1 ½ EL Butter']!.amount, 1.5);
    expect(lines['1 1/2 tsp cinnamon']!.amount, 1.5);
    expect(lines['1/2 tsp cumin']!.amount, 0.5);
    expect(lines['1/2 tsp cumin']!.unit, tsp);
    expect(lines['1,5 l Gemüsebrühe']!.amount, 1.5);
  });

  test('maps a line without a unit', () {
    expect(
      recorded()['2 Eier'],
      const ParsedIngredient(
        originalText: '2 Eier',
        food: NamedRef(id: 110, name: 'Ei'),
        amount: 2,
      ),
    );
  });

  test('maps a line without an amount to amount 0', () {
    final lines = recorded();

    expect(
      lines['Salz, nach Geschmack'],
      const ParsedIngredient(
        originalText: 'Salz, nach Geschmack',
        food: salz,
        note: 'nach Geschmack',
      ),
    );
    expect(
      lines['Butter (weich)'],
      const ParsedIngredient(
        originalText: 'Butter (weich)',
        food: butter,
        note: 'weich',
      ),
    );
  });

  test('leaves out the blank line', () {
    expect(recorded(), hasLength(11));
    expect(recorded().keys, isNot(contains('')));
  });

  test('throws a FormatException for a food without an id', () {
    final ingredient = api.IngredientSimple(
      (b) => b
        ..amount = 1
        ..food.name = 'Karotte',
    );

    expect(() => ingredient.toParsed('1 Karotte'), throwsFormatException);
  });
}

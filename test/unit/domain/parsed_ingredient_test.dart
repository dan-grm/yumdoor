import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

void main() {
  test('an unparsed line has no food and the trimmed text as note', () {
    expect(
      ParsedIngredient.unparsed(' etwas Liebe '),
      const ParsedIngredient(
        originalText: ' etwas Liebe ',
        note: 'etwas Liebe',
      ),
    );
  });

  test('becomes a new ingredient of a draft', () {
    const parsed = ParsedIngredient(
      originalText: '200 g Karotten, geschält',
      food: NamedRef(id: 91, name: 'Karotte'),
      unit: NamedRef(id: 20, name: 'g'),
      amount: 200,
      note: 'geschält',
    );

    expect(
      parsed.toDraft(),
      const IngredientDraft(
        food: NamedRef(id: 91, name: 'Karotte'),
        unit: NamedRef(id: 20, name: 'g'),
        amount: 200,
        note: 'geschält',
        originalText: '200 g Karotten, geschält',
      ),
    );
  });
}

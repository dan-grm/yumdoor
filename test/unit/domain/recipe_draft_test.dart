import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/unit.dart';

import '../../fixtures/recipes.dart';

void main() {
  group('RecipeDraft.fromRecipe', () {
    test('takes the fields Yumdoor edits', () {
      final recipe = ofenkarotten.copyWith(
        servingsText: 'Portionen',
        sourceUrl: 'https://example.com/ofenkarotten',
      );

      final draft = RecipeDraft.fromRecipe(recipe);

      expect(draft.name, 'Ofenkarotten mit Feta');
      expect(draft.description, 'Süß, salzig und *knusprig*.');
      expect(draft.servings, 2);
      expect(draft.servingsText, 'Portionen');
      expect(draft.workingTime, const Duration(minutes: 15));
      expect(draft.waitingTime, const Duration(minutes: 20));
      expect(draft.keywords, const [
        NamedRef(id: 1, name: 'Vegetarisch'),
        NamedRef(id: 2, name: 'Ofen'),
      ]);
      expect(draft.sourceUrl, 'https://example.com/ofenkarotten');
      expect(draft.steps.map((s) => s.id), [1, 2, 3]);
    });

    test('takes steps and ingredients in their order, with their ids', () {
      const recipe = Recipe(
        id: 1,
        name: 'Teig',
        steps: [
          RecipeStep(
            id: 10,
            name: 'Kneten',
            instruction: 'Alles {{ ingredients[0] }} verkneten.',
            time: Duration(minutes: 5),
            order: 0,
            showAsHeader: true,
            ingredients: [
              Ingredient(id: 20, isHeader: true, note: 'Für den Teig'),
              Ingredient(
                id: 21,
                food: Food(id: 30, name: 'Mehl', pluralName: 'Mehle'),
                unit: Unit(id: 40, name: 'g'),
                amount: 500,
                note: 'Type 550',
                originalText: '500 g Mehl (Type 550)',
                order: 1,
              ),
              Ingredient(
                id: 22,
                food: Food(id: 31, name: 'Salz'),
                noAmount: true,
                order: 2,
              ),
            ],
          ),
          RecipeStep(id: 11, order: 1),
        ],
      );

      final draft = RecipeDraft.fromRecipe(recipe);

      expect(draft.steps, const [
        StepDraft(
          id: 10,
          name: 'Kneten',
          instruction: 'Alles {{ ingredients[0] }} verkneten.',
          time: Duration(minutes: 5),
          ingredients: [
            IngredientDraft(id: 20, isHeader: true, note: 'Für den Teig'),
            IngredientDraft(
              id: 21,
              food: NamedRef(id: 30, name: 'Mehl'),
              unit: NamedRef(id: 40, name: 'g'),
              amount: 500,
              note: 'Type 550',
              originalText: '500 g Mehl (Type 550)',
            ),
            IngredientDraft(
              id: 22,
              food: NamedRef(id: 31, name: 'Salz'),
              noAmount: true,
            ),
          ],
        ),
        StepDraft(id: 11),
      ]);
    });
  });

  test('survives a JSON round trip, for local drafts', () {
    final draft = RecipeDraft.fromRecipe(ofenkarotten).copyWith(
      sourceUrl: 'https://example.com/a',
      keywords: const [NamedRef(name: 'Neu')],
    );

    final json = jsonDecode(jsonEncode(draft)) as Map<String, dynamic>;

    expect(RecipeDraft.fromJson(json), draft);
  });
}

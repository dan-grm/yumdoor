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

  group('ingredient changes', () {
    const salz = IngredientDraft(food: NamedRef(name: 'Salz'), noAmount: true);
    const pfeffer = IngredientDraft(food: NamedRef(name: 'Pfeffer'));
    const oel = IngredientDraft(food: NamedRef(name: 'Öl'), amount: 1);
    final draft = RecipeDraft(
      steps: [
        const StepDraft(id: 1, ingredients: [salz]),
        const StepDraft(id: 2, ingredients: [pfeffer, oel]),
      ],
    );

    List<List<IngredientDraft>> ingredients(RecipeDraft draft) => [
      for (final step in draft.steps) step.ingredients,
    ];

    test('adds to the last step unless a step is given', () {
      expect(ingredients(draft.addIngredient(salz)), [
        [salz],
        [pfeffer, oel, salz],
      ]);
      expect(ingredients(draft.addIngredient(oel, step: 0)), [
        [salz, oel],
        [pfeffer, oel],
      ]);
      // A step that no longer exists falls back to the last one.
      expect(ingredients(draft.addIngredient(salz, step: 5)), [
        [salz],
        [pfeffer, oel, salz],
      ]);
    });

    test('a draft without steps gets one for the first ingredient', () {
      final added = const RecipeDraft().addIngredient(salz);

      expect(added.steps, [
        const StepDraft(ingredients: [salz]),
      ]);
    });

    test('replaces, removes and moves within a step', () {
      expect(ingredients(draft.replaceIngredient(1, 0, salz)), [
        [salz],
        [salz, oel],
      ]);
      expect(ingredients(draft.removeIngredient(1, 1)), [
        [salz],
        [pfeffer],
      ]);
      expect(ingredients(draft.moveIngredient(1, 0, 1)), [
        [salz],
        [oel, pfeffer],
      ]);
      // Not past the ends.
      expect(ingredients(draft.moveIngredient(1, 0, -1)), ingredients(draft));
      expect(ingredients(draft.moveIngredient(1, 1, 2)), ingredients(draft));
    });

    test('groups by step when more than one step has ingredients', () {
      expect(draft.groupsIngredientsByStep, isTrue);
      expect(draft.removeIngredient(0, 0).groupsIngredientsByStep, isFalse);
      expect(const RecipeDraft().groupsIngredientsByStep, isFalse);
    });

    test('a header has its title as note and no amount', () {
      expect(
        IngredientDraft.header('  Für den Teig '),
        const IngredientDraft(
          isHeader: true,
          noAmount: true,
          note: 'Für den Teig',
        ),
      );
    });
  });

  group('steps', () {
    final draft = RecipeDraft.fromRecipe(ofenkarotten);
    List<int?> ids(RecipeDraft d) => [for (final s in d.steps) s.id];

    test('adds an empty step at the end', () {
      final added = draft.addStep();

      expect(ids(added), [1, 2, 3, null]);
      expect(added.steps.last, const StepDraft());
    });

    test('removes a step with its ingredients', () {
      final removed = draft.removeStep(1);

      expect(ids(removed), [1, 3]);
      expect(removed.steps.expand((s) => s.ingredients).map((i) => i.id), [
        5,
        6,
      ]);
    });

    test('moves a step, not past the ends', () {
      expect(ids(draft.moveStep(0, 2)), [2, 3, 1]);
      expect(ids(draft.moveStep(2, 1)), [1, 3, 2]);
      expect(ids(draft.moveStep(0, -1)), [1, 2, 3]);
      expect(ids(draft.moveStep(2, 3)), [1, 2, 3]);
    });

    test('changes one step', () {
      final changed = draft.changeStep(
        0,
        (s) => s.copyWith(time: const Duration(minutes: 10)),
      );

      expect(changed.steps[0].time, const Duration(minutes: 10));
      expect(changed.steps[1], draft.steps[1]);
    });

    test('moves an ingredient to the end of another step', () {
      final moved = draft.moveIngredientToStep(1, 0, 2);

      expect(moved.steps[1].ingredients.map((i) => i.id), [2, 3, 4]);
      expect(moved.steps[2].ingredients.map((i) => i.id), [5, 6, 1]);
      expect(draft.moveIngredientToStep(1, 0, 1), draft);
    });
  });
}

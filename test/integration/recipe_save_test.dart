@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

import 'seeded_tandoor.dart';

/// Saving recipes, on recipes the test creates and deletes again.
///
/// Other integration tests run at the same time and count the seeded
/// recipes, so the test recipes are created as the admin and private: Anna
/// and Ben, whom the other tests search as, never see them.
void main() {
  final tandoor = SeededTandoor.load();
  // Unique per run, so a run that was cut short doesn't get in the way.
  final tag = 'Yumdoor-Test ${DateTime.now().microsecondsSinceEpoch}';
  late Dio dio;
  late TandoorRecipeRepository recipes;
  late int propertyType;
  late int otherRecipe;

  /// Recipes, foods and keywords to delete after each test, as API paths.
  final created = <String>[];

  setUpAll(() async {
    dio = createTandoorDio(tandoor.baseUrl, token: tandoor.token('admin'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'POST' && options.path == '/api/recipe/') {
              (options.data as Map)['private'] = true;
            }
            handler.next(options);
          },
        ),
      );
    recipes = TandoorRecipeRepository(
      api.TandoorApi(dio: dio, interceptors: const []).getApiApi(),
    );
    final type = await dio.post<Map<String, dynamic>>(
      '/api/property-type/',
      data: {'name': '$tag Protein', 'unit': 'g'},
    );
    propertyType = type.data!['id'] as int;
    final list = await dio.get<Map<String, dynamic>>(
      '/api/recipe/',
      queryParameters: {'page_size': 1},
    );
    otherRecipe = (list.data!['results'] as List).first['id'] as int;
  });

  tearDown(() async {
    // Recipes first: deleting a food deletes the ingredients that use it.
    for (final path in created.reversed) {
      await dio.delete<void>(path);
    }
    created.clear();
  });

  tearDownAll(() async {
    await dio.delete<void>('/api/property-type/$propertyType/');
    dio.close();
  });

  Future<Map<String, dynamic>> raw(int id) async =>
      (await dio.get<Map<String, dynamic>>('/api/recipe/$id/')).data!;

  /// Remembers the foods and keywords [draft] created, to delete them.
  Future<void> forget(int recipe, RecipeDraft draft) async {
    final saved = await raw(recipe);
    for (final keyword in saved['keywords'] as List) {
      if ((keyword['name'] as String).startsWith(tag)) {
        created.insert(0, '/api/keyword/${keyword['id']}/');
      }
    }
    for (final step in saved['steps'] as List) {
      for (final ingredient in step['ingredients'] as List) {
        final food = ingredient['food'] as Map?;
        if (food != null && (food['name'] as String).startsWith(tag)) {
          created.insert(0, '/api/food/${food['id']}/');
        }
      }
    }
  }

  Future<int> create(RecipeDraft draft) async {
    final recipe = await recipes.createRecipe(draft);
    created.add('/api/recipe/${recipe.id}/');
    await forget(recipe.id, draft);
    return recipe.id;
  }

  final draft = RecipeDraft(
    name: '$tag Ofenkarotten',
    description: 'Süß und *knusprig*.',
    servings: 3,
    servingsText: 'Bleche',
    workingTime: const Duration(minutes: 15),
    waitingTime: const Duration(minutes: 25),
    keywords: [
      const NamedRef(name: 'Vegetarisch'),
      NamedRef(name: '$tag Ofen'),
    ],
    sourceUrl: 'https://example.com/ofenkarotten',
    steps: [
      const StepDraft(
        name: 'Vorbereiten',
        instruction: 'Den Ofen auf 200 °C vorheizen.',
      ),
      StepDraft(
        instruction: 'Karotten mit {{ ingredients[1] }} mischen und rösten.',
        time: const Duration(minutes: 25),
        ingredients: [
          const IngredientDraft(isHeader: true, note: 'Gemüse'),
          const IngredientDraft(
            food: NamedRef(name: 'Karotte'),
            unit: NamedRef(name: 'g'),
            amount: 500,
            note: 'geschält',
            originalText: '500 g Karotten, geschält',
          ),
          IngredientDraft(
            food: NamedRef(name: '$tag Feta'),
            unit: const NamedRef(name: 'g'),
            amount: 150.5,
          ),
          const IngredientDraft(food: NamedRef(name: 'Salz'), noAmount: true),
        ],
      ),
    ],
  );

  test('creates a recipe that reads back as it was saved', () async {
    final saved = await recipes.createRecipe(draft);
    created.add('/api/recipe/${saved.id}/');
    await forget(saved.id, draft);

    final read = await recipes.fetchRecipe(saved.id);
    expect(saved.copyWith(updatedAt: read.updatedAt), read);
    expect(_withoutIds(RecipeDraft.fromRecipe(read)), draft);
    // Existing foods, units and keywords were found by name, not created
    // again.
    final ingredients = read.steps[1].ingredients;
    expect(ingredients[1].food?.pluralName, 'Karotten');
    expect(ingredients[2].unit?.id, ingredients[1].unit?.id);
    expect(read.keywords.first.name, 'Vegetarisch');
    // Marked as written in Tandoor, like recipes from its own editor.
    expect((await raw(saved.id))['internal'], isTrue);
  });

  test('updates a recipe and keeps what Yumdoor does not edit', () async {
    final id = await create(draft);
    // What only Tandoor's own editor sets: a property, nutrition, a
    // sub-recipe step and a step without the ingredient table.
    final before = await raw(id);
    final steps = before['steps'] as List;
    final patched = await dio.patch<Map<String, dynamic>>(
      '/api/recipe/$id/',
      data: {
        'show_ingredient_overview': false,
        'properties': [
          {
            'property_amount': 12.5,
            'property_type': {'id': propertyType, 'name': '$tag Protein'},
          },
        ],
        'nutrition': {
          'carbohydrates': 1,
          'fats': 2,
          'proteins': 3,
          'calories': 4,
          'source': 'Test',
        },
        'steps': [
          {'id': steps[0]['id']},
          {'id': steps[1]['id'], 'show_ingredients_table': false},
          {
            'name': 'Beilage',
            'instruction': '',
            'order': 2,
            'step_recipe': otherRecipe,
            'ingredients': <Object>[],
          },
        ],
      },
    );
    // A property outlives its recipe and keeps the type from being deleted.
    for (final property in patched.data!['properties'] as List) {
      created.add('/api/property/${property['id']}/');
    }
    final loaded = RecipeDraft.fromRecipe(await recipes.fetchRecipe(id));
    expect(loaded.steps, hasLength(3));
    final [prepare, roast, side] = loaded.steps;
    final [header, carrots, feta, salt] = roast.ingredients;

    // Renamed, steps reordered, the first step and an ingredient removed,
    // a step and an ingredient added, ingredients reordered and changed.
    final changed = loaded.copyWith(
      name: '$tag Ofenkarotten mit Feta',
      servings: 2,
      keywords: [loaded.keywords.last],
      sourceUrl: null,
      steps: [
        side,
        roast.copyWith(
          name: 'Rösten',
          ingredients: [
            feta.copyWith(amount: 200, note: 'zerbröselt'),
            header,
            carrots.copyWith(amount: 600),
            const IngredientDraft(
              food: NamedRef(name: 'Olivenöl'),
              unit: NamedRef(name: 'EL'),
              amount: 2,
            ),
          ],
        ),
        const StepDraft(name: 'Anrichten', instruction: 'Sofort servieren.'),
      ],
    );
    final saved = await recipes.updateRecipe(id, changed);

    final read = await recipes.fetchRecipe(id);
    expect(saved.copyWith(updatedAt: read.updatedAt), read);
    expect(_withoutIds(RecipeDraft.fromRecipe(read)), _withoutIds(changed));
    final readSteps = RecipeDraft.fromRecipe(read).steps;
    // Existing steps and ingredients keep their ids.
    expect(readSteps[0].id, side.id);
    expect(readSteps[1].id, roast.id);
    expect(readSteps[1].ingredients.map((i) => i.id).take(3), [
      feta.id,
      header.id,
      carrots.id,
    ]);
    expect(readSteps[1].ingredients.map((i) => i.id), isNot(contains(salt.id)));
    expect(readSteps.map((s) => s.id), isNot(contains(prepare.id)));

    final after = await raw(id);
    expect(after['private'], isTrue);
    expect(after['internal'], isTrue);
    expect(after['show_ingredient_overview'], isFalse);
    expect(after['nutrition']['calories'], 4);
    expect(
      [
        for (final p in after['properties'] as List)
          (p['property_type']['id'], p['property_amount']),
      ],
      [(propertyType, 12.5)],
    );
    final afterSteps = (after['steps'] as List).cast<Map<String, dynamic>>();
    expect(afterSteps[0]['step_recipe'], otherRecipe);
    expect(afterSteps[1]['step_recipe'], isNull);
    // Kept, although the step was moved and changed; a new step gets
    // Tandoor's default.
    expect(afterSteps[1]['show_ingredients_table'], isFalse);
    expect(afterSteps[2]['show_ingredients_table'], isTrue);
    // Tandoor keeps the imported line only from when it was created.
    expect(
      (afterSteps[1]['ingredients'] as List)[2]['original_text'],
      '500 g Karotten, geschält',
    );
  });

  test('updating a recipe that is gone throws NotFoundFailure', () async {
    final id = await create(const RecipeDraft(name: 'Gleich weg'));
    await dio.delete<void>('/api/recipe/$id/');
    created.clear();

    await expectLater(
      recipes.updateRecipe(id, const RecipeDraft(name: 'Neu')),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}

/// [draft] without the ids of steps, ingredients, foods, units and keywords,
/// to compare what was saved with what was sent.
RecipeDraft _withoutIds(RecipeDraft draft) => draft.copyWith(
  keywords: [for (final k in draft.keywords) k.copyWith(id: null)],
  steps: [
    for (final step in draft.steps)
      step.copyWith(
        id: null,
        ingredients: [
          for (final i in step.ingredients)
            i.copyWith(
              id: null,
              food: i.food?.copyWith(id: null),
              unit: i.unit?.copyWith(id: null),
            ),
        ],
      ),
  ],
);

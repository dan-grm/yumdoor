import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/recipe_draft_mapper.dart';
import 'package:yumdoor/data/mappers/recipe_mapper.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  final suppe = api.standardSerializers.deserializeWith(
    api.Recipe.serializer,
    tandoorFixture('recipe_karottensuppe.json'),
  )!;

  /// What the generated client sends for [body].
  Map<String, Object?> wire(Object body) =>
      switch (body) {
            api.PatchedRecipe() => api.standardSerializers.serializeWith(
              api.PatchedRecipe.serializer,
              body,
            ),
            api.Recipe() => api.standardSerializers.serializeWith(
              api.Recipe.serializer,
              body,
            ),
            _ => throw ArgumentError(body),
          }!
          as Map<String, Object?>;

  group('update', () {
    test('sends only the fields Yumdoor edits', () {
      final draft = RecipeDraft.fromRecipe(suppe.toDomain());

      final json = wire(draft.toPatchedRecipe());

      expect(json.keys.toSet(), {
        'name',
        'description',
        'servings',
        'servings_text',
        'working_time',
        'waiting_time',
        'keywords',
        'source_url',
        'steps',
      });
      expect(json['name'], 'Karottensuppe mit Ingwer');
      expect(json['servings'], 4);
      expect(json['working_time'], 15);
      expect(json['waiting_time'], 20);
      // Empty, so a removed URL is removed on the server too.
      expect(json['source_url'], '');
      expect(json['keywords'], [
        {'id': 45, 'name': 'Suppe'},
        {'id': 46, 'name': 'Vegetarisch'},
        {'id': 47, 'name': 'Herbst'},
      ]);
    });

    test('sends steps and ingredients by id, numbered in list order', () {
      final draft = RecipeDraft.fromRecipe(suppe.toDomain());
      // The last step first.
      final reordered = draft.copyWith(
        steps: [draft.steps[2], draft.steps[0], draft.steps[1]],
      );

      final steps = wire(reordered.toPatchedRecipe())['steps']! as List;

      expect(steps[0], {
        'id': 141,
        'name': '',
        'instruction': suppe.steps[2].instruction,
        'time': 0,
        'order': 0,
        'ingredients': [
          _ingredient(392, 'Kokosmilch', 216, 'ml', 42, 200, order: 0),
          {
            'id': 393,
            'food': {'id': 228, 'name': 'Salz'},
            'unit': null,
            'amount': 0.0,
            'no_amount': true,
            'is_header': false,
            'note': '',
            'order': 1,
            'checked': false,
          },
          {
            'id': 394,
            'food': {'id': 229, 'name': 'Pfeffer'},
            'unit': null,
            'amount': 0.0,
            'no_amount': true,
            'is_header': false,
            'note': '',
            'order': 2,
            'checked': false,
          },
        ],
      });
      expect([for (final s in steps) (s as Map)['id']], [141, 139, 140]);
      expect([for (final s in steps) (s as Map)['order']], [0, 1, 2]);
      // Sub-recipe, file and display settings stay as they are.
      for (final step in steps.cast<Map<String, Object?>>()) {
        expect(
          step.keys,
          isNot(
            anyOf(
              contains('step_recipe'),
              contains('file'),
              contains('show_as_header'),
              contains('show_ingredients_table'),
            ),
          ),
        );
      }
    });

    test('sends new items without an id, foods and units by name', () {
      const draft = RecipeDraft(
        name: 'Neu',
        keywords: [NamedRef(name: 'Schnell')],
        steps: [
          StepDraft(
            ingredients: [
              IngredientDraft(isHeader: true, note: 'Für die Soße'),
              IngredientDraft(
                food: NamedRef(name: 'Tahin'),
                unit: NamedRef(name: 'EL'),
                amount: 2,
                originalText: '2 EL Tahin',
              ),
            ],
          ),
        ],
      );

      final json = wire(draft.toPatchedRecipe());

      expect(json['keywords'], [
        {'name': 'Schnell'},
      ]);
      expect(json['steps'], [
        {
          'name': '',
          'instruction': '',
          'time': 0,
          'order': 0,
          'ingredients': [
            {
              'food': null,
              'unit': null,
              'amount': 0.0,
              'no_amount': false,
              'is_header': true,
              'note': 'Für die Soße',
              'order': 0,
              'checked': false,
            },
            {
              'food': {'name': 'Tahin'},
              'unit': {'name': 'EL'},
              'amount': 2.0,
              'no_amount': false,
              'is_header': false,
              'note': '',
              'original_text': '2 EL Tahin',
              'order': 1,
              'checked': false,
            },
          ],
        },
      ]);
    });

    test('sends the source as written and times in whole minutes', () {
      const draft = RecipeDraft(
        name: 'Neu',
        workingTime: Duration(minutes: 90, seconds: 30),
        sourceUrl: 'Omas Kochbuch, S. 12',
      );

      final json = wire(draft.toPatchedRecipe());

      expect(json['working_time'], 90);
      expect(json['source_url'], 'Omas Kochbuch, S. 12');
    });
  });

  test('create sends the same as an update, as written in Tandoor', () {
    final draft = RecipeDraft.fromRecipe(suppe.toDomain());
    final update = wire(draft.toPatchedRecipe());

    final create = wire(draft.toApiRecipe());

    // New steps and ingredients: with ids, the copy would share the
    // original's. Foods, units and keywords keep theirs.
    expect(create, {
      ...update,
      'steps': [
        for (final step
            in (update['steps']! as List).cast<Map<String, Object?>>())
          {
            ...step,
            'ingredients': [
              for (final i
                  in (step['ingredients'] as List).cast<Map<String, Object?>>())
                {...i}..remove('id'),
            ],
          }..remove('id'),
      ],
      'internal': true,
    });
    expect(
      ((create['steps']! as List).first as Map)['ingredients'],
      contains(containsPair('food', {'id': 178, 'name': 'Karotte'})),
    );
  });

  test('a recipe read back maps to the draft that was saved', () {
    // The server echoes a saved body back with everything else filled in.
    final draft = RecipeDraft.fromRecipe(suppe.toDomain());
    final echoed = api.standardSerializers.deserializeWith(
      api.Recipe.serializer,
      {
        ...tandoorFixture('recipe_karottensuppe.json')! as Map<String, Object?>,
        ...wire(draft.toPatchedRecipe()),
      },
    )!;

    expect(RecipeDraft.fromRecipe(echoed.toDomain()), draft);
  });
}

Map<String, Object?> _ingredient(
  int id,
  String food,
  int foodId,
  String unit,
  int unitId,
  double amount, {
  required int order,
}) => {
  'id': id,
  'food': {'id': foodId, 'name': food},
  'unit': {'id': unitId, 'name': unit},
  'amount': amount,
  'no_amount': false,
  'is_header': false,
  'note': '',
  'order': order,
  'checked': false,
};

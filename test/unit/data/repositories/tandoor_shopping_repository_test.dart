import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_food_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_shopping_repository.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fakes/fake_http_adapter.dart';

// The shopping and food repositories against canned responses. Behavior
// against a real Tandoor is in test/integration/shopping_repository_test.dart.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  (api.ApiApi, Dio) client(FakeHttpAdapter adapter) {
    final dio = createTandoorDio(serverUrl, token: 'tda_test')
      ..httpClientAdapter = adapter;
    return (api.TandoorApi(dio: dio, interceptors: const []).getApiApi(), dio);
  }

  TandoorShoppingRepository shopping(FakeHttpAdapter adapter) {
    final (apiClient, dio) = client(adapter);
    return TandoorShoppingRepository(apiClient, dio);
  }

  Map<String, Object?> entry(int id, {bool checked = false}) => {
    'id': id,
    'list_recipe': null,
    'shopping_lists': <Object?>[],
    'food': {
      'id': 100 + id,
      'name': 'Food $id',
      'plural_name': null,
      'supermarket_category': null,
      'shopping_lists': <Object?>[],
    },
    'unit': null,
    'amount': 1.0,
    'order': 0,
    'checked': checked,
    'ingredient': null,
    'list_recipe_data': null,
    'created_by': {'id': 1, 'username': 'anna', 'display_name': 'Anna'},
    'created_at': '2026-11-20T10:00:00+01:00',
    'updated_at': '2026-11-20T10:00:00+01:00',
    'completed_at': null,
    'delay_until': null,
  };

  const timestamp = '2026-11-20T09:30:00.250000+00:00';

  Map<String, Object?> page(
    List<Object?> results, {
    bool more = false,
    int? count,
    String timestamp = timestamp,
  }) => {
    'count': count ?? results.length,
    'next': more ? 'next' : null,
    'previous': null,
    'timestamp': timestamp,
    'results': results,
  };

  group('fetch', () {
    test('reads every page, oldest entries first', () async {
      final adapter = FakeHttpAdapter((request) {
        return jsonResponse(switch (request.uri.queryParameters['page']) {
          '1' => page([entry(1), entry(2)], more: true, count: 3),
          _ => page(
            [entry(3, checked: true)],
            count: 3,
            timestamp: '2026-11-20T09:30:05+00:00',
          ),
        });
      });

      final list = await shopping(adapter).fetch();

      expect([for (final e in list.entries) e.id], [1, 2, 3]);
      expect(list.entries.last.checked, isTrue);
      expect(list.truncated, isFalse);
      // The first page's time, a minute earlier.
      expect(list.syncedAt, DateTime.utc(2026, 11, 20, 9, 29, 0, 250));
      expect(list.syncedAt.isUtc, isTrue);
      expect(adapter.requests, hasLength(2));
      final query = adapter.requests.first.uri.queryParameters;
      expect(query['page_size'], '200');
      expect(query.containsKey('updated_after'), isFalse);
    });

    test('sends updatedAfter in UTC', () async {
      final adapter = FakeHttpAdapter((_) => jsonResponse(page([entry(1)])));
      final since = DateTime.utc(2026, 11, 20, 9, 30, 1, 5);

      await shopping(adapter).fetch(updatedAfter: since.toLocal());

      final uri = adapter.requests.single.uri;
      expect(uri.queryParameters['updated_after'], '2026-11-20T09:30:01.005Z');
      // A raw `+` would be read as a space, and Tandoor then ignores the
      // filter.
      expect(uri.query, isNot(contains('+')));
    });

    test('starts over when the list changes between pages', () async {
      var reads = 0;
      final adapter = FakeHttpAdapter((request) {
        if (request.uri.queryParameters['page'] == '1') {
          reads++;
          return jsonResponse(page([entry(1), entry(2)], more: true, count: 3));
        }
        // Entry 2 was deleted before the second read's page 2.
        return jsonResponse(
          reads == 1 ? page([entry(4)], count: 2) : page([entry(3)], count: 3),
        );
      });

      final list = await shopping(adapter).fetch();

      expect([for (final e in list.entries) e.id], [1, 2, 3]);
      expect(adapter.requests, hasLength(4));
    });

    test('keeps the last read of a list that keeps changing', () async {
      var reads = 0;
      final adapter = FakeHttpAdapter((request) {
        if (request.uri.queryParameters['page'] == '1') {
          reads++;
          return jsonResponse(page([entry(reads)], more: true, count: 9));
        }
        return jsonResponse(page([entry(10 + reads)], count: 8));
      });

      final list = await shopping(adapter).fetch();

      expect([for (final e in list.entries) e.id], [3, 13]);
      expect(adapter.requests, hasLength(6));
    });

    test('reports a list cut off at the server limit', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(page([entry(1)], count: maxShoppingEntries)),
      );

      expect((await shopping(adapter).fetch()).truncated, isTrue);
    });

    test('keeps updatedAfter after a truncated incremental read', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(page([entry(1)], count: maxShoppingEntries)),
      );
      final since = DateTime.utc(2026, 11, 20, 8);

      final changes = await shopping(adapter).fetch(updatedAfter: since);

      expect(changes.truncated, isTrue);
      expect(changes.syncedAt, since);
    });

    test('maps a response without timestamp to a ServerFailure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(page([entry(1)])..remove('timestamp')),
      );

      expect(shopping(adapter).fetch(), throwsA(isA<ServerFailure>()));
    });

    test('maps an error to a failure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'Keine Berechtigung'}, status: 403),
      );

      expect(shopping(adapter).fetch(), throwsA(isA<UnauthorizedFailure>()));
    });
  });

  group('setChecked', () {
    test('posts the ids and the state to the bulk endpoint', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'ids': [3, 5],
          'checked': true,
          'shopping_lists_remove_all': false,
          'timestamp': '2026-11-20T09:30:00Z',
        }),
      );

      await shopping(adapter).setChecked({3, 5}, checked: true);
      await shopping(adapter).setChecked({3}, checked: false);

      final [check, uncheck] = adapter.requests;
      expect(check.method, 'POST');
      expect(check.uri.path, '/tandoor/api/shopping-list-entry/bulk/');
      expect(jsonDecode(jsonEncode(check.data)), {
        'ids': [3, 5],
        'checked': true,
      });
      expect(jsonDecode(jsonEncode(uncheck.data)), {
        'ids': [3],
        'checked': false,
      });
    });

    test('sends nothing for no ids', () async {
      final adapter = FakeHttpAdapter((_) => throw StateError('no request'));

      await shopping(adapter).setChecked({}, checked: true);

      expect(adapter.requests, isEmpty);
    });

    test('maps an error to a failure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'ids': 'Required'}, status: 400),
      );

      expect(
        shopping(adapter).setChecked({1}, checked: true),
        throwsA(isA<Failure>()),
      );
    });
  });

  /// Answers the requests of a meal plan's cleanup check: [entriesLeft]
  /// entries of the plan on the list, and its list recipes [listRecipes].
  ResponseBody? planCheck(
    RequestOptions request, {
    int entriesLeft = 0,
    List<int> listRecipes = const [],
  }) {
    if (request.method != 'GET') return null;
    if (request.uri.path.endsWith('/shopping-list-entry/')) {
      return jsonResponse(
        page([for (var i = 0; i < entriesLeft; i++) entry(90 + i)]),
      );
    }
    return jsonResponse(
      page([
        for (final id in listRecipes) {'id': id, 'servings': 4.0},
      ]),
    );
  }

  String describe(RequestOptions r) =>
      '${r.method} ${r.uri.path.replaceFirst('/tandoor/api', '')}'
      '${r.uri.queryParameters.containsKey('mealplan') ? '?mealplan=${r.uri.queryParameters['mealplan']}' : ''}';

  group('addRecipe', () {
    const gram = Unit(id: 10, name: 'g');
    const salad = Recipe(
      id: 7,
      name: 'Salat',
      servings: 2,
      steps: [
        RecipeStep(
          id: 1,
          ingredients: [
            Ingredient(
              id: 100,
              food: Food(id: 1, name: 'Tomate'),
              unit: gram,
              amount: 300,
            ),
            Ingredient(
              id: 101,
              food: Food(id: 2, name: 'Olivenöl', onHand: true),
              amount: 2,
            ),
            Ingredient(
              id: 102,
              food: Food(id: 3, name: 'Salz', ignoreShopping: true),
              noAmount: true,
            ),
            Ingredient(id: 103, food: Food(id: 4, name: 'Basilikum')),
          ],
        ),
      ],
    );

    test('creates the recipe for the plan, then its entries', () async {
      final adapter = FakeHttpAdapter((request) {
        if (request.uri.path.endsWith('/shopping-list-recipe/')) {
          return jsonResponse({'id': 42, 'servings': 3.0}, status: 201);
        }
        return jsonResponse(request.data);
      });

      final added = await shopping(adapter).addRecipe(salad, 3, mealPlanId: 9);

      expect(added.neededCount, 2);
      expect(added.onHandCount, 1);
      expect(
        [for (final r in adapter.requests) describe(r)],
        [
          'POST /shopping-list-recipe/',
          'POST /shopping-list-recipe/42/bulk_create_entries/',
        ],
      );
      final [listRecipe, entries] = adapter.requests;
      expect(jsonDecode(jsonEncode(listRecipe.data)), {
        'recipe': 7,
        'servings': 3.0,
        'mealplan': 9,
      });
      expect(jsonDecode(jsonEncode(entries.data)), {
        'entries': [
          {'amount': 450.0, 'food_id': 1, 'unit_id': 10, 'ingredient_id': 100},
          {'amount': 0.0, 'food_id': 4, 'unit_id': null, 'ingredient_id': 103},
        ],
        'shopping_lists_ids': <Object?>[],
      });
    });

    test('scales to fractional servings and sends them', () async {
      final adapter = FakeHttpAdapter((request) {
        if (request.uri.path.endsWith('/shopping-list-recipe/')) {
          return jsonResponse({'id': 42}, status: 201);
        }
        return jsonResponse(request.data);
      });

      await shopping(adapter).addRecipe(salad, 1.5);

      final [listRecipe, entries] = adapter.requests;
      expect(jsonDecode(jsonEncode(listRecipe.data))['servings'], 1.5);
      expect(
        (jsonDecode(jsonEncode(entries.data))['entries'] as List).first,
        containsPair('amount', 225.0),
      );
    });

    test('sends no meal plan without one, and 1 serving for 0', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'id': 42}, status: 201),
      );

      await shopping(adapter).addRecipe(salad, 0);

      expect(jsonDecode(jsonEncode(adapter.requests.first.data)), {
        'recipe': 7,
        'servings': 1.0,
        'mealplan': null,
      });
    });

    test('creates nothing when everything is on hand', () async {
      final adapter = FakeHttpAdapter((_) => throw StateError('no request'));
      const onHand = Recipe(
        id: 8,
        name: 'Brot',
        steps: [
          RecipeStep(
            id: 1,
            ingredients: [
              Ingredient(
                id: 1,
                food: Food(id: 5, name: 'Mehl', onHand: true),
                amount: 500,
              ),
            ],
          ),
        ],
      );

      final added = await shopping(adapter).addRecipe(onHand, 2, mealPlanId: 9);

      expect(added.isEmpty, isTrue);
      expect(added.onHandCount, 1);
      expect(adapter.requests, isEmpty);
    });

    test('deletes the recipe again when its entries fail', () async {
      final adapter = FakeHttpAdapter((request) {
        if (request.method == 'DELETE') return jsonResponse(null, status: 204);
        if (request.uri.path.endsWith('/bulk_create_entries/')) {
          return htmlResponse('<h1>Server Error (500)</h1>', status: 500);
        }
        return jsonResponse({'id': 42}, status: 201);
      });

      await expectLater(
        shopping(adapter).addRecipe(salad, 4, mealPlanId: 9),
        throwsA(isA<ServerFailure>()),
      );

      expect(
        describe(adapter.requests.last),
        'DELETE /shopping-list-recipe/42/',
      );
    });

    test('reports the original failure when the cleanup fails, too', () async {
      final adapter = FakeHttpAdapter((request) {
        if (request.uri.path.endsWith('/shopping-list-recipe/')) {
          return jsonResponse({'id': 42}, status: 201);
        }
        throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        );
      });

      await expectLater(
        shopping(adapter).addRecipe(salad, 4),
        throwsA(isA<OfflineFailure>()),
      );
      expect(adapter.requests.last.method, 'DELETE');
    });

    test('creates no entries when the recipe fails', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'recipe': 'Invalid'}, status: 400),
      );

      await expectLater(
        shopping(adapter).addRecipe(salad, 4),
        throwsA(isA<ServerFailure>()),
      );
      expect(adapter.requests, hasLength(1));
    });
  });

  group('addItem', () {
    test('sends food and unit as plain ids', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(entry(5), status: 201),
      );

      final added = await shopping(adapter).addItem(105, 2, unitId: 3);

      expect(added.id, 5);
      expect(added.food.name, 'Food 5');
      expect(added.source, isNull);
      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/tandoor/api/shopping-list-entry/');
      expect(jsonDecode(jsonEncode(request.data)), {
        'food': 105,
        'unit': 3,
        'amount': 2.0,
      });
    });

    test('sends a null unit without one', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(entry(5), status: 201),
      );

      await shopping(adapter).addItem(105, 0);

      expect(jsonDecode(jsonEncode(adapter.requests.single.data)), {
        'food': 105,
        'unit': null,
        'amount': 0.0,
      });
    });

    test('maps an unexpected response to a ServerFailure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'id': 'x'}, status: 201),
      );

      expect(shopping(adapter).addItem(105, 1), throwsA(isA<ServerFailure>()));
    });
  });

  group('deleteEntries', () {
    final plan = MealPlan(
      id: 9,
      servings: 4,
      fromDay: CalendarDay(2026, 11, 23),
      toDay: CalendarDay(2026, 11, 23),
      mealType: const MealType(id: 1, name: 'Mittagessen'),
      onShoppingList: true,
      createdBy: 1,
    );

    ShoppingEntry domainEntry(int id, {MealPlan? mealPlan, int? listRecipe}) =>
        ShoppingEntry(
          id: id,
          food: ShoppingFood(id: 100 + id, name: 'Food $id'),
          amount: 1,
          updatedAt: DateTime.utc(2026, 11, 20),
          createdBy: const UserRef(id: 1, name: 'Anna'),
          source: listRecipe == null
              ? null
              : ShoppingEntrySource(
                  listRecipeId: listRecipe,
                  servings: 4,
                  mealPlan: mealPlan,
                ),
        );

    test('deletes each entry and ignores ones already gone', () async {
      final adapter = FakeHttpAdapter(
        (request) => request.uri.path.endsWith('/2/')
            ? jsonResponse({'detail': 'Not found.'}, status: 404)
            : jsonResponse(null, status: 204),
      );

      await shopping(adapter)
          .deleteEntries([domainEntry(1), domainEntry(2, listRecipe: 42)]);

      expect(
        [for (final r in adapter.requests) describe(r)],
        ['DELETE /shopping-list-entry/1/', 'DELETE /shopping-list-entry/2/'],
      );
    });

    test('deletes a few at a time and tries them all', () async {
      var running = 0;
      var most = 0;
      final adapter = FakeHttpAdapter((request) async {
        running++;
        most = running > most ? running : most;
        await Future<void>.delayed(Duration.zero);
        running--;
        return request.uri.path.endsWith('/3/')
            ? jsonResponse({'detail': 'Fehler'}, status: 500)
            : jsonResponse(null, status: 204);
      });

      await expectLater(
        shopping(adapter)
            .deleteEntries([for (var id = 1; id <= 10; id++) domainEntry(id)]),
        throwsA(isA<ServerFailure>()),
      );

      expect(adapter.requests, hasLength(10));
      expect(most, 4);
    });

    test('sends nothing for no entries', () async {
      final adapter = FakeHttpAdapter((_) => throw StateError('no request'));

      await shopping(adapter).deleteEntries(const []);

      expect(adapter.requests, isEmpty);
    });

    test('unlinks the recipes of a plan with no entries left', () async {
      final adapter = FakeHttpAdapter(
        (request) =>
            planCheck(request, listRecipes: [42, 43]) ??
            (request.method == 'PATCH'
                ? jsonResponse({'id': 42, 'servings': 4.0})
                : jsonResponse(null, status: 204)),
      );

      await shopping(adapter).deleteEntries([
        domainEntry(1, mealPlan: plan, listRecipe: 42),
        domainEntry(2, mealPlan: plan, listRecipe: 42),
      ]);

      expect(
        [for (final r in adapter.requests) describe(r)],
        [
          'DELETE /shopping-list-entry/1/',
          'DELETE /shopping-list-entry/2/',
          'GET /shopping-list-entry/?mealplan=9',
          'GET /shopping-list-recipe/?mealplan=9',
          'PATCH /shopping-list-recipe/42/',
          'PATCH /shopping-list-recipe/43/',
        ],
      );
      // Not deleted: that would delete their checked entries, too.
      expect(jsonDecode(jsonEncode(adapter.requests.last.data)), {
        'mealplan': null,
      });
    });

    test('skips the cleanup for a plan whose entries failed', () async {
      final adapter = FakeHttpAdapter(
        (request) => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
      );

      await expectLater(
        shopping(adapter)
            .deleteEntries([domainEntry(1, mealPlan: plan, listRecipe: 42)]),
        throwsA(isA<OfflineFailure>()),
      );
      expect(adapter.requests, hasLength(1));
    });

    test("keeps a meal plan's recipes with entries left", () async {
      final adapter = FakeHttpAdapter(
        (request) =>
            planCheck(request, entriesLeft: 1, listRecipes: [42]) ??
            jsonResponse(null, status: 204),
      );

      await shopping(adapter)
          .deleteEntries([domainEntry(1, mealPlan: plan, listRecipe: 42)]);

      expect([for (final r in adapter.requests) r.method], ['DELETE', 'GET']);
    });

    test('cleans up the other plans after a failed delete', () async {
      final adapter = FakeHttpAdapter(
        (request) =>
            planCheck(request, listRecipes: [42]) ??
            (request.uri.path.endsWith('/shopping-list-entry/5/')
                ? jsonResponse({'detail': 'Fehler'}, status: 500)
                : request.method == 'PATCH'
                ? jsonResponse({'id': 42, 'servings': 4.0})
                : jsonResponse(null, status: 204)),
      );

      await expectLater(
        shopping(adapter).deleteEntries([
          domainEntry(1, mealPlan: plan, listRecipe: 42),
          domainEntry(5),
        ]),
        throwsA(isA<ServerFailure>()),
      );

      expect(
        describe(adapter.requests.last),
        'PATCH /shopping-list-recipe/42/',
      );
    });

    test('reports other errors as a ServerFailure', () {
      final adapter = FakeHttpAdapter((_) => throw StateError('closed'));

      expect(
        shopping(adapter).deleteEntries([domainEntry(1)]),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('succeeds when the cleanup fails', () async {
      final adapter = FakeHttpAdapter(
        (request) => request.method == 'GET'
            ? jsonResponse({'detail': 'Fehler'}, status: 500)
            : jsonResponse(null, status: 204),
      );

      await shopping(adapter)
          .deleteEntries([domainEntry(1, mealPlan: plan, listRecipe: 42)]);

      expect(adapter.requests, hasLength(2));
    });

    test('maps an error to a failure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'Keine Berechtigung'}, status: 403),
      );

      expect(
        shopping(adapter).deleteEntries([domainEntry(1)]),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });

  group('supermarkets', () {
    test('reads every page', () async {
      Map<String, Object?> market(int id) => {
        'id': id,
        'name': 'Markt $id',
        'description': null,
        'shopping_lists': <Object?>[],
        'category_to_supermarket': [
          {
            'id': id,
            'category': {'id': 10 * id, 'name': 'Kategorie'},
            'supermarket': id,
            'order': 0,
          },
        ],
        'open_data_slug': null,
      };
      final adapter = FakeHttpAdapter((request) {
        return jsonResponse(switch (request.uri.queryParameters['page']) {
          '1' => page([market(1)], more: true),
          _ => page([market(2)]),
        });
      });

      final markets = await shopping(adapter).supermarkets();

      expect(markets, const [
        Supermarket(id: 1, name: 'Markt 1', categoryIds: [10]),
        Supermarket(id: 2, name: 'Markt 2', categoryIds: [20]),
      ]);
    });
  });

  group('FoodRepository.setOnHand', () {
    TandoorFoodRepository foods(FakeHttpAdapter adapter) =>
        TandoorFoodRepository(client(adapter).$1);

    test('patches only food_onhand', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'id': 7,
          'name': 'Milch',
          'food_onhand': true,
          'ignore_shopping': false,
        }),
      );

      final food = await foods(adapter).setOnHand(7, onHand: true);

      expect(food.onHand, isTrue);
      final request = adapter.requests.single;
      expect(request.method, 'PATCH');
      expect(request.uri.path, '/tandoor/api/food/7/');
      expect(jsonDecode(jsonEncode(request.data)), {'food_onhand': true});
    });

    test('fails with NotFoundFailure for an unknown food', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'Not found.'}, status: 404),
      );

      expect(
        foods(adapter).setOnHand(7, onHand: false),
        throwsA(isA<NotFoundFailure>()),
      );
    });
  });
}

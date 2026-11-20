import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_food_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_shopping_repository.dart';
import 'package:yumdoor/domain/models/shopping.dart';

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
      // The first page's time, a second earlier.
      expect(list.syncedAt, DateTime.utc(2026, 11, 20, 9, 29, 59, 250));
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

    test('reports a list cut off at the server limit', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(page([entry(1)], count: maxShoppingEntries)),
      );

      expect((await shopping(adapter).fetch()).truncated, isTrue);
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

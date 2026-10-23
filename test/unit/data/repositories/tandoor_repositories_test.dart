import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_food_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_keyword_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_server_repository.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';

import '../../../fakes/fake_http_adapter.dart';
import '../../../fixtures/tandoor_fixtures.dart';

// The repositories against canned responses: request parameters and failure
// mapping. Behavior against a real Tandoor is in test/integration/.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  Dio fakeDio(FakeHttpAdapter adapter, {String? token = 'tda_test'}) =>
      createTandoorDio(serverUrl, token: token)..httpClientAdapter = adapter;

  api.ApiApi client(FakeHttpAdapter adapter) =>
      api.TandoorApi(dio: fakeDio(adapter), interceptors: const []).getApiApi();

  group('createTandoorDio', () {
    test('sends the token as a bearer token under the server path', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('keyword_list.json')),
      );

      await TandoorKeywordRepository(client(adapter)).autocomplete('Suppe');

      final request = adapter.requests.single;
      expect(request.uri.path, '/tandoor/api/keyword/');
      expect(request.headers['Authorization'], 'Bearer tda_test');
    });
  });

  group('TandoorRecipeRepository', () {
    test('searches by text, foods and keywords', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );

      final page = await TandoorRecipeRepository(client(adapter)).search(
        const RecipeQuery(text: ' Kuchen ', foodIds: {1, 2}, keywordIds: {3}),
        page: 2,
        pageSize: 3,
      );

      final query = adapter.requests.single.uri.queryParametersAll;
      expect(query['query'], ['Kuchen']);
      expect(query['foods_and'], ['1', '2']);
      expect(query['keywords_and'], ['3']);
      expect(query['page'], ['2']);
      expect(query['page_size'], ['3']);
      expect(page.items, hasLength(3));
      expect(page.totalCount, 25);
      expect(page.hasMore, isTrue);
    });

    test('filters by the current user\'s rating and last cooked day', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );

      await TandoorRecipeRepository(client(adapter)).search(
        RecipeQuery(minRating: 4, lastCookedBefore: DateTime(2026, 9, 1, 18)),
      );

      final query = adapter.requests.single.uri.queryParameters;
      expect(query['rating_gte'], '4');
      expect(query['cookedon_lte'], '2026-09-01');
    });

    test('cancels the request with its CancelSignal', () async {
      final response = Completer<ResponseBody>();
      final adapter = FakeHttpAdapter((_) => response.future);
      final cancel = CancelSignal();

      final search = TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(), cancel: cancel);
      cancel.cancel();

      await expectLater(search, throwsA(isA<CancelledFailure>()));
      response.complete(jsonResponse(tandoorFixture('recipe_list.json')));
    });

    test('leaves out empty filters', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );

      await TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(text: '  '));

      expect(adapter.requests.single.uri.queryParameters.keys, {
        'page',
        'page_size',
      });
    });

    test('fetches a recipe', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_apfelkuchen.json')),
      );

      final recipe = await TandoorRecipeRepository(client(adapter))
          .fetchRecipe(58);

      expect(adapter.requests.single.uri.path, '/tandoor/api/recipe/58/');
      expect(recipe.name, 'Apfelkuchen vom Blech');
    });

    test('throws NotFoundFailure for a missing recipe', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'detail': 'No Recipe matches the given query.',
        }, status: 404),
      );

      expect(
        TandoorRecipeRepository(client(adapter)).fetchRecipe(1),
        throwsA(isA<NotFoundFailure>()),
      );
    });

    test('throws UnauthorizedFailure for a rejected token', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'detail': 'Authentication credentials were not provided.',
        }, status: 403),
      );

      expect(
        TandoorRecipeRepository(client(adapter)).search(const RecipeQuery()),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });

  test('TandoorFoodRepository asks for at most limit foods', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonResponse(tandoorFixture('food_list.json')),
    );

    final foods = await TandoorFoodRepository(client(adapter))
        .autocomplete('Karotte', limit: 5);

    final query = adapter.requests.single.uri.queryParameters;
    expect(query['query'], 'Karotte');
    expect(query['page_size'], '5');
    expect(foods.single.name, 'Karotte');
  });

  Object? firstResult(String fixture) =>
      ((tandoorFixture(fixture)! as Map<String, Object?>)['results']!
              as List<Object?>)
          .first;

  test('TandoorFoodRepository fetches a food by id', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonResponse(firstResult('food_list.json')),
    );

    final food = await TandoorFoodRepository(client(adapter)).fetchFood(178);

    expect(adapter.requests.single.uri.path, '/tandoor/api/food/178/');
    expect(food.pluralName, 'Karotten');
  });

  test('TandoorKeywordRepository fetches a keyword by id', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonResponse(firstResult('keyword_list.json')),
    );

    final keyword = await TandoorKeywordRepository(client(adapter))
        .fetchKeyword(45);

    expect(adapter.requests.single.uri.path, '/tandoor/api/keyword/45/');
    expect(keyword.name, 'Suppe');
  });

  group('TandoorServerRepository', () {
    TandoorServerRepository repository(FakeHttpAdapter adapter) =>
        TandoorServerRepository(
          dioFor: (url) => createTandoorDio(url)..httpClientAdapter = adapter,
        );

    test('reads the version without a token', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('server_settings.json')),
      );

      final info = await repository(adapter).fetchServerInfo(serverUrl);

      expect(info.version, '2.6.15');
      final request = adapter.requests.single;
      expect(request.uri.path, '/tandoor/api/server-settings/current/');
      expect(request.headers, isNot(contains('Authorization')));
    });

    test('throws IncompatibleServerFailure for a 404', () {
      final adapter = FakeHttpAdapter(
        (_) => htmlResponse('<h1>Not Found</h1>', status: 404),
      );

      expect(
        repository(adapter).fetchServerInfo(serverUrl),
        throwsA(isA<IncompatibleServerFailure>()),
      );
    });

    test('throws IncompatibleServerFailure for a page that is not Tandoor', () {
      final adapter = FakeHttpAdapter(
        (_) => htmlResponse('<html><body>Login</body></html>'),
      );

      expect(
        repository(adapter).fetchServerInfo(serverUrl),
        throwsA(isA<IncompatibleServerFailure>()),
      );
    });

    test('throws IncompatibleServerFailure for other JSON', () {
      final adapter = FakeHttpAdapter((_) => jsonResponse({'status': 'ok'}));

      expect(
        repository(adapter).fetchServerInfo(serverUrl),
        throwsA(isA<IncompatibleServerFailure>()),
      );
    });

    test('keeps server errors', () {
      final adapter = FakeHttpAdapter(
        (_) => htmlResponse('Bad Gateway', status: 502),
      );

      expect(
        repository(adapter).fetchServerInfo(serverUrl),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 502),
        ),
      );
    });
  });
}

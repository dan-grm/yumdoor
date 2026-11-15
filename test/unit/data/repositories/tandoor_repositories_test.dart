import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_book_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_food_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_keyword_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_server_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_user_repository.dart';
import 'package:yumdoor/domain/models/recipe_book.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

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

    test('maps the times cooked filters', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );
      final repository = TandoorRecipeRepository(client(adapter));

      await repository.search(const RecipeQuery(minTimesCooked: 5));
      await repository.search(const RecipeQuery(neverCooked: true));

      final [often, never] = [
        for (final r in adapter.requests) r.uri.queryParameters,
      ];
      expect(often['timescooked_gte'], '5');
      expect(often.containsKey('timescooked'), isFalse);
      // `timescooked_lte=0` would match nothing on Tandoor.
      expect(never['timescooked'], '0');
      expect(never.containsKey('timescooked_lte'), isFalse);
    });

    test('maps the cookable, book and creator filters', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );
      final repository = TandoorRecipeRepository(client(adapter));

      await repository.search(
        const RecipeQuery(maxMissingFoods: 0, bookIds: {4, 7}, createdBy: 2),
      );
      await repository.search(const RecipeQuery(maxMissingFoods: 1));

      final [now, oneMissing] = [
        for (final r in adapter.requests) r.uri.queryParametersAll,
      ];
      // An int, although the schema says boolean (docs/TANDOOR_API.md).
      expect(now['makenow'], ['0']);
      expect(now['books_or'], ['4', '7']);
      expect(now['createdby'], ['2']);
      expect(oneMissing['makenow'], ['1']);
      expect(oneMissing.containsKey('books_or'), isFalse);
      expect(oneMissing.containsKey('createdby'), isFalse);
    });

    test('sends the chosen sort order', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(tandoorFixture('recipe_list.json')),
      );
      final repository = TandoorRecipeRepository(client(adapter));

      await repository.search(const RecipeQuery(sort: RecipeSort.rating));
      await repository.search(const RecipeQuery(sort: RecipeSort.random));
      await repository.search(
        const RecipeQuery(text: 'Suppe', sort: RecipeSort.relevance),
      );
      await repository.search(const RecipeQuery(text: 'Suppe'));

      final [rating, random, relevance, byDefault] = [
        for (final r in adapter.requests) r.uri.queryParameters,
      ];
      expect(rating['sort_order'], '-rating');
      expect(rating.containsKey('random'), isFalse);
      expect(random['random'], 'true');
      expect(random.containsKey('sort_order'), isFalse);
      for (final params in [relevance, byDefault]) {
        expect(params.containsKey('sort_order'), isFalse);
        expect(params.containsKey('random'), isFalse);
      }
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

    group('saved search of a dynamic book', () {
      final recipeList = tandoorFixture('recipe_list.json')! as Map;
      final overviews = [
        for (final r in recipeList['results'] as List) r as Map,
      ];

      Map<String, Object?> book(String? search) => {
        ...(tandoorFixture('recipe_book_list.json')! as Map)['results'].single
            as Map<String, dynamic>,
        'id': 5,
        'filter': search == null
            ? null
            : {
                'id': 3,
                'name': 'Gespeichert',
                'search': search,
                'shared': <Object>[],
                'created_by': 2,
              },
      };

      /// Answers the book with [search] and every recipe search with the
      /// fixture, or with [all] when the request asks for 100 at once.
      FakeHttpAdapter tandoor(String? search, {List<int> all = const []}) =>
          FakeHttpAdapter((request) {
            if (request.uri.path.endsWith('/recipe-book/5/')) {
              return jsonResponse(book(search));
            }
            if (request.uri.queryParameters['sort_order'] == 'created_at') {
              return jsonResponse({
                'count': all.length,
                'next': null,
                'previous': null,
                'results': [
                  for (final o in overviews)
                    if (all.contains(o['id'])) o,
                ],
              });
            }
            return jsonResponse(recipeList);
          });

      List<Map<String, List<String>>> recipeSearches(FakeHttpAdapter a) => [
        for (final r in a.requests)
          if (r.uri.path.endsWith('/api/recipe/')) r.uri.queryParametersAll,
      ];

      test('is sent with the other filters, without its order', () async {
        final adapter = tandoor(
          '{"keywords_or":[1,2],"rating_lte":4,"makenow":true,"query":"",'
          '"units":[{"id":6,"name":"g"}],'
          '"sort_order":"-rating","new":true,"version":"2"}',
        );

        final page = await TandoorRecipeRepository(client(adapter)).search(
          const RecipeQuery(
            savedSearchOfBook: 5,
            foodIds: {9},
            minRating: 2,
            sort: RecipeSort.name,
          ),
        );

        final query = recipeSearches(adapter).single;
        expect(query['keywords_or'], ['1', '2']);
        // Both bounds apply.
        expect(query['rating_gte'], ['2']);
        expect(query['rating_lte'], ['4']);
        expect(query['makenow'], ['true']);
        expect(query['units'], ['6']);
        expect(query['foods_and'], ['9']);
        expect(query['sort_order'], isNot(contains('-rating')));
        expect(query.keys, isNot(contains('new')));
        expect(query.keys, isNot(contains('version')));
        expect(query.keys, isNot(contains('query')));
        expect(query.keys, isNot(contains('books_or')));
        expect(page.items, hasLength(3));
        expect(page.totalCount, 25);
      });

      test(
        'keeps what the whole saved search finds when a parameter clashes',
        () async {
          final adapter = tandoor('{"keywords_or":[1]}', all: [58, 67]);
          final repository = TandoorRecipeRepository(client(adapter));

          final first = await repository.search(
            const RecipeQuery(savedSearchOfBook: 5, anyKeywordIds: {4}),
            pageSize: 3,
          );
          final second = await repository.search(
            const RecipeQuery(savedSearchOfBook: 5, anyKeywordIds: {4}),
            page: 2,
            pageSize: 3,
          );

          final [ours, all, ours2] = recipeSearches(adapter);
          // Ours wins in the request; the saved search's alone gives the ids.
          expect(ours['keywords_or'], ['4']);
          expect(all['keywords_or'], ['1']);
          expect(ours2['page'], ['2']);
          expect([for (final r in first.items) r.id], [58, 67]);
          expect(first.hasMore, isTrue);
          expect(first.totalCount, 2);
          expect(second.items, hasLength(2));
          // The later page reuses the book and the ids.
          expect(adapter.requests, hasLength(4));
        },
      );

      test('loads every page of the ids it finds', () async {
        final adapter = FakeHttpAdapter((request) {
          if (request.uri.path.endsWith('/recipe-book/5/')) {
            return jsonResponse(book('{"keywords_or":[1]}'));
          }
          final params = request.uri.queryParameters;
          if (params['sort_order'] == 'created_at') {
            final page = int.parse(params['page']!);
            return jsonResponse({
              'count': 250,
              'next': page < 3 ? 'next' : null,
              'previous': null,
              // Page 2 holds one of the recipes the search below finds.
              'results': [
                {...overviews[0], 'id': page == 2 ? 72 : 1000 + page},
              ],
            });
          }
          return jsonResponse(recipeList);
        });

        final page = await TandoorRecipeRepository(
          client(adapter),
        ).search(const RecipeQuery(savedSearchOfBook: 5, anyKeywordIds: {4}));

        expect([for (final r in page.items) r.id], [72]);
        expect(
          [
            for (final r in adapter.requests)
              if (r.uri.queryParameters['sort_order'] == 'created_at')
                r.uri.queryParameters['page'],
          ]..sort(),
          ['1', '2', '3'],
        );
      });

      test('is checked by itself when it changes child matching', () async {
        final adapter = tandoor(
          '{"foods_or":[3],"include_children":false}',
          all: [72],
        );

        final page = await TandoorRecipeRepository(client(adapter))
            .search(const RecipeQuery(savedSearchOfBook: 5, foodIds: {9}));

        final [ours, all] = recipeSearches(adapter);
        expect(ours['foods_or'], ['3']);
        expect(ours.keys, isNot(contains('include_children')));
        expect(all['include_children'], ['false']);
        expect([for (final r in page.items) r.id], [72]);
      });

      test('is not checked by itself for the default child matching', () async {
        final adapter = tandoor('{"foods_or":[3],"include_children":true}');

        final page = await TandoorRecipeRepository(client(adapter))
            .search(const RecipeQuery(savedSearchOfBook: 5, foodIds: {9}));

        expect(recipeSearches(adapter), hasLength(1));
        expect(page.items, hasLength(3));
      });

      test('is checked by itself without the interceptor', () async {
        final adapter = tandoor('{"keywords_or":[1]}', all: [67]);
        // A Dio that doesn't send the saved search.
        final bare = api.TandoorApi(
          dio: Dio(BaseOptions(baseUrl: serverUrl.toString()))
            ..httpClientAdapter = adapter,
          interceptors: const [],
        ).getApiApi();

        final page = await TandoorRecipeRepository(bare)
            .search(const RecipeQuery(savedSearchOfBook: 5));

        expect([for (final r in page.items) r.id], [67]);
      });

      test(
        'finds nothing for a book without one, or without the book',
        () async {
          final none = tandoor(null);
          final gone = FakeHttpAdapter(
            (_) => jsonResponse({'detail': 'Not found.'}, status: 404),
          );
          // Objects without an id, which Tandoor can't use either.
          final unreadable = tandoor('{"keywords_or":[{"name":"x"}]}');

          for (final adapter in [none, gone, unreadable]) {
            final page = await TandoorRecipeRepository(client(adapter))
                .search(const RecipeQuery(savedSearchOfBook: 5));

            expect(page.items, isEmpty);
            expect(page.hasMore, isFalse);
            expect(recipeSearches(adapter), isEmpty);
          }
        },
      );

      test('sees a clash under the name Tandoor reads first', () async {
        // `keywords` counts only without `keywords_or`.
        final adapter = tandoor(
          '{"keywords":[1],"foods":[2],"foods_or":[3]}',
          all: [58],
        );

        final page = await TandoorRecipeRepository(
          client(adapter),
        ).search(const RecipeQuery(savedSearchOfBook: 5, anyKeywordIds: {4}));

        final [ours, all] = recipeSearches(adapter);
        expect(ours['keywords_or'], ['4']);
        expect(ours['foods_or'], ['3']);
        expect(ours.keys, isNot(contains('keywords')));
        expect(ours.keys, isNot(contains('foods')));
        expect(all['keywords_or'], ['1']);
        expect([for (final r in page.items) r.id], [58]);
      });

      test('a cancelled search stops waiting for shared ids', () async {
        final ids = Completer<ResponseBody>();
        final adapter = FakeHttpAdapter((request) {
          if (request.uri.path.endsWith('/recipe-book/5/')) {
            return jsonResponse(book('{"keywords_or":[1]}'));
          }
          if (request.uri.queryParameters['sort_order'] == 'created_at') {
            return ids.future;
          }
          return jsonResponse(recipeList);
        });
        final repository = TandoorRecipeRepository(client(adapter));
        const query = RecipeQuery(savedSearchOfBook: 5, anyKeywordIds: {4});
        final cancel = CancelSignal();

        final cancelled = repository.search(query, cancel: cancel);
        final other = repository.search(query);
        await pumpEventQueue();
        cancel.cancel();

        await expectLater(cancelled, throwsA(isA<CancelledFailure>()));
        ids.complete(
          jsonResponse({
            'count': 1,
            'next': null,
            'previous': null,
            'results': [overviews.first],
          }),
        );
        expect([for (final r in (await other).items) r.id], [58]);
        // One load of the book and the ids for both.
        expect(
          [
            for (final r in adapter.requests)
              if (r.uri.path.endsWith('/recipe-book/5/') ||
                  r.uri.queryParameters['sort_order'] == 'created_at')
                r.uri.path,
          ],
          ['/tandoor/api/recipe-book/5/', '/tandoor/api/recipe/'],
        );
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

    test('records a view of a recipe', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'id': 1, 'recipe': 58}, status: 201),
      );

      await TandoorRecipeRepository(client(adapter)).recordView(58);

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/tandoor/api/view-log/');
      expect(request.data, {'recipe': 58});
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

  test('TandoorBookRepository reads every page of books', () async {
    final book =
        (tandoorFixture('recipe_book_list.json')! as Map)['results'].single
            as Map<String, dynamic>;
    final adapter = FakeHttpAdapter(
      (request) => jsonResponse({
        'count': 2,
        'next': request.uri.queryParameters['page'] == '1'
            ? '$serverUrl/api/recipe-book/?page=2'
            : null,
        'previous': null,
        'results': [
          if (request.uri.queryParameters['page'] == '1')
            book
          else
            {...book, 'id': 9, 'name': "Ben's baking"},
        ],
      }),
    );

    final books = await TandoorBookRepository(client(adapter)).books();

    expect(books, const [
      RecipeBook(id: 1, name: 'Unsere Lieblingsrezepte'),
      RecipeBook(id: 9, name: "Ben's baking"),
    ]);
    expect(
      [for (final r in adapter.requests) r.uri.path],
      ['/tandoor/api/recipe-book/', '/tandoor/api/recipe-book/'],
    );
  });

  test('TandoorUserRepository lists the space members', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonResponse(tandoorFixture('user_list.json')),
    );

    final users = await TandoorUserRepository(client(adapter)).users();

    expect(adapter.requests.single.uri.path, '/tandoor/api/user/');
    expect(users, const [
      UserRef(id: 1, name: 'Admin'),
      UserRef(id: 2, name: 'Anna'),
      UserRef(id: 3, name: 'Ben'),
    ]);
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

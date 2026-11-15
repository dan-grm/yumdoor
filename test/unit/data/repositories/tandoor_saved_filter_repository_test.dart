import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_saved_filter_repository.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';

import '../../../fakes/fake_http_adapter.dart';
import '../../../fixtures/tandoor_fixtures.dart';

// Saved searches against canned responses. Behavior against a real Tandoor
// is in test/integration/saved_filter_repository_test.dart.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  api.ApiApi client(FakeHttpAdapter adapter) => api.TandoorApi(
    dio: createTandoorDio(serverUrl, token: 'tda_test')
      ..httpClientAdapter = adapter,
    interceptors: const [],
  ).getApiApi();

  Map<String, Object?> filter(
    int id,
    String name,
    String search, {
    int createdBy = 2,
  }) => {
    'id': id,
    'name': name,
    'search': search,
    'shared': <Object>[],
    'created_by': createdBy,
  };

  Map<String, Object?> page(List<Object?> results, {bool next = false}) => {
    'count': results.length,
    'next': next ? 'next' : null,
    'previous': null,
    'results': results,
  };

  /// The current user is Anna (2); [filters] are the pages of
  /// `/api/custom-filter/`.
  FakeHttpAdapter tandoor(
    List<List<Map<String, Object?>>> filters, {
    ResponseBodyFor? other,
  }) => FakeHttpAdapter((request) {
    final path = request.uri.path;
    if (path.endsWith('/api/user-preference/')) {
      return jsonResponse([
        {
          'user': {'id': 2, 'username': 'anna', 'display_name': 'Anna '},
        },
      ]);
    }
    if (path.endsWith('/api/custom-filter/') && request.method == 'GET') {
      final number = int.parse(request.uri.queryParameters['page'] ?? '1');
      return jsonResponse(
        page(filters[number - 1], next: number < filters.length),
      );
    }
    return other?.call(request) ?? jsonResponse({'detail': 'x'}, status: 404);
  });

  group('TandoorSavedFilterRepository', () {
    test('lists every page by name, telling own from shared', () async {
      final adapter = tandoor([
        [
          filter(1, 'Zum Wochenende', '{"keywords_and":[3]}'),
          filter(2, 'bens Kuchen', '{"query":"Kuchen"}', createdBy: 3),
        ],
        [filter(3, 'Selten gekocht', '{"timescooked_lte":2}')],
      ]);

      final filters = await TandoorSavedFilterRepository(client(adapter))
          .savedFilters();

      expect(
        [for (final f in filters) f.name],
        ['bens Kuchen', 'Selten gekocht', 'Zum Wochenende'],
      );
      expect([for (final f in filters) f.own], [false, true, true]);
      expect(filters[0].query, const RecipeQuery(text: 'Kuchen'));
      expect(filters[1].query, isNull);
      expect(filters[2].query, const RecipeQuery(keywordIds: {3}));
      final lists = [
        for (final r in adapter.requests)
          if (r.uri.path.endsWith('/api/custom-filter/')) r,
      ];
      expect(
        [for (final r in lists) r.uri.queryParameters['page']],
        ['1', '2'],
      );
    });

    test('creates one with the search as Tandoor saves it', () async {
      final adapter = tandoor(
        const [],
        other: (request) => jsonResponse(
          filter(
            7,
            (request.data as Map)['name'] as String,
            (request.data as Map)['search'] as String,
          ),
          status: 201,
        ),
      );

      final saved = await TandoorSavedFilterRepository(client(adapter)).create(
        ' Suppen ',
        const RecipeQuery(text: 'Suppe', minRating: 4, sort: RecipeSort.name),
      );

      final post = adapter.requests.singleWhere((r) => r.method == 'POST');
      expect(post.uri.path, endsWith('/api/custom-filter/'));
      final body = post.data as Map;
      expect(body['name'], 'Suppen');
      expect(jsonDecode(body['search'] as String), {
        'query': 'Suppe',
        'rating_gte': 4,
        'sort_order': 'name',
        'version': '2',
      });
      expect(saved.id, 7);
      expect(saved.own, isTrue);
      expect(
        saved.query,
        const RecipeQuery(text: 'Suppe', minRating: 4, sort: RecipeSort.name),
      );
    });

    test('renames with a PATCH of the name only', () async {
      final adapter = tandoor(
        const [],
        other: (request) =>
            jsonResponse(filter(7, 'Neu', '{"keywords_and":[3]}')),
      );

      final renamed = await TandoorSavedFilterRepository(client(adapter))
          .rename(7, ' Neu ');

      final patch = adapter.requests.singleWhere((r) => r.method == 'PATCH');
      expect(patch.uri.path, endsWith('/api/custom-filter/7/'));
      expect(patch.data, {'name': 'Neu'});
      expect(renamed.name, 'Neu');
    });

    test('deletes one', () async {
      final adapter = tandoor(
        const [],
        other: (request) => jsonResponse(null, status: 204),
      );

      await TandoorSavedFilterRepository(client(adapter)).delete(7);

      final delete = adapter.requests.single;
      expect(delete.method, 'DELETE');
      expect(delete.uri.path, endsWith('/api/custom-filter/7/'));
    });

    test('maps 403 for someone else\'s saved search', () {
      final adapter = tandoor(
        const [],
        other: (_) => jsonResponse({'detail': 'nope'}, status: 403),
      );

      expect(
        TandoorSavedFilterRepository(client(adapter)).delete(7),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });

  group('TandoorRecipeRepository with a saved filter', () {
    final recipeList = tandoorFixture('recipe_list.json')! as Map;
    final overviews = [for (final r in recipeList['results'] as List) r as Map];

    /// Answers the saved filters, the book 5 with [bookSearch], every
    /// recipe search with the fixture, or with [all] when the request asks
    /// for 100 by creation.
    FakeHttpAdapter server(
      List<Map<String, Object?>> filters, {
      String? bookSearch,
      List<int> all = const [],
    }) => tandoor(
      [filters],
      other: (request) {
        if (request.uri.path.endsWith('/recipe-book/5/')) {
          return jsonResponse({
            ...(tandoorFixture('recipe_book_list.json')! as Map)['results']
                    .single
                as Map<String, dynamic>,
            'id': 5,
            'filter': {
              'id': 9,
              'name': 'Buch',
              'search': bookSearch,
              'shared': <Object>[],
              'created_by': 2,
            },
          });
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
      },
    );

    List<Map<String, List<String>>> recipeSearches(FakeHttpAdapter a) => [
      for (final r in a.requests)
        if (r.uri.path.endsWith('/api/recipe/')) r.uri.queryParametersAll,
    ];

    test('sends its parameters with the others, read from the list', () async {
      final adapter = server([
        filter(3, 'Selten', '{"timescooked_lte":2,"units":[6],"version":"2"}'),
      ]);

      final page = await TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(savedFilter: 3, text: 'Suppe'));

      final query = recipeSearches(adapter).single;
      expect(query['timescooked_lte'], ['2']);
      expect(query['units'], ['6']);
      expect(query['query'], ['Suppe']);
      expect(query.keys, isNot(contains('filter')));
      // Not asked for by id: Tandoor answers 403 to those it is shared with.
      expect(
        adapter.requests.where((r) => r.uri.path.contains('custom-filter/3')),
        isEmpty,
      );
      expect(page.items, hasLength(3));
    });

    test('sends an exact value and its range of its own together', () async {
      final adapter = server([
        filter(3, 'Nie', '{"timescooked":0,"timescooked_gte":1}'),
      ]);

      await TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(savedFilter: 3));

      // Tandoor lets the exact value win; nothing to check by ids.
      final query = recipeSearches(adapter).single;
      expect(query['timescooked'], ['0']);
      expect(query['timescooked_gte'], ['1']);
    });

    test('finds nothing when it is gone', () async {
      final adapter = server([filter(4, 'Andere', '{"units":[6]}')]);

      final page = await TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(savedFilter: 3));

      expect(page.items, isEmpty);
      expect(recipeSearches(adapter), isEmpty);
    });

    test('keeps what it finds by itself when it clashes with ours', () async {
      final adapter = server(
        [filter(3, 'Suppen', '{"query":"Suppe"}')],
        all: [58],
      );

      final page = await TandoorRecipeRepository(client(adapter))
          .search(const RecipeQuery(savedFilter: 3, text: 'Karotte'));

      final [ours, all] = recipeSearches(adapter);
      expect(ours['query'], ['Karotte']);
      expect(all['query'], ['Suppe']);
      expect([for (final r in page.items) r.id], [58]);
    });

    test(
      'is checked by itself when it clashes with a book\'s saved search',
      () async {
        final adapter = server(
          [filter(3, 'Ab 4', '{"keywords_or":[1]}')],
          bookSearch: '{"keywords_or":[2]}',
          all: [58, 67],
        );

        final page = await TandoorRecipeRepository(client(adapter))
            .search(const RecipeQuery(savedFilter: 3, savedSearchOfBook: 5));

        final [ours, ids] = recipeSearches(adapter);
        // The book's goes with ours, the filter's alone gives the ids.
        expect(ours['keywords_or'], ['2']);
        expect(ids['keywords_or'], ['1']);
        expect([for (final r in page.items) r.id], [58, 67]);
      },
    );
  });
}

typedef ResponseBodyFor = ResponseBody Function(RequestOptions request);

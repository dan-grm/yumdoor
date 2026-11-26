import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_cook_log_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';

import '../../../fakes/fake_http_adapter.dart';
import '../../../fixtures/tandoor_fixtures.dart';

// The cook log repository against canned responses. Behavior against a real
// Tandoor is in test/integration/cook_log_repository_test.dart.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  api.ApiApi client(FakeHttpAdapter adapter) => api.TandoorApi(
    dio: createTandoorDio(serverUrl, token: 'tda_test')
      ..httpClientAdapter = adapter,
    interceptors: const [],
  ).getApiApi();

  Map<String, Object?> user(int id, String name) => {
    'id': id,
    'username': name.toLowerCase(),
    'display_name': '$name ',
  };

  Map<String, Object?> entry(int id, int userId, String createdAt) => {
    'id': id,
    'recipe': 7,
    'servings': 2,
    'rating': null,
    'comment': null,
    'created_by': user(userId, 'User $userId'),
    'created_at': createdAt,
  };

  /// The current user is Anna (2). [pages] are the recipe's cook log pages,
  /// oldest first, as the server sends them.
  FakeHttpAdapter cookLogServer(List<List<Map<String, Object?>>> pages) {
    final count = pages.fold(0, (sum, page) => sum + page.length);
    return FakeHttpAdapter((request) {
      final path = request.uri.path;
      if (path.endsWith('/api/user-preference/')) {
        return jsonResponse([
          {'user': user(2, 'Anna')},
        ]);
      }
      if (path.endsWith('/api/cook-log/')) {
        final page = int.parse(request.uri.queryParameters['page'] ?? '1');
        if (page > pages.length && page > 1) {
          return jsonResponse({'detail': 'Invalid page.'}, status: 404);
        }
        return jsonResponse({
          'count': count,
          'next': page < pages.length ? 'next' : null,
          'previous': null,
          'results': pages.isEmpty ? [] : pages[page - 1],
        });
      }
      return jsonResponse({'detail': 'Not found.'}, status: 404);
    });
  }

  group('create', () {
    test('posts the entry and returns the saved one', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(
          (tandoorFixture('cook_log_list.json')! as Map)['results'][2],
          status: 201,
        ),
      );

      final saved = await TandoorCookLogRepository(client(adapter)).create(
        NewCookLog(recipeId: 25, servings: 2, rating: 2, comment: ' Lecker '),
      );

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/tandoor/api/cook-log/');
      expect(request.data, {
        'recipe': 25,
        'servings': 2,
        'rating': 2,
        'comment': 'Lecker',
      });
      expect(saved.id, 3);
      expect(saved.recipeId, 25);
    });

    test('throws a ServerFailure when the server rejects it', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'recipe': ['Invalid pk'],
        }, status: 400),
      );

      expect(
        TandoorCookLogRepository(client(adapter))
            .create(NewCookLog(recipeId: 99, servings: 1)),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('throws an OfflineFailure without a connection', () {
      final adapter = FakeHttpAdapter(
        (request) => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
      );

      expect(
        TandoorCookLogRepository(client(adapter))
            .create(NewCookLog(recipeId: 7, servings: 1)),
        throwsA(isA<OfflineFailure>()),
      );
    });
  });

  test('delete sends a DELETE for the entry', () async {
    final adapter = FakeHttpAdapter((_) => ResponseBody.fromString('', 204));

    await TandoorCookLogRepository(client(adapter)).delete(33);

    final request = adapter.requests.single;
    expect(request.method, 'DELETE');
    expect(request.uri.path, '/tandoor/api/cook-log/33/');
  });

  group('lastCooked', () {
    test('is the current user\'s newest entry for the recipe', () async {
      final adapter = cookLogServer([
        [
          entry(1, 2, '2026-10-01T19:00:00Z'),
          // `created_at` can be set, so it isn't in id order.
          entry(2, 2, '2026-11-02T19:00:00Z'),
          entry(3, 2, '2026-10-20T19:00:00Z'),
          // Ben's is newer, but not Anna's.
          entry(4, 3, '2026-11-10T19:00:00Z'),
        ],
      ]);

      final repository = TandoorCookLogRepository(client(adapter));
      expect(await repository.lastCooked(7), DateTime.utc(2026, 11, 2, 19));

      final list = adapter.requests.last.uri.queryParameters;
      expect(list['recipe'], '7');
      // The user is looked up once.
      await repository.lastCooked(7);
      expect(
        adapter.requests.where(
          (r) => r.uri.path.endsWith('/api/user-preference/'),
        ),
        hasLength(1),
      );
    });

    test('is null if the user never cooked it', () async {
      final adapter = cookLogServer([
        [entry(1, 3, '2026-10-01T19:00:00Z')],
      ]);

      expect(
        await TandoorCookLogRepository(client(adapter)).lastCooked(7),
        isNull,
      );
    });

    test('is null for a recipe without entries', () async {
      final adapter = cookLogServer([]);

      expect(
        await TandoorCookLogRepository(client(adapter)).lastCooked(7),
        isNull,
      );
    });

    test('reads the newest pages first', () async {
      final adapter = cookLogServer([
        [
          for (var id = 1; id <= 100; id++)
            entry(id, 2, '2026-01-01T19:00:00Z'),
        ],
        [
          for (var id = 101; id <= 200; id++)
            entry(id, 2, '2026-06-01T19:00:00Z'),
        ],
        [entry(201, 3, '2026-11-01T19:00:00Z')],
      ]);

      expect(
        await TandoorCookLogRepository(client(adapter)).lastCooked(7),
        DateTime.utc(2026, 6, 1, 19),
      );
      final pages = [
        for (final request in adapter.requests)
          if (request.uri.path.endsWith('/api/cook-log/'))
            request.uri.queryParameters['page'],
      ];
      expect(pages, ['1', '3', '2']);
    });
  });

  group('recent', () {
    /// A recorded entry of the space's cook log ([tandoorFixture]) with
    /// [id], [recipe] and [createdAt]; [byBen] switches the author.
    Map<String, Object?> logEntry(
      int id,
      int recipe,
      String createdAt, {
      bool byBen = false,
    }) {
      final results =
          (tandoorFixture('cook_log_list.json')! as Map)['results'] as List;
      return Map<String, Object?>.from(results[byBen ? 1 : 0] as Map)
        ..['id'] = id
        ..['recipe'] = recipe
        ..['created_at'] = createdAt;
    }

    /// The recorded recipes, by their ids. 66 is someone else's private
    /// recipe, 77 one the server fails to send; any other id is gone.
    const recipeFixtures = {
      58: 'recipe_apfelkuchen.json',
      51: 'recipe_karottensuppe.json',
    };

    /// [pages] are the space's cook log pages, oldest first, 100 entries
    /// each as the repository asks for. [count] is what the server says, if
    /// it changed between requests.
    FakeHttpAdapter spaceServer(
      List<List<Map<String, Object?>>> pages, {
      int? count,
    }) {
      count ??= pages.fold<int>(0, (sum, page) => sum + page.length);
      return FakeHttpAdapter((request) {
        final path = request.uri.path;
        if (path.endsWith('/api/cook-log/')) {
          final query = request.uri.queryParameters;
          expect(query['page_size'], '100');
          expect(query, isNot(contains('recipe')));
          final page = int.parse(query['page'] ?? '1');
          if (page > pages.length && page > 1) {
            return jsonResponse({'detail': 'Invalid page.'}, status: 404);
          }
          return jsonResponse({
            'count': count,
            'next': page < pages.length ? 'next' : null,
            'previous': null,
            'results': pages.isEmpty ? [] : pages[page - 1],
          });
        }
        final recipe = RegExp(r'/api/recipe/(\d+)/$').firstMatch(path);
        if (recipe != null) {
          final id = int.parse(recipe[1]!);
          if (id == 66) {
            return jsonResponse({
              'detail': 'You do not have permission to perform this action.',
            }, status: 403);
          }
          if (id == 77) return jsonResponse('Server Error', status: 500);
          if (recipeFixtures[id] case final fixture?) {
            return jsonResponse(tandoorFixture(fixture));
          }
        }
        return jsonResponse({'detail': 'Not found.'}, status: 404);
      });
    }

    List<String?> cookLogPages(FakeHttpAdapter adapter) => [
      for (final request in adapter.requests)
        if (request.uri.path.endsWith('/api/cook-log/'))
          request.uri.queryParameters['page'],
    ];

    List<String> recipeRequests(FakeHttpAdapter adapter) => [
      for (final request in adapter.requests)
        if (request.uri.path.contains('/api/recipe/')) request.uri.path,
    ];

    test('is newest first, with recipe and author', () async {
      final adapter = spaceServer([
        [
          logEntry(1, 58, '2026-10-01T19:00:00Z'),
          // `created_at` can be set, so it isn't in id order.
          logEntry(2, 51, '2026-11-02T19:00:00Z', byBen: true),
          logEntry(3, 58, '2026-10-20T19:00:00Z', byBen: true),
        ],
      ]);

      final recent = await TandoorCookLogRepository(client(adapter)).recent();

      expect([for (final r in recent) r.entry.id], [2, 3, 1]);
      final newest = recent.first;
      expect(newest.recipe.id, 51);
      expect(newest.recipe.name, 'Karottensuppe mit Ingwer');
      expect(newest.entry.createdBy?.name, 'Ben');
      expect(newest.entry.createdAt, DateTime.utc(2026, 11, 2, 19));
      expect(recent[1].recipe.name, 'Apfelkuchen vom Blech');
      expect(recent[2].entry.createdBy?.name, 'Anna');
      // Each recipe is loaded once.
      expect(recipeRequests(adapter), hasLength(2));
    });

    test('reads pages from the newest and stops at the limit', () async {
      final adapter = spaceServer([
        [
          for (var id = 1; id <= 100; id++)
            logEntry(id, 58, '2026-01-01T19:00:00Z'),
        ],
        [
          for (var id = 101; id <= 200; id++)
            logEntry(id, 58, '2026-06-01T19:00:00Z'),
        ],
        [
          logEntry(201, 51, '2026-11-01T19:00:00Z'),
          logEntry(202, 58, '2026-11-02T19:00:00Z'),
        ],
      ]);

      final recent = await TandoorCookLogRepository(client(adapter))
          .recent(limit: 4);

      // Equal dates go by id, newest first.
      expect([for (final r in recent) r.entry.id], [202, 201, 200, 199]);
      // Page 1 for the count, then from the end; page 2 has enough.
      expect(cookLogPages(adapter), ['1', '3', '2']);
      expect(recipeRequests(adapter), hasLength(2));
    });

    test('leaves out entries from before since', () async {
      String october(int day) => '2026-10-${'$day'.padLeft(2, '0')}T19:00:00Z';
      final adapter = spaceServer([
        [
          for (var id = 1; id <= 100; id++)
            logEntry(id, 58, '2026-01-01T19:00:00Z'),
        ],
        [
          for (var id = 101; id <= 200; id++)
            logEntry(id, 58, october(id % 28 + 1)),
        ],
        [logEntry(201, 51, '2026-11-20T19:00:00Z')],
      ]);

      final since = DateTime.utc(2026, 10, 27);
      final recent = await TandoorCookLogRepository(client(adapter))
          .recent(since: since);

      // 201, and the four entries each of October 27 and 28.
      expect(recent.first.entry.id, 201);
      expect(recent, hasLength(9));
      expect(recent.every((r) => !r.entry.createdAt.isBefore(since)), isTrue);
      // Page 2 reaches before since, so page 1 isn't read again.
      expect(cookLogPages(adapter), ['1', '3', '2']);
    });

    test('skips entries whose recipe is gone or private', () async {
      final adapter = spaceServer([
        [
          logEntry(1, 58, '2026-11-01T19:00:00Z'),
          logEntry(2, 66, '2026-11-02T19:00:00Z', byBen: true),
          logEntry(3, 99, '2026-11-03T19:00:00Z'),
          logEntry(4, 51, '2026-11-04T19:00:00Z', byBen: true),
          logEntry(5, 66, '2026-11-05T19:00:00Z', byBen: true),
        ],
      ]);

      final recent = await TandoorCookLogRepository(client(adapter))
          .recent(limit: 2);

      expect([for (final r in recent) r.entry.id], [4, 1]);
      // 66 is asked for once, although two entries need it.
      expect(
        recipeRequests(adapter).where((p) => p.endsWith('/66/')),
        hasLength(1),
      );
    });

    test('uses stored recipes instead of fetching them', () async {
      final adapter = spaceServer([
        [
          logEntry(1, 58, '2026-11-01T19:00:00Z'),
          logEntry(2, 51, '2026-11-02T19:00:00Z'),
        ],
      ]);
      const stored = RecipeSummary(id: 58, name: 'Apfelkuchen (gespeichert)');

      final recent = await TandoorCookLogRepository(
        client(adapter),
        storedRecipe: (id) async => id == 58 ? stored : null,
      ).recent();

      expect(recent.last.recipe, stored);
      expect(recipeRequests(adapter), ['/tandoor/api/recipe/51/']);
    });

    test('reads at most the five newest pages, without a gap', () async {
      final adapter = spaceServer([
        for (var page = 0; page < 7; page++)
          [
            for (var id = 1; id <= 100; id++)
              logEntry(page * 100 + id, 66, '2026-06-01T19:00:00Z'),
          ],
      ]);
      final repository = TandoorCookLogRepository(client(adapter));

      expect(await repository.recent(), isEmpty);
      // Page 1 for the count, then 7 to 3; not page 1 after a gap.
      expect(cookLogPages(adapter), ['1', '7', '6', '5', '4', '3']);

      // The private recipe isn't asked for again.
      await repository.recent();
      expect(recipeRequests(adapter), hasLength(1));
    });

    test('skips an entry whose recipe the server fails to send', () async {
      final adapter = spaceServer([
        [
          logEntry(1, 58, '2026-11-01T19:00:00Z'),
          logEntry(2, 77, '2026-11-02T19:00:00Z'),
        ],
      ]);

      final recent = await TandoorCookLogRepository(client(adapter)).recent();

      expect([for (final r in recent) r.entry.id], [1]);
    });

    test('copes with entries deleted or added between requests', () async {
      final page = [
        for (var id = 1; id <= 100; id++)
          logEntry(id, 58, '2026-06-01T19:00:00Z'),
      ];
      // Page 1 counted 301 entries, so a fourth page, deleted since.
      final deleted = spaceServer([page, page, page], count: 301);
      expect(
        await TandoorCookLogRepository(client(deleted)).recent(limit: 3),
        hasLength(3),
      );
      expect(cookLogPages(deleted), ['1', '4', '3']);

      // Page 1 counted 200, so two pages; a third one was added since. The
      // pages overlap, as a deletion moves entries between them.
      final added = spaceServer([
        page,
        page,
        [
          logEntry(100, 58, '2026-06-01T19:00:00Z'),
          logEntry(201, 51, '2026-11-02T19:00:00Z'),
        ],
      ], count: 200);
      final recent = await TandoorCookLogRepository(client(added))
          .recent(limit: 3);
      expect([for (final r in recent) r.entry.id], [201, 100, 99]);
      expect(cookLogPages(added), ['1', '2', '3']);
    });

    test('is empty for an empty cook log or a limit of 0', () async {
      final repository = TandoorCookLogRepository(client(spaceServer([])));

      expect(await repository.recent(), isEmpty);
      expect(await repository.recent(limit: 0), isEmpty);
    });

    test('throws an OfflineFailure without a connection', () {
      final adapter = FakeHttpAdapter(
        (request) => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
      );

      expect(
        TandoorCookLogRepository(client(adapter)).recent(),
        throwsA(isA<OfflineFailure>()),
      );
    });
  });

  group('TandoorRecipeRepository', () {
    FakeHttpAdapter recipeServer() => FakeHttpAdapter(
      (_) => jsonResponse(tandoorFixture('recipe_apfelkuchen.json')),
    );

    test('fills in last cooked from the cook log', () async {
      final repository = TandoorRecipeRepository(
        client(recipeServer()),
        dio: Dio(),
        lastCooked: (id) async => DateTime.utc(2026, 11, 2),
      );

      final recipe = await repository.fetchRecipe(8);

      expect(recipe.lastCooked, DateTime.utc(2026, 11, 2));
    });

    test('shows the recipe if the cook log fails', () async {
      final repository = TandoorRecipeRepository(
        client(recipeServer()),
        dio: Dio(),
        lastCooked: (id) async => throw const ServerFailure(statusCode: 500),
      );

      final recipe = await repository.fetchRecipe(8);

      expect(recipe.lastCooked, isNull);
    });
  });
}

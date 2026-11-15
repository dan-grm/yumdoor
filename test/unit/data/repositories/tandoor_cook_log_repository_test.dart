import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_cook_log_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/domain/models/cook_log.dart';

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

  group('TandoorRecipeRepository', () {
    FakeHttpAdapter recipeServer() => FakeHttpAdapter(
      (_) => jsonResponse(tandoorFixture('recipe_apfelkuchen.json')),
    );

    test('fills in last cooked from the cook log', () async {
      final repository = TandoorRecipeRepository(
        client(recipeServer()),
        lastCooked: (id) async => DateTime.utc(2026, 11, 2),
      );

      final recipe = await repository.fetchRecipe(8);

      expect(recipe.lastCooked, DateTime.utc(2026, 11, 2));
    });

    test('shows the recipe if the cook log fails', () async {
      final repository = TandoorRecipeRepository(
        client(recipeServer()),
        lastCooked: (id) async => throw const ServerFailure(statusCode: 500),
      );

      final recipe = await repository.fetchRecipe(8);

      expect(recipe.lastCooked, isNull);
    });
  });
}

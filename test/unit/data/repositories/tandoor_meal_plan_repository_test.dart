import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_meal_plan_repository.dart';
import 'package:yumdoor/data/repositories/tandoor_meal_type_repository.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';

import '../../../fakes/fake_http_adapter.dart';

// The meal plan and meal type repositories against canned responses.
// Behavior against a real Tandoor is in
// test/integration/meal_plan_repository_test.dart.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  (api.ApiApi, Dio) client(FakeHttpAdapter adapter) {
    final dio = createTandoorDio(serverUrl, token: 'tda_test')
      ..httpClientAdapter = adapter;
    return (api.TandoorApi(dio: dio, interceptors: const []).getApiApi(), dio);
  }

  TandoorMealPlanRepository plans(FakeHttpAdapter adapter) {
    final (apiClient, dio) = client(adapter);
    return TandoorMealPlanRepository(apiClient, dio);
  }

  TandoorMealTypeRepository types(FakeHttpAdapter adapter) =>
      TandoorMealTypeRepository(client(adapter).$1);

  Map<String, Object?> type(int id, String name, {int order = 0}) => {
    'id': id,
    'name': name,
    'order': order,
    'time': null,
    'color': null,
    'created_by': 1,
  };

  /// A plan on [from] to [to] at noon on this device.
  Map<String, Object?> plan(
    int id,
    CalendarDay from, {
    CalendarDay? to,
    Map<String, Object?>? mealType,
  }) => {
    'id': id,
    'title': 'Plan $id',
    'recipe': null,
    'servings': 2.0,
    'note': '',
    'from_date': from
        .atLocalTime(const Duration(hours: 12))
        .toUtc()
        .toIso8601String(),
    'to_date': (to ?? from)
        .atLocalTime(const Duration(hours: 12))
        .toUtc()
        .toIso8601String(),
    'meal_type': mealType ?? type(3, 'Abendessen', order: 2),
    'created_by': 1,
    'shopping': false,
  };

  Map<String, Object?> page(List<Object?> results, {bool more = false}) => {
    'count': results.length,
    'next': more ? 'next' : null,
    'previous': null,
    'results': results,
  };

  final monday = CalendarDay(2026, 11, 16);
  final sunday = CalendarDay(2026, 11, 22);

  group('list', () {
    test('reads every page of a wider range and keeps overlapping plans', () {
      final adapter = FakeHttpAdapter((request) {
        final number = request.uri.queryParameters['page'];
        return jsonResponse(switch (number) {
          '1' => page([
            // Ends on Monday, started the week before.
            plan(1, monday.addDays(-2), to: monday),
            // Ended the day before.
            plan(2, monday.addDays(-1)),
          ], more: true),
          _ => page([
            plan(4, sunday, to: sunday.addDays(3)),
            plan(3, monday.addDays(2)),
            // Starts the day after.
            plan(5, sunday.addDays(1)),
          ]),
        });
      });

      return expectLater(
        plans(adapter).list(monday, sunday).then((list) {
          final query = adapter.requests.first.uri.queryParameters;
          expect(query['from_date'], '2026-11-14');
          expect(query['to_date'], '2026-12-25');
          expect(query['page_size'], '200');
          expect(adapter.requests, hasLength(2));
          return [for (final plan in list) plan.id];
        }),
        completion([1, 3, 4]),
      );
    });

    test('sorts by first day, then meal type, then id', () async {
      final breakfast = type(1, 'Frühstück');
      final dinner = type(3, 'Abendessen', order: 2);
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(
          page([
            plan(9, monday.addDays(1), mealType: breakfast),
            plan(8, monday, mealType: dinner),
            plan(7, monday, mealType: dinner),
            plan(6, monday, mealType: breakfast),
          ]),
        ),
      );

      final list = await plans(adapter).list(monday, sunday);

      expect([for (final plan in list) plan.id], [6, 7, 8, 9]);
    });

    test('maps an error to a failure', () {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'Keine Berechtigung'}, status: 403),
      );

      expect(
        plans(adapter).list(monday, sunday),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });

  test('create posts ids and returns the saved plan', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonResponse(plan(11, monday), status: 201),
    );

    final saved = await plans(adapter).create(
      NewMealPlan(
        recipeId: 140,
        servings: 2,
        day: monday,
        mealType: const MealType(id: 3, name: 'Abendessen'),
      ),
    );

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.uri.path, '/tandoor/api/meal-plan/');
    final body = request.data as Map<String, Object?>;
    expect(body['recipe'], 140);
    expect(body['meal_type'], 3);
    expect(saved.id, 11);
    expect(saved.fromDay, monday);
  });

  test('create moves a plan back that Tandoor put on another day', () async {
    final adapter = FakeHttpAdapter(
      (request) => switch (request.method) {
        'POST' => jsonResponse(plan(11, monday.addDays(1)), status: 201),
        _ => jsonResponse(plan(11, monday)),
      },
    );

    final saved = await plans(adapter).create(
      NewMealPlan(
        title: 'Pizza',
        servings: 2,
        day: monday,
        mealType: const MealType(id: 3, name: 'Abendessen'),
      ),
    );

    final post = adapter.requests.first.data as Map<String, Object?>;
    final patch = adapter.requests.last;
    expect(patch.method, 'PATCH');
    expect(patch.uri.path, '/tandoor/api/meal-plan/11/');
    expect(patch.data, {
      'servings': 2.0,
      'from_date': post['from_date'],
      'to_date': post['to_date'],
    });
    expect(saved.fromDay, monday);
  });

  test('create deletes the plan again if moving it back fails', () async {
    final adapter = FakeHttpAdapter(
      (request) => switch (request.method) {
        'POST' => jsonResponse(plan(11, monday.addDays(1)), status: 201),
        'PATCH' => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
        _ => jsonResponse(null, status: 204),
      },
    );

    await expectLater(
      plans(adapter).create(
        NewMealPlan(
          title: 'Pizza',
          servings: 2,
          day: monday,
          mealType: const MealType(id: 3, name: 'Abendessen'),
        ),
      ),
      throwsA(isA<OfflineFailure>()),
    );
    expect(
      [for (final r in adapter.requests) r.method],
      ['POST', 'PATCH', 'DELETE'],
    );
    expect(adapter.requests.last.uri.path, '/tandoor/api/meal-plan/11/');
  });

  group('update', () {
    test('reads the plan, then patches it', () async {
      final adapter = FakeHttpAdapter(
        (request) => jsonResponse(switch (request.method) {
          'GET' => plan(12, monday, to: monday.addDays(1)),
          _ => plan(12, monday.addDays(2), to: monday.addDays(3)),
        }),
      );

      final saved = await plans(adapter)
          .update(12, MealPlanChanges(day: monday.addDays(2)));

      expect([for (final r in adapter.requests) r.method], ['GET', 'PATCH']);
      final patch = adapter.requests.last;
      expect(patch.uri.path, '/tandoor/api/meal-plan/12/');
      final body = patch.data as Map<String, Object?>;
      expect(body['servings'], 2.0);
      expect(
        DateTime.parse(body['from_date']! as String).toLocal(),
        DateTime(2026, 11, 18, 12),
      );
      expect(
        DateTime.parse(body['to_date']! as String).toLocal(),
        DateTime(2026, 11, 19, 12),
      );
      expect(saved.fromDay, monday.addDays(2));
      expect(saved.toDay, monday.addDays(3));
    });

    test('fails with NotFoundFailure for an unknown plan', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'Not found.'}, status: 404),
      );

      await expectLater(
        plans(adapter).update(99, MealPlanChanges(servings: 3)),
        throwsA(isA<NotFoundFailure>()),
      );
      expect(adapter.requests, hasLength(1));
    });

    test('maps an unexpected response to a ServerFailure', () {
      final adapter = FakeHttpAdapter(
        (request) => jsonResponse(switch (request.method) {
          'GET' => plan(12, monday),
          _ => {'id': 12},
        }),
      );

      expect(
        plans(adapter).update(12, MealPlanChanges(servings: 3)),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  test('delete sends DELETE', () async {
    final adapter = FakeHttpAdapter((_) => jsonResponse(null, status: 204));

    await plans(adapter).delete(12);

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.uri.path, '/tandoor/api/meal-plan/12/');
  });

  group('meal types', () {
    test('list reads every page and sorts by order, then name', () async {
      final adapter = FakeHttpAdapter((request) {
        final number = request.uri.queryParameters['page'];
        return jsonResponse(switch (number) {
          '1' => page([
            type(3, 'Abendessen', order: 2),
            type(2, 'snack', order: 1),
          ], more: true),
          _ => page([type(1, 'Mittagessen', order: 1)]),
        });
      });

      final list = await types(adapter).list();

      expect(
        [for (final t in list) t.name],
        ['Mittagessen', 'snack', 'Abendessen'],
      );
    });

    test('create returns an existing type of that name', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse(page([type(3, 'Abendessen', order: 2)])),
      );

      final created = await types(adapter).create(' abendessen ');

      expect(created.id, 3);
      expect(adapter.requests.single.method, 'GET');
    });

    test('create adds a new type after the others', () async {
      final adapter = FakeHttpAdapter(
        (request) => switch (request.method) {
          'GET' => jsonResponse(
            page([type(1, 'Frühstück'), type(3, 'Abendessen', order: 2)]),
          ),
          _ => jsonResponse(type(4, 'Snack', order: 3), status: 201),
        },
      );

      final created = await types(adapter).create(' Snack ');

      final post = adapter.requests.last;
      expect(post.method, 'POST');
      expect(post.data, containsPair('name', 'Snack'));
      expect(post.data, containsPair('order', 3));
      expect(created, const MealType(id: 4, name: 'Snack', order: 3));
    });

    test('create returns the type someone else created meanwhile', () async {
      var lists = 0;
      final adapter = FakeHttpAdapter(
        (request) => switch (request.method) {
          'GET' => jsonResponse(
            page([if (lists++ > 0) type(4, 'Snack', order: 3)]),
          ),
          _ => htmlResponse('<h1>Server Error (500)</h1>', status: 500),
        },
      );

      final created = await types(adapter).create('snack');

      expect(created.id, 4);
      expect(
        [for (final r in adapter.requests) r.method],
        ['GET', 'POST', 'GET'],
      );
    });

    test('create fails on a server error without a matching type', () {
      final adapter = FakeHttpAdapter(
        (request) => switch (request.method) {
          'GET' => jsonResponse(page([])),
          _ => htmlResponse('<h1>Server Error (500)</h1>', status: 500),
        },
      );

      expect(types(adapter).create('Snack'), throwsA(isA<ServerFailure>()));
    });

    test('create rejects a blank or long name without a request', () {
      final adapter = FakeHttpAdapter((_) => jsonResponse(page([])));

      expect(() => types(adapter).create('  '), throwsArgumentError);
      expect(() => types(adapter).create('x' * 129), throwsArgumentError);
      expect(adapter.requests, isEmpty);
    });
  });
}

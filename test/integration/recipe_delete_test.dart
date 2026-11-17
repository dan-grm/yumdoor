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

/// Deleting a recipe, on recipes the test creates (private, as the admin, so
/// other tests don't see them).
void main() {
  final tandoor = SeededTandoor.load();
  final tag = 'Yumdoor-Test ${DateTime.now().microsecondsSinceEpoch}';
  late Dio dio;
  late TandoorRecipeRepository recipes;

  setUpAll(() {
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
      dio: dio,
    );
  });

  tearDownAll(() => dio.close());

  test('deletes a recipe; it is gone afterwards', () async {
    final recipe = await recipes.createRecipe(
      RecipeDraft(name: '$tag Weg', steps: [const StepDraft()]),
    );

    await recipes.deleteRecipe(recipe.id);

    await expectLater(
      recipes.fetchRecipe(recipe.id),
      throwsA(isA<NotFoundFailure>()),
    );
    await expectLater(
      recipes.deleteRecipe(recipe.id),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('takes its cook log entries and meal plans with it', () async {
    final recipe = await recipes.createRecipe(
      RecipeDraft(name: '$tag Mit Anhang', steps: [const StepDraft()]),
    );
    await dio.post<void>(
      '/api/cook-log/',
      data: {'recipe': recipe.id, 'servings': 2},
    );
    final types = await dio.get<Map<String, dynamic>>('/api/meal-type/');
    final type = (types.data!['results'] as List).first as Map;
    final plan = await dio.post<Map<String, dynamic>>(
      '/api/meal-plan/',
      data: {
        'recipe': {'id': recipe.id, 'name': recipe.name},
        'servings': 2,
        'title': '',
        'from_date': '2030-01-01T12:00:00Z',
        'meal_type': {'id': type['id'], 'name': type['name']},
      },
    );

    await recipes.deleteRecipe(recipe.id);

    final logs = await dio.get<Map<String, dynamic>>(
      '/api/cook-log/',
      queryParameters: {'recipe': recipe.id},
    );
    expect(logs.data!['results'], isEmpty);
    await expectLater(
      dio.get<void>('/api/meal-plan/${plan.data!['id']}/'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      ),
    );
  });
}

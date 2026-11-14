@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  /// Entries the test created, deleted again afterwards.
  final created = <int>[];

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
  });
  tearDown(() async {
    for (final id in created) {
      try {
        await anna.cookLogs.delete(id);
      } on NotFoundFailure {
        // The test deleted it itself.
      }
    }
    created.clear();
    anna.close();
    ben.close();
  });

  Future<int> recipeId(String name) async {
    final page = await anna.recipes.search(RecipeQuery(text: name));
    return page.items.firstWhere((r) => r.name == name).id;
  }

  test('creates an entry with rating and comment, and deletes it', () async {
    final id = await recipeId('Karottensuppe mit Ingwer');
    final before = DateTime.now().subtract(const Duration(minutes: 1));

    final entry = await anna.cookLogs.create(
      NewCookLog(recipeId: id, servings: 3, rating: 5, comment: ' Lecker! '),
    );
    created.add(entry.id);

    expect(entry.recipeId, id);
    expect(entry.servings, 3);
    expect(entry.rating, 5);
    expect(entry.comment, 'Lecker!');
    expect(entry.createdBy?.name, 'Anna');
    expect(entry.createdAt.isAfter(before), isTrue);

    // The recipe now shows it as Anna's last cooking.
    final recipe = await anna.recipes.fetchRecipe(id);
    expect(recipe.lastCooked, entry.createdAt);
    expect(await anna.cookLogs.lastCooked(id), entry.createdAt);
    // Ben's last cooking is his own.
    expect(await ben.cookLogs.lastCooked(id), isNot(entry.createdAt));

    await anna.cookLogs.delete(entry.id);
    expect(anna.cookLogs.delete(entry.id), throwsA(isA<NotFoundFailure>()));
  });

  test('creates an entry without rating or comment', () async {
    final id = await recipeId('Apfelkuchen vom Blech');

    final entry = await anna.cookLogs.create(
      NewCookLog(recipeId: id, servings: 1, comment: '   '),
    );
    created.add(entry.id);

    expect(entry.rating, isNull);
    expect(entry.comment, isNull);
    expect(entry.servings, 1);
  });

  test('the rating counts towards the recipe\'s rating', () async {
    final id = await recipeId('Apfelkuchen vom Blech');
    final before = (await anna.recipes.fetchRecipe(id)).rating;

    final entry = await anna.cookLogs.create(
      NewCookLog(recipeId: id, servings: 1, rating: 1),
    );
    created.add(entry.id);

    // Anna's own average, now with a 1 in it.
    final after = (await anna.recipes.fetchRecipe(id)).rating;
    expect(after, before == null || before == 1 ? 1 : lessThan(before));
  });

  test('only the author may delete an entry', () async {
    final id = await recipeId('Apfelkuchen vom Blech');
    final entry = await anna.cookLogs.create(
      NewCookLog(recipeId: id, servings: 1),
    );
    created.add(entry.id);

    expect(ben.cookLogs.delete(entry.id), throwsA(isA<UnauthorizedFailure>()));
  });
}

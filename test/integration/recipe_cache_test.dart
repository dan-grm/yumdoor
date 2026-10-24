@Tags(['integration'])
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';

import 'seeded_tandoor.dart';

/// Nothing listens here, so connecting fails at once.
final _unreachable = Uri.parse('http://localhost:9');

void main() {
  final tandoor = SeededTandoor.load();
  late CacheDatabase db;
  late RecipeCache cache;

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    cache = RecipeCache(db);
  });
  tearDown(() => db.close());

  TandoorRepositories connect(Uri serverUrl, {List<bool>? reachable}) {
    final repositories = TandoorRepositories(
      TandoorConnection(serverUrl, tandoor.token('anna')),
      cache: cache,
      onReachable: reachable?.add,
    );
    addTearDown(repositories.close);
    return repositories;
  }

  /// Waits for the write-through that `fetchRecipe` does in the background.
  Future<void> untilCached(int id) async {
    for (var i = 0; i < 100 && await cache.get(id) == null; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  test('a recipe opened online is the same offline', () async {
    final online = connect(tandoor.baseUrl);
    final page = await online.recipes.search(const RecipeQuery());
    final id = page.items.first.id;
    final recipe = await online.recipes.fetchRecipe(id);
    await untilCached(id);

    final reachable = <bool>[];
    final offline = connect(_unreachable, reachable: reachable);

    expect(await offline.recipes.fetchRecipe(id), recipe);
    expect(reachable, [false]);
  });

  test('offline search finds opened recipes by name', () async {
    final online = connect(tandoor.baseUrl);
    final page = await online.recipes.search(const RecipeQuery());
    final recipe = await online.recipes.fetchRecipe(page.items.first.id);
    await untilCached(recipe.id);

    final offline = connect(_unreachable);
    final results = await offline.recipes.search(
      RecipeQuery(text: recipe.name.toUpperCase()),
    );

    expect(results.fromCache, isTrue);
    expect([for (final r in results.items) r.id], contains(recipe.id));
  });

  test('a recipe never opened is not there offline', () async {
    final offline = connect(_unreachable);

    await expectLater(
      offline.recipes.fetchRecipe(1),
      throwsA(isA<OfflineFailure>()),
    );
  });
}

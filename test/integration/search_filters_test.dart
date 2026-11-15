@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';

import '../../tool/seed.dart' show TandoorClient;
import '../../tool/seed/data.dart';
import 'seeded_tandoor.dart';

// The cookable, book and creator filters against the seeded Tandoor.
void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
  });
  tearDown(() {
    anna.close();
    ben.close();
  });

  Future<Set<String>> names(
    RecipeQuery query, {
    TandoorRepositories? as,
  }) async {
    final page = await (as ?? anna).recipes.search(query, pageSize: 100);
    expect(page.hasMore, isFalse);
    return {for (final recipe in page.items) recipe.name};
  }

  test('lists the space members', () async {
    final users = await anna.users.users();

    expect(users.map((u) => u.name), containsAll(['Admin', 'Anna', 'Ben']));
  });

  test('filters by creator', () async {
    final users = await anna.users.users();

    for (final user in ['anna', 'ben']) {
      final id = users.singleWhere((u) => u.name.toLowerCase() == user).id;
      final expected = {
        for (final recipe in seedRecipes)
          if (recipe.author == user) recipe.name,
      };
      expect(expected, isNotEmpty);
      expect(await names(RecipeQuery(createdBy: id)), expected, reason: user);
    }
  });

  test('lists own and shared books only', () async {
    final annas = await anna.books.books();
    final bens = await ben.books.books();

    Set<String> visibleTo(String user) => {
      for (final book in seedBooks)
        if (book.owner == user || book.sharedWith.contains(user)) book.name,
    };
    expect(annas.map((b) => b.name).toSet(), visibleTo('anna'));
    expect(bens.map((b) => b.name).toSet(), visibleTo('ben'));
  });

  test('filters by any of the books', () async {
    final books = await ben.books.books();
    final ids = {for (final book in books) book.name: book.id};

    for (final seed in seedBooks) {
      expect(
        await names(RecipeQuery(bookIds: {ids[seed.name]!}), as: ben),
        seed.recipes.toSet(),
        reason: seed.name,
      );
    }
    expect(await names(RecipeQuery(bookIds: ids.values.toSet()), as: ben), {
      for (final book in seedBooks) ...book.recipes,
    });
  });

  group('cookable', () {
    // Marked on hand for the test, so one recipe is cookable and another
    // misses one food; unmarked again afterwards.
    const extra = {'Butter', 'Ei', 'Milch', 'Sahne'};
    late TandoorClient client;

    setUp(() async {
      client = TandoorClient(tandoor.baseUrl, tandoor.token('anna'));
      for (final name in extra) {
        final food = (await anna.foods.autocomplete(name))
            .singleWhere((f) => f.name == name);
        expect(food.onHand, isFalse, reason: '$name is on hand already');
        addTearDown(
          () => client.patch('/api/food/${food.id}/', {'food_onhand': false}),
        );
        await client.patch('/api/food/${food.id}/', {'food_onhand': true});
      }
    });
    tearDown(() => client.close());

    /// The seeded recipes missing at most [max] foods, like Tandoor counts
    /// them (the seed has no substitutes).
    Set<String> expected(int max) {
      final available = {
        ...extra,
        for (final food in seedFoods)
          if (food.onHand || food.ignoreShopping) food.name,
      };
      return {
        for (final recipe in seedRecipes)
          if ({
                for (final step in recipe.steps)
                  for (final ingredient in step.ingredients) ?ingredient.food,
              }.difference(available).length <=
              max)
            recipe.name,
      };
    }

    test('finds what can be cooked now, or with one food missing', () async {
      expect(expected(0), contains('Pfannkuchen'));
      expect(expected(1), contains('Kartoffelgratin'));
      expect(expected(1).length, greaterThan(expected(0).length));

      expect(await names(const RecipeQuery(maxMissingFoods: 0)), expected(0));
      expect(await names(const RecipeQuery(maxMissingFoods: 1)), expected(1));
      // On hand counts for the whole household.
      expect(
        await names(const RecipeQuery(maxMissingFoods: 0), as: ben),
        expected(0),
      );
    });
  });
}

@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/services/universal_search.dart';

import 'seeded_tandoor.dart';

// The sort orders against the seeded Tandoor.
void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
  });
  tearDown(() => anna.close());

  Future<List<RecipeSummary>> all(RecipeQuery query) async {
    final page = await anna.recipes.search(query, pageSize: 100);
    expect(page.hasMore, isFalse);
    return page.items;
  }

  test('every order lists every recipe', () async {
    final ids = {for (final r in await all(const RecipeQuery())) r.id};
    expect(ids, isNotEmpty);

    for (final sort in RecipeSort.values) {
      final sorted = await all(RecipeQuery(sort: sort));
      expect({for (final r in sorted) r.id}, ids, reason: '$sort');
    }
  });

  test('newest first', () async {
    final ids = [
      for (final r in await all(const RecipeQuery(sort: RecipeSort.newest)))
        r.id,
    ];

    expect(ids, [...ids]..sort((a, b) => b.compareTo(a)));
  });

  test('best rated first, unrated last', () async {
    final ratings = [
      for (final r in await all(const RecipeQuery(sort: RecipeSort.rating)))
        r.rating,
    ];

    // Anna rated some of the seeded recipes, not all.
    expect(ratings.whereType<double>(), isNotEmpty);
    expect(ratings, contains(isNull));
    final rated = ratings.takeWhile((r) => r != null).cast<double>().toList();
    expect(ratings.skip(rated.length), everyElement(isNull));
    expect(rated, [...rated]..sort((a, b) => b.compareTo(a)));
  });

  test('recently viewed first after opening a recipe', () async {
    final recipes = await all(const RecipeQuery(sort: RecipeSort.name));
    final viewed = recipes.last;

    await anna.recipes.recordView(viewed.id);

    final sorted = await all(
      const RecipeQuery(sort: RecipeSort.recentlyViewed),
    );
    expect(sorted.first.id, viewed.id);
  });

  test('the universal search merges by rating', () async {
    final search = UniversalSearch(
      recipes: anna.recipes,
      foods: anna.foods,
      keywords: anna.keywords,
      books: anna.books,
    ).start(const RecipeQuery(text: 'Karotte', sort: RecipeSort.rating));
    final ratings = <double?>[];
    while (true) {
      final page = await search.next();
      ratings.addAll([for (final m in page.items) m.recipe.rating]);
      if (!page.hasMore) break;
    }

    final rated = ratings.takeWhile((r) => r != null).cast<double>().toList();
    expect(ratings.skip(rated.length), everyElement(isNull));
    expect(rated, [...rated]..sort((a, b) => b.compareTo(a)));
  });
}

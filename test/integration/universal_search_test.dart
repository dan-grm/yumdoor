@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_match.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/services/universal_search.dart';

import '../../tool/seed/data.dart';
import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories repositories;
  late UniversalSearch search;

  setUp(() {
    repositories = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    search = UniversalSearch(
      recipes: repositories.recipes,
      foods: repositories.foods,
      keywords: repositories.keywords,
    );
  });
  tearDown(() => repositories.close());

  /// Every result of [query], loading [pageSize] at a time.
  Future<List<RecipeMatch>> all(RecipeQuery query, {int pageSize = 25}) async {
    final results = search.start(query, pageSize: pageSize);
    final matches = <RecipeMatch>[];
    while (true) {
      final page = await results.next();
      matches.addAll(page.items);
      if (!page.hasMore) return matches;
    }
  }

  test(
    '"Karotte" finds a recipe that has carrots only as an ingredient',
    () async {
      final carrotOnly = seedRecipesWithAnyFood(seedFoodWithChildren('Karotte'))
          .where((name) => !name.toLowerCase().contains('karotte'))
          .toSet();
      expect(carrotOnly, isNotEmpty);

      final matches = await all(const RecipeQuery(text: 'Karotte'));

      final byName = {for (final m in matches) m.recipe.name: m};
      for (final name in carrotOnly) {
        expect(byName[name]?.foods.map((f) => f.name), contains('Karotte'));
      }
    },
  );

  test('lists name matches first, each recipe once', () async {
    final matches = await all(const RecipeQuery(text: 'Karotte'), pageSize: 2);

    final names = [for (final m in matches) m.recipe.name];
    expect(names.toSet(), hasLength(names.length));
    final nameMatches = names.takeWhile(
      (name) => name.toLowerCase().contains('karotte'),
    );
    expect(nameMatches.toSet(), {
      for (final recipe in seedRecipes)
        if (recipe.name.toLowerCase().contains('karotte')) recipe.name,
    });
  });

  test('counts every recipe once, also across pages', () async {
    final matches = await all(const RecipeQuery(text: 'Karotte'));

    // With one result per page the count needs the overlaps from the server.
    final page = await search
        .start(const RecipeQuery(text: 'Karotte'), pageSize: 1)
        .next();
    expect(page.totalCount, matches.length);
  });

  test('finds recipes by keyword and says which', () async {
    final matches = await all(const RecipeQuery(text: 'vegetarisch'));

    final expected = {
      for (final recipe in seedRecipes)
        if (recipe.keywords.contains('Vegetarisch')) recipe.name,
    };
    expect(expected, isNotEmpty);
    expect({for (final m in matches) m.recipe.name}, containsAll(expected));
    for (final match in matches) {
      expect(match.keywords.map((k) => k.name), contains('Vegetarisch'));
    }
  });

  test('applies the other filters to every part of the search', () async {
    final zwiebel = (await repositories.foods.autocomplete('Zwiebel'))
        .singleWhere((f) => f.name == 'Zwiebel');

    final matches = await all(
      RecipeQuery(text: 'Karotte', foodIds: {zwiebel.id}),
    );

    final expected = seedRecipesWithAnyFood(seedFoodWithChildren('Karotte'))
        .intersection(seedRecipesWithAnyFood({'Zwiebel'}));
    expect(expected, isNotEmpty);
    expect({for (final m in matches) m.recipe.name}, expected);
  });
}

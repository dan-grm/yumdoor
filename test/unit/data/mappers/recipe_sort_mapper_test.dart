import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/mappers/recipe_sort_mapper.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';

void main() {
  test('maps every order to sort_order or random', () {
    expect(
      {for (final sort in RecipeSort.values) sort: sortParams(sort)},
      {
        RecipeSort.relevance: (sortOrder: null, random: null),
        RecipeSort.name: (sortOrder: 'name', random: null),
        RecipeSort.lastCooked: (sortOrder: '-lastcooked', random: null),
        RecipeSort.rating: (sortOrder: '-rating', random: null),
        RecipeSort.newest: (sortOrder: '-created_at', random: null),
        RecipeSort.recentlyViewed: (sortOrder: '-lastviewed', random: null),
        RecipeSort.random: (sortOrder: null, random: true),
      },
    );
  });
}

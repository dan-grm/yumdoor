import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/features/search/search_location.dart';

void main() {
  RecipeQuery parse(String location) => searchQueryFromUri(Uri.parse(location));

  test('an empty query is the bare search path', () {
    expect(searchLocation(const RecipeQuery()), '/search');
    expect(searchLocation(const RecipeQuery(text: '  ')), '/search');
    expect(parse('/search'), const RecipeQuery());
  });

  test('round-trips every filter', () {
    final query = RecipeQuery(
      text: 'Suppe mit Ingwer',
      foodIds: {12, 40},
      keywordIds: {3},
      minRating: 4,
      lastCookedBefore: DateTime(2026, 9, 1),
    );

    final location = searchLocation(query);

    expect(
      location,
      '/search?q=Suppe+mit+Ingwer&food=12&food=40&keyword=3&rating=4'
      '&cooked_before=2026-09-01',
    );
    expect(parse(location), query);
  });

  test('trims the text', () {
    expect(
      searchLocation(const RecipeQuery(text: ' Kuchen ')),
      '/search?q=Kuchen',
    );
    expect(parse('/search?q=%20Kuchen%20').text, 'Kuchen');
  });

  test('drops parameters that do not parse', () {
    expect(
      parse(
        '/search?food=12&food=karotte&food=-1&keyword=0&rating=6'
        '&cooked_before=2026-02-31',
      ),
      const RecipeQuery(foodIds: {12}),
    );
    expect(
      parse('/search?rating=0&cooked_before=gestern'),
      const RecipeQuery(),
    );
  });

  test('ignores unknown parameters', () {
    expect(parse('/search?sort=name&q=Brot'), const RecipeQuery(text: 'Brot'));
  });
}

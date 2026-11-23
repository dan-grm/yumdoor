import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
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

  test('round-trips the cookable, book and creator filters', () {
    const query = RecipeQuery(
      maxMissingFoods: 1,
      bookIds: {4, 7},
      createdBy: 2,
    );

    final location = searchLocation(query);

    expect(location, '/search?missing=1&book=4&book=7&created_by=2');
    expect(parse(location), query);
    expect(
      searchLocation(const RecipeQuery(maxMissingFoods: 0)),
      '/search?missing=0',
    );
    expect(parse('/search?missing=0'), const RecipeQuery(maxMissingFoods: 0));
    for (final query in [
      const RecipeQuery(maxMissingFoods: 0),
      const RecipeQuery(bookIds: {4}),
      const RecipeQuery(createdBy: 2),
    ]) {
      expect(query.isEmpty, isFalse);
    }
  });

  test('round-trips a saved search the chips can\'t show', () {
    const query = RecipeQuery(savedFilter: 5, text: 'Suppe');

    final location = searchLocation(query);

    expect(location, '/search?q=Suppe&saved=5');
    expect(parse(location), query);
    expect(query.copyWith(text: '').isEmpty, isFalse);
    expect(parse('/search?saved=0'), const RecipeQuery());
    expect(parse('/search?saved=x'), const RecipeQuery());
  });

  test('round-trips every sort order', () {
    for (final sort in RecipeSort.values) {
      final query = RecipeQuery(text: 'Suppe', sort: sort);

      expect(parse(searchLocation(query)), query, reason: '$sort');
      // It doesn't narrow the search.
      expect(RecipeQuery(sort: sort).isEmpty, isTrue);
    }
    expect(
      searchLocation(const RecipeQuery(sort: RecipeSort.lastCooked)),
      '/search?sort=last_cooked',
    );
  });

  test('leaves out the default order and drops an unknown one', () {
    expect(searchLocation(const RecipeQuery(text: 'Suppe')), '/search?q=Suppe');
    expect(parse('/search?sort=times_cooked'), const RecipeQuery());
  });

  test('drops cookable, book and creator values that do not parse', () {
    expect(
      parse('/search?missing=2&book=0&book=x&created_by=-1'),
      const RecipeQuery(),
    );
    expect(parse('/search?missing=-1&created_by=anna'), const RecipeQuery());
  });

  test('round-trips the times cooked', () {
    const often = RecipeQuery(minTimesCooked: 5);
    const never = RecipeQuery(neverCooked: true);

    expect(searchLocation(often), '/search?times_min=5');
    expect(parse('/search?times_min=5'), often);
    expect(searchLocation(never), '/search?never=1');
    expect(parse('/search?never=1'), never);
    // Never wins over a count.
    expect(parse('/search?never=1&times_min=5'), never);
    expect(parse('/search?times_min=0'), const RecipeQuery());
    expect(parse('/search?never=0&times_min=x'), const RecipeQuery());
    expect(often.isEmpty, isFalse);
    expect(never.isEmpty, isFalse);
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
    expect(parse('/search?view=grid&q=Brot'), const RecipeQuery(text: 'Brot'));
  });

  test('the picker location carries the day and the query', () {
    final day = CalendarDay(2026, 11, 25);
    final location = pickRecipeLocation(const RecipeQuery(text: 'Brot'), day);
    expect(location, '/plan/pick?q=Brot&day=2026-11-25');
    final uri = Uri.parse(location);
    expect(pickDayFromUri(uri), day);
    expect(searchQueryFromUri(uri), const RecipeQuery(text: 'Brot'));
    expect(pickDayFromUri(Uri.parse('/plan/pick?day=gestern')), isNull);
    expect(pickDayFromUri(Uri.parse('/plan/pick')), isNull);
  });
}

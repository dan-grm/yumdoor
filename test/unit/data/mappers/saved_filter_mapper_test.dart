import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/saved_filter_mapper.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  group('savedSearchQuery', () {
    test('reads what Tandoor\'s search page saves', () {
      expect(
        savedSearchQuery(
          '{"query":"Suppe","keywords_and":[3,4],"foods_and":[9],'
          '"books":[5],"rating_gte":4,"cookedon_lte":"2026-10-01",'
          '"timescooked_gte":2,"makenow":"true","createdby":2,'
          '"sort_order":"-rating","include_children":"true","version":"2"}',
        ),
        RecipeQuery(
          text: 'Suppe',
          keywordIds: const {3, 4},
          foodIds: const {9},
          bookIds: const {5},
          minRating: 4,
          lastCookedBefore: DateTime(2026, 10),
          minTimesCooked: 2,
          maxMissingFoods: 0,
          createdBy: 2,
          sort: RecipeSort.rating,
        ),
      );
    });

    test('takes a single "any of" food or keyword as a chip', () {
      expect(
        savedSearchQuery('{"keywords":[3],"foods_or":[{"id":9,"name":"x"}]}'),
        const RecipeQuery(keywordIds: {3}, foodIds: {9}),
      );
    });

    test('adds "all of" to a single "any of", in either order', () {
      for (final json in [
        '{"keywords":[3],"keywords_and":[5,6]}',
        '{"keywords_and":[5,6],"keywords":[3]}',
      ]) {
        expect(
          savedSearchQuery(json),
          const RecipeQuery(keywordIds: {3, 5, 6}),
          reason: json,
        );
      }
      expect(
        savedSearchQuery('{"foods_or":[1],"foods_and":[2]}'),
        const RecipeQuery(foodIds: {1, 2}),
      );
    });

    test('takes a date and time as the local day', () {
      final midnight = DateTime(2026, 11, 1).toUtc().toIso8601String();
      expect(
        savedSearchQuery('{"cookedon_lte":"$midnight"}')?.lastCookedBefore,
        DateTime(2026, 11),
      );
    });

    test('takes never cooked, and lets it win over a minimum', () {
      expect(
        savedSearchQuery('{"timescooked":0,"timescooked_gte":3}'),
        const RecipeQuery(neverCooked: true),
      );
    });

    test('ignores empty values and orders it can\'t show', () {
      expect(
        savedSearchQuery(
          '{"query":"","keywords":[],"makenow":"false","rating_gte":null,'
          '"sort_order":"times_cooked","page":1}',
        ),
        const RecipeQuery(),
      );
      expect(
        savedSearchQuery('{"sort_order":"random"}')?.sort,
        RecipeSort.random,
      );
      expect(
        savedSearchQuery('{"sort_order":"-score"}')?.sort,
        RecipeSort.relevance,
      );
    });

    for (final json in [
      '{"keywords_or":[1,2]}',
      '{"foods_or_not":[1]}',
      '{"rating_lte":3}',
      '{"rating_gte":7}',
      '{"timescooked_lte":2}',
      '{"timescooked":3}',
      '{"makenow":2}',
      '{"units":[6]}',
      '{"include_children":"false"}',
      '{"cookedon_gte":"2026-01-01"}',
      '{"cookedon_lte":"gestern"}',
      '{"internal":"true"}',
      '[1]',
      'kein JSON',
    ]) {
      test('can\'t show $json as chips', () {
        expect(savedSearchQuery(json), isNull);
      });
    }
  });

  group('savedSearchJson', () {
    final queries = [
      const RecipeQuery(),
      RecipeQuery(
        text: ' Suppe ',
        foodIds: const {9, 4},
        keywordIds: const {3},
        bookIds: const {5},
        minRating: 4,
        lastCookedBefore: DateTime(2026, 2, 3),
        minTimesCooked: 2,
        maxMissingFoods: 1,
        createdBy: 2,
        sort: RecipeSort.newest,
      ),
      const RecipeQuery(neverCooked: true, sort: RecipeSort.random),
      const RecipeQuery(text: 'x', sort: RecipeSort.relevance),
      for (final sort in RecipeSort.values) RecipeQuery(sort: sort),
    ];
    for (final query in queries) {
      test('reads back $query', () {
        expect(
          savedSearchQuery(savedSearchJson(query)),
          query.copyWith(text: query.text.trim()),
        );
      });
    }

    test('writes the names Tandoor\'s search page reads', () {
      expect(
        savedSearchJson(
          RecipeQuery(
            text: 'Suppe',
            keywordIds: const {3},
            lastCookedBefore: DateTime(2026, 2, 3),
            maxMissingFoods: 0,
            sort: RecipeSort.relevance,
          ),
        ),
        '{"query":"Suppe","keywords_and":[3],"cookedon_lte":"2026-02-03",'
        '"makenow":"true","sort_order":"-score","version":"2"}',
      );
    });

    test('refuses a search with a saved search in it', () {
      expect(
        () => savedSearchJson(const RecipeQuery(savedFilter: 3)),
        throwsArgumentError,
      );
    });
  });

  test('maps the recorded saved searches', () {
    final page = api.standardSerializers.deserializeWith(
      api.PaginatedCustomFilterList.serializer,
      tandoorFixture('custom_filter_list.json'),
    )!;
    // Anna's view; Ben shared his saved search with her.
    final anna = page.results
        .expand((f) => f.shared ?? const <api.User>[])
        .firstWhere((u) => u.username == 'anna')
        .id!;
    final filters = [
      for (final filter in page.results) filter.toDomain(userId: anna),
    ];
    expect(filters.map((f) => f.name), contains('Schnell & vegetarisch'));
    final quick = filters.singleWhere((f) => f.name == 'Schnell & vegetarisch');
    expect(quick.own, isTrue);
    expect(quick.query?.keywordIds, hasLength(2));
    final rare = filters.singleWhere((f) => f.name == 'Selten gekocht');
    expect(rare.query, isNull);
    expect(rare.search, RecipeQuery(savedFilter: rare.id));
    final ben = filters.singleWhere((f) => f.name == 'Bens Backideen');
    expect(ben.own, isFalse);
  });
}

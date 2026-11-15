@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/result_page.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  /// Saved searches the test created, deleted again afterwards.
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
        await anna.savedFilters.delete(id);
      } on NotFoundFailure {
        // The test deleted it itself.
      }
    }
    created.clear();
    anna.close();
    ben.close();
  });

  Set<String> names(ResultPage<RecipeSummary> page) => {
    for (final recipe in page.items) recipe.name,
  };

  test('lists the seeded ones, own and shared', () async {
    final filters = await anna.savedFilters.savedFilters();

    final quick = filters.singleWhere((f) => f.name == 'Schnell & vegetarisch');
    expect(quick.own, isTrue);
    expect(quick.query?.keywordIds, hasLength(2));
    final rare = filters.singleWhere((f) => f.name == 'Selten gekocht');
    expect(rare.own, isTrue);
    expect(rare.query, isNull);
    final shared = filters.singleWhere((f) => f.name == 'Bens Backideen');
    expect(shared.own, isFalse);
    expect(shared.query, const RecipeQuery(text: 'Kuchen'));

    final bens = await ben.savedFilters.savedFilters();
    expect(bens.map((f) => f.name), contains('Schnell & vegetarisch'));
    expect(bens.map((f) => f.name), isNot(contains('Selten gekocht')));
  });

  test('creates one, finds it, renames and deletes it', () async {
    final saved = await anna.savedFilters.create(
      'Suppen ab 4 Sternen',
      const RecipeQuery(text: 'Suppe', minRating: 4),
    );
    created.add(saved.id);
    expect(saved.own, isTrue);
    expect(saved.query, const RecipeQuery(text: 'Suppe', minRating: 4));

    final renamed = await anna.savedFilters.rename(saved.id, 'Gute Suppen');
    expect(renamed.name, 'Gute Suppen');
    expect(
      (await anna.savedFilters.savedFilters()).map((f) => f.name),
      contains('Gute Suppen'),
    );

    await anna.savedFilters.delete(saved.id);
    expect(
      (await anna.savedFilters.savedFilters()).map((f) => f.id),
      isNot(contains(saved.id)),
    );
  });

  test('someone it is shared with can use it but not change it', () async {
    final quick = (await anna.savedFilters.savedFilters()).singleWhere(
      (f) => f.name == 'Schnell & vegetarisch',
    );

    expect(
      ben.savedFilters.rename(quick.id, 'Meins'),
      throwsA(isA<UnauthorizedFailure>()),
    );
    expect(
      ben.savedFilters.delete(quick.id),
      throwsA(isA<UnauthorizedFailure>()),
    );
  });

  test(
    'applies one the chips can\'t show, alone and with search text',
    () async {
      final rare = (await anna.savedFilters.savedFilters()).singleWhere(
        (f) => f.name == 'Selten gekocht',
      );

      final alone = await anna.recipes.search(
        RecipeQuery(savedFilter: rare.id),
        pageSize: 100,
      );
      final reference = await anna.recipes.search(
        const RecipeQuery(minTimesCooked: 1),
        pageSize: 100,
      );
      // `timescooked_lte: 2` leaves out recipes never cooked.
      expect(names(alone), isNotEmpty);
      expect(names(reference), containsAll(names(alone)));

      final soups = await anna.recipes.search(
        RecipeQuery(savedFilter: rare.id, text: 'Suppe'),
        pageSize: 100,
      );
      expect(names(alone), containsAll(names(soups)));
      for (final name in names(soups)) {
        expect(name.toLowerCase(), contains('suppe'));
      }

      // Not shared with Ben: he can't use it, so it finds nothing.
      final asBen = await ben.recipes.search(RecipeQuery(savedFilter: rare.id));
      expect(asBen.items, isEmpty);
    },
  );

  test('applies the shared one with a clashing text search', () async {
    final bens = (await anna.savedFilters.savedFilters()).singleWhere(
      (f) => f.name == 'Bens Backideen',
    );

    // Its `query` clashes with the text, so the ids decide.
    final page = await anna.recipes.search(
      RecipeQuery(savedFilter: bens.id, text: 'Apfel'),
      pageSize: 100,
    );

    expect(names(page), isNotEmpty);
    for (final name in names(page)) {
      expect(name.toLowerCase(), contains('kuchen'));
      expect(name.toLowerCase(), contains('apfel'));
    }
  });
}

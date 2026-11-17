import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/caching_recipe_repository.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fakes/fake_recipe_repository.dart';
import '../../../fixtures/recipes.dart';

final _image = Uri.parse('https://tandoor.example.com/media/recipes/7.jpg');
final _karotten = ofenkarotten.copyWith(image: _image);
final _suppe = ofenkarotten.copyWith(
  id: 8,
  name: 'Kürbissuppe',
  keywords: const [Keyword(id: 3, name: 'Suppe')],
  steps: const [],
  rating: 3,
  lastCooked: DateTime(2026, 9, 1, 18),
  createdBy: const UserRef(id: 2, name: 'Anna'),
);

void main() {
  late CacheDatabase db;
  late RecipeCache cache;
  late FakeRecipeRepository remote;
  late List<Uri> downloads;
  late CachingRecipeRepository repository;

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    // Every access a second later, so "most recently opened" is never a tie.
    var now = DateTime.utc(2026, 10, 24);
    cache = RecipeCache(
      db,
      clock: () => now = now.add(const Duration(seconds: 1)),
    );
    remote = FakeRecipeRepository([_karotten, _suppe]);
    downloads = [];
    repository = CachingRecipeRepository(
      remote,
      cache,
      downloadImage: (url) async {
        downloads.add(url);
        return Uint8List.fromList([1, 2, 3]);
      },
    );
  });

  tearDown(() => db.close());

  /// Fetches the recipe and lets the caching that
  /// [CachingRecipeRepository.fetchRecipe] starts in the background finish.
  Future<Recipe> fetch(int id) async {
    final recipe = await repository.fetchRecipe(id);
    await pumpEventQueue();
    return recipe;
  }

  group('fetchRecipe', () {
    test('stores what the server returns', () async {
      expect(await fetch(7), _karotten);

      expect(await cache.get(7), _karotten);
    });

    test('keeps the stored last cooked date when none came', () async {
      // The cook log couldn't be read this time.
      await fetch(8);
      remote.recipes[8] = _suppe.copyWith(lastCooked: null, rating: 4);

      await fetch(8);

      final stored = await cache.get(8);
      expect(stored?.lastCooked, _suppe.lastCooked);
      expect(stored?.rating, 4);
    });

    test('falls back to the stored copy when offline', () async {
      await fetch(7);
      remote.failure = const OfflineFailure();

      expect(await fetch(7), _karotten);
    });

    test('without allowCached, stays offline despite a stored copy', () async {
      await fetch(7);
      remote.failure = const OfflineFailure();

      await expectLater(
        repository.fetchRecipe(7, allowCached: false),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('prefers the server over the stored copy', () async {
      await fetch(7);
      remote.recipes[7] = _karotten.copyWith(name: 'Ofenkarotten neu');

      expect((await fetch(7)).name, 'Ofenkarotten neu');
      expect((await cache.get(7))!.name, 'Ofenkarotten neu');
    });

    test('stays offline for a recipe that was never opened', () async {
      remote.failure = const OfflineFailure();

      await expectLater(
        repository.fetchRecipe(7),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('does not fall back for other failures', () async {
      await fetch(7);
      remote.failure = const ServerFailure(statusCode: 500);

      await expectLater(
        repository.fetchRecipe(7),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('forgets a recipe the server no longer has', () async {
      await fetch(7);
      remote.recipes.remove(7);

      await expectLater(
        repository.fetchRecipe(7),
        throwsA(isA<NotFoundFailure>()),
      );
      expect(await cache.get(7), isNull);
    });

    test('stores the image once', () async {
      await fetch(7);
      await fetch(7);

      expect(downloads, [_image]);
      expect(await cache.image(_image), [1, 2, 3]);
    });

    test('ignores a failed image download', () async {
      repository = CachingRecipeRepository(
        remote,
        cache,
        downloadImage: (_) => Future.error(Exception('no image')),
      );

      expect(await fetch(7), _karotten);
      expect(await cache.image(_image), isNull);
    });

    test('returns the recipe even if storing it fails', () async {
      await db.close();

      expect(await fetch(7), _karotten);
    });
  });

  group('search', () {
    test('asks the server when online', () async {
      final page = await repository.search(const RecipeQuery(text: 'suppe'));

      expect(page.fromCache, isFalse);
      expect([for (final r in page.items) r.id], [8]);
      expect(remote.searches, hasLength(1));
    });

    group('offline', () {
      setUp(() async {
        await fetch(8);
        await fetch(7);
        remote.failure = const OfflineFailure();
      });

      test('lists stored recipes by name', () async {
        final page = await repository.search(const RecipeQuery());

        expect(page.fromCache, isTrue);
        expect(page.hasMore, isFalse);
        expect(page.totalCount, 2);
        expect(page.items, [_suppe.summary, _karotten.summary]);
      });

      test('matches the text against names, ignoring case', () async {
        final page = await repository.search(
          const RecipeQuery(text: ' KÜRBIS '),
        );

        expect([for (final r in page.items) r.id], [8]);
      });

      test('matches the text against ingredients and keywords', () async {
        Future<List<int>> ids(String text) async => [
          for (final r in (await repository.search(
            RecipeQuery(text: text),
          )).items)
            r.id,
        ];

        expect(await ids('olivenol'), [7]);
        expect(await ids('Vegetarisch'), [7]);
        expect(await ids('Suppe'), [8]);
        expect(await ids('Zimt'), isEmpty);
      });

      test('carries the foods of cached recipes', () async {
        final page = await repository.search(const RecipeQuery(text: 'Ofen'));

        expect(page.items.single.foods.map((f) => f.name), contains('Karotte'));
      });

      test('matches any of the foods or keywords', () async {
        Future<List<int>> ids(RecipeQuery query) async => [
          for (final r in (await repository.search(query)).items) r.id,
        ];

        expect(await ids(const RecipeQuery(anyFoodIds: {1, 99})), [7]);
        expect(await ids(const RecipeQuery(anyKeywordIds: {3, 99})), [8]);
        expect(await ids(const RecipeQuery(anyKeywordIds: {99})), isEmpty);
      });

      test('applies food, keyword and rating filters', () async {
        Future<List<int>> ids(RecipeQuery query) async => [
          for (final r in (await repository.search(query)).items) r.id,
        ];

        expect(await ids(const RecipeQuery(foodIds: {1})), [7]);
        expect(await ids(const RecipeQuery(keywordIds: {3})), [8]);
        expect(await ids(const RecipeQuery(minRating: 4)), [7]);
      });

      test('applies the cooking history filters like the server', () async {
        Future<List<int>> ids(RecipeQuery query) async => [
          for (final r in (await repository.search(query)).items) r.id,
        ];

        // Cooked on the day itself counts; never cooked recipes don't.
        expect(await ids(RecipeQuery(lastCookedBefore: DateTime(2026, 9, 1))), [
          8,
        ]);
        expect(
          await ids(RecipeQuery(lastCookedBefore: DateTime(2026, 8, 31))),
          isEmpty,
        );
        expect(await ids(const RecipeQuery(neverCooked: true)), [7]);
        // Counts aren't cached: at least cooked once.
        expect(await ids(const RecipeQuery(minTimesCooked: 5)), [8]);
      });

      test('applies the cookable and creator filters, not books', () async {
        Future<List<int>> ids(RecipeQuery query) async => [
          for (final r in (await repository.search(query)).items) r.id,
        ];

        // The soup has no ingredients; none of the carrots' foods is on hand.
        expect(await ids(const RecipeQuery(maxMissingFoods: 0)), [8]);
        expect(await ids(const RecipeQuery(maxMissingFoods: 1)), [8]);
        expect(await ids(const RecipeQuery(createdBy: 2)), [8]);
        expect(await ids(const RecipeQuery(createdBy: 3)), isEmpty);
        // Book entries aren't cached, nor saved searches.
        expect(await ids(const RecipeQuery(bookIds: {1})), isEmpty);
        expect(await ids(const RecipeQuery(savedSearchOfBook: 1)), isEmpty);
        expect(await ids(const RecipeQuery(savedFilter: 1)), isEmpty);
      });

      test('sorts in the chosen order as far as the cache can', () async {
        Future<List<int>> ids(RecipeSort sort) async => [
          for (final r in (await repository.search(
            RecipeQuery(sort: sort),
          )).items)
            r.id,
        ];

        expect(await ids(RecipeSort.name), [8, 7]);
        expect(await ids(RecipeSort.rating), [7, 8]);
        // Only Kürbissuppe was cooked.
        expect(await ids(RecipeSort.lastCooked), [8, 7]);
        expect(await ids(RecipeSort.newest), [8, 7]);
        // Opened in Yumdoor: most recently opened first.
        expect(await ids(RecipeSort.recentlyViewed), [7, 8]);
        expect(await ids(RecipeSort.random), unorderedEquals([7, 8]));
      });

      test('has no later pages', () async {
        await expectLater(
          repository.search(const RecipeQuery(), page: 2),
          throwsA(isA<OfflineFailure>()),
        );
      });

      test('respects a cancelled search', () async {
        final cancel = CancelSignal()..cancel();

        await expectLater(
          repository.search(const RecipeQuery(), cancel: cancel),
          throwsA(isA<CancelledFailure>()),
        );
      });
    });
  });

  group('saves', () {
    test('an update stores the recipe as saved', () async {
      await fetch(7);
      final draft = RecipeDraft.fromRecipe(_karotten).copyWith(name: 'Neu');

      final saved = await repository.updateRecipe(7, draft);

      expect(saved.name, 'Neu');
      // Before the save returns, not in the background.
      expect(await cache.get(7), saved);
    });

    test('an update keeps the stored last cooked date', () async {
      await fetch(8);
      // The cook log can't be read during the save.
      remote.recipes[8] = _suppe.copyWith(lastCooked: null);
      final draft = RecipeDraft.fromRecipe(_suppe).copyWith(name: 'Neu');

      final saved = await repository.updateRecipe(8, draft);

      expect(saved.lastCooked, _suppe.lastCooked);
      expect(await cache.get(8), saved);
    });

    test('a new recipe is stored', () async {
      final saved = await repository.createRecipe(
        const RecipeDraft(name: 'Brot'),
      );

      expect(await cache.get(saved.id), saved);
    });

    test('fail offline and are not queued', () async {
      await fetch(7);
      remote.failure = const OfflineFailure();
      final draft = RecipeDraft.fromRecipe(_karotten).copyWith(name: 'Neu');

      await expectLater(
        repository.updateRecipe(7, draft),
        throwsA(isA<OfflineFailure>()),
      );
      await expectLater(
        repository.createRecipe(draft),
        throwsA(isA<OfflineFailure>()),
      );

      expect((await cache.get(7))?.name, 'Ofenkarotten mit Feta');
      remote.failure = null;
      // Nothing was kept to be sent later.
      expect(remote.recipes.length, 2);
    });

    test('an update of a deleted recipe removes it from the cache', () async {
      await fetch(7);
      remote.recipes.remove(7);

      await expectLater(
        repository.updateRecipe(7, RecipeDraft.fromRecipe(_karotten)),
        throwsA(isA<NotFoundFailure>()),
      );

      expect(await cache.get(7), isNull);
    });
  });

  group('images', () {
    final upload = ImageUpload(
      bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF]),
      fileName: 'karotten.jpg',
      mimeType: 'image/jpeg',
    );

    test('an upload gives the stored recipe the new image', () async {
      await fetch(7);

      final url = await repository.uploadImage(7, upload);
      await pumpEventQueue();

      expect(url, FakeRecipeRepository.imageUrl(7, 1));
      expect((await cache.get(7))?.image, url);
      // The new image is downloaded for offline use; the old one goes.
      expect(downloads, [_image, url]);
      expect(await cache.image(url), [1, 2, 3]);
      expect(await cache.image(_image), isNull);
    });

    test('a removal stores the recipe without an image', () async {
      await fetch(7);

      await repository.removeImage(7);
      await pumpEventQueue();

      expect((await cache.get(7))?.image, isNull);
      expect(await cache.image(_image), isNull);
    });

    test('a recipe that is not stored stays so', () async {
      await repository.uploadImage(7, upload);
      await pumpEventQueue();

      expect(await cache.get(7), isNull);
    });

    test('fail offline and keep the stored recipe', () async {
      await fetch(7);
      remote.imageFailure = const OfflineFailure();

      await expectLater(
        repository.uploadImage(7, upload),
        throwsA(isA<OfflineFailure>()),
      );
      await expectLater(
        repository.removeImage(7),
        throwsA(isA<OfflineFailure>()),
      );

      expect((await cache.get(7))?.image, _image);
    });

    test('an upload to a deleted recipe removes it from the cache', () async {
      await fetch(7);
      remote.recipes.remove(7);

      await expectLater(
        repository.uploadImage(7, upload),
        throwsA(isA<NotFoundFailure>()),
      );

      expect(await cache.get(7), isNull);
    });
  });
}

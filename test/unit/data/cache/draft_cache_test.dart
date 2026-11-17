import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/draft_cache.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/stored_draft.dart';

import '../../../fixtures/recipes.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late DraftCache drafts;
  final savedAt = DateTime(2026, 11, 16, 18, 30);

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    drafts = DraftCache(db);
  });

  tearDown(() => db.close());

  StoredDraft draftNamed(String name) => StoredDraft(
    draft: RecipeDraft.fromRecipe(ofenkarotten).copyWith(name: name),
    savedAt: savedAt,
  );

  test('stores a draft with every tab and reads it back', () async {
    final draft = RecipeDraft.fromRecipe(ofenkarotten)
        .copyWith(name: 'Ofengemüse', workingTime: const Duration(minutes: 20))
        .addStep()
        .addIngredient(
          const IngredientDraft(
            food: NamedRef(name: 'Feta'),
            unit: NamedRef(id: 9, name: 'g'),
            amount: 150,
          ),
        );

    await drafts.save(7, StoredDraft(draft: draft, savedAt: savedAt));
    final loaded = await drafts.load(7);

    expect(loaded!.draft, draft);
    expect(loaded.savedAt, savedAt);
    expect(loaded.newImage, isNull);
    expect(loaded.removeImage, isFalse);
  });

  test('keeps a new photo, or that the photo goes', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    await drafts.save(
      7,
      StoredDraft(
        draft: const RecipeDraft(name: 'A'),
        newImage: ImageUpload(
          bytes: bytes,
          fileName: 'a.png',
          mimeType: 'image/png',
        ),
        savedAt: savedAt,
      ),
    );
    await drafts.save(
      8,
      StoredDraft(
        draft: const RecipeDraft(name: 'B'),
        removeImage: true,
        savedAt: savedAt,
      ),
    );

    final image = (await drafts.load(7))!.newImage!;
    expect(image.bytes, bytes);
    expect(image.fileName, 'a.png');
    expect(image.mimeType, 'image/png');
    expect((await drafts.load(8))!.removeImage, isTrue);
  });

  test('one draft per recipe, and one for a new recipe', () async {
    await drafts.save(7, draftNamed('Sieben'));
    await drafts.save(null, draftNamed('Neu'));
    await drafts.save(7, draftNamed('Sieben, später'));

    expect((await drafts.load(7))!.draft.name, 'Sieben, später');
    expect((await drafts.load(null))!.draft.name, 'Neu');
    expect(await drafts.load(8), isNull);
  });

  test('deletes one draft', () async {
    await drafts.save(7, draftNamed('Sieben'));
    await drafts.save(null, draftNamed('Neu'));

    await drafts.delete(7);

    expect(await drafts.load(7), isNull);
    expect(await drafts.load(null), isNotNull);
  });

  test('clear deletes every draft', () async {
    await drafts.save(7, draftNamed('Sieben'));
    await drafts.save(null, draftNamed('Neu'));

    await drafts.clear();

    expect(await drafts.load(7), isNull);
    expect(await drafts.load(null), isNull);
  });

  test('clearing the offline cache leaves them to their own clear', () async {
    await drafts.save(7, draftNamed('Sieben'));

    await RecipeCache(db).clear();

    expect(await drafts.load(7), isNotNull);
  });

  test('keeps the stored photo unless it changed', () async {
    final image = ImageUpload(
      bytes: Uint8List.fromList([1, 2, 3]),
      fileName: 'a.png',
      mimeType: 'image/png',
    );
    await drafts.save(
      7,
      StoredDraft(
        draft: const RecipeDraft(name: 'A'),
        newImage: image,
        savedAt: savedAt,
      ),
    );

    await drafts.save(7, draftNamed('B'), imageChanged: false);
    final kept = (await drafts.load(7))!;
    expect(kept.draft.name, 'B');
    expect(kept.newImage!.bytes, image.bytes);

    await drafts.save(7, draftNamed('C'));
    expect((await drafts.load(7))!.newImage, isNull);
  });

  test('stores everything if there is no draft yet', () async {
    await drafts.save(
      7,
      StoredDraft(
        draft: const RecipeDraft(name: 'A'),
        newImage: ImageUpload(
          bytes: Uint8List.fromList([1]),
          fileName: 'a.png',
          mimeType: 'image/png',
        ),
        savedAt: savedAt,
      ),
      imageChanged: false,
    );

    expect((await drafts.load(7))!.newImage, isNotNull);
  });

  test('keeps the base time exactly', () async {
    final base = DateTime.utc(2026, 11, 16, 9, 15, 30, 123, 456);
    await drafts.save(
      7,
      StoredDraft(
        draft: const RecipeDraft(name: 'A'),
        savedAt: savedAt,
        baseUpdatedAt: base,
      ),
    );

    expect((await drafts.load(7))!.baseUpdatedAt, base);
  });

  test('drops a draft that no longer decodes', () async {
    await drafts.save(7, draftNamed('Sieben'));
    await db.customStatement(
      "UPDATE editor_draft SET json = '{\"name\": 7}' WHERE recipe_id = 7",
    );

    expect(await drafts.load(7), isNull);
    final rows = await db.select(db.editorDrafts).get();
    expect(rows, isEmpty);
  });

  group('a new schema version', () {
    late File file;

    setUp(() async {
      final dir = Directory.systemTemp.createTempSync('yumdoor_draft_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      file = File('${dir.path}/cache.sqlite');
      final current = CacheDatabase(NativeDatabase(file));
      await DraftCache(current).save(7, draftNamed('Sieben'));
      await RecipeCache(current).put(ofenkarotten);
      await current.close();
    });

    test('keeps the drafts, but not the cached recipes', () async {
      final next = _VersionedCacheDatabase(
        NativeDatabase(file),
        db.schemaVersion + 1,
      );
      addTearDown(next.close);

      expect((await DraftCache(next).load(7))!.draft.name, 'Sieben');
      expect(await RecipeCache(next).all(), isEmpty);
    });

    test('keeps the drafts through a rollback and back', () async {
      final old = _VersionedCacheDatabase(NativeDatabase(file), 2);
      await old.customSelect('SELECT 1').get();
      await old.close();
      final current = CacheDatabase(NativeDatabase(file));
      addTearDown(current.close);

      expect((await DraftCache(current).load(7))!.draft.name, 'Sieben');
    });

    test('the first version with drafts creates their table', () async {
      // As the app before drafts left it.
      final old = _VersionedCacheDatabase(NativeDatabase(file), 2);
      await old.customStatement('DROP TABLE editor_draft');
      await old.close();
      final current = CacheDatabase(NativeDatabase(file));
      addTearDown(current.close);

      expect(await DraftCache(current).load(7), isNull);
      await DraftCache(current).save(7, draftNamed('Sieben'));
      expect(await DraftCache(current).load(7), isNotNull);
    });
  });
}

/// The cache database as another app version would open it.
class _VersionedCacheDatabase extends CacheDatabase {
  _VersionedCacheDatabase(super.executor, this.version);

  final int version;

  @override
  int get schemaVersion => version;
}

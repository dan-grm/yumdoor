import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/data/cache/shopping_check_cache.dart';
import 'package:yumdoor/domain/repositories/shopping_check_queue.dart';

import '../../../fixtures/recipes.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late ShoppingCheckCache queue;
  final at = DateTime.utc(2026, 11, 18, 15, 30, 12, 345, 678);
  final server = Uri.parse('https://tandoor.example.com');

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    queue = ShoppingCheckCache(db, server: server);
  });

  tearDown(() => db.close());

  test('stores pending states and reads them back exactly', () async {
    expect(await queue.read(), isEmpty);

    await queue.put([101, 102], PendingCheck(checked: true, at: at));
    await queue.put([109], PendingCheck(checked: false, at: at));

    expect(await ShoppingCheckCache(db, server: server).read(), {
      101: PendingCheck(checked: true, at: at),
      102: PendingCheck(checked: true, at: at),
      109: PendingCheck(checked: false, at: at),
    });
  });

  test('a new state for an entry replaces the pending one', () async {
    final later = at.add(const Duration(seconds: 5));
    await queue.put([105], PendingCheck(checked: true, at: at));
    await queue.put([105], PendingCheck(checked: false, at: later));

    expect(await queue.read(), {105: PendingCheck(checked: false, at: later)});
  });

  test('takes sent entries off', () async {
    await queue.put([101, 102, 103], PendingCheck(checked: true, at: at));

    await queue.remove([101, 103, 999]);

    expect((await queue.read()).keys, [102]);
  });

  test(
    'logout clears them, and a late write does not bring them back',
    () async {
      await queue.put([105], PendingCheck(checked: true, at: at));

      await RecipeCache(db).clear();
      expect(await queue.read(), isEmpty);

      // The session that ended writes after the clear.
      await queue.put([106], PendingCheck(checked: true, at: at));
      expect(await ShoppingCheckCache(db, server: server).read(), isEmpty);

      // The next session's queue works.
      final next = ShoppingCheckCache(db, server: server);
      await next.put([107], PendingCheck(checked: true, at: at));
      expect((await next.read()).keys, [107]);
    },
  );

  test('a session ended by a rejected token leaves them for the next login '
      'to the same server', () async {
    await queue.put([105], PendingCheck(checked: true, at: at));

    await RecipeCache(db).clear(keepShoppingQueue: true);

    expect(await ShoppingCheckCache(db, server: server).read(), {
      105: PendingCheck(checked: true, at: at),
    });
  });

  test("another server's never come back", () async {
    await queue.put([105], PendingCheck(checked: true, at: at));
    await RecipeCache(db).clear(keepShoppingQueue: true);

    final other = ShoppingCheckCache(
      db,
      server: Uri.parse('https://other.example.com'),
    );
    expect(await other.read(), isEmpty);
    await other.put([106], PendingCheck(checked: true, at: at));
    expect((await other.read()).keys, [106]);
    // Read by another server's session: deleted.
    expect(await ShoppingCheckCache(db, server: server).read(), isEmpty);
  });

  test('a new schema version keeps them, but not the cached recipes', () async {
    final dir = Directory.systemTemp.createTempSync('yumdoor_check_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/cache.sqlite');
    final current = CacheDatabase(NativeDatabase(file));
    await ShoppingCheckCache(
      current,
      server: server,
    ).put([105], PendingCheck(checked: true, at: at));
    await RecipeCache(current).put(ofenkarotten);
    await current.close();

    final next = _VersionedCacheDatabase(
      NativeDatabase(file),
      db.schemaVersion + 1,
    );
    addTearDown(next.close);

    expect(await ShoppingCheckCache(next, server: server).read(), {
      105: PendingCheck(checked: true, at: at),
    });
    expect(await RecipeCache(next).all(), isEmpty);
  });

  test('drops them after a version before the queue ran', () async {
    final dir = Directory.systemTemp.createTempSync('yumdoor_check_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/cache.sqlite');
    final current = CacheDatabase(NativeDatabase(file));
    await ShoppingCheckCache(
      current,
      server: server,
    ).put([105], PendingCheck(checked: true, at: at));
    await current.close();
    // Rolled back: that version's logout doesn't know the queue.
    final old = _VersionedCacheDatabase(
      NativeDatabase(file),
      CacheDatabase.firstQueueVersion - 1,
    );
    await old.customSelect('SELECT 1').get();
    await old.close();

    final again = CacheDatabase(NativeDatabase(file));
    addTearDown(again.close);
    expect(await ShoppingCheckCache(again, server: server).read(), isEmpty);
  });

  test('the first version with the queue creates its table', () async {
    final dir = Directory.systemTemp.createTempSync('yumdoor_check_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/cache.sqlite');
    // As the app before the queue left it.
    final old = _VersionedCacheDatabase(NativeDatabase(file), 4);
    await old.customStatement('DROP TABLE pending_shopping_check');
    await old.close();

    final current = CacheDatabase(NativeDatabase(file));
    addTearDown(current.close);
    final queue = ShoppingCheckCache(current, server: server);
    expect(await queue.read(), isEmpty);
    await queue.put([105], PendingCheck(checked: true, at: at));
    expect((await queue.read()).keys, [105]);
  });
}

/// The cache database as another app version would open it.
class _VersionedCacheDatabase extends CacheDatabase {
  _VersionedCacheDatabase(super.executor, this.version);

  final int version;

  @override
  int get schemaVersion => version;
}

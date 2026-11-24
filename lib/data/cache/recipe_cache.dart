import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/recipe.dart';
import '../../domain/repositories/offline_cache.dart';
import 'cache_database.dart';

/// Reads and writes recipes and their images in the [CacheDatabase], keeping
/// at most [maxRecipes] recipes (the most recently opened ones).
class RecipeCache implements OfflineCache {
  RecipeCache(
    this._db, {
    this.maxRecipes = defaultMaxRecipes,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  /// A few hundred KB each with the image, so a few dozen MB at most.
  static const defaultMaxRecipes = 100;

  final CacheDatabase _db;
  final int maxRecipes;
  final DateTime Function() _now;

  /// The number to pass as `epoch` for a read that starts now: writes
  /// with it do nothing once the cache was cleared ([clear]) since.
  int get epoch => _db.clears;

  /// Stores [recipe] as just opened, replacing an older copy, and drops the
  /// least recently opened recipes beyond [maxRecipes]. With [opened]
  /// `false` (a recipe stored ahead, not opened), an older copy keeps when
  /// it was last opened. With an [epoch], only if the cache wasn't cleared
  /// since.
  Future<void> put(Recipe recipe, {int? epoch, bool opened = true}) =>
      _db.transaction(() async {
        if (epoch != null && _db.clears != epoch) return;
        final row = CachedRecipesCompanion(
          id: Value(recipe.id),
          name: Value(recipe.name),
          imageUrl: Value(recipe.image?.toString()),
          updatedAt: Value(recipe.updatedAt),
          json: Value(jsonEncode(recipe.toJson())),
          lastOpenedAt: Value(_now().millisecondsSinceEpoch),
        );
        await _db
            .into(_db.cachedRecipes)
            .insert(
              row,
              onConflict: DoUpdate(
                (_) => opened
                    ? row
                    : row.copyWith(lastOpenedAt: const Value.absent()),
              ),
            );
        await _evict();
      });

  /// The stored recipe with [id], or `null`, without counting as opening
  /// it.
  Future<Recipe?> peek(int id) async {
    final query = _db.select(_db.cachedRecipes)..where((r) => r.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _decode(row);
  }

  /// The stored recipe with [id], marked as just opened, or `null`.
  Future<Recipe?> get(int id) async {
    final query = _db.select(_db.cachedRecipes)..where((r) => r.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    final recipe = await _decode(row);
    if (recipe != null) {
      await (_db.update(
        _db.cachedRecipes,
      )..where((r) => r.id.equals(id))).write(
        CachedRecipesCompanion(
          lastOpenedAt: Value(_now().millisecondsSinceEpoch),
        ),
      );
    }
    return recipe;
  }

  /// Whether the recipe with [id] is stored, as last changed at
  /// [updatedAt] if given. Doesn't count as opening it.
  Future<bool> has(int id, {DateTime? updatedAt}) async {
    final recipe = await peek(id);
    if (recipe == null) return false;
    if (updatedAt == null) return true;
    final stored = recipe.updatedAt;
    return stored != null && stored.isAtSameMomentAs(updatedAt);
  }

  /// Every stored recipe, the most recently opened first.
  Future<List<Recipe>> all() async {
    final query = _db.select(_db.cachedRecipes)
      ..orderBy([(r) => OrderingTerm.desc(r.lastOpenedAt)]);
    return [for (final row in await query.get()) ?await _decode(row)];
  }

  /// Deletes the recipe with [id], e.g. after the server says it is gone.
  Future<void> remove(int id) => _db.transaction(() async {
    await (_db.delete(_db.cachedRecipes)..where((r) => r.id.equals(id))).go();
    await _evict();
  });

  /// Whether the image at [url] is stored.
  Future<bool> hasImage(Uri url) async {
    final query = _db.selectOnly(_db.cachedImages)
      ..addColumns([_db.cachedImages.url])
      ..where(_db.cachedImages.url.equals(url.toString()));
    return await query.getSingleOrNull() != null;
  }

  /// Stores the image at [url] if a stored recipe still uses it. With an
  /// [epoch], only if the cache wasn't cleared since.
  Future<void> putImage(Uri url, Uint8List bytes, {int? epoch}) =>
      _db.transaction(() async {
        if (epoch != null && _db.clears != epoch) return;
        final users = _db.selectOnly(_db.cachedRecipes)
          ..addColumns([_db.cachedRecipes.id])
          ..where(_db.cachedRecipes.imageUrl.equals(url.toString()))
          ..limit(1);
        if (await users.getSingleOrNull() == null) return;
        await _db
            .into(_db.cachedImages)
            .insertOnConflictUpdate(
              CachedImagesCompanion(
                url: Value(url.toString()),
                bytes: Value(bytes),
              ),
            );
      });

  @override
  Future<Uint8List?> image(Uri url) async {
    final query = _db.select(_db.cachedImages)
      ..where((i) => i.url.equals(url.toString()));
    return (await query.getSingleOrNull())?.bytes;
  }

  @override
  Future<void> clear() {
    // Before the transaction starts: writes that read the server before
    // this are dropped, even if they come first.
    _db.clears++;
    return _clearTables();
  }

  Future<void> _clearTables() => _db.transaction(() async {
    // Every table: saved searches, meal plans and the shopping list too.
    // The editor's drafts aren't
    // cached server content; DraftStore.clear deletes them.
    for (final table in _db.allTables) {
      if (table.actualTableName == _db.editorDrafts.actualTableName) continue;
      await _db.delete(table).go();
    }
  });

  /// The recipe in [row], or `null` (and the row deleted) if it can't be
  /// read, which only happens if a model changed without a new cache version.
  Future<Recipe?> _decode(CachedRecipeRow row) async {
    try {
      return Recipe.fromJson(jsonDecode(row.json) as Map<String, dynamic>);
    } on Object {
      await (_db.delete(
        _db.cachedRecipes,
      )..where((r) => r.id.equals(row.id))).go();
      return null;
    }
  }

  Future<void> _evict() async {
    final recipes = _db.cachedRecipes;
    final kept = _db.selectOnly(recipes)
      ..addColumns([recipes.id])
      ..orderBy([OrderingTerm.desc(recipes.lastOpenedAt)])
      ..limit(maxRecipes);
    await (_db.delete(recipes)..where((r) => r.id.isNotInQuery(kept))).go();

    final usedImages = _db.selectOnly(recipes)
      ..addColumns([recipes.imageUrl])
      ..where(recipes.imageUrl.isNotNull());
    await (_db.delete(
      _db.cachedImages,
    )..where((i) => i.url.isNotInQuery(usedImages))).go();
  }
}

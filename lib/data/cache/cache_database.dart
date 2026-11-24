import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'cache_database.g.dart';

/// Recipes the user has opened, as JSON of the domain [Recipe] model.
///
/// Not a mirror of Tandoor's schema: a change to the domain model only needs
/// a new [CacheDatabase.schemaVersion], which drops the stored rows.
@DataClassName('CachedRecipeRow')
class CachedRecipes extends Table {
  @override
  String get tableName => 'cached_recipe';

  IntColumn get id => integer()();
  TextColumn get name => text()();

  /// `Recipe.image`, to find the images no recipe uses any more.
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get json => text()();

  /// Milliseconds since the epoch; the least recently opened go first.
  IntColumn get lastOpenedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Images of cached recipes, by URL.
@DataClassName('CachedImageRow')
class CachedImages extends Table {
  @override
  String get tableName => 'cached_image';

  TextColumn get url => text()();
  BlobColumn get bytes => blob()();

  @override
  Set<Column<Object>> get primaryKey => {url};
}

/// The user's saved searches, so they can be applied offline.
@DataClassName('CachedSavedFilterRow')
class CachedSavedFilters extends Table {
  @override
  String get tableName => 'cached_saved_filter';

  IntColumn get id => integer()();
  TextColumn get name => text()();

  /// The search as the `search` JSON of a saved search, `null` for one the
  /// filter chips can't show (`SavedFilter.query`).
  TextColumn get search => text().nullable()();
  BoolColumn get own => boolean()();

  /// The position in the list.
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The meal plans of the days the planner showed, as JSON of a list of the
/// domain `MealPlan` model, by the days asked for.
@DataClassName('CachedMealPlansRow')
class CachedMealPlans extends Table {
  @override
  String get tableName => 'cached_meal_plans';

  /// The first and last day asked for, as `CalendarDay.toString`.
  TextColumn get fromDay => text()();
  TextColumn get toDay => text()();
  TextColumn get json => text()();

  /// When they were read from the server, in milliseconds since the epoch;
  /// the oldest go first.
  IntColumn get storedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {fromDay, toDay};
}

/// The entries of the shopping list as last read from the server (with the
/// changes made on this device since that the server accepted), as JSON of
/// the domain `ShoppingEntry` model. The rest of the list is in
/// [CachedValues] (`ShoppingCache`).
@DataClassName('CachedShoppingEntryRow')
class CachedShoppingEntries extends Table {
  @override
  String get tableName => 'cached_shopping_entry';

  IntColumn get id => integer()();

  /// The position in the list, as the server sent it.
  IntColumn get position => integer()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Single values stored for offline use, as JSON by key.
@DataClassName('CachedValueRow')
class CachedValues extends Table {
  @override
  String get tableName => 'cached_value';

  TextColumn get key => text()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// The recipe editor's unsaved drafts (`DraftStore`), one per recipe.
///
/// Unlike the other tables, these are the user's own work and can't be
/// fetched again: [CacheDatabase.migration] keeps them when the cache's
/// version changes. Changing this table needs a real migration.
@DataClassName('EditorDraftRow')
class EditorDrafts extends Table {
  @override
  String get tableName => 'editor_draft';

  /// The recipe's id; [newRecipeDraftId] for a new recipe.
  IntColumn get recipeId => integer()();

  /// The `RecipeDraft` as JSON.
  TextColumn get json => text()();
  DateTimeColumn get savedAt => dateTime()();

  /// `StoredDraft.baseUpdatedAt` in microseconds since the epoch: exact,
  /// to compare with the recipe's (a date time column keeps only seconds).
  IntColumn get baseUpdatedAt => integer().nullable()();

  /// A photo chosen to replace the recipe's, with its name and type.
  BlobColumn get imageBytes => blob().nullable()();
  TextColumn get imageFileName => text().nullable()();
  TextColumn get imageMimeType => text().nullable()();
  BoolColumn get removeImage => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {recipeId};
}

/// Shopping list check states set offline and not sent yet
/// (`ShoppingCheckCache`), one per entry.
///
/// Like the drafts, the user's own work: [CacheDatabase.migration] keeps
/// them when the cache's version changes. Changing this table needs a real
/// migration. Logout deletes them with the cached server content; a session
/// that ended because the token was rejected keeps them for the next login
/// to the same server.
@DataClassName('PendingShoppingCheckRow')
class PendingShoppingChecks extends Table {
  @override
  String get tableName => 'pending_shopping_check';

  /// The server the entry is on, as `TandoorConnection.serverUrl`.
  TextColumn get server => text()();

  /// The shopping list entry's id.
  IntColumn get entryId => integer()();

  /// The state to send: checked off, or back on the list.
  BoolColumn get checked => boolean()();

  /// When it was set, in microseconds since the epoch (UTC).
  IntColumn get at => integer()();

  @override
  Set<Column<Object>> get primaryKey => {server, entryId};
}

/// The [EditorDrafts] key of a new recipe's draft; Tandoor's ids start at 1.
const newRecipeDraftId = 0;

/// The offline cache, the editor's drafts and the shopping check-offs still
/// to be sent. Everything but those two can be fetched again, so migrations
/// start over instead of converting rows.
@DriftDatabase(
  tables: [
    CachedRecipes,
    CachedImages,
    CachedSavedFilters,
    CachedMealPlans,
    CachedShoppingEntries,
    CachedValues,
    EditorDrafts,
    PendingShoppingChecks,
  ],
)
class CacheDatabase extends _$CacheDatabase {
  CacheDatabase(super.executor);

  /// How many times the cache was cleared (`RecipeCache.clear`) since the
  /// database was opened. Server content read before a clear, e.g. for the
  /// user who just logged out, must not be stored after it: writers note
  /// this before they ask the server and store nothing once it changed.
  var clears = 0;

  /// How many of the [clears] also deleted the shopping check-offs not sent
  /// yet (`ShoppingCheckCache`), which a session ended by a rejected token
  /// keeps.
  var queueClears = 0;

  /// The database on the device: IndexedDB or OPFS through a worker on the
  /// web (`web/drift_worker.js`, `web/sqlite3.wasm`), a file in the app's
  /// support directory on native platforms.
  factory CacheDatabase.open() => CacheDatabase(
    driftDatabase(
      name: 'yumdoor_cache',
      web: DriftWebOptions(
        // Relative to the base href, so the app works under any path.
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );

  /// Bump this whenever a cached domain model (`Recipe`, `MealPlan`,
  /// `ShoppingEntry`, `Supermarket` and the models in them) or a table
  /// changes; opening the database then drops all rows but the drafts and
  /// the pending check-offs.
  @override
  int get schemaVersion => 5;

  /// The first [schemaVersion] with [PendingShoppingChecks].
  static const firstQueueVersion = 5;

  /// The tables of the user's own work, which a version change keeps.
  Set<String> get userTables => {
    editorDrafts.actualTableName,
    pendingShoppingChecks.actualTableName,
  };

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Drift calls this for downgrades too, e.g. after rolling back the app.
    onUpgrade: (migrator, from, to) async {
      for (final table in allTables) {
        // Drafts and pending check-offs can't be fetched again: their
        // tables are only created if they are missing (e.g. coming from a
        // version before them), even after a rollback to such a version. A
        // draft that no longer decodes is dropped when it is read
        // (DraftCache).
        if (userTables.contains(table.actualTableName)) {
          await migrator.createTable(table);
          // A version before the queue ran since its rows were stored, and
          // its logout didn't clear them: they may be another session's.
          if (table.actualTableName == pendingShoppingChecks.actualTableName &&
              from < firstQueueVersion) {
            await delete(pendingShoppingChecks).go();
          }
          continue;
        }
        await migrator.deleteTable(table.actualTableName);
        await migrator.createTable(table);
      }
    },
  );
}

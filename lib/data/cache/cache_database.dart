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

/// The offline cache. Everything in it can be fetched again, so migrations
/// start over instead of converting rows.
@DriftDatabase(tables: [CachedRecipes, CachedImages])
class CacheDatabase extends _$CacheDatabase {
  CacheDatabase(super.executor);

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

  /// Bump this whenever a cached domain model (`Recipe` and the models in
  /// it) or a table changes; opening the database then drops all rows.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Drift calls this for downgrades too, e.g. after rolling back the app.
    onUpgrade: (migrator, from, to) async {
      for (final table in allTables) {
        await migrator.deleteTable(table.actualTableName);
        await migrator.createTable(table);
      }
    },
  );
}

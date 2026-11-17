import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/image_upload.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/models/stored_draft.dart';
import '../../domain/repositories/draft_store.dart';
import 'cache_database.dart';

/// Keeps the editor's drafts in the [CacheDatabase], so logout's
/// `RecipeCache.clear` deletes them too.
class DraftCache implements DraftStore {
  DraftCache(this._db);

  final CacheDatabase _db;

  static int _key(int? recipeId) => recipeId ?? newRecipeDraftId;

  @override
  Future<StoredDraft?> load(int? recipeId) async {
    final query = _db.select(_db.editorDrafts)
      ..where((d) => d.recipeId.equals(_key(recipeId)));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    try {
      final bytes = row.imageBytes;
      final fileName = row.imageFileName;
      final mimeType = row.imageMimeType;
      return StoredDraft(
        draft: RecipeDraft.fromJson(
          jsonDecode(row.json) as Map<String, dynamic>,
        ),
        savedAt: row.savedAt,
        newImage: bytes != null && fileName != null && mimeType != null
            ? ImageUpload(bytes: bytes, fileName: fileName, mimeType: mimeType)
            : null,
        removeImage: row.removeImage,
      );
    } on Object {
      // Only if RecipeDraft changed in a way its JSON doesn't follow.
      await delete(recipeId);
      return null;
    }
  }

  @override
  Future<void> save(int? recipeId, StoredDraft draft) => _db
      .into(_db.editorDrafts)
      .insertOnConflictUpdate(
        EditorDraftsCompanion(
          recipeId: Value(_key(recipeId)),
          json: Value(jsonEncode(draft.draft.toJson())),
          savedAt: Value(draft.savedAt),
          imageBytes: Value(draft.newImage?.bytes),
          imageFileName: Value(draft.newImage?.fileName),
          imageMimeType: Value(draft.newImage?.mimeType),
          removeImage: Value(draft.removeImage),
        ),
      );

  @override
  Future<void> delete(int? recipeId) => (_db.delete(
    _db.editorDrafts,
  )..where((d) => d.recipeId.equals(_key(recipeId)))).go();

  @override
  Future<void> clear() => _db.delete(_db.editorDrafts).go();
}

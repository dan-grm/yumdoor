import '../models/stored_draft.dart';

/// The recipe editor's unsaved drafts on the device: one per recipe, and one
/// for a new recipe (`recipeId` `null`).
///
/// Drafts are the user's own work, but they belong to the session: logout
/// deletes them with the offline cache.
abstract interface class DraftStore {
  /// The draft for [recipeId], or `null` if there is none or it can't be
  /// read any more.
  Future<StoredDraft?> load(int? recipeId);

  /// Stores [draft] for [recipeId], replacing an older one.
  Future<void> save(int? recipeId, StoredDraft draft);

  /// Deletes the draft for [recipeId], if any.
  Future<void> delete(int? recipeId);

  /// Deletes every draft, e.g. on logout.
  Future<void> clear();
}

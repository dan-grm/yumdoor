import '../models/stored_draft.dart';

/// The recipe editor's unsaved drafts on the device: one per recipe, and one
/// for a new recipe (`recipeId` `null`).
///
/// Drafts are the user's own work, but they belong to the session: logout
/// deletes them ([clear]).
abstract interface class DraftStore {
  /// The draft for [recipeId], or `null` if there is none or it can't be
  /// read any more.
  Future<StoredDraft?> load(int? recipeId);

  /// Stores [draft] for [recipeId], replacing an older one.
  ///
  /// Without [imageChanged], the stored draft's photo is kept as it is
  /// rather than written again, if there is a stored draft.
  Future<void> save(
    int? recipeId,
    StoredDraft draft, {
    bool imageChanged = true,
  });

  /// Deletes the draft for [recipeId], if any.
  Future<void> delete(int? recipeId);

  /// Deletes every draft, e.g. on logout.
  Future<void> clear();
}

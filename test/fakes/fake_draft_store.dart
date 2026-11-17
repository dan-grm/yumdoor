import 'package:yumdoor/domain/models/stored_draft.dart';
import 'package:yumdoor/domain/repositories/draft_store.dart';

/// [DraftStore] in memory, by recipe id (`null` for a new recipe).
class FakeDraftStore implements DraftStore {
  FakeDraftStore([Map<int?, StoredDraft>? drafts]) : drafts = drafts ?? {};

  final Map<int?, StoredDraft> drafts;
  int clearCount = 0;

  @override
  Future<StoredDraft?> load(int? recipeId) async => drafts[recipeId];

  /// How often [save] wrote the photo.
  int imageWrites = 0;

  @override
  Future<void> save(
    int? recipeId,
    StoredDraft draft, {
    bool imageChanged = true,
  }) async {
    final old = drafts[recipeId];
    if (!imageChanged && old != null) {
      drafts[recipeId] = StoredDraft(
        draft: draft.draft,
        savedAt: draft.savedAt,
        baseUpdatedAt: draft.baseUpdatedAt,
        newImage: old.newImage,
        removeImage: draft.removeImage,
      );
      return;
    }
    if (draft.newImage != null) imageWrites++;
    drafts[recipeId] = draft;
  }

  @override
  Future<void> delete(int? recipeId) async => drafts.remove(recipeId);

  @override
  Future<void> clear() async {
    clearCount++;
    drafts.clear();
  }
}

import 'image_upload.dart';
import 'recipe_draft.dart';

/// Unsaved changes from the recipe editor, kept on the device so a reload, a
/// crash or lost connectivity doesn't throw them away.
///
/// Everything the editor changes: the [draft] of all tabs and the photo
/// ([newImage], [removeImage]).
final class StoredDraft {
  const StoredDraft({
    required this.draft,
    required this.savedAt,
    this.baseUpdatedAt,
    this.newImage,
    this.removeImage = false,
  });

  final RecipeDraft draft;

  /// A photo chosen to replace the recipe's, not uploaded yet.
  final ImageUpload? newImage;

  /// Whether the recipe's photo is to be removed.
  final bool removeImage;

  /// When the draft was stored.
  final DateTime savedAt;

  /// When the recipe the draft started from was last changed on the server
  /// (`Recipe.updatedAt`); `null` for a new recipe. A recipe changed since
  /// has changes the draft would overwrite.
  final DateTime? baseUpdatedAt;
}

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/image_upload.dart';
import '../../domain/models/keyword.dart';
import '../../domain/models/parsed_ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/models/stored_draft.dart';
import '../../domain/repositories/draft_store.dart';
import '../../domain/services/recipe_draft_validation.dart';
import '../recipe/recipe_providers.dart';
import '../search/search_providers.dart';

part 'editor_controller.g.dart';

/// What the recipe editor shows: the draft being edited and how saving it
/// went.
final class EditorState {
  const EditorState({
    required this.draft,
    this.original = const RecipeDraft(),
    this.recipeId,
    this.recipeName,
    this.updatedAt,
    this.saving = false,
    this.failure,
    this.showProblems = false,
    this.savedImage,
    this.newImage,
    this.removeImage = false,
    this.imageFailure,
    this.offeredDraft,
  });

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

  /// The draft as the recipe is saved: as loaded, or as last saved from
  /// here. An empty draft for a new recipe.
  final RecipeDraft original;

  /// When the recipe was last changed on the server, as loaded.
  final DateTime? updatedAt;

  /// A draft from an earlier visit with changes that weren't saved, until
  /// the user restores ([RecipeEditor.restoreDraft]) or discards
  /// ([RecipeEditor.discardDraft]) it. Not overwritten meanwhile.
  final StoredDraft? offeredDraft;

  /// Whether the offered draft is older than the recipe on the server, which
  /// was changed after it was stored.
  bool get offeredDraftIsStale => switch ((offeredDraft, updatedAt)) {
    (final draft?, final updatedAt?) => draft.savedAt.isBefore(updatedAt),
    _ => false,
  };

  /// Whether there are changes that saving would send: to the draft or the
  /// photo.
  bool get isDirty => draft != original || newImage != null || removeImage;

  /// The recipe's photo as it was loaded.
  final Uri? savedImage;

  /// A photo chosen to replace [savedImage], uploaded on save.
  final ImageUpload? newImage;

  /// Whether saving removes [savedImage], unless there is a [newImage] to
  /// replace it.
  final bool removeImage;

  /// Why the photo wasn't saved by the last save, which saved the recipe
  /// itself.
  final Failure? imageFailure;

  /// Whether the recipe will have a photo after saving: [newImage], or
  /// [savedImage] unless it is removed.
  bool get hasImage => newImage != null || (savedImage != null && !removeImage);

  /// The recipe's name as it was loaded, for the header; `null` for a new
  /// recipe.
  final String? recipeName;
  final RecipeDraft draft;

  /// While a save is under way. The form can't be saved again meanwhile.
  final bool saving;

  /// Why the last save failed, until the next try.
  final Failure? failure;

  /// Whether [problems] are shown at their fields: after the first try to
  /// save a draft that has some, so an empty new form isn't all red.
  final bool showProblems;

  /// What keeps the draft from being saved; see [validateDraft].
  Map<DraftField, DraftProblem> get problems => validateDraft(draft);

  EditorState _copyWith({
    RecipeDraft? draft,
    RecipeDraft? original,
    bool? saving,
    Failure? Function()? failure,
    bool? showProblems,
    Uri? Function()? savedImage,
    ImageUpload? Function()? newImage,
    bool? removeImage,
    Failure? Function()? imageFailure,
    StoredDraft? Function()? offeredDraft,
  }) => EditorState(
    recipeId: recipeId,
    recipeName: recipeName,
    updatedAt: updatedAt,
    draft: draft ?? this.draft,
    original: original ?? this.original,
    offeredDraft: offeredDraft != null ? offeredDraft() : this.offeredDraft,
    saving: saving ?? this.saving,
    failure: failure != null ? failure() : this.failure,
    showProblems: showProblems ?? this.showProblems,
    savedImage: savedImage != null ? savedImage() : this.savedImage,
    newImage: newImage != null ? newImage() : this.newImage,
    removeImage: removeImage ?? this.removeImage,
    imageFailure: imageFailure != null ? imageFailure() : this.imageFailure,
  );
}

/// The recipe editor's state: the single source for all its tabs.
///
/// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
/// the recipe fresh from the server and fails with [OfflineFailure] rather
/// than edit a cached copy; failures are shown with a retry button instead
/// of retrying on their own.
///
/// Saving overwrites the recipe as it is on the server: the last save wins,
/// without checking for changes made elsewhere meanwhile, like Tandoor's own
/// editor (decided in M3, docs/ROADMAP.md).
///
/// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
/// change, and when the editor closes), one draft per recipe and one for a
/// new recipe. Loading offers a stored draft that differs from the recipe
/// ([EditorState.offeredDraft]); saving deletes it, and so does
/// [discardChanges].
@Riverpod(retry: _noRetry)
class RecipeEditor extends _$RecipeEditor {
  /// How long after the last change the draft is stored.
  static const draftDelay = Duration(seconds: 1);

  late DraftStore _drafts;
  late DateTime Function() _clock;
  Timer? _draftTimer;

  /// The state to store as draft when [_draftTimer] fires.
  EditorState? _pendingDraft;

  @override
  Future<EditorState> build(int? recipeId) async {
    _drafts = ref.read(draftStoreProvider);
    _clock = ref.read(clockProvider);
    // Leaving the editor right after a change keeps it all the same.
    ref.onDispose(() => unawaited(flushDraft()));
    final stored = _loadDraft(recipeId);
    if (recipeId == null) {
      return _offer(const EditorState(draft: RecipeDraft()), await stored);
    }
    // Not the offline copy: it may be old, and saving it later would undo
    // newer changes on the server.
    final recipe = await ref
        .read(recipeRepositoryProvider)
        .fetchRecipe(recipeId, allowCached: false);
    final draft = RecipeDraft.fromRecipe(recipe);
    return _offer(
      EditorState(
        recipeId: recipeId,
        recipeName: recipe.name,
        updatedAt: recipe.updatedAt,
        draft: draft,
        original: draft,
        savedImage: recipe.image,
      ),
      await stored,
    );
  }

  /// The stored draft for [recipeId]; `null` if it can't be read, which
  /// mustn't keep the editor from opening.
  Future<StoredDraft?> _loadDraft(int? recipeId) async {
    try {
      return await _drafts.load(recipeId);
    } on Object {
      return null;
    }
  }

  /// [state] offering [stored] if it has changes; a draft without any is
  /// deleted.
  EditorState _offer(EditorState state, StoredDraft? stored) {
    if (stored == null) return state;
    final changed =
        stored.draft != state.original ||
        stored.newImage != null ||
        (stored.removeImage && state.savedImage != null);
    if (!changed) {
      unawaited(_deleteDraft(state.recipeId));
      return state;
    }
    return state._copyWith(offeredDraft: () => stored);
  }

  /// Continues with the offered draft: its changes replace the loaded
  /// recipe's.
  void restoreDraft() {
    final current = state.value;
    final stored = current?.offeredDraft;
    if (current == null || stored == null || current.saving) return;
    state = AsyncData(
      current._copyWith(
        draft: stored.draft,
        newImage: () => stored.newImage,
        removeImage: stored.removeImage && current.savedImage != null,
        offeredDraft: () => null,
      ),
    );
  }

  /// Deletes the offered draft and continues with the recipe as loaded.
  void discardDraft() {
    final current = state.value;
    if (current?.offeredDraft == null) return;
    state = AsyncData(current!._copyWith(offeredDraft: () => null));
    unawaited(_deleteDraft(recipeId));
  }

  /// Deletes the draft of the changes made here, for leaving without
  /// saving them. Changes made afterwards are stored again.
  Future<void> discardChanges() async {
    _draftTimer?.cancel();
    _pendingDraft = null;
    await _deleteDraft(recipeId);
  }

  /// Stores the draft now if a change is waiting for [draftDelay], e.g.
  /// when the app is hidden and may be closed.
  Future<void> flushDraft() async {
    _draftTimer?.cancel();
    final pending = _pendingDraft;
    _pendingDraft = null;
    if (pending == null || pending.offeredDraft != null) return;
    try {
      if (pending.isDirty) {
        await _drafts.save(
          pending.recipeId,
          StoredDraft(
            draft: pending.draft,
            newImage: pending.newImage,
            removeImage: pending.removeImage,
            savedAt: _clock(),
          ),
        );
      } else {
        await _drafts.delete(pending.recipeId);
      }
    } on Object {
      // The draft is a safety net; editing goes on without it.
    }
  }

  Future<void> _deleteDraft(int? recipeId) async {
    try {
      await _drafts.delete(recipeId);
    } on Object {
      // A draft left behind is offered again, and can be discarded then.
    }
  }

  /// Changes the draft. Ignored while loading or saving; returns whether
  /// the change was made.
  bool edit(RecipeDraft Function(RecipeDraft draft) change) =>
      _change((state) => state._copyWith(draft: change(state.draft)));

  /// Makes [image] the recipe's photo when it is saved. Ignored while
  /// loading or saving.
  void setImage(ImageUpload image) =>
      _change((state) => state._copyWith(newImage: () => image));

  /// Drops the photo chosen with [setImage], back to what was there before
  /// (the saved photo, or none if it was removed); without one, removes the
  /// saved photo when the recipe is saved. Ignored while loading or saving.
  void removeImage() => _change(
    (state) => state.newImage != null
        ? state._copyWith(newImage: () => null)
        : state._copyWith(removeImage: state.savedImage != null),
  );

  /// Changes the state with [change]. Ignored while loading or saving;
  /// returns whether the change was made.
  bool _change(EditorState Function(EditorState state) change) {
    final current = state.value;
    if (current == null || current.saving) return false;
    final changed = change(current);
    state = AsyncData(changed);
    _pendingDraft = changed;
    _draftTimer?.cancel();
    _draftTimer = Timer(draftDelay, () => unawaited(flushDraft()));
    return true;
  }

  /// Adds [keyword] to the draft unless it is there already.
  void addKeyword(Keyword keyword) => edit(
    (draft) => draft.keywords.any((k) => k.id == keyword.id)
        ? draft
        : draft.copyWith(
            keywords: [...draft.keywords, NamedRef.keyword(keyword)],
          ),
  );

  /// Removes the keyword at [index] from the draft.
  void removeKeywordAt(int index) => edit(
    (draft) => draft.copyWith(keywords: [...draft.keywords]..removeAt(index)),
  );

  /// Parses [line] with Tandoor's ingredient parser and adds the result to
  /// the step at [step], or to the last step if `null` (decided in M3,
  /// docs/ROADMAP.md). Returns what was added, or `null` if [line] is blank
  /// or the draft can't be changed (loading, saving).
  ///
  /// A line the parser can't split is added all the same, with its text as
  /// note and no food ([ParsedIngredient.unparsed]). Throws the [Failure] of
  /// a request that fails (offline, …); nothing is added then.
  Future<IngredientDraft?> addLine(String line, {int? step}) async {
    if (line.trim().isEmpty) return null;
    final current = state.value;
    if (current == null || current.saving) return null;
    final parsed = await ref.read(ingredientParserProvider).parse(line);
    if (!ref.mounted) return null;
    final ingredient = parsed.toDraft();
    final added = edit((draft) => draft.addIngredient(ingredient, step: step));
    return added ? ingredient : null;
  }

  /// Registers [finish] to be awaited by [save] before it saves: an
  /// ingredient entry adds the line typed into it (or still being parsed)
  /// and returns whether that worked. Returns the function that unregisters
  /// it.
  ///
  /// So a line typed right before "Speichern" is saved too, and a line that
  /// can't be added stops the save, with the entry saying why, instead of
  /// being lost.
  void Function() addPendingLine(Future<bool> Function() finish) {
    _pendingLines.add(finish);
    return () => _pendingLines.remove(finish);
  }

  final _pendingLines = <Future<bool> Function()>{};

  /// Adds a section header with [title] at the end of the step at [step],
  /// or of the last step if `null`. A blank title adds nothing.
  void addHeader(String title, {int? step}) {
    if (title.trim().isEmpty) return;
    edit(
      (draft) => draft.addIngredient(IngredientDraft.header(title), step: step),
    );
  }

  /// Replaces the ingredient at [index] of the step at [step].
  void updateIngredient(int step, int index, IngredientDraft ingredient) =>
      edit((draft) => draft.replaceIngredient(step, index, ingredient));

  /// Removes the ingredient at [index] of the step at [step].
  void removeIngredient(int step, int index) =>
      edit((draft) => draft.removeIngredient(step, index));

  /// Moves the ingredient at [index] of the step at [step] by [offset]
  /// places within the step (-1 up, 1 down); not past its ends.
  void moveIngredient(int step, int index, int offset) =>
      edit((draft) => draft.moveIngredient(step, index, index + offset));

  /// Adds an empty step at the end.
  void addStep() => edit((draft) => draft.addStep());

  /// Removes the step at [index] with its ingredients.
  void removeStep(int index) => edit((draft) => draft.removeStep(index));

  /// Moves the step at [index] by [offset] places (-1 up, 1 down); not past
  /// the ends.
  void moveStep(int index, int offset) =>
      edit((draft) => draft.moveStep(index, index + offset));

  /// Moves the step at [index] to place [to].
  void reorderStep(int index, int to) =>
      edit((draft) => draft.moveStep(index, to));

  /// Sets the instruction of the step at [index].
  void setStepInstruction(int index, String instruction) => edit(
    (draft) =>
        draft.changeStep(index, (s) => s.copyWith(instruction: instruction)),
  );

  /// Sets the name of the step at [index].
  void setStepName(int index, String name) =>
      edit((draft) => draft.changeStep(index, (s) => s.copyWith(name: name)));

  /// Sets the explicit duration of the step at [index], in whole minutes;
  /// [Duration.zero] for none.
  void setStepTime(int index, Duration time) => edit(
    (draft) => draft.changeStep(
      index,
      (s) => s.copyWith(time: Duration(minutes: time.inMinutes)),
    ),
  );

  /// Moves the ingredient at [index] of the step at [from] to the end of the
  /// step at [to].
  void moveIngredientToStep(int from, int index, int to) =>
      edit((draft) => draft.moveIngredientToStep(from, index, to));

  /// Saves the draft, creating the recipe if it is new, and returns it as
  /// saved. Returns `null` if the draft has problems, which are then shown
  /// at their fields, or if saving failed ([EditorState.failure]), or while
  /// another save is under way.
  ///
  /// Then uploads or removes the photo ([setImage], [removeImage]). If that
  /// fails, the recipe is saved all the same and returned, and
  /// [EditorState.imageFailure] says why the photo isn't. Once the recipe is
  /// saved, its stored draft is deleted.
  ///
  /// Adds the lines typed into ingredient entries first
  /// ([addPendingLine]); returns `null` without saving if one can't be
  /// added.
  Future<Recipe?> save() async {
    if (state.value?.saving ?? true) return null;
    for (final finish in [..._pendingLines]) {
      final added = await finish();
      if (!ref.mounted || !added) return null;
    }
    final current = state.value;
    if (current == null || current.saving) return null;
    if (current.problems.isNotEmpty) {
      state = AsyncData(
        current._copyWith(showProblems: true, failure: () => null),
      );
      return null;
    }
    // What the last save said no longer applies.
    final base = current._copyWith(
      showProblems: true,
      failure: () => null,
      imageFailure: () => null,
    );
    state = AsyncData(base._copyWith(saving: true));
    final draft = current.draft.copyWith(name: current.draft.name.trim());
    final repository = ref.read(recipeRepositoryProvider);
    Recipe saved;
    try {
      saved = switch (current.recipeId) {
        final id? => await repository.updateRecipe(id, draft),
        null => await repository.createRecipe(draft),
      };
    } on Object catch (error) {
      // Anything else, too: a save stuck in `saving` would lock the editor.
      if (ref.mounted) {
        state = AsyncData(
          base._copyWith(saving: false, failure: () => _asFailure(error)),
        );
      }
      return null;
    }
    // The photo goes in a request of its own, once the recipe exists.
    Failure? imageFailure;
    try {
      if (current.newImage case final image?) {
        final url = await repository.uploadImage(saved.id, image);
        saved = saved.copyWith(image: url);
      } else if (current.removeImage && saved.image != null) {
        await repository.removeImage(saved.id);
        saved = saved.copyWith(image: null);
      }
    } on Object catch (error) {
      // The recipe is saved all the same; the screen says the photo isn't.
      imageFailure = _asFailure(error);
    }
    // Saved: the draft has done its job. A failed photo change is dropped
    // with it (see below).
    await discardChanges();
    if (ref.mounted) {
      // Screens showing the recipe load it again, as saved.
      ref
        ..invalidate(recipeProvider(saved.id))
        ..invalidate(searchResultsProvider);
      // A failed photo change is dropped too: the screen leaves and says it
      // wasn't saved (a new recipe saved again from here would be created
      // twice).
      state = AsyncData(
        base._copyWith(
          saving: false,
          original: current.draft,
          imageFailure: () => imageFailure,
          savedImage: () => saved.image,
          newImage: () => null,
          removeImage: false,
        ),
      );
    }
    return saved;
  }
}

/// [error] as a [Failure]; anything else as a [ServerFailure].
Failure _asFailure(Object error) =>
    error is Failure ? error : ServerFailure(cause: error);

Duration? _noRetry(int retryCount, Object error) => null;

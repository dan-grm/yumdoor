import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/image_upload.dart';
import '../../domain/models/keyword.dart';
import '../../domain/models/parsed_ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/services/recipe_draft_validation.dart';
import '../recipe/recipe_providers.dart';
import '../search/search_providers.dart';

part 'editor_controller.g.dart';

/// What the recipe editor shows: the draft being edited and how saving it
/// went.
final class EditorState {
  const EditorState({
    required this.draft,
    this.recipeId,
    this.recipeName,
    this.saving = false,
    this.failure,
    this.showProblems = false,
    this.savedImage,
    this.newImage,
    this.removeImage = false,
    this.imageFailure,
  });

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

  /// The recipe's photo as it was loaded.
  final Uri? savedImage;

  /// A photo chosen to replace [savedImage], uploaded on save.
  final ImageUpload? newImage;

  /// Whether saving removes [savedImage] (and there is no [newImage]).
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
    bool? saving,
    Failure? Function()? failure,
    bool? showProblems,
    Uri? Function()? savedImage,
    ImageUpload? Function()? newImage,
    bool? removeImage,
    Failure? Function()? imageFailure,
  }) => EditorState(
    recipeId: recipeId,
    recipeName: recipeName,
    draft: draft ?? this.draft,
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
@Riverpod(retry: _noRetry)
class RecipeEditor extends _$RecipeEditor {
  @override
  Future<EditorState> build(int? recipeId) async {
    if (recipeId == null) return const EditorState(draft: RecipeDraft());
    // Not the offline copy: it may be old, and saving it later would undo
    // newer changes on the server.
    final recipe = await ref
        .read(recipeRepositoryProvider)
        .fetchRecipe(recipeId, allowCached: false);
    return EditorState(
      recipeId: recipeId,
      recipeName: recipe.name,
      draft: RecipeDraft.fromRecipe(recipe),
      savedImage: recipe.image,
    );
  }

  /// Changes the draft. Ignored while loading or saving; returns whether
  /// the change was made.
  bool edit(RecipeDraft Function(RecipeDraft draft) change) {
    final current = state.value;
    if (current == null || current.saving) return false;
    state = AsyncData(current._copyWith(draft: change(current.draft)));
    return true;
  }

  /// Makes [image] the recipe's photo when it is saved. Ignored while
  /// loading or saving.
  void setImage(ImageUpload image) => _change(
    (state) => state._copyWith(newImage: () => image, removeImage: false),
  );

  /// Removes the recipe's photo when it is saved: the one chosen, or the
  /// one it had. Ignored while loading or saving.
  void removeImage() => _change(
    (state) => state._copyWith(
      newImage: () => null,
      removeImage: state.savedImage != null,
    ),
  );

  void _change(EditorState Function(EditorState state) change) {
    final current = state.value;
    if (current == null || current.saving) return;
    state = AsyncData(change(current));
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
  /// [EditorState.imageFailure] says why the photo isn't.
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
    state = AsyncData(
      current._copyWith(
        saving: true,
        showProblems: true,
        failure: () => null,
        imageFailure: () => null,
      ),
    );
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
      final failure = error is Failure ? error : ServerFailure(cause: error);
      if (ref.mounted) {
        state = AsyncData(
          current._copyWith(saving: false, failure: () => failure),
        );
      }
      return null;
    }
    // The photo goes in a request of its own, once the recipe exists.
    Failure? imageFailure;
    try {
      if (current.newImage case final image?) {
        saved = await repository.uploadImage(saved.id, image);
      } else if (current.removeImage && saved.image != null) {
        saved = await repository.removeImage(saved.id);
      }
    } on Object catch (error) {
      // The recipe is saved all the same; the screen says the photo isn't.
      imageFailure = error is Failure ? error : ServerFailure(cause: error);
    }
    if (ref.mounted) {
      // Screens showing the recipe load it again, as saved.
      ref
        ..invalidate(recipeProvider(saved.id))
        ..invalidate(searchResultsProvider);
      state = AsyncData(
        imageFailure == null
            ? current._copyWith(
                saving: false,
                failure: () => null,
                savedImage: () => saved.image,
                newImage: () => null,
                removeImage: false,
              )
            : current._copyWith(
                saving: false,
                failure: () => null,
                imageFailure: () => imageFailure,
              ),
      );
    }
    return saved;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

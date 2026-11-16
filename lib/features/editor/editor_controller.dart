import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
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
  });

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

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
  }) => EditorState(
    recipeId: recipeId,
    recipeName: recipeName,
    draft: draft ?? this.draft,
    saving: saving ?? this.saving,
    failure: failure != null ? failure() : this.failure,
    showProblems: showProblems ?? this.showProblems,
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
  ///
  /// A save started meanwhile waits for the line, so it isn't lost.
  Future<IngredientDraft?> addLine(String line, {int? step}) async {
    if (line.trim().isEmpty) return null;
    final current = state.value;
    if (current == null || current.saving) return null;
    final parsing = ref.read(ingredientParserProvider).parse(line);
    _parsing.add(parsing);
    final ParsedIngredient parsed;
    try {
      parsed = await parsing;
    } finally {
      _parsing.remove(parsing);
    }
    if (!ref.mounted) return null;
    final ingredient = parsed.toDraft();
    final added = edit((draft) => draft.addIngredient(ingredient, step: step));
    return added ? ingredient : null;
  }

  /// Lines being parsed by [addLine].
  final _parsing = <Future<ParsedIngredient>>{};

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

  /// Saves the draft, creating the recipe if it is new, and returns it as
  /// saved. Returns `null` if the draft has problems, which are then shown
  /// at their fields, or if saving failed ([EditorState.failure]), or while
  /// another save is under way.
  ///
  /// Waits for lines still being parsed ([addLine]) first, so they are
  /// saved with the draft.
  Future<Recipe?> save() async {
    while (_parsing.isNotEmpty) {
      // A line that fails isn't added; addLine's caller says so.
      await Future.wait([
        for (final parsing in _parsing)
          parsing.then<void>((_) {}, onError: (Object _) {}),
      ]);
      // addLine awaited each line first, so it has added it by now.
      if (!ref.mounted) return null;
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
      current._copyWith(saving: true, showProblems: true, failure: () => null),
    );
    final draft = current.draft.copyWith(name: current.draft.name.trim());
    final repository = ref.read(recipeRepositoryProvider);
    final Recipe saved;
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
    if (ref.mounted) {
      // Screens showing the recipe load it again, as saved.
      ref
        ..invalidate(recipeProvider(saved.id))
        ..invalidate(searchResultsProvider);
      state = AsyncData(current._copyWith(saving: false, failure: () => null));
    }
    return saved;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

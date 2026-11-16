import '../models/recipe_draft.dart';

/// The fields of a [RecipeDraft] that [validateDraft] checks.
enum DraftField { name, description, servings, servingsText, sourceUrl }

/// What is wrong with a [DraftField].
enum DraftProblem {
  /// Empty, or only spaces.
  missing,

  /// Longer than Tandoor stores ([draftMaxLengths]).
  tooLong,

  /// Below the smallest allowed value: servings must be at least 1.
  tooSmall,
}

/// The most characters Tandoor stores per text field (its model's
/// `max_length`, see the OpenAPI schema). Longer text is rejected with a 400.
const draftMaxLengths = {
  DraftField.name: 128,
  DraftField.description: 512,
  DraftField.servingsText: 32,
  DraftField.sourceUrl: 1024,
};

/// What keeps [draft] from being saved, by field; empty if it can be saved.
///
/// The name is checked as it will be saved, without surrounding spaces.
/// Working and waiting time can't be wrong: the editor only takes whole,
/// non-negative minutes.
Map<DraftField, DraftProblem> validateDraft(RecipeDraft draft) {
  final problems = <DraftField, DraftProblem>{};
  void checkLength(DraftField field, String? text) {
    if ((text?.length ?? 0) > draftMaxLengths[field]!) {
      problems[field] = DraftProblem.tooLong;
    }
  }

  final name = draft.name.trim();
  if (name.isEmpty) {
    problems[DraftField.name] = DraftProblem.missing;
  } else {
    checkLength(DraftField.name, name);
  }
  checkLength(DraftField.description, draft.description);
  if (draft.servings < 1) problems[DraftField.servings] = DraftProblem.tooSmall;
  checkLength(DraftField.servingsText, draft.servingsText);
  checkLength(DraftField.sourceUrl, draft.sourceUrl);
  return problems;
}

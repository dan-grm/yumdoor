import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/services/recipe_draft_validation.dart';

void main() {
  test('a named draft with one serving has no problems', () {
    expect(validateDraft(const RecipeDraft(name: 'Suppe')), isEmpty);
  });

  test('the name is required, spaces alone are no name', () {
    expect(validateDraft(const RecipeDraft()), {
      DraftField.name: DraftProblem.missing,
    });
    expect(validateDraft(const RecipeDraft(name: '   ')), {
      DraftField.name: DraftProblem.missing,
    });
  });

  test('texts may be as long as Tandoor stores, not longer', () {
    RecipeDraft draft(int extra) => RecipeDraft(
      name: 'n' * (128 + extra),
      description: 'd' * (512 + extra),
      servingsText: 's' * (32 + extra),
      sourceUrl: 'u' * (1024 + extra),
    );

    expect(validateDraft(draft(0)), isEmpty);
    expect(validateDraft(draft(1)), {
      DraftField.name: DraftProblem.tooLong,
      DraftField.description: DraftProblem.tooLong,
      DraftField.servingsText: DraftProblem.tooLong,
      DraftField.sourceUrl: DraftProblem.tooLong,
    });
  });

  test('the name is measured without surrounding spaces', () {
    expect(validateDraft(RecipeDraft(name: ' ${'n' * 128} ')), isEmpty);
  });

  test('lengths count characters like Tandoor: an emoji is one', () {
    expect(validateDraft(RecipeDraft(name: '🥕' * 128)), isEmpty);
  });

  test('servings must be at least 1', () {
    expect(validateDraft(const RecipeDraft(name: 'Suppe', servings: 0)), {
      DraftField.servings: DraftProblem.tooSmall,
    });
  });
}

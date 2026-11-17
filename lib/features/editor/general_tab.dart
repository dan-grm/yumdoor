import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/services/recipe_draft_validation.dart';
import '../../l10n/l10n.dart';
import 'delete_recipe.dart';
import 'editor_controller.dart';
import 'editor_field.dart';
import 'picker_sheet.dart';

/// The editor's "Allgemein" tab: name, description, servings, times,
/// keywords and source.
///
/// The fields start from the draft in [recipeEditorProvider] and write every
/// change back to it, so switching tabs keeps what was typed.
class GeneralTab extends ConsumerStatefulWidget {
  const GeneralTab({super.key, required this.recipeId});

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

  @override
  ConsumerState<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends ConsumerState<GeneralTab> {
  late final RecipeDraft _initial = ref
      .read(recipeEditorProvider(widget.recipeId))
      .requireValue
      .draft;
  late final _name = TextEditingController(text: _initial.name);
  late final _description = TextEditingController(text: _initial.description);
  // 0 is what an emptied field left in the draft.
  late final _servings = TextEditingController(
    text: _initial.servings == 0 ? '' : '${_initial.servings}',
  );
  late final _servingsText = TextEditingController(text: _initial.servingsText);
  late final _workingTime = TextEditingController(
    text: _minutes(_initial.workingTime),
  );
  late final _waitingTime = TextEditingController(
    text: _minutes(_initial.waitingTime),
  );
  late final _source = TextEditingController(text: _initial.sourceUrl ?? '');

  /// No time is an empty field rather than "0".
  static String _minutes(Duration time) =>
      time == Duration.zero ? '' : '${time.inMinutes}';

  @override
  void dispose() {
    for (final controller in [
      _name,
      _description,
      _servings,
      _servingsText,
      _workingTime,
      _waitingTime,
      _source,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  RecipeEditor get _editor =>
      ref.read(recipeEditorProvider(widget.recipeId).notifier);

  void _edit(RecipeDraft Function(RecipeDraft draft) change) =>
      _editor.edit(change);

  Future<void> _addKeyword() async {
    final draft = ref
        .read(recipeEditorProvider(widget.recipeId))
        .requireValue
        .draft;
    final keyword = await showKeywordPicker(
      context,
      exclude: {for (final k in draft.keywords) ?k.id},
    );
    if (keyword != null && mounted) _editor.addKeyword(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final state = ref.watch(recipeEditorProvider(widget.recipeId)).requireValue;
    final enabled = !state.saving;
    final problems = state.showProblems
        ? state.problems
        : const <DraftField, DraftProblem>{};
    String? error(DraftField field) => switch (problems[field]) {
      DraftProblem.missing => l10n.editorNameMissing,
      DraftProblem.tooLong => l10n.editorTooLong(draftMaxLengths[field]!),
      DraftProblem.tooSmall => l10n.editorServingsTooSmall,
      null => null,
    };
    int number(String text) => int.tryParse(text) ?? 0;

    final servings = EditorField.number(
      label: l10n.editorServings,
      controller: _servings,
      enabled: enabled,
      error: error(DraftField.servings),
      onChanged: (text) =>
          _edit((draft) => draft.copyWith(servings: number(text))),
    );
    final servingsText = EditorField(
      label: l10n.editorServingsText,
      controller: _servingsText,
      enabled: enabled,
      hint: l10n.editorServingsTextHint,
      error: error(DraftField.servingsText),
      textCapitalization: TextCapitalization.none,
      onChanged: (text) => _edit((draft) => draft.copyWith(servingsText: text)),
    );
    final workingTime = EditorField.number(
      label: l10n.editorWorkingTime,
      controller: _workingTime,
      enabled: enabled,
      onChanged: (text) => _edit(
        (draft) => draft.copyWith(workingTime: Duration(minutes: number(text))),
      ),
    );
    final waitingTime = EditorField.number(
      label: l10n.editorWaitingTime,
      controller: _waitingTime,
      enabled: enabled,
      onChanged: (text) => _edit(
        (draft) => draft.copyWith(waitingTime: Duration(minutes: number(text))),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: t.space4,
      children: [
        EditorField(
          label: l10n.editorName,
          controller: _name,
          enabled: enabled,
          error: error(DraftField.name),
          onChanged: (text) => _edit((draft) => draft.copyWith(name: text)),
        ),
        EditorField(
          label: l10n.editorDescription,
          controller: _description,
          enabled: enabled,
          multiline: true,
          help: l10n.editorDescriptionHelp,
          error: error(DraftField.description),
          onChanged: (text) =>
              _edit((draft) => draft.copyWith(description: text)),
        ),
        _Pair(first: servings, second: servingsText),
        _Pair(first: workingTime, second: waitingTime),
        _Keywords(
          keywords: state.draft.keywords,
          onAdd: enabled ? _addKeyword : null,
          onRemove: enabled ? _editor.removeKeywordAt : null,
        ),
        EditorField(
          label: l10n.editorSource,
          controller: _source,
          enabled: enabled,
          hint: l10n.editorSourceHint,
          keyboardType: TextInputType.url,
          textCapitalization: TextCapitalization.none,
          error: error(DraftField.sourceUrl),
          onChanged: (text) => _edit(
            (draft) => draft.copyWith(
              sourceUrl: text.trim().isEmpty ? null : text.trim(),
            ),
          ),
        ),
        if (widget.recipeId case final id?) DeleteRecipeButton(recipeId: id),
      ],
    );
  }
}

/// Two fields side by side, top-aligned so an error under one doesn't shift
/// the other.
class _Pair extends StatelessWidget {
  const _Pair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: context.tokens.space3,
    children: [
      Expanded(child: first),
      Expanded(child: second),
    ],
  );
}

/// The keywords as chips that remove them, and a chip that adds one.
class _Keywords extends StatelessWidget {
  const _Keywords({
    required this.keywords,
    required this.onAdd,
    required this.onRemove,
  });

  final List<NamedRef> keywords;

  /// `null` while saving.
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.editorKeywords,
            style: t.caption.copyWith(
              color: t.inkMuted,
              fontWeight: t.label.fontWeight,
            ),
          ),
        ),
        SizedBox(height: t.space2),
        Wrap(
          spacing: t.space2,
          runSpacing: t.space2,
          children: [
            for (final (index, keyword) in keywords.indexed)
              SelectedFilterChip(
                label: keyword.name,
                removeLabel: l10n.editorRemoveKeyword(keyword.name),
                onRemove: switch (onRemove) {
                  final onRemove? => () => onRemove(index),
                  null => null,
                },
              ),
            AddFilterChip(
              label: l10n.editorAddKeyword,
              tooltip: l10n.editorAddKeywordTooltip,
              onPressed: onAdd,
            ),
          ],
        ),
      ],
    );
  }
}

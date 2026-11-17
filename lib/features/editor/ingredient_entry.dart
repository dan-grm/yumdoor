import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_draft.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import 'editor_controller.dart';
import 'editor_field.dart';
import 'editor_sheet.dart';
import 'ingredient_sheets.dart';

/// The name an ingredient row shows: its food, or for a line without food
/// its note.
String ingredientName(BuildContext context, IngredientDraft ingredient) =>
    switch (ingredient.food?.name) {
      final name? => name,
      null when ingredient.note.trim().isNotEmpty => ingredient.note.trim(),
      null => context.l10n.ingredientUnnamed,
    };

/// Fast ingredient entry: a line like "200 g Karotten, geschält" is parsed
/// on Enter (or the add button) with Tandoor's ingredient parser and added
/// to the recipe draft of [recipeId], to the step at [step] or, if `null`,
/// to the last step.
///
/// Parsing creates unknown foods and units on the server, so it is a write:
/// disabled offline. The field keeps the focus after a line is added, for
/// the next one.
class IngredientEntry extends ConsumerStatefulWidget {
  const IngredientEntry({
    super.key,
    required this.recipeId,
    this.step,
    this.autofocus = false,
  });

  final int? recipeId;
  final int? step;
  final bool autofocus;

  @override
  ConsumerState<IngredientEntry> createState() => _IngredientEntryState();
}

class _IngredientEntryState extends ConsumerState<IngredientEntry> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  var _busy = false;

  /// What happened to the last line: added, not recognized, or failed.
  String? _message;
  var _messageIsError = false;

  /// The line being added, which completes with whether that worked.
  Future<bool>? _adding;

  /// While the editor is saving the line typed here before it saves.
  var _finishing = false;

  late final void Function() _removePendingLine;

  @override
  void initState() {
    super.initState();
    _removePendingLine = ref
        .read(recipeEditorProvider(widget.recipeId).notifier)
        .addPendingLine(
          _finish,
          hasText: () => _controller.text.trim().isNotEmpty,
        );
  }

  @override
  void dispose() {
    _removePendingLine();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Adds what is typed (or still being added) before the recipe is saved.
  /// Returns `false` if it can't be added; this entry then says why.
  Future<bool> _finish() async {
    _finishing = true;
    try {
      if (_adding case final adding?) {
        if (!await adding) return false;
      }
      return mounted ? await _submit() : true;
    } finally {
      _finishing = false;
    }
  }

  /// Adds the typed line; completes with `false` if that failed. A line
  /// already being added is waited for instead.
  Future<bool> _submit() {
    if (_adding case final adding?) return adding;
    final line = _controller.text;
    if (line.trim().isEmpty) return Future.value(true);
    final adding = _add(line);
    _adding = adding;
    return adding.whenComplete(() => _adding = null);
  }

  Future<bool> _add(String line) async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _message = null;
    });
    String? message;
    var isError = false;
    try {
      final added = await ref
          .read(recipeEditorProvider(widget.recipeId).notifier)
          .addLine(line, step: widget.step);
      if (!mounted) return true;
      if (added != null) {
        _controller.clear();
        message = added.food == null && added.note == line.trim()
            ? l10n.ingredientEntryUnparsed(line.trim())
            : l10n.ingredientEntryAdded(ingredientName(context, added));
      }
    } on Object catch (error) {
      if (!mounted) return false;
      final failure = error is Failure ? error : ServerFailure(cause: error);
      message = l10n.ingredientEntryFailed(failureMessage(context, failure));
      isError = true;
    }
    if (!mounted) return !isError;
    setState(() {
      _busy = false;
      _message = message;
      _messageIsError = isError;
    });
    // For the next line; not while the editor is about to save and leave.
    if (!_finishing) _focus.requestFocus();
    return !isError;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final saving =
        ref.watch(
          recipeEditorProvider(widget.recipeId)
              .select((state) => state.value?.saving),
        ) ??
        true;
    final message = _message;

    return OfflineDisabled(
      builder: (context, online) {
        final enabled = online && !saving;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: t.space2,
              children: [
                Expanded(
                  child: Semantics(
                    label: l10n.ingredientEntryLabel,
                    textField: true,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      autofocus: widget.autofocus,
                      enabled: enabled,
                      readOnly: _busy,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        CodePointLimitFormatter(ingredientNoteMaxLength),
                      ],
                      onSubmitted: (_) => _submit(),
                      // Keeps the focus in the field for the next line.
                      onEditingComplete: () {},
                      style: t.bodyL.copyWith(color: t.ink),
                      cursorColor: t.sage,
                      decoration: editorInputDecoration(
                        context,
                        hint: l10n.ingredientEntryHint,
                      ),
                    ),
                  ),
                ),
                if (_busy)
                  SizedBox.square(
                    dimension: t.sizeTouch,
                    child: Padding(
                      padding: EdgeInsets.all(t.space3),
                      child: CircularProgressIndicator(
                        color: t.sage,
                        strokeWidth: t.space1 / 2,
                      ),
                    ),
                  )
                else
                  RoundIconButton(
                    icon: Icons.add_rounded,
                    label: l10n.ingredientEntryAdd,
                    onPressed: enabled ? _submit : null,
                  ),
              ],
            ),
            if (message != null)
              Padding(
                padding: EdgeInsets.only(top: t.space2),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    message,
                    style: t.caption.copyWith(
                      color: _messageIsError ? t.danger : t.inkMuted,
                      fontWeight: t.label.fontWeight,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A sheet with an [IngredientEntry] for the step at [step] of the recipe
/// draft of [recipeId], for the Schritte tab's "+ Zutat". Stays open for
/// more lines until "Fertig".
Future<void> showIngredientEntrySheet(
  BuildContext context, {
  required int? recipeId,
  required int step,
}) => showEditorSheet<void>(
  context,
  (context) => EditorSheetFrame(
    title: context.l10n.ingredientEntryLabel,
    children: [
      IngredientEntry(recipeId: recipeId, step: step, autofocus: true),
      PillButton(
        label: context.l10n.ingredientEntryDone,
        kind: PillButtonKind.secondary,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);

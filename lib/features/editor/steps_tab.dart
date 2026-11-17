import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/services/step_template_references.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/offline_disabled.dart';
import '../common/step_text.dart';
import '../recipe/ingredient_lines.dart';
import 'editor_controller.dart';
import 'editor_field.dart';
import 'ingredient_entry.dart';
import 'ingredients_tab.dart';

/// Most digits of a step's duration in minutes.
const _maxDurationDigits = 5;

/// Most characters of a step's name: Tandoor's `Step.name` `max_length`.
const stepNameMaxLength = 128;

/// Shows that the text of the step at [number] (1-based) refers to
/// ingredients by position, when changing the ingredients at [index] and
/// after it (a removal, a swap) changes what those references show.
void warnIfReferencesShift(
  BuildContext context,
  StepDraft step,
  int number,
  int index,
) {
  if (!StepTemplateReferences.shiftedBy(step.instruction, index)) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(content: Text(context.l10n.stepTemplateWarning(number))),
    );
}

/// The editor's "Schritte" tab (mockup 09-rezept-bearbeiten): the steps as
/// cards that can be reordered, expanded to edit the instruction, name,
/// ingredients and duration, added and deleted.
///
/// Nothing is only behind dragging: every card has a menu to move it up and
/// down.
class StepsTab extends ConsumerStatefulWidget {
  const StepsTab({super.key, required this.recipeId});

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

  @override
  ConsumerState<StepsTab> createState() => _StepsTabState();
}

class _StepsTabState extends ConsumerState<StepsTab> {
  /// One key per step, in the steps' order, so a card keeps its fields and
  /// whether it is open when it moves. Steps have no identity of their own
  /// before they are saved.
  var _keys = <Key>[];
  final _expanded = <Key>{};

  RecipeEditor get _editor =>
      ref.read(recipeEditorProvider(widget.recipeId).notifier);

  void _sync(int count) {
    if (_keys.length == count) return;
    _keys = [for (var i = 0; i < count; i++) UniqueKey()];
    _expanded.clear();
  }

  void _toggle(Key key) => setState(() {
    if (!_expanded.remove(key)) _expanded.add(key);
  });

  void _add() {
    _editor.addStep();
    setState(() {
      final key = UniqueKey();
      _keys = [..._keys, key];
      _expanded.add(key);
    });
  }

  void _move(int index, int to) {
    if (to < 0 || to >= _keys.length || to == index) return;
    _editor.reorderStep(index, to);
    setState(() {
      _keys = [..._keys];
      _keys.insert(to, _keys.removeAt(index));
    });
  }

  void _remove(int index) {
    _editor.removeStep(index);
    setState(() {
      _expanded.remove(_keys[index]);
      _keys = [..._keys]..removeAt(index);
    });
  }

  Future<void> _delete(int index, StepDraft step) async {
    final needsConfirmation =
        step.instruction.trim().isNotEmpty ||
        step.name.trim().isNotEmpty ||
        step.ingredients.isNotEmpty;
    if (needsConfirmation) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          final t = context.tokens;
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(l10n.stepDeleteTitle(index + 1)),
            content: Text(l10n.stepDeleteBody(step.ingredients.length)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: t.danger),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.stepDelete),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !mounted) return;
    }
    _remove(index);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final state = ref.watch(recipeEditorProvider(widget.recipeId)).requireValue;
    final steps = state.draft.steps;
    final enabled = !state.saving;
    _sync(steps.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (steps.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: t.space4),
            child: Text(
              l10n.stepsEmpty,
              style: t.body.copyWith(color: t.inkMuted),
            ),
          ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: steps.length,
          onReorderItem: (from, to) {
            if (enabled) _move(from, to);
          },
          itemBuilder: (context, index) {
            final key = _keys[index];
            return Padding(
              key: key,
              padding: EdgeInsets.only(bottom: t.space3),
              child: _StepCard(
                recipeId: widget.recipeId,
                index: index,
                count: steps.length,
                step: steps[index],
                servings: state.draft,
                expanded: _expanded.contains(key),
                enabled: enabled,
                onToggle: () => _toggle(key),
                onMove: (offset) => _move(index, index + offset),
                onDelete: () => _delete(index, steps[index]),
              ),
            );
          },
        ),
        SizedBox(height: t.space1),
        _AddStepButton(onPressed: enabled ? _add : null),
      ],
    );
  }
}

/// The dashed "Schritt hinzufügen" button.
class _AddStepButton extends StatelessWidget {
  const _AddStepButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = onPressed == null ? t.inkMuted : t.ink;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: context.l10n.stepAdd,
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(t.radiusM),
        child: CustomPaint(
          painter: DashedOutlinePainter(
            color: onPressed == null ? t.line : t.controlBorder,
            radius: t.radiusM,
          ),
          child: SizedBox(
            height: t.sizeButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: t.space2,
              children: [
                Icon(Icons.add_rounded, color: color),
                Text(
                  context.l10n.stepAdd,
                  style: t.label.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _Action { up, down }

/// One step: collapsed to its number and the start of its text, or expanded
/// to edit it.
class _StepCard extends ConsumerStatefulWidget {
  const _StepCard({
    required this.recipeId,
    required this.index,
    required this.count,
    required this.step,
    required this.servings,
    required this.expanded,
    required this.enabled,
    required this.onToggle,
    required this.onMove,
    required this.onDelete,
  });

  final int? recipeId;
  final int index;
  final int count;
  final StepDraft step;

  /// The draft, for the base servings the amounts are for.
  final RecipeDraft servings;
  final bool expanded;

  /// Not while saving.
  final bool enabled;
  final VoidCallback onToggle;

  /// Moves the step by -1 (up) or 1 (down).
  final ValueChanged<int> onMove;
  final VoidCallback onDelete;

  @override
  ConsumerState<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends ConsumerState<_StepCard> {
  late final _instruction = TextEditingController(
    text: widget.step.instruction,
  );
  late final _name = TextEditingController(text: widget.step.name);
  late final _time = TextEditingController(text: _minutes(widget.step.time));

  static String _minutes(Duration time) =>
      time.inMinutes > 0 ? '${time.inMinutes}' : '';

  @override
  void didUpdateWidget(_StepCard old) {
    super.didUpdateWidget(old);
    // The draft changed elsewhere (loaded again): show it.
    final step = widget.step;
    if (_instruction.text != step.instruction) {
      _instruction.text = step.instruction;
    }
    if (_name.text != step.name) _name.text = step.name;
    if ((int.tryParse(_time.text) ?? 0) != step.time.inMinutes) {
      _time.text = _minutes(step.time);
    }
  }

  @override
  void dispose() {
    _instruction.dispose();
    _name.dispose();
    _time.dispose();
    super.dispose();
  }

  RecipeEditor get _editor =>
      ref.read(recipeEditorProvider(widget.recipeId).notifier);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final number = widget.index + 1;
    final expanded = widget.expanded;
    final step = widget.step;

    final handle = ReorderableDragStartListener(
      index: widget.index,
      enabled: widget.enabled,
      child: Tooltip(
        message: l10n.stepDragHandle(number),
        child: SizedBox.square(
          dimension: t.sizeTouch,
          child: Icon(Icons.drag_indicator_rounded, color: t.inkMuted),
        ),
      ),
    );
    final badge = Container(
      width: t.sizeDot + t.space2,
      height: t.sizeDot + t.space2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: expanded ? t.sage : t.surfaceSunken,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: t.label.copyWith(color: expanded ? t.onSage : t.ink),
      ),
    );

    final String preview = step.instruction.trim().isNotEmpty
        ? step.instruction.trim().split('\n').first
        : step.name.trim().isNotEmpty
        ? step.name.trim()
        : l10n.stepEmptyPreview;

    final Widget header = expanded
        ? Row(
            children: [
              handle,
              Expanded(
                child: Semantics(
                  button: true,
                  label: l10n.stepCollapse(number),
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: widget.onToggle,
                    borderRadius: BorderRadius.circular(t.radiusM),
                    child: SizedBox(
                      height: t.sizeTouch,
                      child: Row(
                        spacing: t.space3,
                        children: [
                          badge,
                          Expanded(
                            child: Text(
                              stepTitle(context, step.name, widget.index),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleS.copyWith(color: t.ink),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_Action>(
                enabled: widget.enabled,
                tooltip: l10n.stepActions(number),
                icon: Icon(Icons.more_vert_rounded, color: t.inkMuted),
                color: t.surface,
                onSelected: (action) =>
                    widget.onMove(action == _Action.up ? -1 : 1),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _Action.up,
                    enabled: widget.index > 0,
                    child: Text(l10n.stepMoveUp),
                  ),
                  PopupMenuItem(
                    value: _Action.down,
                    enabled: widget.index < widget.count - 1,
                    child: Text(l10n.stepMoveDown),
                  ),
                ],
              ),
              IconButton(
                tooltip: l10n.stepDelete,
                onPressed: widget.enabled ? widget.onDelete : null,
                icon: Icon(Icons.delete_outline_rounded, color: t.danger),
              ),
            ],
          )
        : Row(
            children: [
              handle,
              Expanded(
                child: Semantics(
                  button: true,
                  label: '${l10n.stepExpand(number)}: $preview',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: widget.onToggle,
                    borderRadius: BorderRadius.circular(t.radiusM),
                    child: SizedBox(
                      height: t.sizeTouch + t.space2,
                      child: Row(
                        spacing: t.space3,
                        children: [
                          badge,
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodyL.copyWith(
                                color: step.instruction.trim().isEmpty
                                    ? t.inkMuted
                                    : t.ink,
                              ),
                            ),
                          ),
                          Icon(Icons.expand_more_rounded, color: t.ink),
                          SizedBox(width: t.space1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusM),
        border: Border.all(
          color: expanded ? t.sage : t.line,
          width: expanded ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          t.space1,
          expanded ? t.space1 : 0,
          t.space2,
          expanded ? t.space4 : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            if (expanded)
              Padding(
                padding: EdgeInsets.fromLTRB(t.space3, t.space2, t.space2, 0),
                child: _StepForm(
                  recipeId: widget.recipeId,
                  index: widget.index,
                  step: step,
                  draft: widget.servings,
                  enabled: widget.enabled,
                  instruction: _instruction,
                  name: _name,
                  time: _time,
                  onInstruction: (text) =>
                      _editor.setStepInstruction(widget.index, text),
                  onName: (text) => _editor.setStepName(widget.index, text),
                  onTime: (text) => _editor.setStepTime(
                    widget.index,
                    Duration(minutes: int.tryParse(text) ?? 0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The expanded card's fields: instruction, name, ingredient chips and
/// duration.
class _StepForm extends ConsumerWidget {
  const _StepForm({
    required this.recipeId,
    required this.index,
    required this.step,
    required this.draft,
    required this.enabled,
    required this.instruction,
    required this.name,
    required this.time,
    required this.onInstruction,
    required this.onName,
    required this.onTime,
  });

  final int? recipeId;
  final int index;
  final StepDraft step;
  final RecipeDraft draft;
  final bool enabled;
  final TextEditingController instruction;
  final TextEditingController name;
  final TextEditingController time;
  final ValueChanged<String> onInstruction;
  final ValueChanged<String> onName;
  final ValueChanged<String> onTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final editor = ref.read(recipeEditorProvider(recipeId).notifier);
    final number = index + 1;
    final stepCount = draft.steps.length;
    final caption = t.caption.copyWith(
      color: t.inkMuted,
      fontWeight: t.label.fontWeight,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: t.space4,
      children: [
        EditorField(
          label: l10n.stepInstruction,
          controller: instruction,
          onChanged: onInstruction,
          enabled: enabled,
          multiline: true,
        ),
        EditorField(
          label: l10n.stepName,
          controller: name,
          onChanged: onName,
          enabled: enabled,
          maxLength: stepNameMaxLength,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(child: EditorLabel(l10n.stepIngredients)),
            SizedBox(height: t.space1),
            Semantics(
              container: true,
              label: l10n.stepIngredients,
              child: Wrap(
                spacing: t.space2,
                runSpacing: 0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final (i, ingredient) in step.ingredients.indexed)
                    if (!ingredient.isHeader)
                      _IngredientChip(
                        ingredient: ingredient,
                        enabled: enabled,
                        otherSteps: [
                          for (var s = 0; s < stepCount; s++)
                            if (s != index) s,
                        ],
                        onRemove: () {
                          warnIfReferencesShift(context, step, number, i);
                          editor.removeIngredient(index, i);
                        },
                        onMove: (to) {
                          warnIfReferencesShift(context, step, number, i);
                          editor.moveIngredientToStep(index, i, to);
                        },
                      ),
                  OfflineDisabled(
                    builder: (context, online) => AddFilterChip(
                      label: l10n.stepAddIngredient,
                      tooltip: l10n.stepAddIngredientTooltip(number),
                      onPressed: online && enabled
                          ? () => showIngredientEntrySheet(
                              context,
                              recipeId: recipeId,
                              step: index,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              l10n.ingredientsBaseServings(
                servingsLabel(context, draft.servings, draft.servingsText),
              ),
              style: caption,
            ),
          ],
        ),
        Wrap(
          spacing: t.space2,
          runSpacing: t.space1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ExcludeSemantics(
              child: Text(
                l10n.stepDuration,
                style: t.label.copyWith(color: t.ink),
              ),
            ),
            SizedBox(
              width: t.sizeButton + t.space3,
              child: Semantics(
                label: '${l10n.stepDuration} (${l10n.stepDurationUnit})',
                textField: true,
                child: TextField(
                  controller: time,
                  onChanged: onTime,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_maxDurationDigits),
                  ],
                  style: t.bodyL.copyWith(color: t.ink),
                  cursorColor: t.sage,
                  decoration: editorInputDecoration(context, hint: '0'),
                ),
              ),
            ),
            ExcludeSemantics(
              child: Text(
                l10n.stepDurationUnit,
                style: t.label.copyWith(color: t.ink),
              ),
            ),
            Text(l10n.stepDurationHelp, style: caption),
          ],
        ),
      ],
    );
  }
}

/// An ingredient of the step as a `sage-soft` chip with an x that removes it
/// from the step. Tapping the name opens a menu to move it to another step.
class _IngredientChip extends StatelessWidget {
  const _IngredientChip({
    required this.ingredient,
    required this.enabled,
    required this.otherSteps,
    required this.onRemove,
    required this.onMove,
  });

  final IngredientDraft ingredient;
  final bool enabled;

  /// Indexes of the steps it can be moved to.
  final List<int> otherSteps;
  final VoidCallback onRemove;
  final ValueChanged<int> onMove;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final name = ingredientName(context, ingredient);
    final amount = ingredient.noAmount
        ? ''
        : [
            if (ingredient.amount > 0)
              ingredientAmountText(LocaleFormat.of(context), ingredient.amount),
            ?ingredient.unit?.name,
          ].join(' ');
    final label = amount.isEmpty ? name : '$name · $amount';
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: t.label.copyWith(color: t.ink),
    );
    final iconSize = t.label.fontSize! + t.space1;
    final inset = (t.sizeTouch - t.sizeChip) / 2;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: t.sizeWide / 2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: inset,
            bottom: inset,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: t.sageSoft,
                borderRadius: BorderRadius.circular(t.radiusM),
              ),
            ),
          ),
          SizedBox(
            height: t.sizeTouch,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: otherSteps.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: t.space3),
                          child: text,
                        )
                      : PopupMenuButton<int>(
                          enabled: enabled,
                          tooltip: l10n.stepMoveIngredient(name),
                          color: t.surface,
                          padding: EdgeInsets.only(left: t.space3),
                          onSelected: onMove,
                          itemBuilder: (context) => [
                            for (final s in otherSteps)
                              PopupMenuItem(
                                value: s,
                                child: Text(l10n.stepMoveIngredientTo(s + 1)),
                              ),
                          ],
                          child: Center(widthFactor: 1, child: text),
                        ),
                ),
                Tooltip(
                  message: l10n.stepRemoveIngredient(name),
                  child: Semantics(
                    button: true,
                    label: l10n.stepRemoveIngredient(name),
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: enabled ? onRemove : null,
                      borderRadius: BorderRadius.circular(t.radiusM),
                      child: SizedBox(
                        width: t.sizeTouch - t.space2,
                        height: t.sizeTouch,
                        child: Icon(
                          Icons.close_rounded,
                          size: iconSize,
                          color: t.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

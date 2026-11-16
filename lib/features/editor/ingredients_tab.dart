import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components/buttons.dart';
import '../../design/components/ingredient_row.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../recipe/ingredient_lines.dart';
import 'editor_controller.dart';
import 'ingredient_entry.dart';
import 'ingredient_sheets.dart';

/// The editor's "Zutaten" tab: the recipe's ingredients with their section
/// headers, fast entry of new lines, and per row edit, move and delete.
///
/// Ingredients are grouped by step when more than one step has some, else
/// they are one list; new lines go to the last step (decided in M3,
/// docs/ROADMAP.md). Amounts are for the recipe's base servings.
class IngredientsTab extends ConsumerWidget {
  const IngredientsTab({super.key, required this.recipeId});

  /// The recipe being edited, `null` for a new one.
  final int? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final provider = recipeEditorProvider(recipeId);
    final state = ref.watch(provider).requireValue;
    final draft = state.draft;
    final enabled = !state.saving;
    final grouped = draft.groupsIngredientsByStep;
    final groups = [
      for (final (index, step) in draft.steps.indexed)
        if (step.ingredients.isNotEmpty) (index, step),
    ];

    Future<void> addHeader() async {
      final title = await showHeaderSheet(context);
      if (title != null) ref.read(provider.notifier).addHeader(title);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ingredientsBaseServings(
            servingsLabel(context, draft.servings, draft.servingsText),
          ),
          style: t.caption.copyWith(
            color: t.inkMuted,
            fontWeight: t.label.fontWeight,
          ),
        ),
        SizedBox(height: t.space2),
        if (groups.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: t.space4),
            child: Text(
              l10n.ingredientsEmpty,
              style: t.body.copyWith(color: t.inkMuted),
            ),
          ),
        for (final (stepIndex, step) in groups) ...[
          if (grouped)
            Padding(
              padding: EdgeInsets.only(top: t.space4, bottom: t.space1),
              child: Semantics(
                header: true,
                child: Text(
                  _stepTitle(context, step, stepIndex).toUpperCase(),
                  style: t.overline.copyWith(color: t.sage),
                ),
              ),
            ),
          for (final (index, ingredient) in step.ingredients.indexed) ...[
            if (index > 0 && !ingredient.isHeader)
              Divider(height: 1, thickness: 1, color: t.line),
            _EditableRow(
              recipeId: recipeId,
              step: stepIndex,
              index: index,
              ingredient: ingredient,
              isFirst: index == 0,
              isLast: index == step.ingredients.length - 1,
              enabled: enabled,
            ),
          ],
        ],
        SizedBox(height: t.space4),
        IngredientEntry(recipeId: recipeId),
        SizedBox(height: t.space3),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: PillButton(
            label: l10n.ingredientAddHeader,
            icon: Icons.add_rounded,
            kind: PillButtonKind.secondary,
            compact: true,
            onPressed: enabled ? addHeader : null,
          ),
        ),
      ],
    );
  }
}

/// "Schritt 2 · Anrichten", or "Schritt 2" for a step without a name.
String _stepTitle(BuildContext context, StepDraft step, int index) {
  final number = context.l10n.recipeStepTitle(index + 1);
  final name = step.name.trim();
  return name.isEmpty ? number : '$number · $name';
}

/// [amount] as it is saved, as the edit sheet shows it: `½` and `1½` where
/// that is exact, else the number itself without thousands separators
/// (`1234,5`), not rounded for cooking like on the recipe screen.
String _amount(LocaleFormat format, double amount) {
  final quantity = Quantity.of(amount);
  return quantity.value == amount
      ? format.quantity(quantity)
      : format.amountInput(amount);
}

enum _Action { edit, up, down, delete }

/// An ingredient or section header with a menu to edit, move and delete it.
/// Tapping it edits it too.
class _EditableRow extends ConsumerWidget {
  const _EditableRow({
    required this.recipeId,
    required this.step,
    required this.index,
    required this.ingredient,
    required this.isFirst,
    required this.isLast,
    required this.enabled,
  });

  final int? recipeId;
  final int step;
  final int index;
  final IngredientDraft ingredient;
  final bool isFirst;
  final bool isLast;

  /// Not while saving.
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final editor = ref.read(recipeEditorProvider(recipeId).notifier);
    final name = ingredient.isHeader
        ? ingredient.note
        : ingredientName(context, ingredient);

    Future<void> edit() async {
      if (ingredient.isHeader) {
        final title = await showHeaderSheet(context, title: ingredient.note);
        if (title != null) {
          editor.updateIngredient(
            step,
            index,
            ingredient.copyWith(note: title),
          );
        }
      } else {
        final changed = await showIngredientSheet(context, ingredient);
        if (changed != null) editor.updateIngredient(step, index, changed);
      }
    }

    void act(_Action action) => switch (action) {
      _Action.edit => edit(),
      _Action.up => editor.moveIngredient(step, index, -1),
      _Action.down => editor.moveIngredient(step, index, 1),
      _Action.delete => editor.removeIngredient(step, index),
    };

    final Widget content;
    if (ingredient.isHeader) {
      content = Padding(
        padding: EdgeInsets.only(top: t.space4, bottom: t.space1),
        child: Semantics(
          header: true,
          child: Text(name, style: t.titleS.copyWith(color: t.ink)),
        ),
      );
    } else {
      final format = LocaleFormat.of(context);
      content = IngredientRow(
        name: name,
        // A line without food shows its note as the name already.
        note: ingredient.food == null ? '' : ingredient.note,
        amount: ingredient.noAmount
            ? ''
            : [
                if (ingredient.amount > 0) _amount(format, ingredient.amount),
                ?ingredient.unit?.name,
              ].join(' '),
      );
    }

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: enabled ? edit : null,
            borderRadius: BorderRadius.circular(t.radiusM),
            child: content,
          ),
        ),
        PopupMenuButton<_Action>(
          enabled: enabled,
          tooltip: l10n.ingredientActions(name),
          icon: Icon(Icons.more_vert_rounded, color: t.inkMuted),
          color: t.surface,
          onSelected: act,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _Action.edit,
              child: Text(l10n.ingredientEdit),
            ),
            PopupMenuItem(
              value: _Action.up,
              enabled: !isFirst,
              child: Text(l10n.ingredientMoveUp),
            ),
            PopupMenuItem(
              value: _Action.down,
              enabled: !isLast,
              child: Text(l10n.ingredientMoveDown),
            ),
            PopupMenuItem(
              value: _Action.delete,
              child: Text(
                l10n.ingredientDelete,
                style: TextStyle(color: t.danger),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

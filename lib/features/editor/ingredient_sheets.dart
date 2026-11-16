import 'package:flutter/material.dart';

import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/services/amount_input.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import 'editor_field.dart';
import 'editor_sheet.dart';
import 'picker_sheet.dart';

/// Most characters of an ingredient's note, and so of a section header and
/// an entered line: Tandoor's `Ingredient.note` `max_length`.
const ingredientNoteMaxLength = 256;

/// Lets the user change amount, unit, food, note and "ohne Menge" of
/// [ingredient]. Returns the changed ingredient, or `null` if the sheet was
/// closed without "Übernehmen".
Future<IngredientDraft?> showIngredientSheet(
  BuildContext context,
  IngredientDraft ingredient,
) => showEditorSheet(
  context,
  (context) => _IngredientSheet(initial: ingredient),
);

/// Asks for the title of a section header ("Für den Teig"), starting from
/// [title]. Returns the trimmed title, or `null` if the sheet was closed.
Future<String?> showHeaderSheet(BuildContext context, {String title = ''}) =>
    showEditorSheet(context, (context) => _HeaderSheet(initial: title));

class _IngredientSheet extends StatefulWidget {
  const _IngredientSheet({required this.initial});

  final IngredientDraft initial;

  @override
  State<_IngredientSheet> createState() => _IngredientSheetState();
}

class _IngredientSheetState extends State<_IngredientSheet> {
  late final _amount = TextEditingController();
  late final _note = TextEditingController(text: widget.initial.note);
  late NamedRef? _food = widget.initial.food;
  late NamedRef? _unit = widget.initial.unit;
  late bool _noAmount = widget.initial.noAmount;
  var _amountInvalid = false;

  /// The amount as first shown; `null` until it is.
  String? _shownAmount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Formatted in the locale, which is only known here.
    if (_shownAmount == null) {
      final amount = widget.initial.amount;
      _amount.text = _shownAmount = amount > 0
          ? LocaleFormat.of(context).amountInput(amount)
          : '';
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickFood() async {
    final food = await showFoodPicker(context);
    if (food != null && mounted) {
      setState(() => _food = NamedRef.food(food));
    }
  }

  Future<void> _pickUnit() async {
    final unit = await showUnitPicker(context);
    if (unit != null && mounted) {
      setState(() => _unit = NamedRef.unit(unit));
    }
  }

  void _apply() {
    // Unchanged, the amount stays exact, also one shown rounded (⅓) or
    // with three decimals, which parseAmount refuses as ambiguous.
    final amount = _amount.text == _shownAmount
        ? widget.initial.amount
        : parseAmount(_amount.text);
    if (amount == null && !_noAmount) {
      setState(() => _amountInvalid = true);
      return;
    }
    Navigator.of(context).pop(
      widget.initial.copyWith(
        food: _food,
        unit: _unit,
        // An amount hidden by "ohne Menge" is kept if it is one.
        amount: amount ?? widget.initial.amount,
        noAmount: _noAmount,
        note: _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return EditorSheetFrame(
      title: l10n.ingredientEditTitle,
      children: [
        EditorPickerField(
          label: l10n.ingredientFood,
          value: _food?.name,
          placeholder: l10n.foodPickerTitle,
          onTap: _pickFood,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: t.space3,
          children: [
            Expanded(
              child: EditorField(
                label: l10n.ingredientAmount,
                controller: _amount,
                enabled: !_noAmount,
                textCapitalization: TextCapitalization.none,
                error: _amountInvalid && !_noAmount
                    ? l10n.ingredientAmountInvalid
                    : null,
                onChanged: (_) {
                  if (_amountInvalid) setState(() => _amountInvalid = false);
                },
              ),
            ),
            Expanded(
              child: EditorPickerField(
                label: l10n.ingredientUnit,
                value: _unit?.name,
                placeholder: l10n.ingredientNoUnit,
                onTap: _pickUnit,
                clearLabel: l10n.ingredientRemoveUnit,
                onClear: () => setState(() => _unit = null),
              ),
            ),
          ],
        ),
        EditorField(
          label: l10n.ingredientNote,
          controller: _note,
          maxLength: ingredientNoteMaxLength,
          textCapitalization: TextCapitalization.none,
          onChanged: (_) {},
        ),
        SwitchListTile(
          value: _noAmount,
          onChanged: (value) => setState(() => _noAmount = value),
          title: Text(
            l10n.ingredientNoAmount,
            style: t.bodyL.copyWith(color: t.ink),
          ),
          contentPadding: EdgeInsets.zero,
          activeThumbColor: t.onSage,
          activeTrackColor: t.sage,
        ),
        PillButton(label: l10n.ingredientApply, onPressed: _apply),
      ],
    );
  }
}

class _HeaderSheet extends StatefulWidget {
  const _HeaderSheet({required this.initial});

  final String initial;

  @override
  State<_HeaderSheet> createState() => _HeaderSheetState();
}

class _HeaderSheetState extends State<_HeaderSheet> {
  late final _title = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _apply() {
    final title = _title.text.trim();
    if (title.isNotEmpty) Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EditorSheetFrame(
      title: l10n.ingredientHeaderTitle,
      children: [
        EditorField(
          label: l10n.ingredientHeaderLabel,
          hint: l10n.ingredientHeaderHint,
          controller: _title,
          autofocus: true,
          maxLength: ingredientNoteMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        PillButton(
          label: l10n.ingredientApply,
          onPressed: _title.text.trim().isEmpty ? null : _apply,
        ),
      ],
    );
  }
}

/// A field of the editor whose value is picked in a sheet (food, unit):
/// looks like an [EditorField], opens the picker on tap, and with [onClear]
/// has a button that removes the value.
class EditorPickerField extends StatelessWidget {
  const EditorPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.clearLabel,
    this.onClear,
  }) : assert(onClear == null || clearLabel != null);

  final String label;

  /// `null` shows [placeholder].
  final String? value;
  final String placeholder;
  final VoidCallback? onTap;
  final String? clearLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final value = this.value;
    final onClear = this.onClear;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: EditorLabel(label)),
        SizedBox(height: t.space2),
        Semantics(
          label: label,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(t.radiusM),
            child: InputDecorator(
              isEmpty: value == null,
              decoration: editorInputDecoration(
                context,
                // Only while empty: a hidden hint still takes its lines.
                hint: value == null ? placeholder : null,
                suffixIcon: value != null && onClear != null
                    ? Tooltip(
                        message: clearLabel,
                        child: Semantics(
                          button: true,
                          label: clearLabel,
                          excludeSemantics: true,
                          onTap: onClear,
                          // An icon, not an IconButton, so the field keeps
                          // the height of the others; the whole suffix
                          // width takes the tap.
                          child: InkResponse(
                            onTap: onClear,
                            radius: t.sizeTouch / 2,
                            child: Icon(Icons.close_rounded, color: t.inkMuted),
                          ),
                        ),
                      )
                    : Icon(Icons.expand_more_rounded, color: t.inkMuted),
              ),
              child: Text(
                value ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.bodyL.copyWith(color: t.ink),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

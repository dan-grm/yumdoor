import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/design.dart';

/// Outline width of the editor's fields (mockup 09-rezept-bearbeiten).
const _borderWidth = 2.0;

/// Most digits a number field takes: minutes and servings stay far below
/// what Tandoor stores.
const _maxDigits = 4;

/// A labelled text field of the recipe editor: the label above, the field
/// with a `control-border` outline, and [error] below it in `danger`.
class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.error,
    this.hint,
    this.help,
    this.enabled = true,
    this.multiline = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
  }) : number = false;

  /// A field for a whole, non-negative number: only digits can be typed.
  const EditorField.number({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.error,
    this.hint,
    this.help,
    this.enabled = true,
  }) : number = true,
       multiline = false,
       keyboardType = TextInputType.number,
       textCapitalization = TextCapitalization.none;

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// What is wrong with the value, shown at the field; `null` if nothing.
  final String? error;
  final String? hint;

  /// A line of help below the field, when there is no [error].
  final String? help;
  final bool enabled;
  final bool multiline;
  final bool number;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(t.radiusM),
      borderSide: BorderSide(color: color, width: _borderWidth),
    );
    final small = t.caption.copyWith(fontWeight: t.label.fontWeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Screen readers get the label as the field's name instead.
        ExcludeSemantics(
          child: Text(label, style: small.copyWith(color: t.inkMuted)),
        ),
        SizedBox(height: t.space2),
        Semantics(
          label: label,
          textField: true,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: enabled,
            minLines: multiline ? 3 : 1,
            maxLines: multiline ? 8 : 1,
            keyboardType:
                keyboardType ??
                (multiline ? TextInputType.multiline : TextInputType.text),
            textCapitalization: textCapitalization,
            inputFormatters: number
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_maxDigits),
                  ]
                : null,
            style: t.bodyL.copyWith(color: t.ink),
            cursorColor: t.sage,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: t.bg,
              hintText: hint,
              hintStyle: t.bodyL.copyWith(color: t.inkMuted),
              errorText: error,
              errorStyle: small.copyWith(color: t.danger),
              errorMaxLines: 3,
              helperText: help,
              helperStyle: small.copyWith(color: t.inkMuted),
              helperMaxLines: 3,
              contentPadding: EdgeInsets.all(t.space3),
              border: border(t.controlBorder),
              enabledBorder: border(t.controlBorder),
              disabledBorder: border(t.line),
              focusedBorder: border(t.sage),
              errorBorder: border(t.danger),
              focusedErrorBorder: border(t.danger),
            ),
          ),
        ),
      ],
    );
  }
}

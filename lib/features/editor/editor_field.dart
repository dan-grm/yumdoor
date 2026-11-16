import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/design.dart';

/// Outline width of the editor's fields (mockup 09-rezept-bearbeiten).
const _borderWidth = 2.0;

/// Most digits a number field takes: enough for waiting times of months
/// (pickles, liqueurs), far below what Tandoor stores.
const _maxDigits = 6;

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
    this.maxLength,
    this.autofocus = false,
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
       maxLength = null,
       autofocus = false,
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

  /// Most characters the field takes; `null` for no limit.
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final maxLength = this.maxLength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Screen readers get the label as the field's name instead.
        ExcludeSemantics(child: EditorLabel(label)),
        SizedBox(height: t.space2),
        Semantics(
          label: label,
          textField: true,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: enabled,
            autofocus: autofocus,
            minLines: multiline ? 3 : 1,
            maxLines: multiline ? 8 : 1,
            keyboardType:
                keyboardType ??
                (multiline ? TextInputType.multiline : TextInputType.text),
            textCapitalization: textCapitalization,
            inputFormatters: [
              if (number) ...[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_maxDigits),
              ],
              if (maxLength != null) CodePointLimitFormatter(maxLength),
            ],
            style: t.bodyL.copyWith(color: t.ink),
            cursorColor: t.sage,
            decoration: editorInputDecoration(
              context,
              hint: hint,
              error: error,
              help: help,
            ),
          ),
        ),
      ],
    );
  }
}

/// The label above an editor field, in `caption` bold and `ink-muted`.
class EditorLabel extends StatelessWidget {
  const EditorLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Text(
      text,
      style: t.caption.copyWith(
        color: t.inkMuted,
        fontWeight: t.label.fontWeight,
      ),
    );
  }
}

/// The look of an editor field: a `bg` fill with a `control-border` outline,
/// `sage` when focused and `danger` with an [error].
InputDecoration editorInputDecoration(
  BuildContext context, {
  String? hint,
  String? error,
  String? help,
  Widget? suffixIcon,
}) {
  final t = context.tokens;
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(t.radiusM),
    borderSide: BorderSide(color: color, width: _borderWidth),
  );
  final small = t.caption.copyWith(fontWeight: t.label.fontWeight);
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: t.bg,
    hintText: hint,
    hintStyle: t.bodyL.copyWith(color: t.inkMuted),
    hintMaxLines: 1,
    errorText: error,
    errorStyle: small.copyWith(color: t.danger),
    errorMaxLines: 3,
    helperText: help,
    helperStyle: small.copyWith(color: t.inkMuted),
    helperMaxLines: 3,
    suffixIcon: suffixIcon,
    // A suffix button doesn't make the field taller than the others.
    suffixIconConstraints: BoxConstraints(
      minWidth: t.sizeTouch,
      minHeight: t.bodyL.fontSize! * t.bodyL.height!,
    ),
    contentPadding: EdgeInsets.all(t.space3),
    border: border(t.controlBorder),
    enabledBorder: border(t.controlBorder),
    disabledBorder: border(t.line),
    focusedBorder: border(t.sage),
    errorBorder: border(t.danger),
    focusedErrorBorder: border(t.danger),
  );
}

/// Keeps a field at most [max] code points long, as Tandoor counts its
/// `max_length` (an emoji family is one character but seven code points).
///
/// Like [LengthLimitingTextInputFormatter]: text that gets too long is cut
/// to the limit (a long paste keeps its start), a full field takes no more,
/// edits that make a too long text shorter are let through, and an IME
/// composition is only limited once it is committed.
class CodePointLimitFormatter extends TextInputFormatter {
  CodePointLimitFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.composing.isValid) return newValue;
    final length = newValue.text.runes.length;
    final oldLength = oldValue.text.runes.length;
    if (length <= max || length < oldLength) return newValue;
    if (oldLength >= max) return oldValue;
    final text = String.fromCharCodes(newValue.text.runes.take(max));
    return TextEditingValue(
      text: text,
      selection: newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset.clamp(0, text.length),
        extentOffset: newValue.selection.extentOffset.clamp(0, text.length),
      ),
    );
  }
}

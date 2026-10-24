import 'package:flutter/material.dart';

import '../design.dart';

/// Border width of the field (mockup 03-suche).
const _borderWidth = 2.0;

/// The rounded search field of the search screen and the filter pickers: a
/// `surface` pill with a search icon and, while it has text, a clear button.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.clearLabel,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  final TextEditingController controller;

  /// The accessible name of the field: "Rezepte durchsuchen".
  final String label;
  final String hint;

  /// The accessible label of the clear button.
  final String clearLabel;

  /// Called on typing and when the clear button empties the field.
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(t.radiusFull),
      borderSide: BorderSide(color: color, width: _borderWidth),
    );
    final iconSize = t.titleS.fontSize! + t.space1;

    return Semantics(
      label: label,
      textField: true,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: t.bodyL.copyWith(color: t.ink),
        cursorColor: t.sage,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: t.bodyL.copyWith(color: t.inkMuted),
          filled: true,
          fillColor: t.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: t.space4,
            vertical: t.space3,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: t.space4, right: t.space2),
            child: Icon(
              Icons.search_rounded,
              size: iconSize,
              color: t.inkMuted,
            ),
          ),
          prefixIconConstraints: BoxConstraints(minHeight: t.sizeTouch),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: clearLabel,
                    icon: Icon(Icons.close_rounded, size: iconSize),
                    color: t.inkMuted,
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                  ),
          ),
          enabledBorder: border(t.controlBorder),
          focusedBorder: border(t.sage),
        ),
      ),
    );
  }
}

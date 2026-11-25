import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/design.dart';
import '../../l10n/l10n.dart';

/// The longest food name Tandoor stores (`Food.name`).
const foodNameLength = 128;

/// Asks for the new name of a shopping item, starting with [initial];
/// `null` if the dialog was closed. Returns the name trimmed, never empty.
Future<String?> askShoppingItemName(
  BuildContext context, {
  required String initial,
}) => showDialog<String>(
  context: context,
  builder: (context) => _RenameDialog(initial: initial),
);

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});

  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _name = TextEditingController(text: widget.initial)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.initial.length,
    );

  /// Why the name can't be used, if it can't.
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final l10n = context.l10n;
    // The field counts characters as shown; Tandoor counts code points.
    final error = name.isEmpty
        ? l10n.shoppingRenameEmpty
        : name.runes.length > foodNameLength
        ? l10n.shoppingRenameTooLong(foodNameLength)
        : null;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return AlertDialog(
      // Room for the field above the keyboard, also in landscape.
      scrollable: true,
      title: Text(l10n.shoppingRenameTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.shoppingRenameHint,
            style: t.body.copyWith(color: t.inkMuted),
          ),
          SizedBox(height: t.space3),
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: foodNameLength,
            // A pasted longer name says so instead of being cut off.
            maxLengthEnforcement: MaxLengthEnforcement.none,
            // Counts what Tandoor counts: code points, as _submit checks.
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => Text(
                  '${_name.text.runes.length}/$foodNameLength',
                  style: t.caption.copyWith(color: t.inkMuted),
                ),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.shoppingRenameLabel,
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.shoppingRename)),
      ],
    );
  }
}

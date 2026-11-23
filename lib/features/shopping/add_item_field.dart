import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/repository_providers.dart';
import '../../design/design.dart';
import '../../domain/models/food.dart';
import '../../l10n/l10n.dart';

/// How many food suggestions show under the field.
const _maxSuggestions = 4;

/// The amount (and unit) part at the start of a line, such as "2 " or
/// "1,5 ", which isn't part of the food's name.
final _leadingAmount = RegExp(r'^[\d.,/½¼¾⅓⅔\s-]+');

/// The "Artikel hinzufügen" field at the top of the shopping list: a line
/// such as "2 Zitronen", added on Enter with [onAdd], and food suggestions
/// for what is typed after the amount.
///
/// [onAdd] answers whether the line was added; the field is emptied then.
/// With [enabled] false (offline) the field is read-only and a tap on it
/// calls [onDisabledTap].
class AddItemField extends ConsumerStatefulWidget {
  const AddItemField({
    super.key,
    required this.onAdd,
    required this.enabled,
    required this.onDisabledTap,
  });

  final Future<bool> Function(String line) onAdd;
  final bool enabled;
  final VoidCallback onDisabledTap;

  @override
  ConsumerState<AddItemField> createState() => _AddItemFieldState();
}

class _AddItemFieldState extends ConsumerState<AddItemField> {
  final _controller = TextEditingController();
  List<Food> _suggestions = const [];
  var _queries = 0;
  var _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// What to look foods up by: the text after the amount, or its last word
  /// if that finds nothing (a unit may stand in between).
  String _query(String text) =>
      text.replaceFirst(_leadingAmount, '').trimLeft();

  Future<void> _changed(String text) async {
    final query = _query(text);
    final id = ++_queries;
    if (query.trim().isEmpty) {
      setState(() => _suggestions = const []);
      return;
    }
    final foods = ref.read(foodRepositoryProvider);
    try {
      var found = await foods.autocomplete(query, limit: _maxSuggestions);
      final words = query.split(RegExp(r'\s+'));
      if (found.isEmpty && words.length > 1) {
        found = await foods.autocomplete(words.last, limit: _maxSuggestions);
      }
      if (!mounted || id != _queries) return;
      setState(() => _suggestions = found);
    } on Object {
      // Suggestions are a convenience; adding still works without them.
      if (mounted && id == _queries) setState(() => _suggestions = const []);
    }
  }

  /// Replaces what was typed of the food (all after the amount, or its last
  /// word) with [food].
  void _pick(Food food) {
    ++_queries;
    final text = _controller.text.trimRight();
    final query = _query(text);
    final typed = food.name.toLowerCase().startsWith(query.toLowerCase())
        ? query
        : query.split(RegExp(r'\s+')).last;
    final keep = text.substring(0, text.length - typed.length);
    final picked = '$keep${food.name}';
    _controller.value = TextEditingValue(
      text: picked,
      selection: TextSelection.collapsed(offset: picked.length),
    );
    setState(() => _suggestions = const []);
  }

  Future<void> _submit(String text) async {
    if (!widget.enabled || _busy || text.trim().isEmpty) return;
    setState(() {
      _busy = true;
      _suggestions = const [];
    });
    ++_queries;
    var added = false;
    try {
      added = await widget.onAdd(text.trim());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (added && mounted) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(t.radiusFull),
      borderSide: BorderSide(color: color, width: 2),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l10n.shoppingAddLabel,
          textField: true,
          child: TextField(
            controller: _controller,
            readOnly: !widget.enabled || _busy,
            onTap: widget.enabled ? null : widget.onDisabledTap,
            onChanged: (text) => unawaited(_changed(text)),
            onSubmitted: (text) => unawaited(_submit(text)),
            textInputAction: TextInputAction.done,
            style: t.bodyL.copyWith(color: widget.enabled ? t.ink : t.inkMuted),
            cursorColor: t.sage,
            decoration: InputDecoration(
              hintText: l10n.shoppingAddHint,
              hintStyle: t.bodyL.copyWith(color: t.inkMuted),
              filled: true,
              fillColor: t.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: t.space4,
                vertical: t.space3,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: t.space4, right: t.space2),
                child: Icon(Icons.add_rounded, color: t.inkMuted),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: t.sizeTouch),
              enabledBorder: border(t.controlBorder),
              focusedBorder: border(t.sage),
            ),
          ),
        ),
        for (final food in _suggestions)
          InkWell(
            onTap: () => _pick(food),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: t.sizeTouch),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: t.space4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(food.name, style: t.body.copyWith(color: t.ink)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

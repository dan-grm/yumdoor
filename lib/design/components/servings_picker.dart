import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../design.dart';

/// The stepper that sets servings before cooking starts
/// (docs/design/components/ServingsPicker.md).
///
/// A `sage-soft` pill with − and + around [label]. The minus button is
/// disabled, not hidden, at [min].
class ServingsPicker extends StatelessWidget {
  const ServingsPicker({
    super.key,
    required this.servings,
    required this.label,
    required this.onChanged,
    this.min = 1,
  });

  final int servings;

  /// [servings] in words: "4 Portionen", "12 Stück".
  final String label;
  final ValueChanged<int> onChanged;
  final int min;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;

    Widget button(IconData icon, String tooltip, int? to) => IconButton(
      onPressed: to == null ? null : () => onChanged(to),
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: Size.square(t.sizeTouch),
        iconSize: t.titleS.fontSize,
        foregroundColor: t.sage,
        disabledForegroundColor: t.inkMuted,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.sageSoft,
        borderRadius: BorderRadius.circular(t.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            Icons.remove_rounded,
            l10n.servingsDecrease,
            servings > min ? servings - 1 : null,
          ),
          Semantics(
            liveRegion: true,
            child: Text(label, style: t.label.copyWith(color: t.ink)),
          ),
          button(Icons.add_rounded, l10n.servingsIncrease, servings + 1),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../design.dart';

/// An ingredient with its amount in a `sage-soft` pill
/// (docs/design/components/IngredientRow.md).
///
/// Amounts arrive already scaled; the row never changes them. Long names wrap
/// instead of pushing the pill out; the pill takes at most 45% of the width.
///
/// With [onToggle], the row starts with a tick-off circle and the whole row
/// toggles [done]; screen readers get a checkbox labeled [toggleLabel].
class IngredientRow extends StatelessWidget {
  const IngredientRow({
    super.key,
    required this.name,
    this.note = '',
    this.amount = '',
    this.done = false,
    this.onToggle,
    this.toggleLabel = '',
    this.status = '',
  }) : assert(onToggle == null || toggleLabel != '');

  /// A state of the row under the note, with a sync icon ("wird
  /// synchronisiert"), empty if none.
  final String status;

  /// "Kreuzkümmel, gemahlen".
  final String name;

  /// Extra text under the name ("geschält"), empty if none.
  final String note;

  /// Amount and unit ("600 g", "½ Bund"), empty if none.
  final String amount;

  /// Ticked off: the name is struck through and the pill turns neutral.
  final bool done;

  /// Toggles [done]; `null` for a row without tick-off (recipe screen).
  final VoidCallback? onToggle;

  /// "Karotten abhaken", for screen readers.
  final String toggleLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.sizeTouch),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.space1),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              if (onToggle != null) ...[
                SizedBox(
                  width: t.sizeTouch,
                  height: t.sizeTouch,
                  child: Center(child: _CheckCircle(done: done)),
                ),
                SizedBox(width: t.space2),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: t.bodyL.copyWith(
                        color: done ? t.inkMuted : t.ink,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: t.inkMuted,
                      ),
                    ),
                    if (note.isNotEmpty)
                      Text(note, style: t.caption.copyWith(color: t.inkMuted)),
                    if (status.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.sync_rounded,
                            size: t.caption.fontSize,
                            color: t.inkMuted,
                          ),
                          SizedBox(width: t.space1),
                          Flexible(
                            child: Text(
                              status,
                              style: t.caption.copyWith(color: t.inkMuted),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (amount.isNotEmpty) ...[
                SizedBox(width: t.space3),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.45,
                  ),
                  child: AmountPill(amount, muted: done),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (onToggle == null) return row;
    // One checkbox for screen readers: "Karotten abhaken", value "600 g".
    return Semantics(
      checked: done,
      label: toggleLabel,
      value: [amount, note, status].where((part) => part.isNotEmpty).join(', '),
      onTap: onToggle,
      excludeSemantics: true,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(t.radiusM),
        child: row,
      ),
    );
  }
}

/// Diameter and ring width of the tick-off circle
/// (docs/design/components/IngredientRow.md).
const _checkSize = 26.0;
const _ringWidth = 2.0;

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: _checkSize,
      height: _checkSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? t.sage : null,
        border: done
            ? null
            : Border.all(color: t.controlBorder, width: _ringWidth),
      ),
      child: done
          ? Icon(Icons.check_rounded, size: t.label.fontSize, color: t.onSage)
          : null,
    );
  }
}

/// An ingredient amount in a `sage-soft` pill.
class AmountPill extends StatelessWidget {
  const AmountPill(this.amount, {super.key, this.muted = false});

  final String amount;

  /// `surface-sunken` instead of `sage-soft`, for ticked-off rows.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: muted ? t.surfaceSunken : t.sageSoft,
        borderRadius: BorderRadius.circular(t.radiusFull),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: t.space3, vertical: t.space1),
        child: Text(
          amount,
          style: t.label.copyWith(color: t.ink),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

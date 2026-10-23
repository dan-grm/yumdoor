import 'package:flutter/material.dart';

import '../design.dart';

/// An ingredient with its amount in a `sage-soft` pill
/// (docs/design/components/IngredientRow.md).
///
/// Amounts arrive already scaled; the row never changes them. Long names wrap
/// instead of pushing the pill out; the pill takes at most 45% of the width.
/// Tick-off comes with cooking mode's second milestone.
class IngredientRow extends StatelessWidget {
  const IngredientRow({
    super.key,
    required this.name,
    this.note = '',
    this.amount = '',
  });

  /// "Kreuzkümmel, gemahlen".
  final String name;

  /// Extra text under the name ("geschält"), empty if none.
  final String note;

  /// Amount and unit ("600 g", "½ Bund"), empty if none.
  final String amount;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.sizeTouch),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.space1),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: t.bodyL.copyWith(color: t.ink)),
                    if (note.isNotEmpty)
                      Text(note, style: t.caption.copyWith(color: t.inkMuted)),
                  ],
                ),
              ),
              if (amount.isNotEmpty) ...[
                SizedBox(width: t.space3),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.45,
                  ),
                  child: AmountPill(amount),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// An ingredient amount in a `sage-soft` pill.
class AmountPill extends StatelessWidget {
  const AmountPill(this.amount, {super.key});

  final String amount;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.sageSoft,
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

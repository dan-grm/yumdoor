import 'package:flutter/material.dart';

import '../design.dart';

/// Outline width of [AddFilterChip], and the dash pattern (mockup 03-suche).
const _addOutlineWidth = 2.0;
const _dash = 5.0;
const _gap = 4.0;

/// A selected search filter (docs/design/components/FilterChip.md): a
/// `sage-soft` chip with a leading check and a trailing ×. Tapping it removes
/// the filter.
class SelectedFilterChip extends StatelessWidget {
  const SelectedFilterChip({
    super.key,
    required this.label,
    required this.removeLabel,
    required this.onRemove,
  });

  final String label;

  /// The accessible label and tooltip: "enthält Karotten entfernen".
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return _ChipTapArea(
      label: removeLabel,
      selected: true,
      onTap: onRemove,
      child: _ChipBody(
        label: label,
        selected: true,
        trailing: Icons.close_rounded,
      ),
    );
  }
}

/// The dashed "+ Zutat" chip that adds a filter.
class AddFilterChip extends StatelessWidget {
  const AddFilterChip({
    super.key,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  final String label;

  /// The accessible label: "Zutat hinzufügen".
  final String tooltip;

  /// `null` disables the chip, e.g. a write action while offline.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = onPressed == null ? t.inkMuted : t.ink;
    return _ChipTapArea(
      label: tooltip,
      onTap: onPressed,
      child: CustomPaint(
        painter: _DashedOutlinePainter(
          color: onPressed == null ? t.line : t.controlBorder,
          radius: t.radiusM,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: t.space3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                size: t.label.fontSize! + t.space1,
                color: color,
              ),
              SizedBox(width: t.space1),
              Text(label, style: t.label.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One of a few mutually exclusive choices, as a chip
/// (docs/design/components/FilterChip.md): `surface` with a `line` border, or
/// `sage-soft` with a leading check when [selected].
class ChoiceFilterChip extends StatelessWidget {
  const ChoiceFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return _ChipTapArea(
      label: label,
      selected: selected,
      exclusive: true,
      tooltip: false,
      onTap: onSelected,
      child: _ChipBody(label: label, selected: selected),
    );
  }
}

/// The visible chip: `sage-soft` with a leading check when [selected], else
/// `surface` with a `line` border.
class _ChipBody extends StatelessWidget {
  const _ChipBody({required this.label, required this.selected, this.trailing});

  final String label;
  final bool selected;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final iconSize = t.label.fontSize! + t.space1;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? t.sageSoft : t.surface,
        border: selected ? null : Border.all(color: t.line),
        borderRadius: BorderRadius.circular(t.radiusM),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: t.space3,
          right: trailing == null ? t.space3 : t.space2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: iconSize, color: t.ink),
              SizedBox(width: t.space1),
            ],
            Text(label, style: t.label.copyWith(color: t.ink)),
            if (trailing case final icon?) ...[
              SizedBox(width: t.space1),
              Icon(icon, size: iconSize, color: t.ink),
            ],
          ],
        ),
      ),
    );
  }
}

/// A `size-chip` tall chip inside a `size-touch` tall tap area.
class _ChipTapArea extends StatelessWidget {
  const _ChipTapArea({
    required this.label,
    required this.onTap,
    required this.child,
    this.selected,
    this.exclusive = false,
    this.tooltip = true,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget child;
  final bool? selected;

  /// One of a group where selecting one deselects the others.
  final bool exclusive;

  /// Whether [label] also shows as a tooltip; off when it repeats the chip
  /// text.
  final bool tooltip;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final tappable = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(t.radiusM),
      child: SizedBox(
        height: t.sizeTouch,
        child: Center(
          widthFactor: 1,
          child: SizedBox(height: t.sizeChip, child: child),
        ),
      ),
    );
    return Semantics(
      button: true,
      enabled: onTap == null ? false : null,
      selected: selected,
      // Screen readers announce a radio button only with a checked state.
      checked: exclusive ? (selected ?? false) : null,
      inMutuallyExclusiveGroup: exclusive ? true : null,
      label: label,
      excludeSemantics: true,
      child: tooltip
          ? Tooltip(message: label, excludeFromSemantics: true, child: tappable)
          : tappable,
    );
  }
}

class _DashedOutlinePainter extends CustomPainter {
  _DashedOutlinePainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = _addOutlineWidth / 2;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            inset,
            inset,
            size.width - _addOutlineWidth,
            size.height - _addOutlineWidth,
          ),
          Radius.circular(radius),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _addOutlineWidth
      ..strokeCap = StrokeCap.round;
    for (final metric in outline.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += _dash + _gap) {
        canvas.drawPath(metric.extractPath(start, start + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutlinePainter old) =>
      old.color != color || old.radius != radius;
}

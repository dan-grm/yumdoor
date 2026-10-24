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
    final t = context.tokens;
    final iconSize = t.label.fontSize! + t.space1;
    return _ChipTapArea(
      label: removeLabel,
      selected: true,
      onTap: onRemove,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.sageSoft,
          borderRadius: BorderRadius.circular(t.radiusM),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: t.space3, right: t.space2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_rounded, size: iconSize, color: t.ink),
              SizedBox(width: t.space1),
              Text(label, style: t.label.copyWith(color: t.ink)),
              SizedBox(width: t.space1),
              Icon(Icons.close_rounded, size: iconSize, color: t.ink),
            ],
          ),
        ),
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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return _ChipTapArea(
      label: tooltip,
      onTap: onPressed,
      child: CustomPaint(
        painter: _DashedOutlinePainter(
          color: t.controlBorder,
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
                color: t.ink,
              ),
              SizedBox(width: t.space1),
              Text(label, style: t.label.copyWith(color: t.ink)),
            ],
          ),
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
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(t.radiusM),
          child: SizedBox(
            height: t.sizeTouch,
            child: Center(
              widthFactor: 1,
              child: SizedBox(height: t.sizeChip, child: child),
            ),
          ),
        ),
      ),
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

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../design.dart';

/// Ring width of the current step's dot (docs/design/components/StepDots.md).
const _ringWidth = 2.5;

/// Numbered dots showing progress through a recipe's steps
/// (docs/design/components/StepDots.md).
///
/// From 9 steps on they collapse to "3 / 12" with a thin bar, so the row
/// never wraps. Visual only: the top bar states the step in words. Tapping a
/// dot jumps to its step.
class StepDots extends StatelessWidget {
  const StepDots({
    super.key,
    required this.count,
    required this.current,
    this.onSelected,
  });

  final int count;

  /// Zero-based index of the current step.
  final int current;
  final ValueChanged<int>? onSelected;

  /// From this many steps on, the dots collapse to text and a bar.
  static const collapseAt = 9;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (count >= collapseAt) {
      return ExcludeSemantics(
        child: Row(
          children: [
            Text(
              context.l10n.cookingStepProgress(current + 1, count),
              style: t.label.copyWith(color: t.sage),
            ),
            SizedBox(width: t.space3),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(t.radiusFull),
                child: LinearProgressIndicator(
                  value: (current + 1) / count,
                  minHeight: t.space1 + t.space1 / 2,
                  color: t.sage,
                  backgroundColor: t.surfaceSunken,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < count; index++)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSelected == null ? null : () => onSelected!(index),
              child: SizedBox(
                // Dots sit space-2 minus 2px apart (the spec); the hit area
                // spans dot and gap, size-touch tall.
                width: t.sizeDot + t.space2 - 2,
                height: t.sizeTouch,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _Dot(
                    number: index + 1,
                    state: index < current
                        ? _DotState.done
                        : index == current
                        ? _DotState.current
                        : _DotState.upcoming,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _DotState { done, current, upcoming }

class _Dot extends StatelessWidget {
  const _Dot({required this.number, required this.state});

  final int number;
  final _DotState state;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (fill, border, color) = switch (state) {
      _DotState.done => (t.sage, null, t.onSage),
      _DotState.current => (
        Colors.transparent,
        Border.all(color: t.sage, width: _ringWidth),
        t.sage,
      ),
      _DotState.upcoming => (t.surfaceSunken, null, t.inkMuted),
    };
    return Container(
      width: t.sizeDot,
      height: t.sizeDot,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: border,
      ),
      child: state == _DotState.done
          ? Icon(Icons.check_rounded, size: t.label.fontSize, color: color)
          : Text(
              '$number',
              style: t.caption.copyWith(
                color: color,
                fontWeight: state == _DotState.current ? FontWeight.w800 : null,
              ),
            ),
    );
  }
}

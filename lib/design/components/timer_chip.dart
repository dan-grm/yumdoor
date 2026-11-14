import 'package:flutter/material.dart';

import '../design.dart';

/// A running timer (docs/design/components/TimerChip.md): `butter` with a
/// clock, a short label and the remaining time in tabular figures. Finished,
/// it turns `sage` with a check and "fertig". Tapping opens the timer sheet.
class TimerChip extends StatelessWidget {
  const TimerChip({
    super.key,
    required this.label,
    required this.time,
    required this.finished,
    required this.semanticsLabel,
    required this.onTap,
  });

  /// "Rösten".
  final String label;

  /// "04:12" while running; the "fertig" text when [finished].
  final String time;

  final bool finished;

  /// "Rösten, noch 04:12".
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final background = finished ? t.sage : t.butter;
    final foreground = finished ? t.onSage : t.onButter;
    final iconSize = t.label.fontSize! + t.space1;
    return Semantics(
      button: true,
      label: semanticsLabel,
      liveRegion: finished,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusM),
        child: SizedBox(
          height: t.sizeTouch,
          child: Center(
            widthFactor: 1,
            child: Container(
              height: t.sizeChip,
              padding: EdgeInsets.symmetric(horizontal: t.space3),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(t.radiusM),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    finished ? Icons.check_rounded : Icons.schedule_rounded,
                    size: iconSize,
                    color: foreground,
                  ),
                  SizedBox(width: t.space2),
                  Text(label, style: t.caption.copyWith(color: foreground)),
                  SizedBox(width: t.space2),
                  Text(
                    time,
                    style: t.label.copyWith(
                      color: foreground,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

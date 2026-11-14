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
    this.paused = false,
    required this.semanticsLabel,
    required this.onTap,
  });

  /// "Rösten".
  final String label;

  /// "04:12" while running; the "fertig" text when [finished].
  final String time;

  final bool finished;

  /// Shows a pause sign instead of the clock.
  final bool paused;

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
                    finished
                        ? Icons.check_rounded
                        : paused
                        ? Icons.pause_rounded
                        : Icons.schedule_rounded,
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

/// A duration detected in step text ("25 Minuten"), inline
/// (docs/design/components/TimerChip.md): `butter` behind it, `radius-s`,
/// 6px side padding, weight 800. Tapping it starts a timer; a second tap
/// within a second (a double tap) is ignored.
///
/// Put it in a [WidgetSpan] aligned to the baseline; the span scales it with
/// the text, so the text inside doesn't scale again.
class TimerHighlight extends StatefulWidget {
  const TimerHighlight({
    super.key,
    required this.text,
    required this.style,
    required this.semanticsLabel,
    required this.onTap,
  });

  /// The phrase as written: "25 Minuten".
  final String text;

  /// The running text's style around it.
  final TextStyle style;

  /// "25 Minuten, Timer starten".
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  State<TimerHighlight> createState() => _TimerHighlightState();
}

class _TimerHighlightState extends State<TimerHighlight> {
  final _sinceTap = Stopwatch();

  void _tap() {
    if (_sinceTap.isRunning && _sinceTap.elapsed < const Duration(seconds: 1)) {
      return;
    }
    _sinceTap
      ..reset()
      ..start();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final radius = BorderRadius.circular(t.radiusS);
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      onTap: _tap,
      excludeSemantics: true,
      child: Material(
        color: t.butter,
        borderRadius: radius,
        child: InkWell(
          onTap: _tap,
          borderRadius: radius,
          child: Padding(
            // 6px, as in the spec.
            padding: EdgeInsets.symmetric(horizontal: t.space1 * 1.5),
            child: Text(
              widget.text,
              textScaler: TextScaler.noScaling,
              style: widget.style.copyWith(
                color: t.onButter,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

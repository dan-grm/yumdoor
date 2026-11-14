import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/timer_chip.dart';
import '../../design/design.dart';
import '../../domain/models/cooking_timer.dart';
import '../../domain/models/recipe_step.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import 'cooking_providers.dart';

/// Rebuilds every second while [active], for remaining times on screen.
mixin _Ticking<T extends StatefulWidget> on State<T> {
  Timer? _ticker;

  /// Called on every tick, before the rebuild.
  void onTick() {}

  void keepTicking(bool active) {
    if (active && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        onTick();
        setState(() {});
      });
    } else if (!active) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

/// The running timers as chips, newest last, and a button to set one by
/// hand. Ticks every second while timers exist and alerts for finished ones
/// (`TimerAlertService`, through the controller) until they are turned off.
class TimerBar extends ConsumerStatefulWidget {
  const TimerBar({super.key, required this.recipeId, required this.recipeName});

  final int recipeId;

  /// The notification body: which recipe the timer belongs to.
  final String recipeName;

  @override
  ConsumerState<TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends ConsumerState<TimerBar> with _Ticking<TimerBar> {
  CookingTimersController get _controller =>
      ref.read(cookingTimersControllerProvider(widget.recipeId).notifier);

  @override
  void onTick() {
    final l10n = context.l10n;
    unawaited(
      _controller.tick(
        title: (timer) => l10n.timerChipFinished(timer.label),
        body: widget.recipeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final timers = ref.watch(cookingTimersControllerProvider(widget.recipeId));
    keepTicking(timers.isNotEmpty);
    final now = ref.read(clockProvider)();

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              spacing: t.space2,
              children: [
                for (final timer in timers)
                  _chip(context, timer, now, format, l10n),
              ],
            ),
          ),
        ),
        SizedBox(width: t.space2),
        RoundIconButton(
          icon: Icons.more_time_rounded,
          label: l10n.timerAdd,
          onPressed: () =>
              unawaited(showNewTimerSheet(context, recipeId: widget.recipeId)),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    CookingTimer timer,
    DateTime now,
    LocaleFormat format,
    AppLocalizations l10n,
  ) {
    final finished = timer.isFinished(now);
    final time = format.countdown(timer.remaining(now));
    return TimerChip(
      label: timer.label,
      time: finished ? l10n.timerFinished : time,
      finished: finished,
      semanticsLabel: finished
          ? l10n.timerChipFinished(timer.label)
          : timer.isPaused
          ? l10n.timerChipPaused(timer.label, time)
          : l10n.timerChipRunning(timer.label, time),
      onTap: () => unawaited(
        showTimerSheet(context, recipeId: widget.recipeId, timerId: timer.id),
      ),
    );
  }
}

/// Starts a timer and, the first time on a device that can't alert in the
/// background, says so once.
Future<void> startTimer(
  BuildContext context,
  WidgetRef ref, {
  required int recipeId,
  required String label,
  required Duration duration,
  int? stepId,
}) async {
  // Everything needed after the await is read now: a sheet that started the
  // timer is closed by then.
  final messenger = ScaffoldMessenger.of(context);
  final hint = context.l10n.timerBackgroundHint;
  final hintShown = ref.read(timerBackgroundHintShownProvider.notifier);
  final capabilities = await ref
      .read(cookingTimersControllerProvider(recipeId).notifier)
      .start(label: label, duration: duration, stepId: stepId);
  if (capabilities.backgroundAlerts || !hintShown.tryMark()) return;
  messenger.showSnackBar(SnackBar(content: Text(hint)));
}

/// "Timer starten · 25:00" for a step with an explicit time, with space
/// above it, unless a timer for the step is already set.
class StepTimerButton extends ConsumerWidget {
  const StepTimerButton({
    super.key,
    required this.recipeId,
    required this.step,
    required this.label,
  });

  final int recipeId;
  final RecipeStep step;

  /// The timer's name: the step's name, or "Schritt 2".
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(cookingTimersControllerProvider(recipeId));
    if (step.time <= Duration.zero ||
        timers.any((timer) => timer.stepId == step.id)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: context.tokens.space5),
      child: PillButton(
        label: context.l10n.timerStart(
          LocaleFormat.of(context).countdown(step.time),
        ),
        icon: Icons.play_arrow_rounded,
        onPressed: () => unawaited(
          startTimer(
            context,
            ref,
            recipeId: recipeId,
            label: label,
            duration: step.time,
            stepId: step.id,
          ),
        ),
      ),
    );
  }
}

Future<void> _showSheet(BuildContext context, Widget child) {
  final t = context.tokens;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space5),
        child: child,
      ),
    ),
  );
}

/// One timer: its time, and pause or resume, +1 min, delete; or turn off
/// once finished.
Future<void> showTimerSheet(
  BuildContext context, {
  required int recipeId,
  required String timerId,
}) => _showSheet(context, _TimerSheet(recipeId: recipeId, timerId: timerId));

class _TimerSheet extends ConsumerStatefulWidget {
  const _TimerSheet({required this.recipeId, required this.timerId});

  final int recipeId;
  final String timerId;

  @override
  ConsumerState<_TimerSheet> createState() => _TimerSheetState();
}

class _TimerSheetState extends ConsumerState<_TimerSheet>
    with _Ticking<_TimerSheet> {
  @override
  void initState() {
    super.initState();
    keepTicking(true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final provider = cookingTimersControllerProvider(widget.recipeId);
    final timers = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final timer = timers.where((t) => t.id == widget.timerId).firstOrNull;
    if (timer == null) return const SizedBox.shrink();
    final now = ref.read(clockProvider)();
    final finished = timer.isFinished(now);

    void close() => Navigator.of(context).pop();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          timer.label,
          textAlign: TextAlign.center,
          style: t.titleM.copyWith(color: t.ink),
        ),
        SizedBox(height: t.space2),
        Text(
          finished
              ? l10n.timerFinished
              : LocaleFormat.of(context).countdown(timer.remaining(now)),
          textAlign: TextAlign.center,
          style: t.titleL.copyWith(
            color: finished ? t.sage : t.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(height: t.space5),
        if (finished) ...[
          PillButton(
            label: l10n.timerTurnOff,
            icon: Icons.check_rounded,
            onPressed: () {
              controller.remove(timer.id);
              close();
            },
          ),
          SizedBox(height: t.space3),
          PillButton(
            label: l10n.timerAddMinute,
            kind: PillButtonKind.secondary,
            onPressed: () => controller.addMinute(timer.id),
          ),
        ] else ...[
          Row(
            spacing: t.space3,
            children: [
              Expanded(
                child: PillButton(
                  label: timer.isPaused ? l10n.timerResume : l10n.timerPause,
                  icon: timer.isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  onPressed: () => timer.isPaused
                      ? controller.resume(timer.id)
                      : controller.pause(timer.id),
                ),
              ),
              Expanded(
                child: PillButton(
                  label: l10n.timerAddMinute,
                  kind: PillButtonKind.secondary,
                  onPressed: () => controller.addMinute(timer.id),
                ),
              ),
            ],
          ),
          SizedBox(height: t.space3),
          PillButton(
            label: l10n.timerDelete,
            kind: PillButtonKind.secondary,
            icon: Icons.delete_outline_rounded,
            onPressed: () {
              controller.remove(timer.id);
              close();
            },
          ),
        ],
      ],
    );
  }
}

/// Sets a timer by hand: minutes, then "Starten".
Future<void> showNewTimerSheet(BuildContext context, {required int recipeId}) =>
    _showSheet(context, _NewTimerSheet(recipeId: recipeId));

class _NewTimerSheet extends ConsumerStatefulWidget {
  const _NewTimerSheet({required this.recipeId});

  final int recipeId;

  @override
  ConsumerState<_NewTimerSheet> createState() => _NewTimerSheetState();
}

class _NewTimerSheetState extends ConsumerState<_NewTimerSheet> {
  static const _maxMinutes = 300;
  var _minutes = 5;

  void _change(int delta) => setState(
    () => _minutes = math.max(1, math.min(_maxMinutes, _minutes + delta)),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.timerNew,
          textAlign: TextAlign.center,
          style: t.titleM.copyWith(color: t.ink),
        ),
        SizedBox(height: t.space4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundIconButton(
              icon: Icons.remove_rounded,
              label: l10n.timerLess,
              outlined: true,
              onPressed: _minutes > 1 ? () => _change(-1) : null,
            ),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  l10n.timerMinutes(_minutes),
                  textAlign: TextAlign.center,
                  style: t.titleL.copyWith(
                    color: t.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            RoundIconButton(
              icon: Icons.add_rounded,
              label: l10n.timerMore,
              outlined: true,
              onPressed: _minutes < _maxMinutes ? () => _change(1) : null,
            ),
          ],
        ),
        SizedBox(height: t.space5),
        PillButton(
          label: l10n.timerStartManual,
          icon: Icons.play_arrow_rounded,
          onPressed: () {
            final navigator = Navigator.of(context);
            unawaited(
              startTimer(
                context,
                ref,
                recipeId: widget.recipeId,
                label: l10n.timerManualLabel,
                duration: Duration(minutes: _minutes),
              ),
            );
            navigator.pop();
          },
        ),
      ],
    );
  }
}

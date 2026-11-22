import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/services/week_plan.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../common/recipe_image.dart';
import '../shell/app_shell.dart';
import 'plan_actions.dart';
import 'planner_providers.dart';
import 'week_labels.dart';

/// The week planner (mockup 10-wochenplan): the days of one week with their
/// planned meals, and buttons to browse the weeks.
///
/// A meal can be dragged to another day (after a long press on touch
/// screens), and its menu edits, moves or deletes it. Offline, all of that is
/// disabled.
///
/// It shows the week of [day], the current week if `null`. Browsing changes
/// the location ([planLocation]), so going to a day always shows its week,
/// even one shown before.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key, this.day});

  /// A day whose week to show.
  final CalendarDay? day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final firstWeekday = firstWeekdayOf(context);
    final thisWeek = startOfWeek(today, firstWeekday);
    final start = startOfWeek(day ?? today, firstWeekday);

    void show(CalendarDay week) =>
        context.go(plannerLocation(context, week, today));

    /// Loads the week again, for pull to refresh.
    Future<void> refresh() async {
      ref.invalidate(weekPlansProvider(start));
      try {
        await ref.read(weekPlansProvider(start).future);
      } on Object {
        // The screen shows the failure.
      }
    }

    final plans = ref.watch(weekPlansProvider(start));
    final pending = ref.watch(pendingPlansProvider);
    final offline = ref.watch(isOfflineProvider);
    final onlyMine = ref.watch(plannerOnlyMineProvider);
    final people = ref.watch(plannerPeopleProvider).value;
    final me = people?.me;
    final names = people?.names ?? const <int, String>{};
    final end = start.addDays(daysInWeek - 1);

    // Kept for after awaits: the screen may be gone by then.
    final container = ProviderScope.containerOf(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    /// Moves [plan] to start on [day], showing it there at once. A failure
    /// puts it back and says why; with [confirm], so does success.
    Future<void> move(
      MealPlan plan,
      CalendarDay day, {
      bool confirm = false,
    }) async {
      final pending = container.read(pendingPlansProvider.notifier);
      if (pending.isPending(plan.id)) return;
      final failure = await pending.move(plan, day, shown: start);
      if (failure == null && !confirm) return;
      showPlannerMessage(
        messenger,
        (context) => switch (failure) {
          null => context.l10n.planMoved(dayLabel(context, day)),
          final failure => context.l10n.planMoveFailed(
            failureMessage(context, failure),
          ),
        },
      );
    }

    final actions = offline
        ? null
        : _PlanActions(
            move: move,
            edit: (plan) => showEditPlanSheet(context, plan, shown: start),
            pickDay: (plan) async {
              final day = await showMovePlanSheet(context, plan);
              if (day != null) await move(plan, day, confirm: true);
            },
            delete: (plan) => confirmAndDeletePlan(context, plan, shown: start),
          );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.navPlanTitle,
                  style: t.titleL.copyWith(color: t.ink),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
              child: _WeekBar(
                start: start,
                today: today,
                isCurrent: start == thisWeek,
                onPrevious: () => show(start.addDays(-daysInWeek)),
                onNext: () => show(start.addDays(daysInWeek)),
                onCurrent: () => show(thisWeek),
              ),
            ),
            _HouseholdBar(
              onlyMine: onlyMine,
              onChanged: ref.read(plannerOnlyMineProvider.notifier).set,
            ),
            SizedBox(height: t.space3),
            Expanded(
              child: switch (plans) {
                AsyncData(:final value) => _Days(
                  start: start,
                  today: today,
                  plans: [
                    for (final loaded in value)
                      if ((pending.containsKey(loaded.id)
                              ? pending[loaded.id]
                              : loaded)
                          case final plan?
                          when (!onlyMine ||
                                  me == null ||
                                  plan.createdBy == me) &&
                              !plan.toDay.isBefore(start) &&
                              !plan.fromDay.isAfter(end))
                        plan,
                  ],
                  actions: actions,
                  pending: pending.keys.toSet(),
                  me: me,
                  names: names,
                  onRefresh: refresh,
                ),
                AsyncError(:final error) => FailureView(
                  error: error,
                  onRetry: () => ref.invalidate(weekPlansProvider(start)),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The note that plans are shared with the household, and the choice between
/// all plans and the current user's own.
class _HouseholdBar extends StatelessWidget {
  const _HouseholdBar({required this.onlyMine, required this.onChanged});

  final bool onlyMine;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(t.space5, t.space2, t.space5, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.planSharedWithHousehold,
              style: t.caption.copyWith(color: t.inkMuted),
            ),
          ),
          ChoiceFilterChip(
            label: l10n.planFilterAll,
            selected: !onlyMine,
            onSelected: () => onChanged(false),
          ),
          SizedBox(width: t.space2),
          ChoiceFilterChip(
            label: l10n.planFilterMine,
            selected: onlyMine,
            onSelected: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

/// The date range with the buttons for the weeks before and after.
class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.start,
    required this.today,
    required this.isCurrent,
    required this.onPrevious,
    required this.onNext,
    required this.onCurrent,
  });

  final CalendarDay start;
  final CalendarDay today;
  final bool isCurrent;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onCurrent;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final range = weekRangeLabel(context, start, today);
    return Row(
      children: [
        RoundIconButton(
          icon: Icons.chevron_left_rounded,
          label: l10n.planWeekPrevious,
          onPressed: onPrevious,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  range,
                  textAlign: TextAlign.center,
                  style: t.titleS.copyWith(color: t.ink),
                ),
              ),
              if (isCurrent)
                Text(
                  l10n.planThisWeek,
                  style: t.caption.copyWith(color: t.inkMuted),
                )
              else
                PillButton(
                  label: l10n.planBackToThisWeek,
                  onPressed: onCurrent,
                  kind: PillButtonKind.secondary,
                  compact: true,
                ),
            ],
          ),
        ),
        RoundIconButton(
          icon: Icons.chevron_right_rounded,
          label: l10n.planWeekNext,
          onPressed: onNext,
        ),
      ],
    );
  }
}

/// The seven days from [start], with the [plans] on each.
class _Days extends StatefulWidget {
  const _Days({
    required this.start,
    required this.today,
    required this.plans,
    required this.me,
    required this.names,
    required this.actions,
    required this.pending,
    required this.onRefresh,
  });

  final CalendarDay start;
  final CalendarDay today;
  final List<MealPlan> plans;

  /// What can be done with the plans, `null` while offline.
  final _PlanActions? actions;

  /// The ids of plans with a change pending, which get no new ones.
  final Set<int> pending;

  /// The current user's id and the users' names, to mark the meals of others.
  final int? me;
  final Map<int, String> names;
  final Future<void> Function() onRefresh;

  @override
  State<_Days> createState() => _DaysState();
}

class _DaysState extends State<_Days> {
  final _controller = ScrollController();
  final _listKey = GlobalKey();
  late final _autoScroll = _AutoScroll(_controller, _listKey);

  @override
  void dispose() {
    _autoScroll.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final _Days(
      :start,
      :today,
      :plans,
      :me,
      :names,
      :actions,
      :pending,
      :onRefresh,
    ) = widget;
    _autoScroll
      ..edge = t.sizeTouch
      ..step = t.space2;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          // Follows the finger from here, not from the dragged card: the
          // list disposes rows that scroll far enough away, that one too.
          child: Listener(
            onPointerMove: (event) => _autoScroll.update(event.position),
            onPointerUp: (_) => _autoScroll.stop(),
            onPointerCancel: (_) => _autoScroll.stop(),
            child: ListView(
              key: _listKey,
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space5),
              children: [
                if (plans.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: t.space3),
                    child: Text(
                      l10n.planEmptyWeek,
                      style: t.body.copyWith(color: t.inkMuted),
                    ),
                  ),
                for (var i = 0; i < daysInWeek; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: t.space2),
                    child: _DayRow(
                      day: start.addDays(i),
                      isToday: start.addDays(i) == today,
                      plans: plansOnDay(plans, start.addDays(i)),
                      me: me,
                      names: names,
                      actions: actions,
                      pending: pending,
                      autoScroll: _autoScroll,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrolls the planner while a dragged plan is held near its top or bottom
/// edge, so that every day can be reached: a drag can't scroll by itself.
///
/// [start] it when a drag starts; the list's pointer events then [update] it
/// until the pointer is lifted ([stop]).
class _AutoScroll {
  _AutoScroll(this._controller, this._listKey);

  final ScrollController _controller;
  final GlobalKey _listKey;

  /// How close to an edge scrolling starts, and how far each frame goes.
  double edge = 0;
  double step = 0;

  Timer? _timer;
  double _speed = 0;
  bool _dragging = false;

  /// A plan is being dragged.
  void start() => _dragging = true;

  /// The pointer is at [position] (global).
  void update(Offset position) {
    if (!_dragging) return;
    final box = _listKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final y = box.globalToLocal(position).dy;
    _speed = y < edge
        ? -step
        : y > box.size.height - edge
        ? step
        : 0;
    if (_speed == 0) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    _timer ??= Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_controller.hasClients) return stop();
      final scroll = _controller.position;
      final to = (scroll.pixels + _speed).clamp(
        scroll.minScrollExtent,
        scroll.maxScrollExtent,
      );
      if (to != scroll.pixels) _controller.jumpTo(to);
    });
  }

  /// The drag ended.
  void stop() {
    _dragging = false;
    _timer?.cancel();
    _timer = null;
  }
}

/// What the planner can do with a plan; see [PlannerScreen].
class _PlanActions {
  const _PlanActions({
    required this.move,
    required this.edit,
    required this.pickDay,
    required this.delete,
  });

  /// Moves the plan to start on the day.
  final Future<void> Function(MealPlan plan, CalendarDay day) move;

  /// Opens the edit sheet.
  final void Function(MealPlan plan) edit;

  /// Asks for another day and moves the plan there.
  final void Function(MealPlan plan) pickDay;

  /// Asks and deletes the plan.
  final void Function(MealPlan plan) delete;
}

/// A plan being dragged, from the [day] it was picked up on: a plan of
/// several days is on each of them.
typedef _PlanDrag = ({MealPlan plan, CalendarDay day});

/// One day of the planner. While a plan is dragged over it, it says "Hier
/// ablegen" and takes the plan: the day it was picked up on moves here, and
/// the rest of a plan of several days moves with it.
class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.isToday,
    required this.plans,
    required this.me,
    required this.names,
    required this.actions,
    required this.pending,
    required this.autoScroll,
  });

  final CalendarDay day;
  final bool isToday;
  final List<MealPlan> plans;
  final int? me;
  final Map<int, String> names;
  final _PlanActions? actions;
  final Set<int> pending;
  final _AutoScroll autoScroll;

  /// The first day of the dragged plan if dropped here.
  CalendarDay _newStart(_PlanDrag drag) =>
      drag.plan.fromDay.addDays(day.differenceInDays(drag.day));

  @override
  Widget build(BuildContext context) => DragTarget<_PlanDrag>(
    onWillAcceptWithDetails: (details) =>
        actions != null && _newStart(details.data) != details.data.plan.fromDay,
    onAcceptWithDetails: (details) =>
        actions?.move(details.data.plan, _newStart(details.data)),
    builder: (context, candidates, rejected) =>
        _build(context, hovered: candidates.isNotEmpty),
  );

  Widget _build(BuildContext context, {required bool hovered}) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final date = day.atLocalTime();
    final name = dayLabel(context, day);
    final label = isToday ? l10n.planToday(name) : name;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: label,
          excludeSemantics: true,
          container: true,
          child: _DayLabel(
            weekday: format.weekdayShort(date),
            number: format.integer(day.day),
            isToday: isToday,
          ),
        ),
        SizedBox(width: t.space3),
        Expanded(
          // "Hier ablegen" covers the day instead of adding to it: a day
          // that changes its height would move the others under the finger.
          child: Stack(
            children: [
              plans.isEmpty
                  ? const _EmptyDay()
                  : Column(
                      children: [
                        for (final (i, plan) in plans.indexed) ...[
                          if (i > 0) SizedBox(height: t.space2),
                          _PlanCard(
                            key: ValueKey(plan.id),
                            plan: plan,
                            day: day,
                            plannedBy: me == null || plan.createdBy == me
                                ? null
                                : names[plan.createdBy] ?? '',
                            actions: pending.contains(plan.id) ? null : actions,
                            autoScroll: autoScroll,
                          ),
                        ],
                      ],
                    ),
              if (hovered) const Positioned.fill(child: _DropHere()),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    required this.weekday,
    required this.number,
    required this.isToday,
  });

  final String weekday;
  final String number;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SizedBox(
      width: context.tokens.sizeTouch,
      child: Padding(
        padding: EdgeInsets.only(top: t.space1),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isToday ? t.sage : Colors.transparent,
            borderRadius: BorderRadius.circular(t.radiusM),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: t.space1),
            child: Column(
              children: [
                Text(
                  weekday,
                  style: t.caption.copyWith(
                    color: isToday ? t.onSage : t.inkMuted,
                  ),
                ),
                Text(
                  number,
                  style: t.titleS.copyWith(color: isToday ? t.onSage : t.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A day without meals: a placeholder for planning one, disabled until
/// planning exists.
class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      enabled: false,
      label: context.l10n.planAddRecipe,
      excludeSemantics: true,
      child: Container(
        height: t.sizeTouch,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.radiusM),
          border: Border.all(color: t.line),
        ),
        child: Text(
          context.l10n.planAddRecipe,
          style: t.label.copyWith(color: t.inkMuted),
        ),
      ),
    );
  }
}

/// Where a dragged plan lands: "Hier ablegen".
class _DropHere extends StatelessWidget {
  const _DropHere();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.sageSoft,
        borderRadius: BorderRadius.circular(t.radiusM),
        border: Border.all(color: t.sage, width: t.space1 / 2),
      ),
      child: Text(
        context.l10n.planDropHere,
        style: t.label.copyWith(color: t.sage),
      ),
    );
  }
}

/// A [Draggable] for a mouse or trackpad: dragging starts right away.
class _PointerDraggable<T extends Object> extends Draggable<T> {
  const _PointerDraggable({
    required super.child,
    required super.feedback,
    super.data,
    super.childWhenDragging,
    super.maxSimultaneousDrags,
    super.onDragStarted,
    super.onDragEnd,
  });

  @override
  MultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) => ImmediateMultiDragGestureRecognizer(
    supportedDevices: const {
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
    },
  )..onStart = onStart;
}

/// A [Draggable] for fingers and pens: dragging starts after a long press,
/// so that swiping still scrolls. By input device, not platform: a laptop
/// can have a touch screen.
class _TouchDraggable<T extends Object> extends LongPressDraggable<T> {
  const _TouchDraggable({
    required super.child,
    required super.feedback,
    super.data,
    super.childWhenDragging,
    super.maxSimultaneousDrags,
    super.onDragStarted,
    super.onDragEnd,
  });

  @override
  DelayedMultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) =>
      DelayedMultiDragGestureRecognizer(
          supportedDevices: const {
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.invertedStylus,
            PointerDeviceKind.unknown,
          },
        )
        ..onStart = (position) {
          final drag = onStart(position);
          if (drag != null) HapticFeedback.selectionClick();
          return drag;
        };
}

/// One planned meal on [day], with its menu. Opens its recipe if it has one.
/// Unless [actions] is `null` (offline), it can be dragged to another day.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    super.key,
    required this.plan,
    required this.day,
    this.plannedBy,
    required this.actions,
    required this.autoScroll,
  });

  final MealPlan plan;
  final CalendarDay day;
  final _AutoScroll autoScroll;

  /// The name of the household member who planned it, empty if unknown;
  /// `null` for the current user's own plans.
  final String? plannedBy;
  final _PlanActions? actions;

  @override
  Widget build(BuildContext context) {
    final card = _PlanTile(plan: plan, plannedBy: plannedBy, actions: actions);
    // The same widgets with and without actions, so the card keeps its state
    // (and its image) when a change of it is pending.
    final drags = actions == null ? 0 : 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final _PlanDrag data = (plan: plan, day: day);
        // In the overlay, as wide as the card.
        final feedback = SizedBox(
          width: constraints.maxWidth,
          child: _PlanTile(
            plan: plan,
            plannedBy: plannedBy,
            actions: actions,
            lifted: true,
          ),
        );
        final placeholder = Opacity(opacity: 0.4, child: card);
        return _TouchDraggable<_PlanDrag>(
          data: data,
          feedback: feedback,
          childWhenDragging: placeholder,
          maxSimultaneousDrags: drags,
          onDragStarted: autoScroll.start,
          onDragEnd: (_) => autoScroll.stop(),
          child: _PointerDraggable<_PlanDrag>(
            data: data,
            feedback: feedback,
            childWhenDragging: placeholder,
            maxSimultaneousDrags: drags,
            onDragStarted: autoScroll.start,
            onDragEnd: (_) => autoScroll.stop(),
            child: card,
          ),
        );
      },
    );
  }
}

/// What can be done with a plan, in its menu.
enum _PlanAction { edit, move, delete }

/// The look of a [_PlanCard]: [lifted] while it is dragged.
class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.plannedBy,
    required this.actions,
    this.lifted = false,
  });

  final MealPlan plan;
  final String? plannedBy;
  final _PlanActions? actions;
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipe = plan.recipe;
    final meal = l10n.planMealLine(
      plan.mealType.name,
      LocaleFormat.of(context).amount(plan.servings),
    );
    final placeholder = Center(
      child: Icon(
        recipe == null ? Icons.edit_note_rounded : Icons.soup_kitchen_outlined,
        size: t.titleS.fontSize,
        color: t.sage,
      ),
    );
    final actions = this.actions;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusM),
      side: lifted
          ? BorderSide(color: t.sage, width: t.space1 / 2)
          : BorderSide(color: t.line),
    );
    final material = Material(
      color: t.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: recipe == null
            ? null
            : () => context.push('/recipe/${recipe.id}'),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.sizeTouch + t.space3),
          child: Padding(
            padding: EdgeInsets.all(t.space2),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(t.radiusS),
                  child: SizedBox.square(
                    dimension: t.sizeTouch,
                    child: ColoredBox(
                      color: t.sageSoft,
                      child: RecipeImage(
                        url: recipe?.image,
                        placeholder: placeholder,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: t.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.caption.copyWith(color: t.inkMuted),
                      ),
                      Text(
                        plan.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.label.copyWith(color: t.ink),
                      ),
                      if (plannedBy case final name?)
                        Text(
                          name.isEmpty
                              ? l10n.planPlannedByOther
                              : l10n.planPlannedBy(name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: t.inkMuted),
                        ),
                    ],
                  ),
                ),
                OfflineDisabled(
                  builder: (context, enabled) => PopupMenuButton<_PlanAction>(
                    enabled: enabled && actions != null,
                    tooltip: l10n.planMealMenu(plan.label),
                    icon: const Icon(Icons.more_vert_rounded),
                    iconColor: t.inkMuted,
                    onSelected: (action) => switch (action) {
                      _PlanAction.edit => actions?.edit(plan),
                      _PlanAction.move => actions?.pickDay(plan),
                      _PlanAction.delete => actions?.delete(plan),
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _PlanAction.edit,
                        child: Text(l10n.planEdit),
                      ),
                      PopupMenuItem(
                        value: _PlanAction.move,
                        child: Text(l10n.planMove),
                      ),
                      PopupMenuItem(
                        value: _PlanAction.delete,
                        child: Text(
                          l10n.planDelete,
                          style: TextStyle(color: t.danger),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!lifted) return material;
    return DecoratedBox(
      decoration: ShapeDecoration(shape: shape, shadows: t.shadowLift),
      child: material,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../common/recipe_image.dart';
import 'planner_providers.dart';

/// The week planner (mockup 10-wochenplan): the days of one week with their
/// planned meals, and buttons to browse the weeks.
class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  /// How many weeks the shown week is after the current one.
  int _offset = 0;

  /// Loads the week at [start] again, for pull to refresh.
  Future<void> _refresh(CalendarDay start) async {
    ref.invalidate(weekPlansProvider(start));
    try {
      await ref.read(weekPlansProvider(start).future);
    } on Object {
      // The screen shows the failure.
    }
  }

  void _browse(int weeks) => setState(() => _offset += weeks);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final firstWeekday = _firstWeekday(context);
    final start = startOfWeek(
      today,
      firstWeekday,
    ).addDays(_offset * daysInWeek);
    final end = start.addDays(daysInWeek - 1);
    final plans = ref.watch(weekPlansProvider(start));
    final onlyMine = ref.watch(plannerOnlyMineProvider);
    final people = ref.watch(plannerPeopleProvider).value;
    final me = people?.me;
    final names = people?.names ?? const <int, String>{};

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
                end: end,
                today: today,
                isCurrent: _offset == 0,
                onPrevious: () => _browse(-1),
                onNext: () => _browse(1),
                onCurrent: () => setState(() => _offset = 0),
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
                    for (final plan in value)
                      if (!onlyMine || me == null || plan.createdBy == me) plan,
                  ],
                  me: me,
                  names: names,
                  onRefresh: () => _refresh(start),
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

/// The first day of the week in the locale, 1 (Monday) to 7 (Sunday).
int _firstWeekday(BuildContext context) {
  // 0 is Sunday, 1 Monday.
  final index = MaterialLocalizations.of(context).firstDayOfWeekIndex;
  return index == 0 ? DateTime.sunday : index;
}

/// The date range with the buttons for the weeks before and after.
class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.start,
    required this.end,
    required this.today,
    required this.isCurrent,
    required this.onPrevious,
    required this.onNext,
    required this.onCurrent,
  });

  final CalendarDay start;
  final CalendarDay end;
  final CalendarDay today;
  final bool isCurrent;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onCurrent;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final now = today.atLocalTime();
    final range = l10n.planRange(
      format.dayMonthOrDate(start.atLocalTime(), now),
      format.dayMonthOrDate(end.atLocalTime(), now),
    );
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
class _Days extends StatelessWidget {
  const _Days({
    required this.start,
    required this.today,
    required this.plans,
    required this.me,
    required this.names,
    required this.onRefresh,
  });

  final CalendarDay start;
  final CalendarDay today;
  final List<MealPlan> plans;

  /// The current user's id and the users' names, to mark the meals of others.
  final int? me;
  final Map<int, String> names;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          child: ListView(
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
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.isToday,
    required this.plans,
    required this.me,
    required this.names,
  });

  final CalendarDay day;
  final bool isToday;
  final List<MealPlan> plans;
  final int? me;
  final Map<int, String> names;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final date = day.atLocalTime();
    final name = l10n.planDayLabel(
      format.weekdayLong(date),
      format.dayMonth(date),
    );
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
          child: plans.isEmpty
              ? const _EmptyDay()
              : Column(
                  children: [
                    for (final (i, plan) in plans.indexed) ...[
                      if (i > 0) SizedBox(height: t.space2),
                      _PlanCard(
                        plan: plan,
                        plannedBy: me == null || plan.createdBy == me
                            ? null
                            : names[plan.createdBy] ?? '',
                      ),
                    ],
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

/// One planned meal. Opens its recipe if it has one.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, this.plannedBy});

  final MealPlan plan;

  /// The name of the household member who planned it, empty if unknown;
  /// `null` for the current user's own plans.
  final String? plannedBy;

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
    return Material(
      color: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.radiusM),
        side: BorderSide(color: t.line),
      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

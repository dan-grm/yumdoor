import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/components/servings_picker.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/meal_type.dart';
import '../../domain/services/week_plan.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../recipe/ingredient_lines.dart';
import 'plan_sheet.dart';
import 'planner_providers.dart';
import 'week_labels.dart';

/// Shows the [message] built in the context of [messenger], unless it is
/// gone. The messenger outlives the sheets and screens that report through
/// it.
void showPlannerMessage(
  ScaffoldMessengerState messenger,
  String Function(BuildContext context) message,
) {
  if (!messenger.mounted) return;
  messenger.showSnackBar(SnackBar(content: Text(message(messenger.context))));
}

/// Opens the [EditPlanSheet] for [plan]. Once the changes are saved, a
/// snackbar says so and the planner's weeks reload.
Future<void> showEditPlanSheet(BuildContext context, MealPlan plan) {
  final messenger = ScaffoldMessenger.of(context);

  void report(String Function(BuildContext context) message) =>
      showPlannerMessage(messenger, message);

  return showPlannerSheet<void>(
    context,
    (context) => EditPlanSheet(
      plan: plan,
      onSaved: () => report((context) => context.l10n.planEditSaved),
      onFailedAfterClose: (failure) => report(
        (context) =>
            context.l10n.planEditFailed(failureMessage(context, failure)),
      ),
    ),
  );
}

/// The plan sheet in edit mode: the day, meal type and servings of a
/// planned [plan], from the parts of the [PlanSheet]. A plan of several days
/// keeps its length on another day. For a plan on the shopping list it says
/// that the amounts there follow the servings, as Tandoor rescales them.
class EditPlanSheet extends ConsumerStatefulWidget {
  const EditPlanSheet({
    super.key,
    required this.plan,
    required this.onSaved,
    this.onFailedAfterClose,
  });

  final MealPlan plan;

  /// Called once the changes are saved, also if the sheet was closed
  /// meanwhile.
  final VoidCallback onSaved;

  /// Called if saving fails after the sheet was closed; while it is open,
  /// the sheet shows the failure.
  final ValueChanged<Failure>? onFailedAfterClose;

  @override
  ConsumerState<EditPlanSheet> createState() => _EditPlanSheetState();
}

class _EditPlanSheetState extends ConsumerState<EditPlanSheet> {
  late CalendarDay _day = widget.plan.fromDay;
  late MealType _mealType = widget.plan.mealType;

  /// Tandoor's servings may have decimals; they stay as they are unless the
  /// user changes them.
  late final int _initialServings = widget.plan.servings.round().clamp(
    1,
    maxPlanServings,
  );
  late int _servings = _initialServings;

  bool _saving = false;
  String? _error;

  /// What the user changed, `null` if nothing.
  MealPlanChanges? get _changes {
    final plan = widget.plan;
    final day = _day == plan.fromDay ? null : _day;
    final mealType = _mealType.id == plan.mealType.id ? null : _mealType;
    final servings = _servings == _initialServings
        ? null
        : _servings.toDouble();
    if (day == null && mealType == null && servings == null) return null;
    return MealPlanChanges(day: day, mealType: mealType, servings: servings);
  }

  Future<void> _save(MealPlanChanges changes) async {
    // Read before the first await: the sheet may be dragged away meanwhile.
    final container = ProviderScope.containerOf(context, listen: false);
    final mealPlans = ref.read(mealPlanRepositoryProvider);
    final onSaved = widget.onSaved;
    final onFailedAfterClose = widget.onFailedAfterClose;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await mealPlans.update(widget.plan.id, changes);
    } on Failure catch (failure) {
      if (!mounted) {
        onFailedAfterClose?.call(failure);
        return;
      }
      setState(() {
        _saving = false;
        _error = context.l10n.planEditFailed(failureMessage(context, failure));
      });
      return;
    }
    container.invalidate(weekPlansProvider);
    onSaved();
    if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final plan = widget.plan;
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final weekStart = startOfWeek(_day, firstWeekdayOf(context));
    final plans = ref.watch(weekPlansProvider(weekStart)).value;
    final mealTypes = ref.watch(mealTypesProvider);
    final servingsText = plan.recipe?.servingsText.trim() ?? '';
    final changes = _changes;

    return _SheetBody(
      saving: _saving,
      title: l10n.planEditTitle,
      subtitle: plan.label,
      error: _error,
      submitLabel: l10n.planEditSave,
      onSubmit: changes == null ? null : () => _save(changes),
      children: [
        PlanDayPicker(
          day: _day,
          today: today,
          plans: plans ?? const [],
          onChanged: (day) => setState(() => _day = day),
        ),
        SizedBox(height: t.space4),
        PlanSectionLabel(l10n.planSheetMealType),
        SizedBox(height: t.space1),
        MealTypePicker(
          mealTypes: mealTypes,
          selected: _mealType,
          onSelected: (type) => setState(() => _mealType = type),
        ),
        SizedBox(height: t.space3),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.planSheetServings,
                style: t.label.copyWith(color: t.ink),
              ),
            ),
            ServingsPicker(
              servings: _servings,
              max: maxPlanServings,
              label: servingsText.isEmpty
                  ? LocaleFormat.of(context).integer(_servings)
                  : servingsLabel(context, _servings, servingsText),
              onChanged: (value) => setState(() => _servings = value),
            ),
          ],
        ),
        if (plan.onShoppingList) ...[
          SizedBox(height: t.space3),
          _Note(
            icon: Icons.shopping_basket_outlined,
            text: l10n.planEditShoppingNote,
          ),
        ],
        SizedBox(height: t.space3),
        _Note(
          icon: Icons.people_outline_rounded,
          text: l10n.planSharedWithHousehold,
        ),
      ],
    );
  }
}

/// Lets the user pick another first day for [plan] (the keyboard
/// alternative to dragging it) and returns it, `null` if they don't.
Future<CalendarDay?> showMovePlanSheet(BuildContext context, MealPlan plan) =>
    showPlannerSheet<CalendarDay>(
      context,
      (context) => MovePlanSheet(plan: plan),
    );

/// Picks another first day for [plan] and closes with it.
class MovePlanSheet extends ConsumerStatefulWidget {
  const MovePlanSheet({super.key, required this.plan});

  final MealPlan plan;

  @override
  ConsumerState<MovePlanSheet> createState() => _MovePlanSheetState();
}

class _MovePlanSheetState extends ConsumerState<MovePlanSheet> {
  late CalendarDay _day = widget.plan.fromDay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final weekStart = startOfWeek(_day, firstWeekdayOf(context));
    final plans = ref.watch(weekPlansProvider(weekStart)).value;
    return _SheetBody(
      title: l10n.planMoveTitle,
      subtitle: widget.plan.label,
      submitLabel: l10n.planMoveSubmit(dayLabel(context, _day)),
      onSubmit: _day == widget.plan.fromDay
          ? null
          : () => Navigator.of(context).pop(_day),
      children: [
        PlanDayPicker(
          day: _day,
          today: today,
          plans: plans ?? const [],
          onChanged: (day) => setState(() => _day = day),
        ),
      ],
    );
  }
}

/// Asks "Mahlzeit löschen?", saying that it goes for the whole household
/// and, for a plan on the shopping list, that its ingredients go with it.
/// Deletes it if the user agrees; a snackbar says how it went.
Future<void> confirmAndDeletePlan(BuildContext context, MealPlan plan) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final container = ProviderScope.containerOf(context, listen: false);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final t = context.tokens;
      return AlertDialog(
        title: Text(l10n.planDeleteTitle),
        content: Text(
          plan.onShoppingList
              ? l10n.planDeleteBodyShopping(plan.label)
              : l10n.planDeleteBody(plan.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.planDeleteKeep),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: t.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.planDelete),
          ),
        ],
      );
    },
  );
  if (confirmed != true) return;
  // Offline came while the dialog was open: nothing is queued.
  if (container.read(isOfflineProvider)) {
    showPlannerMessage(
      messenger,
      (context) => context.l10n.offlineWriteDisabled,
    );
    return;
  }
  Failure? failure;
  try {
    await container.read(mealPlanRepositoryProvider).delete(plan.id);
  } on Failure catch (e) {
    failure = e;
  }
  container.invalidate(weekPlansProvider);
  showPlannerMessage(
    messenger,
    (context) => switch (failure) {
      null => context.l10n.planDeleted,
      final failure => context.l10n.planDeleteFailed(
        failureMessage(context, failure),
      ),
    },
  );
}

/// The frame of the edit and move sheets: a title with the meal's name,
/// [children], an error if there is one, and the submit button, disabled
/// offline with the reason. Nothing reacts while [saving].
class _SheetBody extends ConsumerWidget {
  const _SheetBody({
    required this.title,
    required this.subtitle,
    required this.submitLabel,
    required this.onSubmit,
    required this.children,
    this.saving = false,
    this.error,
  });

  final String title;
  final String subtitle;
  final String submitLabel;

  /// `null` disables the button.
  final VoidCallback? onSubmit;
  final List<Widget> children;
  final bool saving;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    return PopScope(
      canPop: !saving,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          top: false,
          child: IgnorePointer(
            ignoring: saving,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: t.titleM.copyWith(color: t.ink)),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.body.copyWith(color: t.inkMuted),
                  ),
                  SizedBox(height: t.space4),
                  ...children,
                  SizedBox(height: t.space4),
                  if (error case final error?) ...[
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        error,
                        style: t.caption.copyWith(color: t.danger),
                      ),
                    ),
                    SizedBox(height: t.space2),
                  ],
                  OfflineDisabled(
                    builder: (context, enabled) => PillButton(
                      label: submitLabel,
                      onPressed: enabled && !saving ? onSubmit : null,
                    ),
                  ),
                  if (ref.watch(isOfflineProvider)) ...[
                    SizedBox(height: t.space2),
                    Text(
                      l10n.offlineWriteDisabled,
                      style: t.caption.copyWith(color: t.inkMuted),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: t.label.fontSize! + t.space1, color: t.inkMuted),
        SizedBox(width: t.space2),
        Expanded(
          child: Text(text, style: t.caption.copyWith(color: t.inkMuted)),
        ),
      ],
    );
  }
}

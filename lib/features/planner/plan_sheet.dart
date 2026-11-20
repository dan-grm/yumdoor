import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/components/servings_picker.dart';
import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/meal_type.dart';
import '../../domain/models/recipe.dart';
import '../../domain/services/recipe_shopping.dart';
import '../../domain/services/week_plan.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../editor/editor_field.dart';
import '../recipe/ingredient_lines.dart';
import '../recipe/recipe_providers.dart';
import 'planner_providers.dart';
import 'week_labels.dart';

/// How long the confirmation stays: Flutter's default, and twice that when
/// the shopping list couldn't be filled, to read why.
const _snackBarDuration = Duration(seconds: 4);
const _failureSnackBarDuration = Duration(seconds: 8);

/// Opens the [PlanSheet] for the recipe [recipeId] and, once a plan is
/// saved, confirms it in a snackbar with a way to the planner. Completes
/// when the sheet is closed; the planner's weeks reload on their own.
///
/// [servings] is where the servings start, usually what the recipe screen
/// shows, counted in [servingsText] ("Stück") if the recipe has one; [day]
/// presets the day (today if `null`).
Future<void> showPlanSheet(
  BuildContext context, {
  required int recipeId,
  required String recipeName,
  required int servings,
  String servingsText = '',
  CalendarDay? day,
}) async {
  final t = context.tokens;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final clock = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(clockProvider);

  // Confirms through the messenger, which outlives the sheet and the screen
  // that opened it: a sheet that is dragged away while saving still reports
  // how it went.
  void confirm(PlanSheetResult result) {
    if (!messenger.mounted) return;
    final context = messenger.context;
    final l10n = context.l10n;
    final plan = result.plan;
    final day = dayLabel(context, plan.fromDay);
    final failure = result.shoppingFailure;
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (failure) {
          final failure? => l10n.planSavedShoppingFailed(
            day,
            failureMessage(context, failure),
          ),
          null when result.addedToShopping => l10n.planSavedWithShopping(day),
          null => l10n.planSaved(day),
        }),
        // With an action, a snackbar would stay until it is closed.
        persist: false,
        duration: failure == null
            ? _snackBarDuration
            : _failureSnackBarDuration,
        action: SnackBarAction(
          label: l10n.planSavedOpen,
          onPressed: () => router.go(
            plannerLocation(context, plan.fromDay, CalendarDay.of(clock())),
          ),
        ),
      ),
    );
  }

  void reportFailure(Failure failure) {
    if (!messenger.mounted) return;
    final context = messenger.context;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.planSheetSaveFailed(failureMessage(context, failure)),
        ),
        duration: _failureSnackBarDuration,
      ),
    );
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => PlanSheet(
      recipeId: recipeId,
      recipeName: recipeName,
      servings: servings,
      servingsText: servingsText,
      day: day,
      onSaved: confirm,
      onFailedAfterClose: reportFailure,
    ),
  );
}

/// What the [PlanSheet] saved.
class PlanSheetResult {
  const PlanSheetResult({
    required this.plan,
    this.addedToShopping = false,
    this.shoppingFailure,
  });

  final MealPlan plan;

  /// Whether the missing ingredients were put on the shopping list.
  final bool addedToShopping;

  /// Why they couldn't be, though the user asked for it; the plan is saved
  /// all the same.
  final Failure? shoppingFailure;
}

/// The sheet that plans a recipe (mockup 11-einplanen): a day of a week, a
/// meal type of the space, servings, and whether to put what's missing on
/// the shopping list. Once the plan is saved, it calls [onSaved] and closes.
///
/// The parts (the [PlanDayPicker], the meal types with [MealTypePicker] and
/// the servings) don't depend on creating a plan, so editing one can reuse
/// them.
class PlanSheet extends ConsumerStatefulWidget {
  const PlanSheet({
    super.key,
    required this.recipeId,
    required this.recipeName,
    required this.servings,
    this.servingsText = '',
    this.day,
    required this.onSaved,
    this.onFailedAfterClose,
  });

  final int recipeId;
  final String recipeName;

  /// The servings to start with.
  final int servings;

  /// The recipe's own word for servings ("Stück"), empty if it has none.
  final String servingsText;

  /// The day to start with; today if `null`.
  final CalendarDay? day;

  /// Called once the plan is saved, also if the sheet was closed meanwhile.
  final ValueChanged<PlanSheetResult> onSaved;

  /// Called if saving fails after the sheet was closed, so the failure can
  /// still be reported; while it is open, the sheet shows it.
  final ValueChanged<Failure>? onFailedAfterClose;

  @override
  ConsumerState<PlanSheet> createState() => _PlanSheetState();
}

/// The most servings a plan can have; Tandoor stores less than 10000.
const _maxServings = 9999;

class _PlanSheetState extends ConsumerState<PlanSheet> {
  late CalendarDay _day =
      widget.day ?? CalendarDay.of(ref.read(clockProvider)());
  late int _servings = widget.servings.clamp(1, _maxServings);

  /// The meal type the user chose here, `null` until they do.
  int? _mealTypeId;
  late final String? _lastMealType = ref
      .read(planSheetChoicesProvider)
      .mealTypeName;
  late bool _addToShopping = ref.read(planSheetChoicesProvider).addToShopping;

  bool _saving = false;
  String? _error;

  /// The meal type of [types] the user chose here, else the one used last
  /// time, else the first.
  MealType? _selectedType(List<MealType> types) {
    final lastName = _lastMealType?.toLowerCase();
    return types.where((type) => type.id == _mealTypeId).firstOrNull ??
        types
            .where((type) => type.name.toLowerCase() == lastName)
            .firstOrNull ??
        types.firstOrNull;
  }

  /// Saves the plan and, if [shopping] has something to add, puts it on the
  /// shopping list. A failure of the plan keeps the sheet open to retry; a
  /// failure of the shopping list doesn't undo the plan.
  Future<void> _save(MealType mealType, RecipeShopping? shopping) async {
    // Read before the first await: the sheet may be dragged away meanwhile,
    // and the plan is saved and reported all the same.
    final container = ProviderScope.containerOf(context, listen: false);
    final mealPlans = ref.read(mealPlanRepositoryProvider);
    final recipes = ref.read(recipeRepositoryProvider);
    final shoppingList = ref.read(shoppingRepositoryProvider);
    final onSaved = widget.onSaved;
    final onFailedAfterClose = widget.onFailedAfterClose;
    final day = _day;
    final recipeId = widget.recipeId;
    final servings = _servings.toDouble();
    final shoppingChoice = _addToShopping;
    final addToShopping =
        shoppingChoice && shopping != null && !shopping.isEmpty;
    setState(() {
      _saving = true;
      _error = null;
    });

    final MealPlan plan;
    try {
      plan = await mealPlans.create(
        NewMealPlan(
          recipeId: recipeId,
          servings: servings,
          day: day,
          mealType: mealType,
        ),
      );
    } on Failure catch (failure) {
      if (!mounted) {
        onFailedAfterClose?.call(failure);
        return;
      }
      setState(() {
        _saving = false;
        _error = context.l10n.planSheetSaveFailed(
          failureMessage(context, failure),
        );
      });
      return;
    }
    container
        .read(planSheetChoicesProvider.notifier)
        .remember(mealTypeName: mealType.name, addToShopping: shoppingChoice);

    var added = false;
    Failure? shoppingFailure;
    if (addToShopping) {
      try {
        // Freshly read: what is on hand may have changed since the recipe
        // was opened.
        final recipe = await recipes.fetchRecipe(recipeId);
        added = !(await shoppingList.addRecipe(
          recipe,
          servings,
          mealPlanId: plan.id,
        )).isEmpty;
      } on Failure catch (failure) {
        shoppingFailure = failure;
      }
    }
    // After the shopping list, so the plans reload as on it.
    container.invalidate(weekPlansProvider);
    onSaved(
      PlanSheetResult(
        plan: plan,
        addedToShopping: added,
        shoppingFailure: shoppingFailure,
      ),
    );
    // Unless it was dragged away meanwhile; it may still be closing then.
    if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final today = CalendarDay.of(ref.watch(clockProvider)());
    final weekStart = startOfWeek(_day, firstWeekdayOf(context));
    final plans = ref.watch(weekPlansProvider(weekStart)).value;
    final mealTypes = ref.watch(mealTypesProvider);
    final mealType = mealTypes.value == null
        ? null
        : _selectedType(mealTypes.value!);
    final recipe = ref.watch(recipeProvider(widget.recipeId));
    final shopping = switch (recipe.value) {
      final recipe? => buildRecipeShopping(recipe, servings: _servings),
      null => null,
    };

    return PopScope(
      canPop: !_saving,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          top: false,
          // Nothing changes while saving: the plan is saved as it was.
          child: IgnorePointer(
            ignoring: _saving,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.planSheetTitle,
                      style: t.titleM.copyWith(color: t.ink),
                    ),
                  ),
                  Text(
                    widget.recipeName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.body.copyWith(color: t.inkMuted),
                  ),
                  SizedBox(height: t.space4),
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
                    selected: mealType,
                    onSelected: (type) => setState(() => _mealTypeId = type.id),
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
                        max: _maxServings,
                        label: widget.servingsText.trim().isEmpty
                            ? format.integer(_servings)
                            : servingsLabel(
                                context,
                                _servings,
                                widget.servingsText,
                              ),
                        onChanged: (value) => setState(() => _servings = value),
                      ),
                    ],
                  ),
                  SizedBox(height: t.space3),
                  Divider(height: 1, thickness: 1, color: t.line),
                  _ShoppingSwitch(
                    recipe: recipe,
                    shopping: shopping,
                    value: _addToShopping,
                    onChanged: (value) =>
                        setState(() => _addToShopping = value),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: t.label.fontSize! + t.space1,
                        color: t.inkMuted,
                      ),
                      SizedBox(width: t.space2),
                      Expanded(
                        child: Text(
                          l10n.planSharedWithHousehold,
                          style: t.caption.copyWith(color: t.inkMuted),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: t.space4),
                  if (_error case final error?) ...[
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
                      label: _submitLabel(context, today),
                      onPressed: enabled && !_saving && mealType != null
                          ? () => _save(mealType, shopping)
                          : null,
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

  /// "Für heute einplanen", the weekday within the next week, else the
  /// date.
  String _submitLabel(BuildContext context, CalendarDay today) {
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final date = _day.atLocalTime();
    final ahead = _day.differenceInDays(today);
    if (ahead == 0) return l10n.planSheetSubmitToday;
    if (ahead > 0 && ahead < daysInWeek) {
      return l10n.planSheetSubmit(format.weekdayLong(date));
    }
    return l10n.planSheetSubmit(
      l10n.planDayLabel(format.weekdayShort(date), format.dayMonth(date)),
    );
  }
}

/// A section label in the plan sheet: "TAG", "MAHLZEIT".
class PlanSectionLabel extends StatelessWidget {
  const PlanSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      header: true,
      child: Text(
        text.toUpperCase(),
        style: t.overline.copyWith(color: t.inkMuted),
      ),
    );
  }
}

/// The days of the week that holds [day], one of them chosen, with buttons
/// for the weeks before and after. Going to another week moves [day] by a
/// week. Days with [plans] on them get a dot.
class PlanDayPicker extends StatelessWidget {
  const PlanDayPicker({
    super.key,
    required this.day,
    required this.today,
    required this.plans,
    required this.onChanged,
  });

  final CalendarDay day;
  final CalendarDay today;

  /// Plans on the days shown, to mark the days that have some.
  final List<MealPlan> plans;
  final ValueChanged<CalendarDay> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final start = startOfWeek(day, firstWeekdayOf(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: PlanSectionLabel(l10n.planSheetDay)),
            RoundIconButton(
              icon: Icons.chevron_left_rounded,
              label: l10n.planWeekPrevious,
              outlined: true,
              onPressed: () => onChanged(day.addDays(-daysInWeek)),
            ),
            Semantics(
              liveRegion: true,
              child: Text(
                weekRangeLabel(context, start, today),
                style: t.caption.copyWith(color: t.inkMuted),
              ),
            ),
            RoundIconButton(
              icon: Icons.chevron_right_rounded,
              label: l10n.planWeekNext,
              outlined: true,
              onPressed: () => onChanged(day.addDays(daysInWeek)),
            ),
          ],
        ),
        SizedBox(height: t.space2),
        Row(
          spacing: t.space1,
          children: [
            for (var i = 0; i < daysInWeek; i++)
              Expanded(
                child: _DayButton(
                  day: start.addDays(i),
                  selected: start.addDays(i) == day,
                  hasPlans: plans.any((plan) => plan.isOn(start.addDays(i))),
                  onTap: () => onChanged(start.addDays(i)),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.day,
    required this.selected,
    required this.hasPlans,
    required this.onTap,
  });

  final CalendarDay day;
  final bool selected;
  final bool hasPlans;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final format = LocaleFormat.of(context);
    final label = dayLabel(context, day);
    return Semantics(
      button: true,
      selected: selected,
      checked: selected,
      inMutuallyExclusiveGroup: true,
      label: hasPlans ? context.l10n.planSheetDayHasPlans(label) : label,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: selected ? t.sage : t.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radiusM),
          side: selected ? BorderSide.none : BorderSide(color: t.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: t.sizeTouch + t.space4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  format.weekdayShort(day.atLocalTime()),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: t.caption.copyWith(
                    color: selected ? t.onSage : t.inkMuted,
                  ),
                ),
                Text(
                  format.integer(day.day),
                  style: t.titleS.copyWith(color: selected ? t.onSage : t.ink),
                ),
                SizedBox.square(
                  dimension: t.space1,
                  child: hasPlans
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? t.onSage : t.sage,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The meal types of the space as chips, one of them [selected]. While they
/// load, a spinner; if that fails, the reason and a retry button; if the
/// space has none, a way to create the first one, which is then selected.
class MealTypePicker extends ConsumerWidget {
  const MealTypePicker({
    super.key,
    required this.mealTypes,
    required this.selected,
    required this.onSelected,
  });

  final AsyncValue<List<MealType>> mealTypes;
  final MealType? selected;
  final ValueChanged<MealType> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    return switch (mealTypes) {
      // Also while they load again, after a retry or a new meal type.
      AsyncValue(isLoading: true) => SizedBox(
        height: t.sizeTouch,
        child: const Center(child: CircularProgressIndicator()),
      ),
      AsyncData(value: []) => _NewMealType(onCreated: onSelected),
      AsyncData(:final value) => Wrap(
        spacing: t.space2,
        children: [
          for (final type in value)
            ChoiceFilterChip(
              label: type.name,
              selected: type.id == selected?.id,
              onSelected: () => onSelected(type),
            ),
        ],
      ),
      AsyncError(:final error) => Row(
        children: [
          Expanded(
            child: Text(
              failureMessage(context, error),
              style: t.caption.copyWith(color: t.danger),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(mealTypesProvider),
            child: Text(context.l10n.retry),
          ),
        ],
      ),
      AsyncLoading() => const SizedBox.shrink(),
    };
  }
}

/// Creates the first meal type of a space that has none.
class _NewMealType extends ConsumerStatefulWidget {
  const _NewMealType({required this.onCreated});

  final ValueChanged<MealType> onCreated;

  @override
  ConsumerState<_NewMealType> createState() => _NewMealTypeState();
}

class _NewMealTypeState extends ConsumerState<_NewMealType> {
  final _name = TextEditingController();
  bool _creating = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final repository = ref.read(mealTypeRepositoryProvider);
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      final type = await repository.create(name);
      if (!mounted) return;
      widget.onCreated(type);
      ref.invalidate(mealTypesProvider);
    } on Failure catch (failure) {
      if (!mounted) return;
      setState(() {
        _creating = false;
        _error = context.l10n.planSheetMealTypeCreateFailed(
          failureMessage(context, failure),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.planSheetNoMealTypes, style: t.body.copyWith(color: t.ink)),
        SizedBox(height: t.space3),
        EditorField(
          label: l10n.planSheetMealTypeName,
          hint: l10n.planSheetMealTypeHint,
          controller: _name,
          maxLength: maxMealTypeNameLength,
          enabled: !_creating,
          error: _error,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: t.space2),
        OfflineDisabled(
          builder: (context, enabled) => PillButton(
            label: l10n.planSheetMealTypeCreate,
            icon: Icons.add_rounded,
            kind: PillButtonKind.secondary,
            compact: true,
            onPressed: enabled && !_creating && _name.text.trim().isNotEmpty
                ? _create
                : null,
          ),
        ),
      ],
    );
  }
}

/// "Fehlendes auf die Einkaufsliste" with how many ingredients are missing.
/// Disabled, and off, while there is nothing to add.
class _ShoppingSwitch extends StatelessWidget {
  const _ShoppingSwitch({
    required this.recipe,
    required this.shopping,
    required this.value,
    required this.onChanged,
  });

  final AsyncValue<Recipe> recipe;

  /// What would go on the list, `null` until the recipe is loaded.
  final RecipeShopping? shopping;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final shopping = this.shopping;
    final total = shopping == null
        ? 0
        : shopping.neededCount + shopping.onHandCount;
    final String? detail = switch (shopping) {
      _ when recipe.hasError && shopping == null =>
        l10n.planSheetIngredientsFailed,
      null => null,
      _ when total == 0 => l10n.planSheetNoIngredients,
      RecipeShopping(isEmpty: true) => l10n.planSheetNothingMissing,
      RecipeShopping(:final neededCount) => l10n.planSheetMissing(
        neededCount,
        total,
      ),
    };
    final enabled = shopping != null && !shopping.isEmpty;
    return SwitchListTile(
      value: enabled && value,
      onChanged: enabled ? onChanged : null,
      title: Text(
        l10n.planSheetAddMissing,
        style: t.label.copyWith(color: t.ink),
      ),
      subtitle: detail == null
          ? null
          : Text(detail, style: t.caption.copyWith(color: t.inkMuted)),
      contentPadding: EdgeInsets.zero,
      activeThumbColor: t.onSage,
      activeTrackColor: t.sage,
    );
  }
}

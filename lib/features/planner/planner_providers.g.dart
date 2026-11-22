// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The plans of the household on the seven days from [start].
///
/// Failures are shown with a retry button instead of retrying on their own.

@ProviderFor(weekPlans)
final weekPlansProvider = WeekPlansFamily._();

/// The plans of the household on the seven days from [start].
///
/// Failures are shown with a retry button instead of retrying on their own.

final class WeekPlansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealPlan>>,
          List<MealPlan>,
          FutureOr<List<MealPlan>>
        >
    with $FutureModifier<List<MealPlan>>, $FutureProvider<List<MealPlan>> {
  /// The plans of the household on the seven days from [start].
  ///
  /// Failures are shown with a retry button instead of retrying on their own.
  WeekPlansProvider._({
    required WeekPlansFamily super.from,
    required CalendarDay super.argument,
  }) : super(
         retry: _noRetry,
         name: r'weekPlansProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weekPlansHash();

  @override
  String toString() {
    return r'weekPlansProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MealPlan>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MealPlan>> create(Ref ref) {
    final argument = this.argument as CalendarDay;
    return weekPlans(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeekPlansProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekPlansHash() => r'160f2591bee44402413b2eec082db85db44eaaa9';

/// The plans of the household on the seven days from [start].
///
/// Failures are shown with a retry button instead of retrying on their own.

final class WeekPlansFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MealPlan>>, CalendarDay> {
  WeekPlansFamily._()
    : super(
        retry: _noRetry,
        name: r'weekPlansProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The plans of the household on the seven days from [start].
  ///
  /// Failures are shown with a retry button instead of retrying on their own.

  WeekPlansProvider call(CalendarDay start) =>
      WeekPlansProvider._(argument: start, from: this);

  @override
  String toString() => r'weekPlansProvider';
}

/// The meal types of the space, for the plan sheet.
///
/// Failures are shown with a retry button instead of retrying on their own.

@ProviderFor(mealTypes)
final mealTypesProvider = MealTypesProvider._();

/// The meal types of the space, for the plan sheet.
///
/// Failures are shown with a retry button instead of retrying on their own.

final class MealTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealType>>,
          List<MealType>,
          FutureOr<List<MealType>>
        >
    with $FutureModifier<List<MealType>>, $FutureProvider<List<MealType>> {
  /// The meal types of the space, for the plan sheet.
  ///
  /// Failures are shown with a retry button instead of retrying on their own.
  MealTypesProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'mealTypesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealTypesHash();

  @$internal
  @override
  $FutureProviderElement<List<MealType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MealType>> create(Ref ref) {
    return mealTypes(ref);
  }
}

String _$mealTypesHash() => r'1bf596c0e90d788d688c9d012fca4a9f4a1e4afb';

@ProviderFor(plannerPeople)
final plannerPeopleProvider = PlannerPeopleProvider._();

final class PlannerPeopleProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlannerPeople>,
          PlannerPeople,
          FutureOr<PlannerPeople>
        >
    with $FutureModifier<PlannerPeople>, $FutureProvider<PlannerPeople> {
  PlannerPeopleProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'plannerPeopleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerPeopleHash();

  @$internal
  @override
  $FutureProviderElement<PlannerPeople> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlannerPeople> create(Ref ref) {
    return plannerPeople(ref);
  }
}

String _$plannerPeopleHash() => r'a08951f3bf4d82aebc0c6a486ed7ca8e73307cf9';

/// Meals being changed, moved or deleted, by id: as they will be once saved,
/// `null` for one being deleted. The planner shows the change right away and
/// offers nothing more for these meals until it is settled, so changes of one
/// meal never overlap. Starts over with another server or login.

@ProviderFor(PendingPlans)
final pendingPlansProvider = PendingPlansProvider._();

/// Meals being changed, moved or deleted, by id: as they will be once saved,
/// `null` for one being deleted. The planner shows the change right away and
/// offers nothing more for these meals until it is settled, so changes of one
/// meal never overlap. Starts over with another server or login.
final class PendingPlansProvider
    extends $NotifierProvider<PendingPlans, Map<int, MealPlan?>> {
  /// Meals being changed, moved or deleted, by id: as they will be once saved,
  /// `null` for one being deleted. The planner shows the change right away and
  /// offers nothing more for these meals until it is settled, so changes of one
  /// meal never overlap. Starts over with another server or login.
  PendingPlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPlansProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPlansHash();

  @$internal
  @override
  PendingPlans create() => PendingPlans();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, MealPlan?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, MealPlan?>>(value),
    );
  }
}

String _$pendingPlansHash() => r'50d5bcd3846c4ae64485134146ff8b3a399b5369';

/// Meals being changed, moved or deleted, by id: as they will be once saved,
/// `null` for one being deleted. The planner shows the change right away and
/// offers nothing more for these meals until it is settled, so changes of one
/// meal never overlap. Starts over with another server or login.

abstract class _$PendingPlans extends $Notifier<Map<int, MealPlan?>> {
  Map<int, MealPlan?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<int, MealPlan?>, Map<int, MealPlan?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, MealPlan?>, Map<int, MealPlan?>>,
              Map<int, MealPlan?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the planner shows only the meals the current user planned,
/// remembered on this device.

@ProviderFor(PlannerOnlyMine)
final plannerOnlyMineProvider = PlannerOnlyMineProvider._();

/// Whether the planner shows only the meals the current user planned,
/// remembered on this device.
final class PlannerOnlyMineProvider
    extends $NotifierProvider<PlannerOnlyMine, bool> {
  /// Whether the planner shows only the meals the current user planned,
  /// remembered on this device.
  PlannerOnlyMineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerOnlyMineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerOnlyMineHash();

  @$internal
  @override
  PlannerOnlyMine create() => PlannerOnlyMine();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$plannerOnlyMineHash() => r'f678854fd1d6db541dd1f00b633c5b6680d10574';

/// Whether the planner shows only the meals the current user planned,
/// remembered on this device.

abstract class _$PlannerOnlyMine extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PlanSheetChoices)
final planSheetChoicesProvider = PlanSheetChoicesProvider._();

final class PlanSheetChoicesProvider
    extends $NotifierProvider<PlanSheetChoices, PlanSheetDefaults> {
  PlanSheetChoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planSheetChoicesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planSheetChoicesHash();

  @$internal
  @override
  PlanSheetChoices create() => PlanSheetChoices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanSheetDefaults value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanSheetDefaults>(value),
    );
  }
}

String _$planSheetChoicesHash() => r'a76f860be39ccc9218c2a77e599d7b3f847e859d';

abstract class _$PlanSheetChoices extends $Notifier<PlanSheetDefaults> {
  PlanSheetDefaults build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlanSheetDefaults, PlanSheetDefaults>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlanSheetDefaults, PlanSheetDefaults>,
              PlanSheetDefaults,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

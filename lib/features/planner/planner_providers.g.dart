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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_shopping.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Counts the ingredients the meals of the week from [start] still need, as
/// adding them would ([buildRecipeShopping]): meals with a recipe that
/// aren't on the shopping list yet. The whole household's meals count, as the
/// list is the household's.
///
/// Failures are shown on the card instead of retrying on their own.

@ProviderFor(weekShopping)
final weekShoppingProvider = WeekShoppingFamily._();

/// Counts the ingredients the meals of the week from [start] still need, as
/// adding them would ([buildRecipeShopping]): meals with a recipe that
/// aren't on the shopping list yet. The whole household's meals count, as the
/// list is the household's.
///
/// Failures are shown on the card instead of retrying on their own.

final class WeekShoppingProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeekShoppingPreview>,
          WeekShoppingPreview,
          FutureOr<WeekShoppingPreview>
        >
    with
        $FutureModifier<WeekShoppingPreview>,
        $FutureProvider<WeekShoppingPreview> {
  /// Counts the ingredients the meals of the week from [start] still need, as
  /// adding them would ([buildRecipeShopping]): meals with a recipe that
  /// aren't on the shopping list yet. The whole household's meals count, as the
  /// list is the household's.
  ///
  /// Failures are shown on the card instead of retrying on their own.
  WeekShoppingProvider._({
    required WeekShoppingFamily super.from,
    required CalendarDay super.argument,
  }) : super(
         retry: _noRetry,
         name: r'weekShoppingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weekShoppingHash();

  @override
  String toString() {
    return r'weekShoppingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WeekShoppingPreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeekShoppingPreview> create(Ref ref) {
    final argument = this.argument as CalendarDay;
    return weekShopping(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeekShoppingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekShoppingHash() => r'6204506cb722d277e1eb1a48e4f96ae831196526';

/// Counts the ingredients the meals of the week from [start] still need, as
/// adding them would ([buildRecipeShopping]): meals with a recipe that
/// aren't on the shopping list yet. The whole household's meals count, as the
/// list is the household's.
///
/// Failures are shown on the card instead of retrying on their own.

final class WeekShoppingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WeekShoppingPreview>, CalendarDay> {
  WeekShoppingFamily._()
    : super(
        retry: _noRetry,
        name: r'weekShoppingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Counts the ingredients the meals of the week from [start] still need, as
  /// adding them would ([buildRecipeShopping]): meals with a recipe that
  /// aren't on the shopping list yet. The whole household's meals count, as the
  /// list is the household's.
  ///
  /// Failures are shown on the card instead of retrying on their own.

  WeekShoppingProvider call(CalendarDay start) =>
      WeekShoppingProvider._(argument: start, from: this);

  @override
  String toString() => r'weekShoppingProvider';
}

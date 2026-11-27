// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recipe of a meal planned for today, with its ingredients, to count
/// those that are missing. Offline it comes from the cache, which keeps the
/// recipes of plans that aren't over yet.
///
/// Unlike `recipeProvider`, loading it records no view: the start screen
/// shows the recipe, it doesn't open it. Failures aren't retried; the start
/// screen then leaves the count out.

@ProviderFor(plannedRecipe)
final plannedRecipeProvider = PlannedRecipeFamily._();

/// The recipe of a meal planned for today, with its ingredients, to count
/// those that are missing. Offline it comes from the cache, which keeps the
/// recipes of plans that aren't over yet.
///
/// Unlike `recipeProvider`, loading it records no view: the start screen
/// shows the recipe, it doesn't open it. Failures aren't retried; the start
/// screen then leaves the count out.

final class PlannedRecipeProvider
    extends $FunctionalProvider<AsyncValue<Recipe>, Recipe, FutureOr<Recipe>>
    with $FutureModifier<Recipe>, $FutureProvider<Recipe> {
  /// The recipe of a meal planned for today, with its ingredients, to count
  /// those that are missing. Offline it comes from the cache, which keeps the
  /// recipes of plans that aren't over yet.
  ///
  /// Unlike `recipeProvider`, loading it records no view: the start screen
  /// shows the recipe, it doesn't open it. Failures aren't retried; the start
  /// screen then leaves the count out.
  PlannedRecipeProvider._({
    required PlannedRecipeFamily super.from,
    required int super.argument,
  }) : super(
         retry: _noRetry,
         name: r'plannedRecipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plannedRecipeHash();

  @override
  String toString() {
    return r'plannedRecipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Recipe> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Recipe> create(Ref ref) {
    final argument = this.argument as int;
    return plannedRecipe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlannedRecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plannedRecipeHash() => r'0cfad4ee9426d963344364beaedf153c55f0fcc3';

/// The recipe of a meal planned for today, with its ingredients, to count
/// those that are missing. Offline it comes from the cache, which keeps the
/// recipes of plans that aren't over yet.
///
/// Unlike `recipeProvider`, loading it records no view: the start screen
/// shows the recipe, it doesn't open it. Failures aren't retried; the start
/// screen then leaves the count out.

final class PlannedRecipeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Recipe>, int> {
  PlannedRecipeFamily._()
    : super(
        retry: _noRetry,
        name: r'plannedRecipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe of a meal planned for today, with its ingredients, to count
  /// those that are missing. Offline it comes from the cache, which keeps the
  /// recipes of plans that aren't over yet.
  ///
  /// Unlike `recipeProvider`, loading it records no view: the start screen
  /// shows the recipe, it doesn't open it. Failures aren't retried; the start
  /// screen then leaves the count out.

  PlannedRecipeProvider call(int id) =>
      PlannedRecipeProvider._(argument: id, from: this);

  @override
  String toString() => r'plannedRecipeProvider';
}

/// What other users of the space cooked lately, newest first, at most
/// [homeActivityCount]. The current user's own entries are left out. Kept
/// while the app runs; invalidated by pull to refresh, when the start tab is
/// shown again and when the server can be reached again.

@ProviderFor(othersActivity)
final othersActivityProvider = OthersActivityProvider._();

/// What other users of the space cooked lately, newest first, at most
/// [homeActivityCount]. The current user's own entries are left out. Kept
/// while the app runs; invalidated by pull to refresh, when the start tab is
/// shown again and when the server can be reached again.

final class OthersActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecentCookLog>>,
          List<RecentCookLog>,
          FutureOr<List<RecentCookLog>>
        >
    with
        $FutureModifier<List<RecentCookLog>>,
        $FutureProvider<List<RecentCookLog>> {
  /// What other users of the space cooked lately, newest first, at most
  /// [homeActivityCount]. The current user's own entries are left out. Kept
  /// while the app runs; invalidated by pull to refresh, when the start tab is
  /// shown again and when the server can be reached again.
  OthersActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'othersActivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$othersActivityHash();

  @$internal
  @override
  $FutureProviderElement<List<RecentCookLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecentCookLog>> create(Ref ref) {
    return othersActivity(ref);
  }
}

String _$othersActivityHash() => r'd6575152cfc8e27f82b2c3caaa1f4e49aea2280f';

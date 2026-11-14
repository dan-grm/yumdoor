// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.

@ProviderFor(WakeLockHintShown)
final wakeLockHintShownProvider = WakeLockHintShownProvider._();

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
final class WakeLockHintShownProvider
    extends $NotifierProvider<WakeLockHintShown, bool> {
  /// Whether cooking mode already told the user, in this app session, that the
  /// screen can't be kept on. The hint is shown once, not on every recipe.
  WakeLockHintShownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wakeLockHintShownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wakeLockHintShownHash();

  @$internal
  @override
  WakeLockHintShown create() => WakeLockHintShown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$wakeLockHintShownHash() => r'01412455520bb7823d41f323c1d236f9e2b117e8';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.

abstract class _$WakeLockHintShown extends $Notifier<bool> {
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

/// The ingredients ticked off while cooking [recipeId], saved so they survive
/// paging and a reload. Cooking mode watches it while open, so a failed save
/// still keeps the ticks in memory until the screen closes.

@ProviderFor(CookingProgressController)
final cookingProgressControllerProvider = CookingProgressControllerFamily._();

/// The ingredients ticked off while cooking [recipeId], saved so they survive
/// paging and a reload. Cooking mode watches it while open, so a failed save
/// still keeps the ticks in memory until the screen closes.
final class CookingProgressControllerProvider
    extends $NotifierProvider<CookingProgressController, CookingProgress> {
  /// The ingredients ticked off while cooking [recipeId], saved so they survive
  /// paging and a reload. Cooking mode watches it while open, so a failed save
  /// still keeps the ticks in memory until the screen closes.
  CookingProgressControllerProvider._({
    required CookingProgressControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'cookingProgressControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cookingProgressControllerHash();

  @override
  String toString() {
    return r'cookingProgressControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CookingProgressController create() => CookingProgressController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookingProgress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookingProgress>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CookingProgressControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cookingProgressControllerHash() =>
    r'ab1a805359ae8f2952aa19bf31a31aa20832b205';

/// The ingredients ticked off while cooking [recipeId], saved so they survive
/// paging and a reload. Cooking mode watches it while open, so a failed save
/// still keeps the ticks in memory until the screen closes.

final class CookingProgressControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CookingProgressController,
          CookingProgress,
          CookingProgress,
          CookingProgress,
          int
        > {
  CookingProgressControllerFamily._()
    : super(
        retry: null,
        name: r'cookingProgressControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The ingredients ticked off while cooking [recipeId], saved so they survive
  /// paging and a reload. Cooking mode watches it while open, so a failed save
  /// still keeps the ticks in memory until the screen closes.

  CookingProgressControllerProvider call(int recipeId) =>
      CookingProgressControllerProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'cookingProgressControllerProvider';
}

/// The ingredients ticked off while cooking [recipeId], saved so they survive
/// paging and a reload. Cooking mode watches it while open, so a failed save
/// still keeps the ticks in memory until the screen closes.

abstract class _$CookingProgressController extends $Notifier<CookingProgress> {
  late final _$args = ref.$arg as int;
  int get recipeId => _$args;

  CookingProgress build(int recipeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CookingProgress, CookingProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CookingProgress, CookingProgress>,
              CookingProgress,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

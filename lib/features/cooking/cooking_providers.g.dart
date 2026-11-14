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

/// Whether cooking mode already said, in this app session, that timers can't
/// alert while the app is in the background.

@ProviderFor(TimerBackgroundHintShown)
final timerBackgroundHintShownProvider = TimerBackgroundHintShownProvider._();

/// Whether cooking mode already said, in this app session, that timers can't
/// alert while the app is in the background.
final class TimerBackgroundHintShownProvider
    extends $NotifierProvider<TimerBackgroundHintShown, bool> {
  /// Whether cooking mode already said, in this app session, that timers can't
  /// alert while the app is in the background.
  TimerBackgroundHintShownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerBackgroundHintShownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerBackgroundHintShownHash();

  @$internal
  @override
  TimerBackgroundHintShown create() => TimerBackgroundHintShown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$timerBackgroundHintShownHash() =>
    r'c0513b5e53f00c6bebd3151c8fb614e1f57a03cd';

/// Whether cooking mode already said, in this app session, that timers can't
/// alert while the app is in the background.

abstract class _$TimerBackgroundHintShown extends $Notifier<bool> {
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
    r'78afcfa061d1d2a1a91d30222245f2d5f196c44a';

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

/// The timers running while cooking [recipeId], saved so they survive paging
/// and a reload. Cooking mode keeps it alive while open and calls [tick]
/// every second.

@ProviderFor(CookingTimersController)
final cookingTimersControllerProvider = CookingTimersControllerFamily._();

/// The timers running while cooking [recipeId], saved so they survive paging
/// and a reload. Cooking mode keeps it alive while open and calls [tick]
/// every second.
final class CookingTimersControllerProvider
    extends $NotifierProvider<CookingTimersController, List<CookingTimer>> {
  /// The timers running while cooking [recipeId], saved so they survive paging
  /// and a reload. Cooking mode keeps it alive while open and calls [tick]
  /// every second.
  CookingTimersControllerProvider._({
    required CookingTimersControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'cookingTimersControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cookingTimersControllerHash();

  @override
  String toString() {
    return r'cookingTimersControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CookingTimersController create() => CookingTimersController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CookingTimer> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CookingTimer>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CookingTimersControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cookingTimersControllerHash() =>
    r'382094a51b2fd5844db12f900b900ebad2d43fde';

/// The timers running while cooking [recipeId], saved so they survive paging
/// and a reload. Cooking mode keeps it alive while open and calls [tick]
/// every second.

final class CookingTimersControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CookingTimersController,
          List<CookingTimer>,
          List<CookingTimer>,
          List<CookingTimer>,
          int
        > {
  CookingTimersControllerFamily._()
    : super(
        retry: null,
        name: r'cookingTimersControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The timers running while cooking [recipeId], saved so they survive paging
  /// and a reload. Cooking mode keeps it alive while open and calls [tick]
  /// every second.

  CookingTimersControllerProvider call(int recipeId) =>
      CookingTimersControllerProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'cookingTimersControllerProvider';
}

/// The timers running while cooking [recipeId], saved so they survive paging
/// and a reload. Cooking mode keeps it alive while open and calls [tick]
/// every second.

abstract class _$CookingTimersController extends $Notifier<List<CookingTimer>> {
  late final _$args = ref.$arg as int;
  int get recipeId => _$args;

  List<CookingTimer> build(int recipeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<CookingTimer>, List<CookingTimer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CookingTimer>, List<CookingTimer>>,
              List<CookingTimer>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

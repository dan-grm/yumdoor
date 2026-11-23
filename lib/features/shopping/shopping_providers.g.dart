// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The entries of the household's shopping list, with the check states set
/// on this device shown at once.
///
/// Checking off ([setChecked]) is optimistic: the rows move right away and
/// the change goes to Tandoor immediately, so the others in the household
/// see it on their next read. Changes are sent one after another, in the
/// order they were made, so an undo can't overtake the check-off it undoes.
/// A change that fails is taken back.
///
/// The local changes stay on top of what the server says until a read that
/// started after they were saved, so a read that was already running can't
/// bring back the old state.
///
/// Sending goes through [_send], the one place a queue for offline
/// check-offs can take over later.

@ProviderFor(ShoppingList)
final shoppingListProvider = ShoppingListProvider._();

/// The entries of the household's shopping list, with the check states set
/// on this device shown at once.
///
/// Checking off ([setChecked]) is optimistic: the rows move right away and
/// the change goes to Tandoor immediately, so the others in the household
/// see it on their next read. Changes are sent one after another, in the
/// order they were made, so an undo can't overtake the check-off it undoes.
/// A change that fails is taken back.
///
/// The local changes stay on top of what the server says until a read that
/// started after they were saved, so a read that was already running can't
/// bring back the old state.
///
/// Sending goes through [_send], the one place a queue for offline
/// check-offs can take over later.
final class ShoppingListProvider
    extends $AsyncNotifierProvider<ShoppingList, List<ShoppingEntry>> {
  /// The entries of the household's shopping list, with the check states set
  /// on this device shown at once.
  ///
  /// Checking off ([setChecked]) is optimistic: the rows move right away and
  /// the change goes to Tandoor immediately, so the others in the household
  /// see it on their next read. Changes are sent one after another, in the
  /// order they were made, so an undo can't overtake the check-off it undoes.
  /// A change that fails is taken back.
  ///
  /// The local changes stay on top of what the server says until a read that
  /// started after they were saved, so a read that was already running can't
  /// bring back the old state.
  ///
  /// Sending goes through [_send], the one place a queue for offline
  /// check-offs can take over later.
  ShoppingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingListHash();

  @$internal
  @override
  ShoppingList create() => ShoppingList();
}

String _$shoppingListHash() => r'c840142dcb6b358031c133d5e5e8b4a042706176';

/// The entries of the household's shopping list, with the check states set
/// on this device shown at once.
///
/// Checking off ([setChecked]) is optimistic: the rows move right away and
/// the change goes to Tandoor immediately, so the others in the household
/// see it on their next read. Changes are sent one after another, in the
/// order they were made, so an undo can't overtake the check-off it undoes.
/// A change that fails is taken back.
///
/// The local changes stay on top of what the server says until a read that
/// started after they were saved, so a read that was already running can't
/// bring back the old state.
///
/// Sending goes through [_send], the one place a queue for offline
/// check-offs can take over later.

abstract class _$ShoppingList extends $AsyncNotifier<List<ShoppingEntry>> {
  FutureOr<List<ShoppingEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ShoppingEntry>>, List<ShoppingEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ShoppingEntry>>, List<ShoppingEntry>>,
              AsyncValue<List<ShoppingEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The supermarkets of the space, for the picker. The list works without
/// them, so a failure only hides the picker.

@ProviderFor(shoppingSupermarkets)
final shoppingSupermarketsProvider = ShoppingSupermarketsProvider._();

/// The supermarkets of the space, for the picker. The list works without
/// them, so a failure only hides the picker.

final class ShoppingSupermarketsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Supermarket>>,
          List<Supermarket>,
          FutureOr<List<Supermarket>>
        >
    with
        $FutureModifier<List<Supermarket>>,
        $FutureProvider<List<Supermarket>> {
  /// The supermarkets of the space, for the picker. The list works without
  /// them, so a failure only hides the picker.
  ShoppingSupermarketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'shoppingSupermarketsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingSupermarketsHash();

  @$internal
  @override
  $FutureProviderElement<List<Supermarket>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Supermarket>> create(Ref ref) {
    return shoppingSupermarkets(ref);
  }
}

String _$shoppingSupermarketsHash() =>
    r'074105a36d56a6c1aa9f2d6e80a9c9bc91c447a6';

/// The id of the current user, to tell their own items from the others';
/// `null` if the server doesn't say.

@ProviderFor(shoppingMe)
final shoppingMeProvider = ShoppingMeProvider._();

/// The id of the current user, to tell their own items from the others';
/// `null` if the server doesn't say.

final class ShoppingMeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// The id of the current user, to tell their own items from the others';
  /// `null` if the server doesn't say.
  ShoppingMeProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'shoppingMeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingMeHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return shoppingMe(ref);
  }
}

String _$shoppingMeHash() => r'7e8bc0a005103fbbd1658a8cce6c7c3ab67341cf';

/// The id of the supermarket whose order the list follows, remembered on
/// this device; `null` for none (categories by name).

@ProviderFor(ShoppingSupermarketChoice)
final shoppingSupermarketChoiceProvider = ShoppingSupermarketChoiceProvider._();

/// The id of the supermarket whose order the list follows, remembered on
/// this device; `null` for none (categories by name).
final class ShoppingSupermarketChoiceProvider
    extends $NotifierProvider<ShoppingSupermarketChoice, int?> {
  /// The id of the supermarket whose order the list follows, remembered on
  /// this device; `null` for none (categories by name).
  ShoppingSupermarketChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingSupermarketChoiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingSupermarketChoiceHash();

  @$internal
  @override
  ShoppingSupermarketChoice create() => ShoppingSupermarketChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$shoppingSupermarketChoiceHash() =>
    r'd5826b79b4c8ae37372a98067c0bd583252ea9f6';

/// The id of the supermarket whose order the list follows, remembered on
/// this device; `null` for none (categories by name).

abstract class _$ShoppingSupermarketChoice extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The chosen supermarket, if the space still has it.

@ProviderFor(shoppingSupermarket)
final shoppingSupermarketProvider = ShoppingSupermarketProvider._();

/// The chosen supermarket, if the space still has it.

final class ShoppingSupermarketProvider
    extends $FunctionalProvider<Supermarket?, Supermarket?, Supermarket?>
    with $Provider<Supermarket?> {
  /// The chosen supermarket, if the space still has it.
  ShoppingSupermarketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingSupermarketProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingSupermarketHash();

  @$internal
  @override
  $ProviderElement<Supermarket?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Supermarket? create(Ref ref) {
    return shoppingSupermarket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Supermarket? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Supermarket?>(value),
    );
  }
}

String _$shoppingSupermarketHash() =>
    r'e6e19707bc99c65075e11f41c9dab449ab1e20b7';

/// The list arranged for the chosen supermarket ([groupShoppingList]).

@ProviderFor(shoppingGroups)
final shoppingGroupsProvider = ShoppingGroupsProvider._();

/// The list arranged for the chosen supermarket ([groupShoppingList]).

final class ShoppingGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShoppingListGroups>,
          AsyncValue<ShoppingListGroups>,
          AsyncValue<ShoppingListGroups>
        >
    with $Provider<AsyncValue<ShoppingListGroups>> {
  /// The list arranged for the chosen supermarket ([groupShoppingList]).
  ShoppingGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingGroupsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<ShoppingListGroups>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ShoppingListGroups> create(Ref ref) {
    return shoppingGroups(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ShoppingListGroups> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ShoppingListGroups>>(
        value,
      ),
    );
  }
}

String _$shoppingGroupsHash() => r'd8d620053f650ee441c8d13a16268646b73a41ca';

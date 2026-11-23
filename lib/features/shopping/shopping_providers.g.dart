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
/// check-offs (#116) can take over later. Until then, a tap offline only
/// explains that ticking needs a connection.

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
/// check-offs (#116) can take over later. Until then, a tap offline only
/// explains that ticking needs a connection.
final class ShoppingListProvider
    extends $AsyncNotifierProvider<ShoppingList, ShoppingListView> {
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
  /// check-offs (#116) can take over later. Until then, a tap offline only
  /// explains that ticking needs a connection.
  ShoppingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
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

String _$shoppingListHash() => r'da0c5ecf09a6e3f59dd88805b420aa1d52a4382b';

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
/// check-offs (#116) can take over later. Until then, a tap offline only
/// explains that ticking needs a connection.

abstract class _$ShoppingList extends $AsyncNotifier<ShoppingListView> {
  FutureOr<ShoppingListView> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ShoppingListView>, ShoppingListView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShoppingListView>, ShoppingListView>,
              AsyncValue<ShoppingListView>,
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
/// this device for the server it was chosen on (as `<id> <server>`: ids of
/// another server mean other stores); `null` for none (categories by name).

@ProviderFor(ShoppingSupermarketChoice)
final shoppingSupermarketChoiceProvider = ShoppingSupermarketChoiceProvider._();

/// The id of the supermarket whose order the list follows, remembered on
/// this device for the server it was chosen on (as `<id> <server>`: ids of
/// another server mean other stores); `null` for none (categories by name).
final class ShoppingSupermarketChoiceProvider
    extends $NotifierProvider<ShoppingSupermarketChoice, int?> {
  /// The id of the supermarket whose order the list follows, remembered on
  /// this device for the server it was chosen on (as `<id> <server>`: ids of
  /// another server mean other stores); `null` for none (categories by name).
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
    r'9d3f2e2a7a73c771e1d7eb6abe39cd98a241dc34';

/// The id of the supermarket whose order the list follows, remembered on
/// this device for the server it was chosen on (as `<id> <server>`: ids of
/// another server mean other stores); `null` for none (categories by name).

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
/// With a supermarket chosen, it waits for the supermarkets, so the sections
/// don't change order once they arrive; if they fail, by name.

@ProviderFor(shoppingGroups)
final shoppingGroupsProvider = ShoppingGroupsProvider._();

/// The list arranged for the chosen supermarket ([groupShoppingList]).
/// With a supermarket chosen, it waits for the supermarkets, so the sections
/// don't change order once they arrive; if they fail, by name.

final class ShoppingGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShoppingListGroups>,
          AsyncValue<ShoppingListGroups>,
          AsyncValue<ShoppingListGroups>
        >
    with $Provider<AsyncValue<ShoppingListGroups>> {
  /// The list arranged for the chosen supermarket ([groupShoppingList]).
  /// With a supermarket chosen, it waits for the supermarkets, so the sections
  /// don't change order once they arrive; if they fail, by name.
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

String _$shoppingGroupsHash() => r'f638af1b9a3892a495451d55f572e57e3774d0cf';

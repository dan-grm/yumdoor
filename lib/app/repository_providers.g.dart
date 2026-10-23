// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serverRepository)
final serverRepositoryProvider = ServerRepositoryProvider._();

final class ServerRepositoryProvider
    extends
        $FunctionalProvider<
          ServerRepository,
          ServerRepository,
          ServerRepository
        >
    with $Provider<ServerRepository> {
  ServerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServerRepository create(Ref ref) {
    return serverRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerRepository>(value),
    );
  }
}

String _$serverRepositoryHash() => r'5f05020ef51a1c2e2c635f4a7411ec9e39d68256';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'5c4e3d6c3ff2e5c8bc7302570834796590a4364c';

/// The server and token of the current session.
///
/// Reading it throws while nobody is logged in; the router keeps every screen
/// that needs it behind login.

@ProviderFor(tandoorConnection)
final tandoorConnectionProvider = TandoorConnectionProvider._();

/// The server and token of the current session.
///
/// Reading it throws while nobody is logged in; the router keeps every screen
/// that needs it behind login.

final class TandoorConnectionProvider
    extends
        $FunctionalProvider<
          TandoorConnection,
          TandoorConnection,
          TandoorConnection
        >
    with $Provider<TandoorConnection> {
  /// The server and token of the current session.
  ///
  /// Reading it throws while nobody is logged in; the router keeps every screen
  /// that needs it behind login.
  TandoorConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tandoorConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tandoorConnectionHash();

  @$internal
  @override
  $ProviderElement<TandoorConnection> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TandoorConnection create(Ref ref) {
    return tandoorConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TandoorConnection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TandoorConnection>(value),
    );
  }
}

String _$tandoorConnectionHash() => r'bf823df6f29345be1feb262fa34f52dfa3c787f3';

@ProviderFor(_tandoorRepositories)
final _tandoorRepositoriesProvider = _TandoorRepositoriesProvider._();

final class _TandoorRepositoriesProvider
    extends
        $FunctionalProvider<
          TandoorRepositories,
          TandoorRepositories,
          TandoorRepositories
        >
    with $Provider<TandoorRepositories> {
  _TandoorRepositoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_tandoorRepositoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_tandoorRepositoriesHash();

  @$internal
  @override
  $ProviderElement<TandoorRepositories> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TandoorRepositories create(Ref ref) {
    return _tandoorRepositories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TandoorRepositories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TandoorRepositories>(value),
    );
  }
}

String _$_tandoorRepositoriesHash() =>
    r'54d08b1a9991d15df7d4f523e70ea459fc4cc764';

@ProviderFor(recipeRepository)
final recipeRepositoryProvider = RecipeRepositoryProvider._();

final class RecipeRepositoryProvider
    extends
        $FunctionalProvider<
          RecipeRepository,
          RecipeRepository,
          RecipeRepository
        >
    with $Provider<RecipeRepository> {
  RecipeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeRepository create(Ref ref) {
    return recipeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeRepository>(value),
    );
  }
}

String _$recipeRepositoryHash() => r'fdfac81aca17414ca4d72b441bc77bca1da539da';

@ProviderFor(foodRepository)
final foodRepositoryProvider = FoodRepositoryProvider._();

final class FoodRepositoryProvider
    extends $FunctionalProvider<FoodRepository, FoodRepository, FoodRepository>
    with $Provider<FoodRepository> {
  FoodRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodRepositoryHash();

  @$internal
  @override
  $ProviderElement<FoodRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoodRepository create(Ref ref) {
    return foodRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodRepository>(value),
    );
  }
}

String _$foodRepositoryHash() => r'b7e3a01c3954214011176c5b698ea9ac472f5188';

@ProviderFor(keywordRepository)
final keywordRepositoryProvider = KeywordRepositoryProvider._();

final class KeywordRepositoryProvider
    extends
        $FunctionalProvider<
          KeywordRepository,
          KeywordRepository,
          KeywordRepository
        >
    with $Provider<KeywordRepository> {
  KeywordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordRepositoryHash();

  @$internal
  @override
  $ProviderElement<KeywordRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeywordRepository create(Ref ref) {
    return keywordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeywordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeywordRepository>(value),
    );
  }
}

String _$keywordRepositoryHash() => r'a633677536f5557907df87100c1a693fdb7ab388';

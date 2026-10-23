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

/// The server and token of the current session.
///
/// Login (#10) overrides this with the session; until then nobody is logged
/// in and reading it throws.

@ProviderFor(tandoorConnection)
final tandoorConnectionProvider = TandoorConnectionProvider._();

/// The server and token of the current session.
///
/// Login (#10) overrides this with the session; until then nobody is logged
/// in and reading it throws.

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
  /// Login (#10) overrides this with the session; until then nobody is logged
  /// in and reading it throws.
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

String _$tandoorConnectionHash() => r'254576b45dbf6bdbf2d8370063629e3687fffd24';

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
    r'af8783761975034ef1d1739f18b9c6b31e4bfee1';

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

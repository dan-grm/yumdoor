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
    r'fe8d238b149a46e8ebb3d8d1427c372a05afcfef';

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

@ProviderFor(unitRepository)
final unitRepositoryProvider = UnitRepositoryProvider._();

final class UnitRepositoryProvider
    extends $FunctionalProvider<UnitRepository, UnitRepository, UnitRepository>
    with $Provider<UnitRepository> {
  UnitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitRepositoryHash();

  @$internal
  @override
  $ProviderElement<UnitRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnitRepository create(Ref ref) {
    return unitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitRepository>(value),
    );
  }
}

String _$unitRepositoryHash() => r'a828e4e25ccb8a572eb32de7da4f49edfaaa6e32';

@ProviderFor(ingredientParser)
final ingredientParserProvider = IngredientParserProvider._();

final class IngredientParserProvider
    extends
        $FunctionalProvider<
          IngredientParser,
          IngredientParser,
          IngredientParser
        >
    with $Provider<IngredientParser> {
  IngredientParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientParserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientParserHash();

  @$internal
  @override
  $ProviderElement<IngredientParser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IngredientParser create(Ref ref) {
    return ingredientParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientParser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientParser>(value),
    );
  }
}

String _$ingredientParserHash() => r'497df1a8bcf95b001f4489fc23ed722421222cec';

@ProviderFor(cookLogRepository)
final cookLogRepositoryProvider = CookLogRepositoryProvider._();

final class CookLogRepositoryProvider
    extends
        $FunctionalProvider<
          CookLogRepository,
          CookLogRepository,
          CookLogRepository
        >
    with $Provider<CookLogRepository> {
  CookLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookLogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CookLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CookLogRepository create(Ref ref) {
    return cookLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookLogRepository>(value),
    );
  }
}

String _$cookLogRepositoryHash() => r'4e01e62ad29f61ec7df5384d170d59bf17f1707b';

@ProviderFor(bookRepository)
final bookRepositoryProvider = BookRepositoryProvider._();

final class BookRepositoryProvider
    extends $FunctionalProvider<BookRepository, BookRepository, BookRepository>
    with $Provider<BookRepository> {
  BookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookRepository create(Ref ref) {
    return bookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookRepository>(value),
    );
  }
}

String _$bookRepositoryHash() => r'c8eef99eb931daf756fa80a528d6dd4da4278668';

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'6ce7e0a54c2658b663434db9aaa512b7d0cebb79';

@ProviderFor(savedFilterRepository)
final savedFilterRepositoryProvider = SavedFilterRepositoryProvider._();

final class SavedFilterRepositoryProvider
    extends
        $FunctionalProvider<
          SavedFilterRepository,
          SavedFilterRepository,
          SavedFilterRepository
        >
    with $Provider<SavedFilterRepository> {
  SavedFilterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedFilterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedFilterRepositoryHash();

  @$internal
  @override
  $ProviderElement<SavedFilterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavedFilterRepository create(Ref ref) {
    return savedFilterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedFilterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedFilterRepository>(value),
    );
  }
}

String _$savedFilterRepositoryHash() =>
    r'd932d3f3f8dbec3fc907798f61bb04d84b877ffe';

@ProviderFor(mealPlanRepository)
final mealPlanRepositoryProvider = MealPlanRepositoryProvider._();

final class MealPlanRepositoryProvider
    extends
        $FunctionalProvider<
          MealPlanRepository,
          MealPlanRepository,
          MealPlanRepository
        >
    with $Provider<MealPlanRepository> {
  MealPlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanRepositoryHash();

  @$internal
  @override
  $ProviderElement<MealPlanRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealPlanRepository create(Ref ref) {
    return mealPlanRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealPlanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealPlanRepository>(value),
    );
  }
}

String _$mealPlanRepositoryHash() =>
    r'52c0ae0eec3fe5e4b263b635a35b27b16d6b6ece';

@ProviderFor(mealTypeRepository)
final mealTypeRepositoryProvider = MealTypeRepositoryProvider._();

final class MealTypeRepositoryProvider
    extends
        $FunctionalProvider<
          MealTypeRepository,
          MealTypeRepository,
          MealTypeRepository
        >
    with $Provider<MealTypeRepository> {
  MealTypeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealTypeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealTypeRepositoryHash();

  @$internal
  @override
  $ProviderElement<MealTypeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealTypeRepository create(Ref ref) {
    return mealTypeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealTypeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealTypeRepository>(value),
    );
  }
}

String _$mealTypeRepositoryHash() =>
    r'7acc0db1a92994a4b53e39a7a56291cdd635356b';

@ProviderFor(shoppingRepository)
final shoppingRepositoryProvider = ShoppingRepositoryProvider._();

final class ShoppingRepositoryProvider
    extends
        $FunctionalProvider<
          ShoppingRepository,
          ShoppingRepository,
          ShoppingRepository
        >
    with $Provider<ShoppingRepository> {
  ShoppingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShoppingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShoppingRepository create(Ref ref) {
    return shoppingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoppingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoppingRepository>(value),
    );
  }
}

String _$shoppingRepositoryHash() =>
    r'5d05d45776533afdcf8a609af6c0275763fc727a';

@ProviderFor(_cacheDatabase)
final _cacheDatabaseProvider = _CacheDatabaseProvider._();

final class _CacheDatabaseProvider
    extends $FunctionalProvider<CacheDatabase, CacheDatabase, CacheDatabase>
    with $Provider<CacheDatabase> {
  _CacheDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_cacheDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_cacheDatabaseHash();

  @$internal
  @override
  $ProviderElement<CacheDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheDatabase create(Ref ref) {
    return _cacheDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheDatabase>(value),
    );
  }
}

String _$_cacheDatabaseHash() => r'0a874c653bcaafffd940ba37ee714e6f3947ef35';

@ProviderFor(_recipeCache)
final _recipeCacheProvider = _RecipeCacheProvider._();

final class _RecipeCacheProvider
    extends $FunctionalProvider<RecipeCache, RecipeCache, RecipeCache>
    with $Provider<RecipeCache> {
  _RecipeCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_recipeCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_recipeCacheHash();

  @$internal
  @override
  $ProviderElement<RecipeCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeCache create(Ref ref) {
    return _recipeCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeCache>(value),
    );
  }
}

String _$_recipeCacheHash() => r'a79b57d7783972af6c2d84c512ec66e4091a3280';

/// Recipes and images stored for offline use. Kept across sessions until
/// logout clears it.

@ProviderFor(offlineCache)
final offlineCacheProvider = OfflineCacheProvider._();

/// Recipes and images stored for offline use. Kept across sessions until
/// logout clears it.

final class OfflineCacheProvider
    extends $FunctionalProvider<OfflineCache, OfflineCache, OfflineCache>
    with $Provider<OfflineCache> {
  /// Recipes and images stored for offline use. Kept across sessions until
  /// logout clears it.
  OfflineCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineCacheHash();

  @$internal
  @override
  $ProviderElement<OfflineCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OfflineCache create(Ref ref) {
    return offlineCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineCache>(value),
    );
  }
}

String _$offlineCacheHash() => r'd9e087a2b51ebfdefd355288b08e352b27943fa0';

/// The recipe editor's unsaved drafts, in the offline cache's database.
/// Kept across sessions until logout clears them.

@ProviderFor(draftStore)
final draftStoreProvider = DraftStoreProvider._();

/// The recipe editor's unsaved drafts, in the offline cache's database.
/// Kept across sessions until logout clears them.

final class DraftStoreProvider
    extends $FunctionalProvider<DraftStore, DraftStore, DraftStore>
    with $Provider<DraftStore> {
  /// The recipe editor's unsaved drafts, in the offline cache's database.
  /// Kept across sessions until logout clears them.
  DraftStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'draftStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$draftStoreHash();

  @$internal
  @override
  $ProviderElement<DraftStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DraftStore create(Ref ref) {
    return draftStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DraftStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DraftStore>(value),
    );
  }
}

String _$draftStoreHash() => r'b1fbc2dbd22756bef3e83cc5464a7e8167ea975c';

/// The shopping check-offs made offline and not sent yet, in the offline
/// cache's database, for the session's server. One per session, like the
/// repositories: logout clears them; a session ended because the token was
/// rejected leaves them to the next login to the same server.

@ProviderFor(shoppingCheckQueue)
final shoppingCheckQueueProvider = ShoppingCheckQueueProvider._();

/// The shopping check-offs made offline and not sent yet, in the offline
/// cache's database, for the session's server. One per session, like the
/// repositories: logout clears them; a session ended because the token was
/// rejected leaves them to the next login to the same server.

final class ShoppingCheckQueueProvider
    extends
        $FunctionalProvider<
          ShoppingCheckQueue,
          ShoppingCheckQueue,
          ShoppingCheckQueue
        >
    with $Provider<ShoppingCheckQueue> {
  /// The shopping check-offs made offline and not sent yet, in the offline
  /// cache's database, for the session's server. One per session, like the
  /// repositories: logout clears them; a session ended because the token was
  /// rejected leaves them to the next login to the same server.
  ShoppingCheckQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingCheckQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingCheckQueueHash();

  @$internal
  @override
  $ProviderElement<ShoppingCheckQueue> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShoppingCheckQueue create(Ref ref) {
    return shoppingCheckQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoppingCheckQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoppingCheckQueue>(value),
    );
  }
}

String _$shoppingCheckQueueHash() =>
    r'f96c0d78e53f92c8f0292f594591eca917ff3b9b';

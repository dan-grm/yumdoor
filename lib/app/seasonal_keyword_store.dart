import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/seasonal_keywords.dart';
import '../domain/repositories/seasonal_keyword_store.dart';
import '../platform/local_store/local_store.dart';
import 'platform_providers.dart';
import 'repository_providers.dart';
import 'session.dart';

part 'seasonal_keyword_store.g.dart';

/// The month → keyword mapping of one account in the [LocalStore].
///
/// Keyed by server and user, so two accounts on this device don't share a
/// mapping. Unlike `CookingProgressStore` it is not cleared on logout: it is
/// a preference of the user, not cached server content, and is there again
/// at the next login of the same account.
class LocalSeasonalKeywordStore implements SeasonalKeywordStore {
  LocalSeasonalKeywordStore(
    this._store, {
    required Uri serverUrl,
    required int userId,
  }) : _key = keyFor(serverUrl, userId);

  final LocalStore _store;
  final String _key;

  static const _prefix = 'seasonal-keywords.';

  /// The [LocalStore] key of [userId] on [serverUrl].
  static String keyFor(Uri serverUrl, int userId) =>
      '$_prefix${Uri.encodeComponent(serverUrl.toString())}.$userId';

  @override
  Future<SeasonalKeywords> load() async {
    final saved = _store.read(_key);
    if (saved == null) return const SeasonalKeywords.empty();
    return SeasonalKeywords.fromJson(saved) ?? const SeasonalKeywords.empty();
  }

  @override
  Future<void> save(SeasonalKeywords keywords) async =>
      _store.write(_key, keywords.toJson());
}

/// The store of the logged-in account. Fails while nobody is logged in, and
/// when the user can't be read (offline at the first start).
@riverpod
Future<SeasonalKeywordStore> seasonalKeywordStore(Ref ref) async {
  final session = await ref.watch(sessionControllerProvider.future);
  if (session == null) throw StateError('Not logged in');
  final userId = await ref.watch(userRepositoryProvider).currentUserId();
  return LocalSeasonalKeywordStore(
    ref.watch(localStoreProvider),
    serverUrl: session.serverUrl,
    userId: userId,
  );
}

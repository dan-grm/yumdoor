import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/seasonal_keyword_store.dart';
import '../../domain/models/seasonal_keywords.dart';

part 'seasonal_keyword_providers.g.dart';

/// The current account's month → keyword mapping, empty until the user sets
/// one up. Ids of keywords deleted on the server stay stored; drop them
/// where the mapping is read against the keyword list
/// ([SeasonalKeywords.retainKeywords]).
@Riverpod(keepAlive: true)
class SeasonalKeywordMapping extends _$SeasonalKeywordMapping {
  @override
  Future<SeasonalKeywords> build() async =>
      (await ref.watch(seasonalKeywordStoreProvider.future)).load();

  /// Replaces the mapping, kept on this device. The new value is shown even
  /// if the device refuses to store it.
  Future<void> setMapping(SeasonalKeywords keywords) async {
    final store = await ref.read(seasonalKeywordStoreProvider.future);
    await store.save(keywords);
    state = AsyncData(keywords);
  }

  /// Remembers the current [names] (id → name) of mapped keywords, e.g.
  /// after the server returned them. Does nothing if they are stored
  /// already.
  Future<void> rememberNames(Map<int, String> names) async {
    final current = await future;
    final updated = current.withNames(names);
    if (updated != current) await setMapping(updated);
  }
}

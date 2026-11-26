import '../models/seasonal_keywords.dart';

/// The current account's month → keyword mapping, stored on this device.
abstract interface class SeasonalKeywordStore {
  /// The stored mapping; empty if there is none or it can't be read.
  Future<SeasonalKeywords> load();

  /// Stores [keywords], replacing the stored mapping.
  Future<void> save(SeasonalKeywords keywords);
}

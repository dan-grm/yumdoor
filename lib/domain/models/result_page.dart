import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_page.freezed.dart';

/// One page of a paginated result.
@freezed
abstract class ResultPage<T> with _$ResultPage<T> {
  const factory ResultPage({
    required List<T> items,

    /// The number of results over all pages.
    required int totalCount,

    /// Whether there is a next page. Requesting a page past the end fails.
    required bool hasMore,

    /// The server couldn't be reached, so these come from the offline cache:
    /// only recipes opened before, matched less precisely than the server
    /// would.
    @Default(false) bool fromCache,
  }) = _ResultPage<T>;
}

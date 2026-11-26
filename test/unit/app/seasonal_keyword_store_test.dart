import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/seasonal_keyword_store.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';

import '../../fakes/in_memory_local_store.dart';

void main() {
  final server = Uri.parse('https://a.example/tandoor');
  late InMemoryLocalStore local;

  LocalSeasonalKeywordStore store(Uri url, int user) =>
      LocalSeasonalKeywordStore(local, serverUrl: url, userId: user);

  setUp(() => local = InMemoryLocalStore());

  test('is empty by default', () async {
    expect(await store(server, 1).load(), const SeasonalKeywords.empty());
  });

  test('saves and loads', () async {
    final keywords = SeasonalKeywords({
      3: [4, 7],
      10: [12],
    });
    await store(server, 1).save(keywords);
    expect(await store(server, 1).load(), keywords);
  });

  test('is kept apart per user and per server', () async {
    final keywords = SeasonalKeywords({
      1: [1],
    });
    await store(server, 1).save(keywords);
    expect(await store(server, 2).load(), const SeasonalKeywords.empty());
    expect(
      await store(Uri.parse('https://b.example'), 1).load(),
      const SeasonalKeywords.empty(),
    );
  });

  test('corrupt data falls back to empty', () async {
    for (final bad in ['', 'nope', '[1]', '{"13": [1]}', '{"1": ["x"]}']) {
      local.write(LocalSeasonalKeywordStore.keyFor(server, 1), bad);
      expect(await store(server, 1).load(), const SeasonalKeywords.empty());
    }
  });

  test('saving empty replaces the mapping', () async {
    await store(server, 1).save(
      SeasonalKeywords({
        1: [1],
      }),
    );
    await store(server, 1).save(const SeasonalKeywords.empty());
    expect(await store(server, 1).load(), const SeasonalKeywords.empty());
  });
}

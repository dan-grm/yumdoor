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

  test('saves and loads names', () async {
    final keywords = SeasonalKeywords(
      {
        3: [4],
      },
      names: {4: 'Spargel'},
    );
    await store(server, 1).save(keywords);
    expect((await store(server, 1).load()).nameOf(4), 'Spargel');
  });

  test('loads a mapping saved with ids only', () async {
    local.write(LocalSeasonalKeywordStore.keyFor(server, 1), '{"3":[4]}');
    final loaded = await store(server, 1).load();
    expect(loaded.forMonth(3), {4});
    expect(loaded.nameOf(4), isNull);
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

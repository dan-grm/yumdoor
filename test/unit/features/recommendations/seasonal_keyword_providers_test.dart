import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/features/recommendations/seasonal_keyword_providers.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_book_user_repositories.dart';
import '../../../fakes/in_memory_local_store.dart';

void main() {
  late InMemoryLocalStore local;

  ProviderContainer start({int user = 1}) {
    final container = ProviderContainer(
      overrides: appOverrides(
        tokenStore: loggedInTokenStore(),
        users: FakeUserRepository(const [], user),
        localStore: local,
      ),
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => local = InMemoryLocalStore());

  test('starts empty and keeps an update across a reload', () async {
    final first = start();
    expect(
      await first.read(seasonalKeywordMappingProvider.future),
      const SeasonalKeywords.empty(),
    );
    final keywords = SeasonalKeywords({
      6: [2, 3],
    });
    await first
        .read(seasonalKeywordMappingProvider.notifier)
        .setMapping(keywords);
    expect(first.read(seasonalKeywordMappingProvider).value, keywords);

    expect(await start().read(seasonalKeywordMappingProvider.future), keywords);
  });

  test('another user on the same server gets their own mapping', () async {
    final first = start();
    await first.read(seasonalKeywordMappingProvider.future);
    await first
        .read(seasonalKeywordMappingProvider.notifier)
        .setMapping(
          SeasonalKeywords({
            1: [1],
          }),
        );

    expect(
      await start(user: 2).read(seasonalKeywordMappingProvider.future),
      const SeasonalKeywords.empty(),
    );
  });
}

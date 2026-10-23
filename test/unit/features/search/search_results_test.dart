import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/features/search/search_providers.dart';

import '../../../fakes/fake_recipe_repository.dart';

void main() {
  late FakeRecipeRepository repository;
  late ProviderContainer container;
  const query = RecipeQuery();
  final provider = searchResultsProvider(query);

  setUp(() {
    repository = FakeRecipeRepository([
      for (var i = 1; i <= searchPageSize * 2 + 5; i++)
        Recipe(id: i, name: 'Rezept $i'),
    ]);
    container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  Future<RecipeResults> firstPage() async {
    container.listen(provider, (_, _) {});
    return container.read(provider.future);
  }

  RecipeResults current() => container.read(provider).requireValue;

  test('loads the first page', () async {
    final results = await firstPage();

    expect(results.items, hasLength(searchPageSize));
    expect(results.totalCount, searchPageSize * 2 + 5);
    expect(results.hasMore, isTrue);
    expect(repository.searches.single.page, 1);
  });

  test('appends pages until there are no more', () async {
    await firstPage();
    final notifier = container.read(provider.notifier);

    await notifier.loadMore();
    expect(current().items, hasLength(searchPageSize * 2));
    await notifier.loadMore();
    expect(current().items, hasLength(searchPageSize * 2 + 5));
    expect(current().hasMore, isFalse);
    await notifier.loadMore();

    expect(repository.searches.map((s) => s.page), [1, 2, 3]);
    expect(current().items.map((r) => r.id).toSet(), hasLength(55));
  });

  test('loads a page only once while it is loading', () async {
    await firstPage();
    final notifier = container.read(provider.notifier);
    repository.gate = Completer();

    final first = notifier.loadMore();
    expect(current().loadingMore, isTrue);
    final second = notifier.loadMore();
    repository.gate!.complete();
    await Future.wait([first, second]);

    expect(repository.searches.map((s) => s.page), [1, 2]);
  });

  test('keeps the loaded results when the next page fails', () async {
    await firstPage();
    final notifier = container.read(provider.notifier);

    repository.failure = const OfflineFailure();
    await notifier.loadMore();
    expect(current().items, hasLength(searchPageSize));
    expect(current().loadMoreError, isA<OfflineFailure>());
    expect(current().loadingMore, isFalse);

    repository.failure = null;
    await notifier.loadMore();
    expect(current().items, hasLength(searchPageSize * 2));
    expect(current().loadMoreError, isNull);
  });

  test('cancels the request when nobody needs the results anymore', () async {
    repository.gate = Completer();
    final subscription = container.listen(provider, (_, _) {});
    await Future<void>.delayed(Duration.zero);
    final cancel = repository.searches.single.cancel!;
    expect(cancel.isCancelled, isFalse);

    subscription.close();
    await container.pump();

    expect(cancel.isCancelled, isTrue);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/features/cooking/cooking_providers.dart';

import '../../../fakes/in_memory_local_store.dart';

void main() {
  late InMemoryLocalStore store;
  late ProviderContainer container;
  var now = DateTime.utc(2026, 11, 14, 18);

  setUp(() {
    store = InMemoryLocalStore();
    container = ProviderContainer(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
  });

  CookingProgressController controller(int recipeId) {
    container.listen(cookingProgressControllerProvider(recipeId), (_, _) {});
    return container.read(cookingProgressControllerProvider(recipeId).notifier);
  }

  test('saves each toggle', () {
    controller(7).toggle((stepId: 2, ingredientId: 1));

    expect(store.values.keys, ['cooking-progress.7']);
  });

  test('after forget, a late tap is not saved again', () {
    final progress = controller(7)..toggle((stepId: 2, ingredientId: 1));

    progress
      ..forget()
      ..toggle((stepId: 2, ingredientId: 5));

    expect(store.values, isEmpty);
  });

  test('opening drops expired progress of other recipes', () {
    controller(8).toggle((stepId: 1, ingredientId: 1));
    now = now.add(const Duration(days: 2));

    controller(7);

    expect(store.values, isEmpty);
  });
}

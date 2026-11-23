@Tags(['integration'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/features/shopping/shopping_providers.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;
  late ProviderContainer annasPhone;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
    annasPhone = ProviderContainer(
      overrides: [shoppingRepositoryProvider.overrideWithValue(anna.shopping)],
    );
  });
  tearDown(() {
    annasPhone.dispose();
    anna.close();
    ben.close();
  });

  ShoppingEntry? shown(int id) {
    for (final entry
        in annasPhone.read(shoppingListProvider).requireValue.entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  test("Anna's sync sees Ben's check-off and new item", () async {
    final page = await ben.recipes.search(
      const RecipeQuery(text: 'Tomaten-Mozzarella-Salat'),
    );
    final recipe = await ben.recipes.fetchRecipe(
      page.items.singleWhere((r) => r.name == 'Tomaten-Mozzarella-Salat').id,
      allowCached: false,
    );
    final mozzarella = recipe.steps
        .expand((s) => s.ingredients)
        .singleWhere((i) => i.food?.name == 'Mozzarella');
    final first = await ben.shopping.addItem(mozzarella.food!.id, 1);
    final added = <ShoppingEntry>[first];
    try {
      // Anna opens the list once the item is on it.
      annasPhone.listen(shoppingListProvider, (_, _) {});
      await annasPhone.read(shoppingListProvider.future);
      final list = annasPhone.read(shoppingListProvider.notifier);
      expect(shown(first.id)!.checked, isFalse);

      await ben.shopping.setChecked({first.id}, checked: true);
      added.add(await ben.shopping.addItem(mozzarella.food!.id, 2));
      await list.poll();

      expect(shown(first.id)!.checked, isTrue);
      expect(shown(first.id)!.completedAt, isNotNull);
      expect(shown(added.last.id)!.amount, 2);

      // Deleted: gone with the next full read, not with a poll.
      await ben.shopping.deleteEntries([added.last]);
      await list.poll();
      expect(shown(added.last.id), isNotNull);
      await list.refresh();
      expect(shown(added.last.id), isNull);
    } finally {
      await ben.shopping.deleteEntries(added);
    }
  });
}

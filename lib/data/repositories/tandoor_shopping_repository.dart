import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/failures.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/shopping.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/services/recipe_shopping.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/shopping_mapper.dart';

/// Entries and supermarkets per request page: `DefaultPagination.max_page_size`.
const _pageSize = 200;

/// How far [ShoppingListSnapshot.syncedAt] lies before the server's time of
/// the read. Tandoor stamps a response after running its query and
/// serializing up to [_pageSize] entries, which can take a while on a small
/// server; a change in between would otherwise be missed by the next
/// incremental read. Entries that come again are harmless.
const _syncMargin = Duration(minutes: 1);

/// How often [TandoorShoppingRepository.fetch] reads the list at most when
/// it changes while the pages are read.
const _attempts = 3;

/// How many entries [TandoorShoppingRepository.deleteEntries] deletes at
/// once, so a long list doesn't flood a small server.
const _parallelDeletes = 4;

/// Writes go through [Dio] directly: the generated `ShoppingListEntryBulk`
/// takes the ids as `JsonObject`s from a package the app doesn't depend on,
/// and the generated `ShoppingListEntry` sends its food and unit as nested
/// objects, which rename them (docs/TANDOOR_API.md#shopping-list).
class TandoorShoppingRepository implements ShoppingRepository {
  TandoorShoppingRepository(this._api, this._dio);

  final api.ApiApi _api;
  final Dio _dio;

  /// Tandoor returns at most [maxShoppingEntries] entries, the oldest
  /// (docs/TANDOOR_API.md#shopping-list); `count` is then exactly that.
  /// `updated_after` must carry a time zone, so it goes as UTC.
  ///
  /// Pages are offsets into the list ordered by id. If an entry is deleted
  /// (or a checked one ages out) between two pages, the later pages shift and
  /// an entry is skipped; a changed `count` shows that, and the read starts
  /// over. The last of [_attempts] reads is kept as it is. Not noticed: a
  /// delete and an add between two pages, or a delete in a list at the cap
  /// (its `count` stays 1000). Lists rarely have more than one page.
  ///
  /// A truncated incremental read keeps [updatedAfter] as `syncedAt`: the
  /// entries it left out are ordered by id, not by time, so moving on would
  /// lose them for good.
  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) =>
      guardRequest(() async {
        for (var attempt = 1; ; attempt++) {
          final snapshot = await _read(
            updatedAfter?.toUtc(),
            strict: attempt < _attempts,
          );
          if (snapshot == null) continue;
          if (snapshot.truncated && updatedAfter != null) {
            return snapshot.copyWith(syncedAt: updatedAfter.toUtc());
          }
          return snapshot;
        }
      });

  /// One read of every page; `null` if the list changed in between, unless
  /// not [strict].
  Future<ShoppingListSnapshot?> _read(
    DateTime? updatedAfter, {
    bool strict = true,
  }) async {
    final entries = <ShoppingEntry>[];
    DateTime? serverTime;
    int? count;
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiShoppingListEntryList(
          updatedAfter: updatedAfter,
          page: page,
          pageSize: _pageSize,
        )).data,
      );
      serverTime ??= response.timestamp;
      if (count != null && response.count != count && strict) return null;
      count ??= response.count;
      entries.addAll(response.results.map((dto) => dto.toDomain()));
      if (response.next == null || response.results.isEmpty) break;
    }
    return ShoppingListSnapshot(
      entries: entries,
      syncedAt:
          (serverTime ??
                  (throw const FormatException(
                    'Shopping list without timestamp',
                  )))
              .toUtc()
              .subtract(_syncMargin),
      truncated: count >= maxShoppingEntries,
    );
  }

  /// Through the bulk endpoint: a PATCH without `checked` can clear the
  /// food's on-hand flag (docs/TANDOOR_API.md#on-hand-foods).
  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) async {
    if (ids.isEmpty) return;
    await guardRequest(
      () => _dio.post<Object?>(
        '/api/shopping-list-entry/bulk/',
        data: {'ids': ids.toList(), 'checked': checked},
      ),
    );
  }

  @override
  Future<List<Supermarket>> supermarkets() => guardRequest(() async {
    final supermarkets = <Supermarket>[];
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiSupermarketList(page: page, pageSize: _pageSize)).data,
      );
      supermarkets.addAll(response.results.map((dto) => dto.toDomain()));
      if (response.next == null || response.results.isEmpty) break;
    }
    return supermarkets;
  });

  /// The client path of docs/TANDOOR_API.md#meal-plan--shopping-list: a
  /// `ShoppingListRecipe`, then its entries in bulk. The recipe alone already
  /// marks the meal plan as on the list, so it is deleted again if the
  /// entries fail; that also removes any entries the server did create.
  @override
  Future<RecipeShopping> addRecipe(
    Recipe recipe,
    double servings, {
    int? mealPlanId,
  }) async {
    final scaledTo = servings > 0 ? servings : 1.0;
    final shopping = buildRecipeShopping(recipe, servings: scaledTo);
    if (shopping.isEmpty) return shopping;
    await guardRequest(() async {
      final created = await _dio.post<Object?>(
        '/api/shopping-list-recipe/',
        data: {
          'recipe': recipe.id,
          'servings': scaledTo,
          'mealplan': mealPlanId,
        },
      );
      // Without an id, the recipe can't be deleted again; the plan then
      // stays marked until it is added again and its entries deleted.
      final listRecipeId = switch (created.data) {
        {'id': final int id} => id,
        _ => throw const FormatException('Shopping list recipe without id'),
      };
      try {
        await _dio.post<Object?>(
          '/api/shopping-list-recipe/$listRecipeId/bulk_create_entries/',
          data: {
            'entries': [
              for (final entry in shopping.entries)
                {
                  'amount': entry.amount,
                  'food_id': entry.foodId,
                  'unit_id': entry.unitId,
                  'ingredient_id': entry.ingredientId,
                },
            ],
            // Optional in the schema, but the view needs it.
            'shopping_lists_ids': <int>[],
          },
        );
      } on Object {
        try {
          await _dio.delete<Object?>(
            '/api/shopping-list-recipe/$listRecipeId/',
          );
        } on Object {
          // It stays: the plan is marked without entries until they are
          // added again and deleted.
        }
        rethrow;
      }
    });
    return shopping;
  }

  /// Food and unit go as plain ids; nested objects would rename them.
  @override
  Future<ShoppingEntry> addItem(int foodId, double amount, {int? unitId}) =>
      guardRequest(() async {
        final response = await _dio.post<Object?>(
          '/api/shopping-list-entry/',
          data: {'food': foodId, 'unit': unitId, 'amount': amount},
        );
        return _parseEntry(response.data).toDomain();
      });

  /// `POST /api/food/` gets or creates the food; the category goes by name,
  /// which Tandoor gets or creates too, and is only used for a new food.
  /// Then each entry gets the food's id, never a nested food, which would
  /// rename it (docs/TANDOOR_API.md#shopping-list). `checked` goes along, as
  /// every entry PATCH needs it, and still such a PATCH clears the on-hand
  /// flag of the food an open entry had when the user's `shopping_add_onhand`
  /// is on (docs/TANDOOR_API.md#on-hand-foods), so flags that were set are
  /// set again.
  ///
  /// Each entry is read first, so one ticked off or deleted meanwhile is
  /// left alone rather than opened again. If moving an entry fails, the ones
  /// sent so far are moved back (best effort); a food created for the new
  /// name stays.
  @override
  Future<List<ShoppingEntry>> renameEntries(
    Iterable<ShoppingEntry> entries,
    String name,
  ) => guardRequest(() async {
    final list = entries.toList();
    if (list.isEmpty) return const <ShoppingEntry>[];
    final category = list.first.food.category;
    final food = await _dio.post<Object?>(
      '/api/food/',
      data: {
        'name': name.trim(),
        if (category != null) 'supermarket_category': {'name': category.name},
      },
    );
    final foodId = switch (food.data) {
      {'id': final int id} => id,
      _ => throw const FormatException('Food without id'),
    };
    final moving = [
      for (final entry in list)
        if (entry.food.id != foodId) entry,
    ];
    if (moving.isEmpty) return const <ShoppingEntry>[];
    // The on-hand flags of the foods the entries have on the server before
    // their PATCH, and of the new food (moving one back would clear it).
    final read = <int>{};
    final onHand = <int>{};
    Future<void> note(int id) async {
      if (read.add(id) && await _isOnHand(id)) onHand.add(id);
    }

    final renamed = <ShoppingEntry>[];
    // Those sent, including one whose answer got lost.
    final attempted = <ShoppingEntry>[];
    try {
      for (final shown in moving) {
        // As the server has it now: the PATCH sets `checked`, and the list
        // shown may not know yet that someone ticked it off or deleted it.
        final entry = await _current(shown.id);
        if (entry == null || entry.checked || entry.food.id == foodId) {
          continue;
        }
        await note(foodId);
        await note(entry.food.id);
        attempted.add(entry);
        final response = await _dio.patch<Object?>(
          '/api/shopping-list-entry/${entry.id}/',
          data: {'food': foodId, 'checked': entry.checked},
        );
        renamed.add(_parseEntry(response.data).toDomain());
      }
    } on Object {
      for (final entry in attempted) {
        try {
          await _dio.patch<Object?>(
            '/api/shopping-list-entry/${entry.id}/',
            data: {'food': entry.food.id, 'checked': entry.checked},
          );
        } on Object {
          // The list is read again after a failure and shows what is left.
        }
      }
      rethrow;
    } finally {
      for (final id in onHand) {
        try {
          await _dio.patch<Object?>(
            '/api/food/$id/',
            data: {'food_onhand': true},
          );
        } on Object {
          // Best effort: the rename itself is what was asked for.
        }
      }
    }
    return renamed;
  });

  /// The entry [id] as the server has it; `null` if it is gone.
  Future<ShoppingEntry?> _current(int id) async {
    try {
      final response = await _dio.get<Object?>('/api/shopping-list-entry/$id/');
      return _parseEntry(response.data).toDomain();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Whether anyone in the household has the food [id] on hand.
  Future<bool> _isOnHand(int id) async {
    final response = await _dio.get<Object?>('/api/food/$id/');
    return switch (response.data) {
      {'food_onhand': true} => true,
      _ => false,
    };
  }

  /// One request per entry, [_parallelDeletes] at a time: Tandoor has no
  /// bulk delete. All are tried; the first failure is thrown at the end.
  ///
  /// Deleting a plan's last entries leaves its `ShoppingListRecipe`, and
  /// with it the plan's `shopping` flag. So when a meal plan of the deleted
  /// entries has none left on the list, its recipes are unlinked from it
  /// (not deleted, which would delete checked entries other household
  /// members may still see). That cleanup is best effort, and skipped for
  /// a plan whose entries failed to delete.
  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries) async {
    final list = entries.toList();
    if (list.isEmpty) return;
    (Object, StackTrace)? failure;
    final failedPlans = <int>{};
    for (var i = 0; i < list.length; i += _parallelDeletes) {
      await Future.wait([
        for (final entry in list.skip(i).take(_parallelDeletes))
          _ignoreNotFound(
            () => _dio.delete<Object?>('/api/shopping-list-entry/${entry.id}/'),
          ).catchError((Object e, StackTrace s) {
            failure ??= (e, s);
            if (entry.source?.mealPlan case final plan?) {
              failedPlans.add(plan.id);
            }
          }),
      ]);
    }
    final plans = {
      for (final entry in list)
        if (entry.source?.mealPlan case final plan?)
          if (!failedPlans.contains(plan.id)) plan.id,
    };
    for (final planId in plans) {
      try {
        await _unlinkIfEmpty(planId);
      } on Object {
        // The plan stays marked as on the list.
      }
    }
    if (failure case (final error, final stack)) {
      if (error is DioException) {
        Error.throwWithStackTrace(failureFromDioException(error), stack);
      }
      Error.throwWithStackTrace(
        error is Failure ? error : ServerFailure(cause: error),
        stack,
      );
    }
  }

  /// Unlinks the `ShoppingListRecipe`s of the meal plan [mealPlanId] from it
  /// if the plan has no entries on the list, so it is no longer marked.
  /// Their entries, if any, stay as they are.
  Future<void> _unlinkIfEmpty(int mealPlanId) async {
    final left = requireBody(
      (await _api.apiShoppingListEntryList(
        mealplan: mealPlanId,
        pageSize: 1,
      )).data,
    );
    if (left.count > 0) return;
    final ids = <int>[];
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiShoppingListRecipeList(
          mealplan: mealPlanId,
          page: page,
          pageSize: _pageSize,
        )).data,
      );
      ids.addAll([
        for (final listRecipe in response.results)
          requireId(listRecipe.id, 'ShoppingListRecipe'),
      ]);
      if (response.next == null || response.results.isEmpty) break;
    }
    for (final id in ids) {
      await _ignoreNotFound(
        () => _dio.patch<Object?>(
          '/api/shopping-list-recipe/$id/',
          data: {'mealplan': null},
        ),
      );
    }
  }

  static Future<void> _ignoreNotFound(
    Future<Object?> Function() request,
  ) async {
    try {
      await request();
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) rethrow;
    }
  }

  static api.ShoppingListEntry _parseEntry(Object? json) {
    try {
      return requireBody(
        api.standardSerializers.deserializeWith(
          api.ShoppingListEntry.serializer,
          requireBody(json),
        ),
      );
    } on FormatException {
      rethrow;
    } on Object catch (e) {
      // built_value throws its own error types for unexpected JSON.
      throw FormatException('Unexpected shopping list entry: $e');
    }
  }
}

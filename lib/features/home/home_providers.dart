import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../domain/models/cook_log.dart';
import '../../domain/models/recipe.dart';

part 'home_providers.g.dart';

/// The recipe of a meal planned for today, with its ingredients, to count
/// those that are missing. Offline it comes from the cache, which keeps the
/// recipes of plans that aren't over yet.
///
/// Unlike `recipeProvider`, loading it records no view: the start screen
/// shows the recipe, it doesn't open it. Failures aren't retried; the start
/// screen then leaves the count out.
@Riverpod(retry: _noRetry)
Future<Recipe> plannedRecipe(Ref ref, int id) =>
    ref.watch(recipeRepositoryProvider).fetchRecipe(id);

/// How many entries "Was andere kochen" shows.
const homeActivityCount = 5;

/// How many of the latest entries are looked at to find [homeActivityCount]
/// of other users.
const _activityWindow = 30;

/// What other users of the space cooked lately, newest first, at most
/// [homeActivityCount]. The current user's own entries are left out. Kept
/// while the app runs; invalidated by pull to refresh, when the start tab is
/// shown again and when the server can be reached again.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<List<RecentCookLog>> othersActivity(Ref ref) async {
  ref.listen(isOfflineProvider, (was, offline) {
    if (was == true && !offline) ref.invalidateSelf();
  });
  final userId = await ref.watch(userRepositoryProvider).currentUserId();
  final recent = await ref
      .watch(cookLogRepositoryProvider)
      .recent(limit: _activityWindow);
  return [
    for (final log in recent)
      if (log.entry.createdBy?.id != userId) log,
  ].take(homeActivityCount).toList();
}

Duration? _noRetry(int retryCount, Object error) => null;

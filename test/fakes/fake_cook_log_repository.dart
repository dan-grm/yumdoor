import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/repositories/cook_log_repository.dart';

/// [CookLogRepository] for tests that keeps entries in [entries]. Set
/// [failure] to make every call throw it.
class FakeCookLogRepository implements CookLogRepository {
  FakeCookLogRepository({DateTime? now})
    : now = now ?? DateTime.utc(2026, 11, 14, 19);

  /// When new entries are created.
  DateTime now;
  final entries = <CookLog>[];

  /// The recipes [recent] knows, by id; entries of others are left out.
  final recipes = <int, RecipeSummary>{};
  Failure? failure;

  /// While set, [create] waits for it before answering.
  Completer<void>? gate;

  @override
  Future<CookLog> create(NewCookLog entry) async {
    if (gate case final gate?) await gate.future;
    if (failure case final failure?) throw failure;
    final log = CookLog(
      id: entries.length + 1,
      recipeId: entry.recipeId,
      servings: entry.servings,
      rating: entry.rating,
      comment: entry.comment,
      createdAt: now,
    );
    entries.add(log);
    return log;
  }

  @override
  Future<void> delete(int id) async {
    if (failure case final failure?) throw failure;
    final before = entries.length;
    entries.removeWhere((e) => e.id == id);
    if (entries.length == before) throw const NotFoundFailure();
  }

  @override
  Future<List<RecentCookLog>> recent({int limit = 20, DateTime? since}) async {
    if (failure case final failure?) throw failure;
    final sorted =
        [
          for (final entry in entries)
            if (since == null || !entry.createdAt.isBefore(since)) entry,
        ]..sort(
          (a, b) => switch (b.createdAt.compareTo(a.createdAt)) {
            0 => b.id.compareTo(a.id),
            final order => order,
          },
        );
    return [
      for (final entry in sorted)
        if (recipes[entry.recipeId] case final recipe?)
          RecentCookLog(entry: entry, recipe: recipe),
    ].take(limit).toList();
  }

  @override
  Future<DateTime?> lastCooked(int recipeId) async {
    if (failure case final failure?) throw failure;
    return entries
        .where((e) => e.recipeId == recipeId)
        .map((e) => e.createdAt)
        .fold<DateTime?>(
          null,
          (latest, date) =>
              latest == null || date.isAfter(latest) ? date : latest,
        );
  }
}

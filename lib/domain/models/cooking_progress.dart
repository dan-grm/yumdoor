import 'dart:convert';

/// One ingredient line of one step. An ingredient used in several steps is
/// ticked off per occurrence.
typedef IngredientOccurrence = ({int stepId, int ingredientId});

/// Which ingredients are ticked off while cooking a recipe.
///
/// Local only, never sent to Tandoor. It is kept across paging and reloads,
/// and forgotten after "Fertig" or once the recipe was left alone for
/// [lifetime].
class CookingProgress {
  CookingProgress({
    Set<IngredientOccurrence> done = const {},
    required this.updatedAt,
  }) : done = Set.unmodifiable(done);

  /// Nothing ticked off yet.
  CookingProgress.empty(DateTime now) : this(updatedAt: now);

  /// How long progress is kept after the last change.
  static const lifetime = Duration(days: 1);

  final Set<IngredientOccurrence> done;

  /// The last change.
  final DateTime updatedAt;

  bool isDone(IngredientOccurrence occurrence) => done.contains(occurrence);

  /// Ticks [occurrence] off, or back on if it was done.
  CookingProgress toggle(IngredientOccurrence occurrence, DateTime now) =>
      CookingProgress(
        done: done.contains(occurrence)
            ? done.difference({occurrence})
            : {...done, occurrence},
        updatedAt: now,
      );

  /// Whether the recipe was left alone for longer than [lifetime].
  bool isExpired(DateTime now) => now.difference(updatedAt) > lifetime;

  String toJson() => jsonEncode({
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'done': [
      for (final o in done) [o.stepId, o.ingredientId],
    ],
  });

  /// Parses what [toJson] wrote; `null` if [source] is not that, e.g. written
  /// by another version or edited by hand.
  static CookingProgress? fromJson(String source) {
    try {
      final json = jsonDecode(source);
      if (json case {
        'updatedAt': final String updatedAt,
        'done': final List<Object?> done,
      }) {
        return CookingProgress(
          updatedAt: DateTime.parse(updatedAt),
          done: {
            for (final entry in done)
              if (entry case [final int stepId, final int ingredientId])
                (stepId: stepId, ingredientId: ingredientId),
          },
        );
      }
    } on FormatException {
      // Not JSON or not a date.
    }
    return null;
  }
}

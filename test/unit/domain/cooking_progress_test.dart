import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/cooking_progress.dart';

void main() {
  final start = DateTime.utc(2026, 11, 14, 18);
  const karotten = (stepId: 2, ingredientId: 1);
  const karottenLater = (stepId: 3, ingredientId: 7);

  test('toggle ticks off and back on, and records the time', () {
    final later = start.add(const Duration(minutes: 5));
    final progress = CookingProgress.empty(start).toggle(karotten, later);

    expect(progress.isDone(karotten), isTrue);
    expect(progress.updatedAt, later);
    expect(progress.toggle(karotten, later).isDone(karotten), isFalse);
  });

  test('occurrences in different steps are separate', () {
    final progress = CookingProgress.empty(start).toggle(karotten, start);

    expect(progress.isDone(karotten), isTrue);
    expect(progress.isDone(karottenLater), isFalse);
  });

  test('expires a day after the last change', () {
    final progress = CookingProgress.empty(start).toggle(karotten, start);

    expect(progress.isExpired(start.add(const Duration(hours: 24))), isFalse);
    expect(
      progress.isExpired(start.add(const Duration(hours: 24, seconds: 1))),
      isTrue,
    );
  });

  test('round-trips through JSON', () {
    final progress = CookingProgress.empty(start)
        .toggle(karotten, start)
        .toggle(karottenLater, start);

    final read = CookingProgress.fromJson(progress.toJson())!;

    expect(read.done, {karotten, karottenLater});
    expect(read.updatedAt, start);
  });

  test('unreadable JSON is null, bad entries are skipped', () {
    for (final source in [
      '',
      'nicht json',
      '[]',
      '{"done": []}',
      '{"updatedAt": "gestern", "done": []}',
      '{"updatedAt": 5, "done": []}',
    ]) {
      expect(CookingProgress.fromJson(source), isNull, reason: source);
    }

    final read = CookingProgress.fromJson(
      '{"updatedAt": "2026-11-14T18:00:00.000Z", '
      '"done": [[2, 1], ["x", 1], [3], 4, [3, 7]]}',
    )!;
    expect(read.done, {karotten, karottenLater});
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/cook_log_mapper.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  List<api.CookLog> recorded() => api.standardSerializers
      .deserializeWith(
        api.PaginatedCookLogList.serializer,
        tandoorFixture('cook_log_list.json'),
      )!
      .results
      .toList();

  test('maps a cook log entry', () {
    final entries = [for (final entry in recorded()) entry.toDomain()];

    expect(
      entries.first,
      CookLog(
        id: 1,
        recipeId: 21,
        servings: 2,
        rating: 4,
        createdBy: const UserRef(id: 2, name: 'Anna'),
        createdAt: DateTime.parse('2026-09-21T22:09:00+02:00'),
      ),
    );
    expect(entries.last.comment, 'Sehr lecker, gerne wieder!');
    expect(entries[1].createdBy, const UserRef(id: 3, name: 'Ben'));
  });

  test('maps missing values and a blank comment to null', () {
    final entry = api.CookLog(
      (b) => b
        ..id = 9
        ..recipe = 7
        ..comment = '  '
        ..createdAt = DateTime.utc(2026, 11, 14),
    ).toDomain();

    expect(entry.servings, isNull);
    expect(entry.rating, isNull);
    expect(entry.comment, isNull);
    expect(entry.createdBy, isNull);
  });

  test('rejects an entry without a date', () {
    expect(
      () => api.CookLog(
        (b) => b
          ..id = 9
          ..recipe = 7,
      ).toDomain(),
      throwsFormatException,
    );
  });

  test('a new entry sends only what was entered', () {
    Object? json(NewCookLog entry) => api.standardSerializers.serializeWith(
      api.CookLog.serializer,
      entry.toApi(),
    );

    expect(
      json(NewCookLog(recipeId: 7, servings: 4, rating: 5, comment: 'Lecker')),
      {'recipe': 7, 'servings': 4, 'rating': 5, 'comment': 'Lecker'},
    );
    // No `created_at`: the server takes the current time.
    expect(json(NewCookLog(recipeId: 7, servings: 4)), {
      'recipe': 7,
      'servings': 4,
    });
  });
}

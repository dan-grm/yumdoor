import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/cook_log.dart';

void main() {
  group('NewCookLog', () {
    test('keeps the rating and a trimmed comment', () {
      final entry = NewCookLog(
        recipeId: 7,
        servings: 4,
        rating: 4,
        comment: '  Nächstes Mal mehr Honig.\n',
      );

      expect(entry.recipeId, 7);
      expect(entry.servings, 4);
      expect(entry.rating, 4);
      expect(entry.comment, 'Nächstes Mal mehr Honig.');
    });

    test('a blank comment counts as none', () {
      expect(
        NewCookLog(recipeId: 7, servings: 1, comment: ' \n ').comment,
        isNull,
      );
      expect(NewCookLog(recipeId: 7, servings: 1).comment, isNull);
    });

    test('accepts 1 to 5 stars or no rating', () {
      for (final rating in [null, 1, 2, 3, 4, 5]) {
        expect(
          NewCookLog(recipeId: 7, servings: 1, rating: rating).rating,
          rating,
        );
      }
    });

    test('rejects other ratings', () {
      // Tandoor stores any integer, so the client has to check.
      for (final rating in [0, 6, -1]) {
        expect(
          () => NewCookLog(recipeId: 7, servings: 1, rating: rating),
          throwsArgumentError,
        );
      }
    });

    test('rejects servings below 1', () {
      expect(() => NewCookLog(recipeId: 7, servings: 0), throwsArgumentError);
    });
  });
}

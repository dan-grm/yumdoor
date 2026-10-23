import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/food_mapper.dart';
import 'package:yumdoor/data/mappers/keyword_mapper.dart';
import 'package:yumdoor/data/mappers/mapping.dart';
import 'package:yumdoor/data/mappers/server_mapper.dart';
import 'package:yumdoor/data/mappers/user_mapper.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/server_info.dart';
import 'package:yumdoor/domain/models/unit.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  test('maps a food', () {
    final page = api.standardSerializers.deserializeWith(
      api.PaginatedFoodList.serializer,
      tandoorFixture('food_list.json'),
    )!;

    final karotte = page.results.single.toDomain();

    expect(karotte.name, 'Karotte');
    expect(karotte.pluralName, 'Karotten');
    expect(karotte.parentId, isNotNull);
    expect(karotte.onHand, isFalse);
    expect(karotte.ignoreShopping, isFalse);
  });

  test('maps a unit without a plural to null', () {
    final unit = api.Unit(
      (b) => b
        ..id = 1
        ..name = 'Prise'
        ..pluralName = '',
    );

    expect(unit.toDomain(), const Unit(id: 1, name: 'Prise'));
  });

  test('maps a keyword', () {
    final page = api.standardSerializers.deserializeWith(
      api.PaginatedKeywordList.serializer,
      tandoorFixture('keyword_list.json'),
    )!;

    expect(
      page.results.single.toDomain(),
      const Keyword(id: 45, name: 'Suppe'),
    );
  });

  test('maps the server settings', () {
    final settings = api.standardSerializers.deserializeWith(
      api.ServerSettings.serializer,
      tandoorFixture('server_settings.json'),
    )!;

    expect(settings.toDomain(), const ServerInfo(version: '2.6.15'));
  });

  group('user name', () {
    api.User user({String? displayName, String? username}) => api.User(
      (b) => b
        ..id = 1
        ..displayName = displayName
        ..username = username,
    );

    test('is the trimmed display name', () {
      expect(
        user(displayName: 'Anna ', username: 'anna').toDomain().name,
        'Anna',
      );
    });

    test('falls back to the username', () {
      expect(user(username: 'anna').toDomain().name, 'anna');
      expect(user(displayName: ' ', username: 'anna').toDomain().name, 'anna');
    });
  });

  test('rejects objects without an id', () {
    final keyword = api.Keyword((b) => b.name = 'Suppe');

    expect(keyword.toDomain, throwsFormatException);
  });

  group('optionalUri', () {
    test('treats empty as missing', () {
      expect(optionalUri(null), isNull);
      expect(optionalUri(''), isNull);
    });

    test('parses a URL', () {
      expect(
        optionalUri('https://example.com/media/a.jpg'),
        Uri.parse('https://example.com/media/a.jpg'),
      );
    });
  });
}

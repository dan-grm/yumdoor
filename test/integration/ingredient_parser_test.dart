@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories repositories;

  setUp(() {
    repositories = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
  });
  tearDown(() => repositories.close());

  // Only seeded foods and units: the parser creates the ones it doesn't know.

  test('parses German and English lines', () async {
    final parser = repositories.ingredientParser;

    final karotten = await parser.parse('200 g Karotten, geschält');
    expect(karotten.amount, 200);
    expect(karotten.unit?.name, 'g');
    expect(karotten.food?.name, 'Karotte');
    expect(karotten.food?.id, isNotNull);
    expect(karotten.note, 'geschält');
    expect(karotten.originalText, '200 g Karotten, geschält');

    final salz = await parser.parse('½ TL Salz');
    expect(
      (salz.amount, salz.unit?.name, salz.food?.name),
      (0.5, 'TL', 'Salz'),
    );

    final broth = await parser.parse('1,5 l Gemüsebrühe');
    expect(broth.amount, 1.5);

    final cinnamon = await parser.parse('1 1/2 tsp cinnamon');
    expect(
      (cinnamon.amount, cinnamon.unit?.name, cinnamon.food?.name),
      (1.5, 'tsp', 'cinnamon'),
    );

    final eier = await parser.parse('2 Eier');
    expect((eier.amount, eier.unit, eier.food?.name), (2, null, 'Ei'));

    final butter = await parser.parse('Butter (weich)');
    expect(
      (butter.amount, butter.unit, butter.food?.name, butter.note),
      (0, null, 'Butter', 'weich'),
    );
  });

  test('returns a line Tandoor fails on as unparsed', () async {
    // An empty food after the unit: Tandoor answers with a 500.
    const line = '1 g\t,\tSalz';

    expect(
      await repositories.ingredientParser.parse(line),
      ParsedIngredient.unparsed(line),
    );
  });

  test('parses a list, splitting it if Tandoor fails on a line', () async {
    final parsed = await repositories.ingredientParser.parseAll([
      '2 tbsp olive oil',
      '',
      '1 g\t,\tSalz',
      '2 carrots, peeled and diced',
    ]);

    expect(parsed.map((p) => (p.food?.name, p.note)), [
      ('olive oil', ''),
      (null, '1 g\t,\tSalz'),
      ('carrot', 'peeled and diced'),
    ]);
  });

  test('creates a food it does not know', () async {
    final name = 'Yumdoor-Test-${DateTime.now().microsecondsSinceEpoch}';
    final dio = createTandoorDio(tandoor.baseUrl, token: tandoor.token('anna'));
    addTearDown(dio.close);

    final parsed = await repositories.ingredientParser.parse('2 EL $name');
    addTearDown(() => dio.delete<void>('/api/food/${parsed.food!.id}/'));

    expect(parsed.food?.name, name);
    expect(parsed.food?.id, isNotNull);
    expect((await repositories.foods.fetchFood(parsed.food!.id!)).name, name);
  });
}

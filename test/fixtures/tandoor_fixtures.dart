import 'dart:convert';
import 'dart:io';

/// A JSON response recorded from the seeded Tandoor with
/// `dart run tool/record_fixtures.dart`, e.g. `recipe_list.json`.
Object? tandoorFixture(String name) =>
    jsonDecode(File('test/fixtures/tandoor/$name').readAsStringSync());

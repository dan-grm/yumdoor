@Tags(['integration'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/repositories/tandoor_server_repository.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  final repository = TandoorServerRepository();

  test('reads the version without logging in', () async {
    final info = await repository.fetchServerInfo(tandoor.baseUrl);

    expect(info.version, File('TANDOOR_VERSION').readAsStringSync().trim());
    expect(info.isSupported, isTrue);
  });

  test('rejects a URL that is not Tandoor', () {
    // Tandoor redirects unknown paths to its login page.
    expect(
      repository.fetchServerInfo(tandoor.baseUrl.resolve('/not-tandoor')),
      throwsA(isA<IncompatibleServerFailure>()),
    );
  });

  test('reports an unreachable server as offline', () {
    expect(
      repository.fetchServerInfo(Uri.parse('http://localhost:1')),
      throwsA(isA<OfflineFailure>()),
    );
  });
}

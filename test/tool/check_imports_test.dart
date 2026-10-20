import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../tool/check_imports.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('check_imports_');
    File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('name: app\n');
  });

  tearDown(() => root.deleteSync(recursive: true));

  /// Writes `lib/<path>` with one import per line of [imports] and returns the
  /// violations as `path:line uri`.
  List<String> check(Map<String, List<String>> tree) {
    tree.forEach((path, imports) {
      File(p.join(root.path, 'lib', path))
        ..createSync(recursive: true)
        ..writeAsStringSync(imports.map((i) => '$i\n').join());
    });
    return [
      for (final v in checkImports(root.path)) '${v.path}:${v.line} ${v.uri}',
    ];
  }

  test('passes when every layer stays in its lane', () {
    expect(
      check({
        'main.dart': [
          "import 'package:flutter/material.dart';",
          "import 'app/app.dart';",
        ],
        'app/app.dart': [
          "import 'package:app/data/recipe_repository_impl.dart';",
          "import '../features/home.dart';",
        ],
        'data/recipe_repository_impl.dart': [
          "import 'package:tandoor_api/tandoor_api.dart';",
          "import 'package:dio/dio.dart';",
          "import 'package:drift/drift.dart';",
          "import '../domain/recipe.dart';",
          "import '../platform/token_store/token_store.dart';",
        ],
        'domain/recipe.dart': [
          "import 'package:freezed_annotation/freezed_annotation.dart';",
          "import 'package:meta/meta.dart';",
          "import '../core/result.dart';",
        ],
        'features/home.dart': [
          "import 'package:flutter/material.dart';",
          "import 'package:flutter_riverpod/flutter_riverpod.dart';",
          "import '../domain/recipe.dart';",
          "import '../platform/token_store/token_store.dart';",
        ],
        'platform/token_store/token_store.dart': [
          "import 'token_store_stub.dart' if (dart.library.js_interop) 'token_store_web.dart';",
        ],
        'platform/token_store/token_store_web.dart': [
          "import 'dart:js_interop';",
          "import 'package:web/web.dart';",
        ],
        'platform/token_store/token_store_io.dart': ["import 'dart:io';"],
      }),
      isEmpty,
    );
  });

  test('only lib/data/ may import package:tandoor_api', () {
    expect(
      check({
        'data/mappers/recipe_mapper.dart': [
          "import 'package:tandoor_api/tandoor_api.dart';",
        ],
        'domain/recipe.dart': [
          "import 'package:tandoor_api/tandoor_api.dart';",
        ],
        'features/recipe/recipe_screen.dart': [
          "export 'package:tandoor_api/model/recipe.dart';",
        ],
        'app/providers.dart': [
          "import 'package:tandoor_api/tandoor_api.dart';",
        ],
      }),
      [
        'lib/app/providers.dart:1 package:tandoor_api/tandoor_api.dart',
        'lib/domain/recipe.dart:1 package:tandoor_api/tandoor_api.dart',
        'lib/features/recipe/recipe_screen.dart:1 package:tandoor_api/model/recipe.dart',
      ],
    );
  });

  test(
    'lib/domain/ imports neither Flutter, Dio, Drift nor other app layers',
    () {
      expect(
        check({
          'domain/services/scaling.dart': [
            "import 'dart:math';",
            "import 'package:flutter/foundation.dart';",
            "import 'package:flutter_riverpod/flutter_riverpod.dart';",
            "import 'dart:ui';",
            "import 'package:dio/dio.dart';",
            "import 'package:drift/drift.dart';",
            "import '../../data/api.dart';",
            "import 'package:app/platform/wake_lock/wake_lock.dart';",
            "import '../../features/home.dart';",
            "import '../models/recipe.dart';",
            "import '../../core/result.dart';",
          ],
        }),
        [
          'lib/domain/services/scaling.dart:2 package:flutter/foundation.dart',
          'lib/domain/services/scaling.dart:3 package:flutter_riverpod/flutter_riverpod.dart',
          'lib/domain/services/scaling.dart:4 dart:ui',
          'lib/domain/services/scaling.dart:5 package:dio/dio.dart',
          'lib/domain/services/scaling.dart:6 package:drift/drift.dart',
          'lib/domain/services/scaling.dart:7 ../../data/api.dart',
          'lib/domain/services/scaling.dart:8 package:app/platform/wake_lock/wake_lock.dart',
          'lib/domain/services/scaling.dart:9 ../../features/home.dart',
        ],
      );
    },
  );

  test('lib/features/ imports neither data, Dio nor Drift', () {
    expect(
      check({
        'features/search/search_screen.dart': [
          "import 'package:app/data/repositories/recipe_repository_impl.dart';",
          "import '../../data/api/client.dart';",
          "import 'package:dio/dio.dart';",
          "import 'package:drift/drift.dart';",
          "import '../../domain/models/recipe.dart';",
        ],
      }),
      [
        'lib/features/search/search_screen.dart:1 package:app/data/repositories/recipe_repository_impl.dart',
        'lib/features/search/search_screen.dart:2 ../../data/api/client.dart',
        'lib/features/search/search_screen.dart:3 package:dio/dio.dart',
        'lib/features/search/search_screen.dart:4 package:drift/drift.dart',
      ],
    );
  });

  test(
    'platform libraries stay in lib/platform/, including conditional imports',
    () {
      expect(
        check({
          'data/cache/db.dart': ["import 'dart:io';"],
          'features/cooking/cooking_screen.dart': [
            "import 'dart:html';",
            "import 'dart:js_interop';",
            "import 'package:web/web.dart';",
          ],
          'main.dart': ["import 'stub.dart' if (dart.library.io) 'dart:io';"],
        }),
        [
          'lib/data/cache/db.dart:1 dart:io',
          'lib/features/cooking/cooking_screen.dart:1 dart:html',
          'lib/features/cooking/cooking_screen.dart:2 dart:js_interop',
          'lib/features/cooking/cooking_screen.dart:3 package:web/web.dart',
          'lib/main.dart:1 dart:io',
        ],
      );
    },
  );

  test('ignores comments and string literals that look like imports', () {
    expect(
      check({
        'domain/recipe.dart': [
          "// import 'package:flutter/material.dart';",
          "/* import 'dart:io'; */",
          "const example = \"import 'package:dio/dio.dart';\";",
        ],
      }),
      isEmpty,
    );
  });

  test('formats violations as path:line:column', () {
    check({
      'domain/recipe.dart': ["import 'package:flutter/material.dart';"],
    });
    expect(
      checkImports(root.path).single.toString(),
      startsWith(
        'lib/domain/recipe.dart:1:8: package:flutter/material.dart: lib/domain/ is pure Dart',
      ),
    );
  });

  test('throws when the root has no pubspec.yaml', () {
    File(p.join(root.path, 'pubspec.yaml')).deleteSync();
    expect(() => checkImports(root.path), throwsFormatException);
  });
}

// Fills the local dev Tandoor with synthetic data (tool/seed/data.dart).
//
//   dart run tool/seed.dart [--reset] [--url http://localhost:8080]
//
// 1. Bootstrap (tool/seed/bootstrap.py through `docker compose exec`): users,
//    space, household and one API token per user. The token API needs a user,
//    and /api-token-auth/ is limited to 10 requests per day.
// 2. Everything else over the REST API, as the user who would have created it.
//
// Running it again on a seeded instance does nothing; `--reset` deletes the
// seeded space and users first. Writes `.seed/credentials.json` (git-ignored)
// for integration tests. Refuses to talk to anything but the local Tandoor.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'seed/data.dart';

/// Hosts the seed may write to: loopback, or the compose service name when
/// running inside the compose network (CI).
const allowedHosts = {'localhost', '127.0.0.1', '::1', 'web_recipes'};

const composeFile = 'docker/tandoor/compose.yml';
const credentialsPath = '.seed/credentials.json';
const _usage =
    'Usage: dart run tool/seed.dart [--reset] [--url http://localhost:8080]';

Future<void> main(List<String> args) async {
  var reset = false;
  var baseUrl = Uri.parse('http://localhost:8080');
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--reset':
        reset = true;
      case '--url' when i + 1 < args.length:
        baseUrl = Uri.parse(args[++i]);
      case '-h' || '--help':
        stdout.writeln(_usage);
        return;
      default:
        stderr.writeln(_usage);
        exitCode = 64;
        return;
    }
  }

  if (!isLocalTarget(baseUrl)) {
    stderr.writeln(
      'seed: refusing to write to ${baseUrl.host}. '
      'The seed only runs against the local dev Tandoor (${allowedHosts.join(', ')}).',
    );
    exitCode = 2;
    return;
  }

  final root = File.fromUri(Platform.script).parent.parent.path;
  try {
    await _run(root, baseUrl, reset: reset);
  } on SeedException catch (e) {
    stderr.writeln('seed: ${e.message}');
    exitCode = 1;
  }
}

bool isLocalTarget(Uri url) => allowedHosts.contains(url.host);

class SeedException implements Exception {
  SeedException(this.message);

  final String message;
}

Future<void> _run(String root, Uri baseUrl, {required bool reset}) async {
  final stopwatch = Stopwatch()..start();
  final problems = seedDataProblems();
  if (problems.isNotEmpty) {
    throw SeedException('invalid seed data:\n  ${problems.join('\n  ')}');
  }

  final pinned = File('$root/TANDOOR_VERSION').readAsStringSync().trim();
  final version = await _serverVersion(baseUrl);
  if (version != pinned) {
    stderr.writeln(
      'seed: warning: server runs Tandoor $version, TANDOOR_VERSION is $pinned.',
    );
  }

  stdout.writeln(
    reset ? 'Resetting and bootstrapping…' : 'Bootstrapping users and space…',
  );
  final boot = await _bootstrap(root, reset: reset);
  final clients = {
    for (final user in boot.users)
      user.username: TandoorClient(baseUrl, user.token),
  };

  try {
    final counts = boot.counts;
    final alreadySeeded = (counts['recipes'] ?? 0) > 0;
    if (alreadySeeded) {
      final complete =
          counts['recipes'] == seedRecipes.length &&
          (counts['shopping_entries'] ?? 0) > 0;
      if (!complete) {
        throw SeedException(
          'the space is only partly seeded (${counts['recipes']} recipes). '
          'Run again with --reset.',
        );
      }
      stdout.writeln(
        'Already seeded; nothing to do (use --reset to start over).',
      );
    } else {
      await Seeder(clients, boot).run();
    }
  } finally {
    for (final client in clients.values) {
      client.close();
    }
  }

  _writeCredentials(root, baseUrl, version, boot);
  stdout
    ..writeln()
    ..writeln(
      'Tandoor $version at $baseUrl, space "$seedSpace" (${stopwatch.elapsed.inSeconds} s)',
    )
    ..writeln();
  for (final user in boot.users) {
    stdout.writeln(
      '  ${user.username.padRight(6)} password ${user.password.padRight(16)} token ${user.token}',
    );
  }
  stdout
    ..writeln()
    ..writeln('Credentials written to $credentialsPath');
}

/// Typos in the dataset (unknown foods, recipes, users), so they fail before
/// anything is written.
List<String> seedDataProblems() {
  final foods = {for (final food in seedFoods) food.name};
  final recipes = {for (final recipe in seedRecipes) recipe.name};
  final users = {for (final user in seedUsers) user.username};
  final mealTypes = {for (final type in seedMealTypes) type.name};
  return [
    for (final food in seedFoods)
      if (food.parent != null && !foods.contains(food.parent))
        'food ${food.name}: unknown parent',
    for (final recipe in seedRecipes) ...[
      if (!users.contains(recipe.author))
        'recipe ${recipe.name}: unknown author',
      for (final step in recipe.steps)
        for (final ingredient in step.ingredients)
          if (ingredient.food != null && !foods.contains(ingredient.food))
            'recipe ${recipe.name}: unknown food ${ingredient.food}',
    ],
    for (final book in seedBooks)
      for (final recipe in book.recipes)
        if (!recipes.contains(recipe))
          'book ${book.name}: unknown recipe $recipe',
    for (final plan in seedMealPlans) ...[
      if (plan.recipe != null && !recipes.contains(plan.recipe))
        'meal plan: unknown recipe ${plan.recipe}',
      if (!mealTypes.contains(plan.mealType))
        'meal plan: unknown meal type ${plan.mealType}',
    ],
    for (final (food, _, _, _) in seedLooseShopping)
      if (!foods.contains(food)) 'shopping: unknown food $food',
  ];
}

Future<String> _serverVersion(Uri baseUrl) async {
  final client = TandoorClient(baseUrl, null);
  try {
    final settings = await client.get(
      '/api/server-settings/current/',
    ) as Map<String, dynamic>;
    return settings['version'] as String;
  } on SocketException {
    throw SeedException(
      'no Tandoor at $baseUrl. Start it with '
      '`docker compose -f $composeFile up -d --wait`.',
    );
  } finally {
    client.close();
  }
}

class BootstrapUser {
  BootstrapUser.fromJson(Map<String, dynamic> json)
    : username = json['username'] as String,
      password = json['password'] as String,
      userId = json['user_id'] as int,
      role = json['role'] as String,
      household = json['household'] as bool,
      token = json['token'] as String;

  final String username;
  final String password;
  final int userId;
  final String role;
  final bool household;
  final String token;

  Map<String, Object> toJson() => {
    'user_id': userId,
    'password': password,
    'token': token,
    'role': role,
    'household': household,
  };
}

class BootstrapResult {
  BootstrapResult.fromJson(Map<String, dynamic> json)
    : spaceId = json['space_id'] as int,
      householdId = json['household_id'] as int,
      users = [
        for (final user in json['users'] as List)
          BootstrapUser.fromJson(user as Map<String, dynamic>),
      ],
      counts = (json['counts'] as Map<String, dynamic>).cast<String, int>();

  final int spaceId;
  final int householdId;
  final List<BootstrapUser> users;
  final Map<String, int> counts;

  BootstrapUser user(String username) =>
      users.firstWhere((u) => u.username == username);
}

Future<BootstrapResult> _bootstrap(String root, {required bool reset}) async {
  const marker = 'YUMDOOR_SEED_RESULT ';
  final bootstrapArgs = {
    'reset': reset,
    'space': seedSpace,
    'household': seedHousehold,
    'users': [for (final user in seedUsers) user.toBootstrapArgs()],
  };
  // A JSON string literal is also a valid Python string literal.
  final script =
      'import json\nARGS = json.loads(${jsonEncode(jsonEncode(bootstrapArgs))})\n'
      '${File('$root/tool/seed/bootstrap.py').readAsStringSync()}';

  final Process process;
  try {
    process = await Process.start('docker', [
      'compose', '-f', composeFile, 'exec', '-T', '-w', '/opt/recipes', //
      'web_recipes', 'venv/bin/python', 'manage.py', 'shell',
    ], workingDirectory: root);
  } on ProcessException catch (e) {
    throw SeedException('could not run docker: ${e.message}');
  }
  process.stdin.add(utf8.encode(script));
  await process.stdin.close();
  final (out, err, code) = await (
    process.stdout.transform(utf8.decoder).join(),
    process.stderr.transform(utf8.decoder).join(),
    process.exitCode,
  ).wait;

  final line = LineSplitter.split(out)
      .where((l) => l.startsWith(marker))
      .firstOrNull;
  if (code != 0 || line == null) {
    throw SeedException('bootstrap failed (exit $code):\n$err$out');
  }
  return BootstrapResult.fromJson(
    jsonDecode(line.substring(marker.length)) as Map<String, dynamic>,
  );
}

void _writeCredentials(
  String root,
  Uri baseUrl,
  String version,
  BootstrapResult boot,
) {
  final file = File('$root/$credentialsPath')
    ..parent.createSync(recursive: true);
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert({
      'base_url': baseUrl.toString(),
      'tandoor_version': version,
      'space_id': boot.spaceId,
      'household_id': boot.householdId,
      'users': {for (final user in boot.users) user.username: user.toJson()},
    })}\n',
  );
}

/// Minimal JSON client for the Tandoor REST API.
class TandoorClient {
  TandoorClient(this.baseUrl, this.token);

  final Uri baseUrl;
  final String? token;
  final _http = HttpClient();

  Future<Object?> get(String path) => _send('GET', path);
  Future<Object?> post(String path, Object body) => _send('POST', path, body);
  Future<Object?> put(String path, Object body) => _send('PUT', path, body);
  Future<Object?> patch(String path, Object body) => _send('PATCH', path, body);

  Future<Object?> _send(String method, String path, [Object? body]) async {
    final request = await _http.openUrl(method, baseUrl.resolve(path));
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    if (token != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(body)));
    }
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 300) {
      throw SeedException('$method $path → ${response.statusCode}: $text');
    }
    return text.isEmpty ? null : jsonDecode(text);
  }

  void close() => _http.close();
}

class Seeder {
  Seeder(this.clients, this.boot);

  final Map<String, TandoorClient> clients;
  final BootstrapResult boot;

  /// Fixed seed so every run produces the same cook logs.
  final _random = Random(7);

  final _foodIds = <String, int>{};
  final _recipes = <String, Map<String, dynamic>>{};
  final _mealTypes = <String, Map<String, dynamic>>{};
  final _onHand = {
    for (final food in seedFoods.where((f) => f.onHand)) food.name,
  };
  final _ignored = {
    for (final food in seedFoods.where((f) => f.ignoreShopping)) food.name,
  };

  TandoorClient get _anna => clients['anna']!;

  Future<void> run() async {
    await _step('supermarket', _supermarket);
    await _step('foods', _foods);
    await _step('recipes', _recipesStep);
    await _step('cook logs', _cookLogs);
    await _step('recipe books', _books);
    await _step('on-hand foods', _markOnHand);
    await _step('meal plans and shopping list', _mealPlans);
  }

  Future<void> _step(String name, Future<void> Function() body) async {
    stdout.write('  $name… ');
    final stopwatch = Stopwatch()..start();
    await body();
    stdout.writeln('${stopwatch.elapsedMilliseconds} ms');
  }

  Future<void> _supermarket() async {
    final market =
        await _anna.post('/api/supermarket/', {'name': seedSupermarket}) as Map;
    for (final (order, name) in seedCategories.indexed) {
      final category =
          await _anna.post('/api/supermarket-category/', {'name': name}) as Map;
      await _anna.post('/api/supermarket-category-relation/', {
        'supermarket': market['id'],
        'category': {'id': category['id'], 'name': name},
        'order': order,
      });
    }
  }

  Future<void> _foods() async {
    for (final food in seedFoods) {
      final created = await _anna.post('/api/food/', {
        'name': food.name,
        'plural_name': ?food.plural,
        if (food.category != null)
          'supermarket_category': {'name': food.category},
        'ignore_shopping': food.ignoreShopping,
      }) as Map;
      _foodIds[food.name] = created['id'] as int;
      if (food.parent case final parent?) {
        await _anna.put(
          '/api/food/${created['id']}/move/${_foodIds[parent]}/',
          {},
        );
      }
    }
  }

  Future<void> _recipesStep() async {
    for (final recipe in seedRecipes) {
      _recipes[recipe.name] = await clients[recipe.author]!.post(
        '/api/recipe/',
        {
          'name': recipe.name,
          'description': recipe.description,
          'servings': recipe.servings,
          'working_time': recipe.workingTime,
          'waiting_time': recipe.waitingTime,
          'internal': true,
          'keywords': [
            for (final keyword in recipe.keywords) {'name': keyword},
          ],
          'steps': [
            for (final (stepOrder, step) in recipe.steps.indexed)
              {
                'name': step.name,
                'instruction': step.instruction,
                'time': step.time,
                'order': stepOrder,
                'show_ingredients_table': true,
                'ingredients': [
                  for (final (order, ingredient) in step.ingredients.indexed)
                    {
                      'amount': ingredient.amount,
                      'unit': ingredient.unit == null
                          ? null
                          : {'name': ingredient.unit},
                      'food': ingredient.food == null
                          ? null
                          : {'name': ingredient.food},
                      'note': ingredient.note ?? '',
                      'order': order,
                      'is_header': ingredient.isHeader,
                      'no_amount': ingredient.noAmount,
                    },
                ],
              },
          ],
        },
      ) as Map<String, dynamic>;
    }
  }

  /// About two logs a week per household member over the last eight weeks.
  Future<void> _cookLogs() async {
    const ratings = [5, 4, 4, 3, 5, 2, null, 4];
    final now = DateTime.now();
    for (var i = 0; i < 32; i++) {
      final user = i.isEven ? 'anna' : 'ben';
      final recipe = seedRecipes[_random.nextInt(seedRecipes.length)];
      final day = now.subtract(Duration(days: 1 + _random.nextInt(56)));
      final cookedAt = DateTime(
        day.year,
        day.month,
        day.day,
        18 + _random.nextInt(3),
        _random.nextInt(60),
      );
      await clients[user]!.post('/api/cook-log/', {
        'recipe': _recipes[recipe.name]!['id'],
        'servings': recipe.servings,
        'rating': ratings[_random.nextInt(ratings.length)],
        'comment': seedComments[_random.nextInt(seedComments.length)],
        'created_at': cookedAt.toUtc().toIso8601String(),
      });
    }
  }

  Future<void> _books() async {
    for (final (order, book) in seedBooks.indexed) {
      final client = clients[book.owner]!;
      final created = await client.post('/api/recipe-book/', {
        'name': book.name,
        'description': book.description,
        'order': order,
        'shared': [
          for (final user in book.sharedWith) {'id': boot.user(user).userId},
        ],
      }) as Map;
      for (final recipe in book.recipes) {
        await client.post('/api/recipe-book-entry/', {
          'book': created['id'],
          'recipe': _recipes[recipe]!['id'],
        });
      }
    }
  }

  /// On hand is per household, so marking it as Anna covers Ben too.
  Future<void> _markOnHand() async {
    for (final food in _onHand) {
      await _anna.patch('/api/food/${_foodIds[food]}/', {'food_onhand': true});
    }
  }

  Future<void> _mealPlans() async {
    for (final type in seedMealTypes) {
      _mealTypes[type.name] = await _anna.post('/api/meal-type/', {
        'name': type.name,
        'order': type.order,
        'time': type.time,
        'color': type.color,
      }) as Map<String, dynamic>;
    }

    final today = DateTime.now();
    final monday = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );
    for (final plan in seedMealPlans) {
      final client = clients[plan.by]!;
      final recipe = plan.recipe == null ? null : _recipes[plan.recipe]!;
      final day = DateTime(
        monday.year,
        monday.month,
        monday.day + plan.weekday - 1,
      );
      final mealType = _mealTypes[plan.mealType]!;
      final created = await client.post('/api/meal-plan/', {
        'title': plan.title,
        'recipe': recipe == null
            ? null
            : {
                'id': recipe['id'],
                'name': recipe['name'],
                'servings': recipe['servings'],
              },
        'servings': plan.servings,
        'note': plan.note,
        // Midnight without offset: Tandoor applies the meal type's time.
        'from_date': '${_date(day)}T00:00:00',
        'meal_type': {'id': mealType['id'], 'name': mealType['name']},
      }) as Map;
      if (plan.shopping && recipe != null) {
        await _addToShopping(
          client,
          recipe,
          created['id'] as int,
          plan.servings,
        );
      }
    }

    for (final (food, amount, unit, by) in seedLooseShopping) {
      await clients[by]!.post('/api/shopping-list-entry/', {
        'food': {'id': _foodIds[food], 'name': food},
        'unit': unit == null ? null : {'name': unit},
        'amount': amount,
      });
    }

    // One checked entry, through the bulk endpoint (see docs/TANDOOR_API.md).
    final entries = await _anna.get('/api/shopping-list-entry/') as Map;
    final milk = (entries['results'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((e) => (e['food'] as Map)['name'] == 'Milch');
    await _anna.post('/api/shopping-list-entry/bulk/', {
      'ids': [milk['id']],
      'checked': true,
    });
  }

  /// What Tandoor's own frontend does: scale client-side, skip on-hand and
  /// ignored foods, then create the entries in bulk.
  Future<void> _addToShopping(
    TandoorClient client,
    Map<String, dynamic> recipe,
    int mealPlanId,
    num servings,
  ) async {
    final factor = servings / (recipe['servings'] as num);
    final entries = [
      for (final step in recipe['steps'] as List)
        for (final ingredient in (step as Map)['ingredients'] as List)
          if (ingredient
              case {
                'is_header': false,
                'no_amount': false,
                'food': {'name': final String food, 'id': final int foodId},
              }
              when !_onHand.contains(food) && !_ignored.contains(food))
            {
              'amount': (ingredient['amount'] as num) * factor,
              'food_id': foodId,
              'unit_id': (ingredient['unit'] as Map?)?['id'],
              'ingredient_id': ingredient['id'],
            },
    ];
    final listRecipe = await client.post('/api/shopping-list-recipe/', {
      'recipe': recipe['id'],
      'servings': servings,
      'mealplan': mealPlanId,
    }) as Map;
    // shopping_lists_ids is optional in the schema, but the view needs it.
    await client.post(
      '/api/shopping-list-recipe/${listRecipe['id']}/bulk_create_entries/',
      {'entries': entries, 'shopping_lists_ids': <int>[]},
    );
  }

  static String _date(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
}

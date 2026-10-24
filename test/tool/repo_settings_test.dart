import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/repo_settings.dart';

class FakeGitHub implements GitHub {
  FakeGitHub(this.responses);

  final Map<String, Object?> responses;
  final sent = <(String, String, Object?)>[];

  @override
  Future<Object?> get(String path) async => responses[path];

  @override
  Future<void> send(String method, String path, [Object? body]) async =>
      sent.add((method, path, body));
}

const repo = 'owner/app';

Map<String, Object?> wanted() => {
  'repos/$repo': {...mergeSettings, 'has_wiki': false},
  'repos/$repo/branches/main/protection': {
    'required_status_checks': {
      'strict': false,
      'checks': [
        for (final check in requiredChecks)
          {'context': check, 'app_id': githubActionsAppId},
      ],
    },
    'enforce_admins': {'enabled': true},
    'required_pull_request_reviews': {
      'dismiss_stale_reviews': true,
      'required_approving_review_count': requiredApprovals,
    },
    'required_linear_history': {'enabled': true},
    'allow_force_pushes': {'enabled': false},
    'allow_deletions': {'enabled': false},
  },
  'repos/$repo/private-vulnerability-reporting': {'enabled': true},
  'repos/$repo/labels?per_page=100': [
    for (final label in [...labels, 'bug']) {'name': label},
  ],
};

void main() {
  test('reports nothing when every setting is as wanted', () async {
    expect(await checkSettings(FakeGitHub(wanted()), repo), isEmpty);
  });

  test('fixes an unprotected main with the full protection', () async {
    final gh = FakeGitHub(
      wanted()..['repos/$repo/branches/main/protection'] = null,
    );
    final drift = await checkSettings(gh, repo);

    expect(drift.single.description, contains('not protected'));
    await drift.single.fix();
    final (method, path, body) = gh.sent.single;
    expect((method, path), ('PUT', 'repos/$repo/branches/main/protection'));
    expect(body, branchProtection());
  });

  test('flags a required check from another app or a missing one', () async {
    final responses = wanted();
    final protection =
        responses['repos/$repo/branches/main/protection']!
            as Map<String, Object?>;
    protection['required_status_checks'] = {
      'checks': [
        for (final check in requiredChecks.skip(1))
          {'context': check, 'app_id': githubActionsAppId},
        {'context': requiredChecks.first, 'app_id': 1},
      ],
    };
    protection['enforce_admins'] = {'enabled': false};

    final drift = await checkSettings(FakeGitHub(responses), repo);
    expect(drift.single.description, contains('required checks'));
    expect(drift.single.description, contains('admins are exempt'));
  });

  test('patches only the differing merge settings', () async {
    final responses = wanted();
    (responses['repos/$repo']! as Map<String, Object?>)
      ..['allow_merge_commit'] = true
      ..['squash_merge_commit_title'] = 'COMMIT_OR_PR_TITLE';
    final gh = FakeGitHub(responses);

    final drift = await checkSettings(gh, repo);
    await drift.single.fix();
    expect(gh.sent.single.$3, {
      'allow_merge_commit': false,
      'squash_merge_commit_title': 'PR_TITLE',
    });
  });

  test('enables vulnerability reporting and creates missing labels', () async {
    final gh = FakeGitHub(
      wanted()
        ..['repos/$repo/private-vulnerability-reporting'] = {'enabled': false}
        ..['repos/$repo/labels?per_page=100'] = [
          {'name': 'feat'},
        ],
    );

    for (final d in await checkSettings(gh, repo)) {
      await d.fix();
    }
    expect(gh.sent.first, (
      'PUT',
      'repos/$repo/private-vulnerability-reporting',
      null,
    ));
    expect(
      [for (final (_, _, body) in gh.sent.skip(1)) body],
      [
        for (final label in labels.skip(1)) {'name': label},
      ],
    );
  });

  test('every required check is a job that runs on every pull request', () {
    final jobs = <String>{};
    for (final file in Directory('.github/workflows').listSync()) {
      if (file is! File || !file.path.endsWith('.yml')) continue;
      final lines = file.readAsLinesSync();
      // The `on:` block, up to the next top-level key.
      final on = lines
          .skipWhile((l) => l != 'on:')
          .skip(1)
          .takeWhile((l) => l.isEmpty || l.startsWith(' '))
          .toList();
      final pr = on.indexOf('  pull_request:');
      final filtered =
          pr < 0 ||
          on.skip(pr + 1).takeWhile((l) => l.startsWith('    ')).isNotEmpty;
      if (filtered) continue;
      for (final line in lines) {
        if (RegExp(r'^    name: (.+)$').firstMatch(line) case final m?) {
          jobs.add(m[1]!);
        }
      }
    }
    expect(jobs, containsAll(requiredChecks));
  });
}

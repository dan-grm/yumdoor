// Checks or applies the GitHub repository settings the workflow in CLAUDE.md
// relies on: branch protection for `main`, squash merges with the PR title as
// commit message, private vulnerability reporting and the issue labels.
//
//   dart run tool/repo_settings.dart [--apply] [--repo owner/name]
//
// Without --apply it only reads the settings, prints what differs and exits
// with 1 if anything does. --apply changes the differing settings (needs admin
// rights; uses `gh api`, so run `gh auth login` first). The repository
// defaults to the one `gh` resolves for the current directory.

import 'dart:convert';
import 'dart:io';

const _usage =
    'Usage: dart run tool/repo_settings.dart [--apply] [--repo owner/name]';

/// Job names (not workflow names) that must pass before a PR can merge.
///
/// Only jobs that run on every pull request belong here; a required check
/// that a path filter skips blocks the PR forever.
const requiredChecks = [
  'Format, analyze, test',
  'API client is up to date',
  'Web build',
  'Integration tests against Tandoor',
];

/// Approvals a PR needs. GitHub never counts the author's own approval, so
/// anything above 0 means only the other developer can unblock a PR.
const requiredApprovals = 0;

/// The GitHub Actions app, so other apps can't report a required check.
const githubActionsAppId = 15368;

const labels = [
  'feat',
  'fix',
  'chore',
  'build',
  'ci',
  'docs',
  'infra',
  'data',
  'ui',
  'platform',
];

const mergeSettings = {
  'allow_squash_merge': true,
  'allow_merge_commit': false,
  'allow_rebase_merge': false,
  'squash_merge_commit_title': 'PR_TITLE',
  'squash_merge_commit_message': 'BLANK',
  'delete_branch_on_merge': true,
};

Map<String, Object?> branchProtection() => {
  'required_status_checks': {
    'strict': false,
    'checks': [
      for (final check in requiredChecks)
        {'context': check, 'app_id': githubActionsAppId},
    ],
  },
  'enforce_admins': true,
  'required_pull_request_reviews': {
    'dismiss_stale_reviews': true,
    'required_approving_review_count': requiredApprovals,
  },
  'restrictions': null,
  'required_linear_history': true,
  'allow_force_pushes': false,
  'allow_deletions': false,
};

/// The subset of the GitHub REST API this tool uses.
abstract interface class GitHub {
  /// Returns the decoded JSON response, or null for 404.
  Future<Object?> get(String path);

  Future<void> send(String method, String path, [Object? body]);
}

/// [GitHub] through `gh api`.
class GhCli implements GitHub {
  @override
  Future<Object?> get(String path) async {
    final result = await Process.run('gh', ['api', path]);
    if (result.exitCode != 0) {
      if ('${result.stdout}'.contains('"status":"404"')) return null;
      throw ProcessException('gh', ['api', path], '${result.stderr}');
    }
    return jsonDecode('${result.stdout}');
  }

  @override
  Future<void> send(String method, String path, [Object? body]) async {
    final args = ['api', '-X', method, path];
    final process = await Process.start('gh', [
      ...args,
      if (body != null) ...['--input', '-'],
    ]);
    if (body != null) process.stdin.write(jsonEncode(body));
    await process.stdin.close();
    final out = await process.stdout.transform(utf8.decoder).join();
    final err = await process.stderr.transform(utf8.decoder).join();
    if (await process.exitCode != 0) {
      throw ProcessException('gh', args, '$out$err');
    }
  }
}

/// A setting that differs from what we want, and how to fix it.
typedef Drift = ({String description, Future<void> Function() fix});

/// Compares [repo]'s settings with the ones above.
Future<List<Drift>> checkSettings(GitHub gh, String repo) async {
  final drift = <Drift>[];

  final repository = (await gh.get('repos/$repo'))! as Map<String, Object?>;
  final mergeDrift = {
    for (final MapEntry(:key, :value) in mergeSettings.entries)
      if (repository[key] != value) key: value,
  };
  if (mergeDrift.isNotEmpty) {
    drift.add((
      description:
          'merge settings: '
          '${[for (final key in mergeDrift.keys) '$key is ${repository[key]}, want ${mergeDrift[key]}'].join('; ')}',
      fix: () => gh.send('PATCH', 'repos/$repo', mergeDrift),
    ));
  }

  final protectionPath = 'repos/$repo/branches/main/protection';
  final problems = _protectionProblems(await gh.get(protectionPath));
  if (problems.isNotEmpty) {
    drift.add((
      description: 'main branch protection: ${problems.join('; ')}',
      fix: () => gh.send('PUT', protectionPath, branchProtection()),
    ));
  }

  final reportingPath = 'repos/$repo/private-vulnerability-reporting';
  final reporting = await gh.get(reportingPath) as Map<String, Object?>?;
  if (reporting?['enabled'] != true) {
    drift.add((
      description: 'private vulnerability reporting is disabled',
      fix: () => gh.send('PUT', reportingPath),
    ));
  }

  final existing = {
    for (final label
        in (await gh.get('repos/$repo/labels?per_page=100'))! as List<Object?>)
      (label! as Map<String, Object?>)['name'],
  };
  for (final label in labels.where((l) => !existing.contains(l))) {
    drift.add((
      description: 'label $label is missing',
      fix: () => gh.send('POST', 'repos/$repo/labels', {'name': label}),
    ));
  }

  return drift;
}

List<String> _protectionProblems(Object? protection) {
  if (protection is! Map<String, Object?>) return ['not protected'];
  bool enabled(String key) =>
      (protection[key] as Map<String, Object?>?)?['enabled'] == true;

  final problems = <String>[];
  final checks = protection['required_status_checks'] as Map<String, Object?>?;
  final actual = {
    for (final check in (checks?['checks'] as List<Object?>?) ?? const [])
      if (check case {'context': final String context, 'app_id': final appId}
          when appId == githubActionsAppId)
        context,
  };
  if (actual.length != requiredChecks.length ||
      !actual.containsAll(requiredChecks)) {
    problems.add('required checks are ${actual.toList()}');
  }
  if (!enabled('enforce_admins')) problems.add('admins are exempt');
  final reviews =
      protection['required_pull_request_reviews'] as Map<String, Object?>?;
  if (reviews == null) {
    problems.add('pull requests are not required');
  } else {
    final approvals = reviews['required_approving_review_count'] ?? 0;
    if (approvals != requiredApprovals) {
      problems.add('$approvals approvals required, want $requiredApprovals');
    }
    if (reviews['dismiss_stale_reviews'] != true) {
      problems.add('stale approvals are kept');
    }
  }
  if (!enabled('required_linear_history')) {
    problems.add('linear history not required');
  }
  if (enabled('allow_force_pushes')) problems.add('force pushes allowed');
  if (enabled('allow_deletions')) problems.add('deletion allowed');
  return problems;
}

Future<void> main(List<String> args) async {
  var apply = false;
  String? repo;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--apply':
        apply = true;
      case '--repo' when i + 1 < args.length:
        repo = args[++i];
      default:
        stderr.writeln(_usage);
        exitCode = 64;
        return;
    }
  }

  final gh = GhCli();
  try {
    repo ??=
        '${(await Process.run('gh', ['repo', 'view', '--json', 'nameWithOwner', '-q', '.nameWithOwner'])).stdout}'
            .trim();
    final drift = await checkSettings(gh, repo);
    if (drift.isEmpty) {
      stdout.writeln('$repo: all settings are as wanted');
      return;
    }
    for (final d in drift) {
      stdout.writeln('${apply ? 'Fixing' : 'Differs'}: ${d.description}');
      if (apply) await d.fix();
    }
    if (!apply) {
      stdout.writeln('Run with --apply to change these settings.');
      exitCode = 1;
    }
  } on ProcessException catch (e) {
    stderr.writeln('repo_settings: ${e.message}');
    exitCode = 2;
  }
}

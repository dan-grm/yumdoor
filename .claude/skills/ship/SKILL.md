---
name: ship
description: Implement one GitHub issue end to end (branch, code, tests, checks, self-review, PR with auto-merge) and wait until it merges. Use when asked to ship, implement or fix an issue, or to fix a bug the user describes.
argument-hint: "[issue number | bug description]"
---

# Ship one issue

Nobody reads the code before it merges. The tests, the checks and your own review are the only safety net, so
don't cut any of them short to finish faster. Follow `CLAUDE.md` throughout.

## 1. Pick the issue

- A number: `gh issue view <n> --comments`.
- A bug described in words: file it first (`gh issue create`, title `fix(<scope>): <symptom>`, label `fix`, the
  current milestone if it blocks it), with what the user saw, what they expected and how to reproduce it. Then
  ship that issue.
- Nothing: the lowest-numbered open issue in the lowest open milestone whose `Depends on` issues are all closed.

If the issue is unclear in a way that changes what you build, ask the user before writing code. Don't ask about
things `docs/`, the mockups or the existing code already answer.

## 2. Branch

```sh
git switch main && git pull --ff-only
git switch -c <type>/<issue>-<slug>
```

Start from `main`; don't stack on an unmerged PR. If the issue depends on one, wait for it to merge.

## 3. Implement

- Read the docs for the area you touch (`docs/ARCHITECTURE.md`, `docs/TANDOOR_API.md`, `docs/design/`, the mockup).
  Check API behavior against the local Tandoor before relying on it, and fix `docs/TANDOOR_API.md` if it is wrong.
- **Bugs:** reproduce first with a test that fails, then fix, then see it pass.
- New domain logic gets unit tests; new screens get widget tests; UI changes get or update goldens (DE, 390 px,
  light and dark). Test German strings at 390 px for overflow.
- Run codegen when inputs change (`build_runner`, `gen-l10n`, `gen_tokens`); commit the generated files.
- Commit in logical steps with Conventional Commit messages. Mechanical changes (renames, codegen) in their own
  commits.

## 4. Check

All must pass before the PR:

```sh
dart format --set-exit-if-changed .
flutter analyze
dart run tool/check_imports.dart
flutter test --exclude-tags integration
```

When `lib/data/` or the seed changed: start the local Tandoor, seed it and run `flutter test --tags integration`.

Goldens are compared on Linux. Push the branch, run `gh workflow run update-goldens.yml --ref <branch>`, download
the `goldens` artifact when it finishes (see the workflow's header), unpack and commit the PNGs.

## 5. Review yourself

Run the `code-review` skill on the branch at `high`. Fix every real finding, re-run the checks, and review again
until nothing real is left. Also check the diff against the issue's acceptance criteria one by one.

## 6. Open the PR

```sh
git push -u origin HEAD
gh pr create --title "<conventional commit>" --body-file <file> --milestone "<milestone>"
gh pr merge --auto --squash
```

The title becomes the commit on `main`. The body follows the earlier PRs: `Closes #<n>`, **What** (and why where it
isn't obvious), **How it was tested**, the goldens as screenshots for UI changes, and anything the user should
check by hand in the app.

## 7. Wait for the merge

Watch the checks (`gh pr checks <pr> --watch`, in the background). If one fails, read its log
(`gh run view <id> --log-failed`), fix the cause, push, and watch again. After three failed rounds, or if the fix
would mean changing the issue's scope, stop and tell the user what is wrong.

When the PR has merged: `git switch main && git pull --ff-only`. Report in two or three sentences what changed for
the user and what to try in the app.

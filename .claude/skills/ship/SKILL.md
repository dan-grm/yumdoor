---
name: ship
description: Implement one GitHub issue end to end (branch, code, tests, checks, self-review, PR) and merge it once CI is green. Use when asked to ship, implement or fix an issue, or to fix a bug the user describes.
argument-hint: "[issue number | bug description]"
---

# Ship one issue

Nobody reads the code before it merges. The tests, the checks and your own review are the only safety net, so
don't cut any of them short to finish faster. Follow `CLAUDE.md` throughout.

**GitHub only through `gh api` (REST).** Cloud sessions block GitHub's GraphQL API, and with it `gh pr` and
`gh issue`. `gh run` and `gh workflow` use REST and work. `gh api` fills in `{owner}/{repo}` from the git remote.

## 1. Pick the issue

- A number: `gh api repos/{owner}/{repo}/issues/<n>` and `…/issues/<n>/comments`.
- A bug described in words: file it first, then ship that issue. Title `fix(<scope>): <symptom>`, label `fix`, the
  current milestone if it blocks it; the body says what the user saw, what they expected and how to reproduce it.

  ```sh
  gh api repos/{owner}/{repo}/issues -f title="…" -F body=@issue.md -f "labels[]=fix" -F milestone=<number>
  ```

- Nothing: the lowest-numbered open issue in the lowest open milestone whose `Depends on` issues are all closed.
  `gh api "repos/{owner}/{repo}/issues?milestone=<number>&state=open&per_page=100"` lists issues and PRs; skip
  entries that have a `pull_request` field.

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

Goldens are compared on Linux:

- **On Linux** (cloud sessions): `flutter test --tags golden --exclude-tags integration --update-goldens`, then
  look at the changed PNGs and commit them.
- **Elsewhere:** push the branch, `gh workflow run update-goldens.yml --ref <branch>`, download the `goldens` artifact
  when it finishes (see the workflow's header), unpack and commit the PNGs.

## 5. Review yourself

Run the `code-review` skill on the branch at `high`. Fix every real finding, re-run the checks, and review again
until nothing real is left. Also check the diff against the issue's acceptance criteria one by one.

## 6. Open the PR

```sh
git push -u origin HEAD
gh api repos/{owner}/{repo}/pulls -f title="<conventional commit>" -f head=<branch> -f base=main \
  -F body=@pr.md --jq .number
gh api -X PATCH repos/{owner}/{repo}/issues/<pr> -F milestone=<number>
```

The title becomes the commit on `main`. The body follows the earlier PRs: `Closes #<n>`, **What** (and why where it
isn't obvious), **How it was tested**, the goldens as screenshots for UI changes, and anything the user should
check by hand in the app. In a cloud session, end the body with a link to the session
(`https://claude.ai/code/$CLAUDE_CODE_REMOTE_SESSION_ID`).

## 7. Merge when green

Wait for the required checks (the list in `tool/repo_settings.dart`) on the PR's head commit. Poll from a
background command or a monitor, about once a minute, not with a foreground sleep:

```sh
gh api "repos/{owner}/{repo}/commits/<sha>/check-runs?per_page=100" \
  --jq '.check_runs[] | "\(.name)\t\(.status)\t\(.conclusion)"'
```

- **All succeeded:** merge with your own credentials, so the push to `main` triggers the image workflow:
  `gh api -X PUT repos/{owner}/{repo}/pulls/<pr>/merge -f merge_method=squash`. Don't let a GitHub Actions token
  merge or enable auto-merge; workflows don't run on pushes made with that token.
- **One failed:** read its log (`gh run view <run-id> --log-failed`), fix the cause, push, and wait again. After
  three failed rounds, or if the fix would mean changing the issue's scope, stop and tell the user what is wrong.

After the merge: `git switch main && git pull --ff-only`. Report in two or three sentences what changed for the user
and what to try in the app.

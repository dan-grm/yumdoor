---
name: milestone
description: Plan a roadmap milestone into GitHub issues, or ship a milestone's open issues by orchestrating one ship subagent per issue, in parallel where they don't depend on each other. Use when asked to plan, start, continue or finish a milestone.
argument-hint: "plan <M2> | run [<M2>]"
---

# Milestones

Talk to GitHub only through `gh api` (REST), as the `ship` skill explains: cloud sessions block `gh issue` and
`gh pr`. Create an issue with `gh api repos/{owner}/{repo}/issues -f title=… -F body=@file -f "labels[]=…"
-F milestone=<number>`; list a milestone's issues with
`gh api "repos/{owner}/{repo}/issues?milestone=<number>&state=open&per_page=100"`, skipping entries that have a
`pull_request` field.

## `plan <milestone>`: turn the roadmap into issues

1. Read the milestone's section in `docs/ROADMAP.md`, its open decisions, and the docs and mockups it touches.
   Look at the code that exists, so issues build on it instead of restating it.
2. Create the GitHub milestone if it is missing, with the roadmap heading as title
   (`gh api repos/{owner}/{repo}/milestones -f title=…`).
3. Split it into issues small enough for one PR each, reviewable in a few minutes. Order them so each builds on
   merged work; put shared foundations (domain models, services, components) first.
4. Each issue, in the format of the M1 issues:
   - Title: a Conventional Commit (`feat(cooking): …`), which becomes the PR title.
   - `## Goal`: one or two sentences on what the user gets.
   - `## Scope`: what is in, and what is explicitly left for later issues.
   - `## Acceptance criteria`: checkable statements, including the tests that prove them.
   - `## Depends on`: issue numbers, or "Nothing".
   - Labels from `tool/repo_settings.dart` (type plus area), and the milestone.
   - Issues reference each other by number, so create them first and fill in `Depends on` afterwards
     (`gh api -X PATCH repos/{owner}/{repo}/issues/<n> -F body=@file`).
5. Open decisions the milestone needs: don't decide them in an issue. List them for the user with a
   recommendation each.
6. Report the issue list (number, title, one line each) so the user can reorder or cut scope before `run`.

## `run [milestone]`: orchestrate one subagent per issue

Without a name, use the lowest open milestone.

You are the orchestrator. Each issue is shipped by its own subagent with a fresh context, so the cost of one issue
doesn't carry into the next. Keep your own context small: don't read code, run checks or review diffs yourself; work
from the issue list and the subagents' one-line results.

### Loop

1. List the milestone's open issues with their `Depends on` lines. An issue is **ready** when all its dependencies
   are closed and no subagent is working on it.
2. Pick the ready issues to start now (see *Parallel or not*), lowest numbers first.
3. Start one subagent per picked issue with the Agent tool: `subagent_type: "general-purpose"`,
   `isolation: "worktree"` (each gets its own checkout; parallel agents must never share one), in the background.
   Prompt:

   > Ship issue #<n> of dan-grm/yumdoor with the `ship` skill, as a subagent of the milestone orchestrator: don't
   > ask the user anything. Work in your own worktree on `<type>/<n>-<slug>`. Other issues may merge meanwhile, so
   > follow the ship skill's rule for a moved `main` before merging. Finish with exactly one line:
   > `merged #<pr>: <what changed for the user>`, or `blocked: <reason, with the question for the user if any>`.

4. When a subagent finishes, record its line, then go back to step 1: a merge can make new issues ready. Don't
   wait for every subagent of a wave before starting the next ready issue.
5. Repeat until the milestone has no open issues.

### Parallel or not

Run issues at the same time only when all of this holds; otherwise start them one after another:

- **Independent:** neither depends on the other, directly or through an open issue.
- **Separate areas:** they change different features (`lib/features/<area>/`) and don't both change shared code:
  domain models or services in `lib/domain/`, design components or tokens, `lib/app/` (router, providers),
  platform services, or the same screen. Both adding strings to the ARB files is fine; the second rebases.
- **One data change at a time:** at most one running issue touches `lib/data/`, the seed or the Tandoor setup. They
  share the one local Tandoor and the integration tests.
- **At most 3** subagents at once (the cloud VM has 4 vCPUs, and every subagent runs builds, tests and goldens).

When unsure, run them in sequence: a wasted rebase costs more than waiting.

### Stop and ask the user

- A subagent returns `blocked:` with a decision that isn't in the docs, or an issue turns out bigger than one PR
  (propose a split instead). Let the other running subagents finish first.
- The `ship` skill gave up on a failing check.
- The remaining issues all depend on something still open.

After each merged issue, give a one-line status (`#52 merged: timers start from step text. 6 left.`). At the end,
close the milestone (`gh api -X PATCH repos/{owner}/{repo}/milestones/<n> -f state=closed`) and list what the
user should try in the app.

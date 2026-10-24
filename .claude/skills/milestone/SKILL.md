---
name: milestone
description: Plan a roadmap milestone into GitHub issues, or work through a milestone's open issues one after another with the ship skill. Use when asked to plan, start, continue or finish a milestone.
argument-hint: "plan <M2> | run [<M2>]"
---

# Milestones

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
5. Open decisions the milestone needs: don't decide them in an issue. List them for the user with a
   recommendation each.
6. Report the issue list (number, title, one line each) so the user can reorder or cut scope before `run`.

## `run [milestone]`: ship the open issues in order

Without a name, use the lowest open milestone.

1. List its open issues. Pick the next one whose dependencies are closed, lowest number first.
2. Ship it with the `ship` skill, including waiting for the merge.
3. Repeat until the milestone has no open issues.

Stop and ask the user when:

- an issue needs a decision that isn't in the docs, or turns out bigger than one PR (propose a split instead),
- the `ship` skill gives up on a failing check,
- the remaining issues all depend on something still open.

After each merged issue, give a one-line status (`#52 merged: timers start from step text. 6 left.`). At the end,
close the milestone (`gh api -X PATCH repos/{owner}/{repo}/milestones/<n> -f state=closed`) and list what the
user should try in the app.

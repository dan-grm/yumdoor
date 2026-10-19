# Yumdoor — guide for Claude Code

Yumdoor is a Flutter client for self-hosted Tandoor Recipes (AGPL-3.0). Two developers, Daniel and his
girlfriend, build it mostly through Claude Code. Read this file first, then the doc for the area you touch:

- `docs/ARCHITECTURE.md`: layers, stack, platform abstraction, offline, security
- `docs/TANDOOR_API.md`: **verified** Tandoor 2.6.15 API behavior and gotchas. Check here before assuming how an
  endpoint works; if you find it wrong, fix the doc in the same PR.
- `docs/ROADMAP.md`: milestones and open decisions
- `docs/design/`: design system (tokens, components, mockups). Mockups are German phone screens at 390 px.

## Product rules

- General Tandoor client: never hardcode anything about our own server, users, meal types or categories.
- No ads, analytics, tracking or third-party requests at runtime.
- Target Tandoor **2.6.15** (pinned in `TANDOOR_VERSION`). Only the latest 2.x line is supported.
- Servings are chosen on the recipe screen and are read-only in cooking mode.
- Offline is read-only. When offline, write actions are disabled (visible, with an explanation), never queued.

## Architecture rules (enforced by `tool/check_imports.dart` in CI)

1. `package:tandoor_api` (generated) is imported **only** in `lib/data/`. Map DTOs to domain models in
   `lib/data/mappers/`. Never pass a generated type to `domain` or `features`.
2. `lib/domain/` is pure Dart: no Flutter, no Dio, no Drift, no platform code.
3. `lib/features/` talks to repositories and services through Riverpod providers, never to `data` directly.
4. Platform-specific code lives in `lib/platform/<service>/` behind an interface, chosen with conditional imports.
   No `dart:html`, `package:web` or `dart:io` anywhere else.
5. Widgets read design tokens (`context.tokens.…`). No hex colors, font sizes or paddings as literals in
   feature code.
6. Every user-visible string is in `lib/l10n/app_de.arb` and `app_en.arb`. German first.
7. Server content is untrusted: render Markdown to widgets from the raw text; never use Tandoor's
   `*_markdown` HTML fields, never inject HTML into the DOM.
8. Don't edit generated code (`packages/tandoor_api/lib/`, `*.g.dart`, `*.freezed.dart`, `lib/l10n/generated/`).
   Regenerate instead.

## Commands

Prerequisites: Flutter stable, Docker, `gh`. Scripts are Dart so they run the same on Windows, macOS and Linux.
These land during Milestone 1; if one doesn't exist yet, the issue that adds it is still open.

```sh
flutter pub get                                   # setup
dart run build_runner build -d                    # freezed, riverpod, drift codegen
flutter gen-l10n                                  # localization (also runs on pub get)
dart run tool/gen_tokens.dart                     # docs/design/tokens.json → lib/design/tokens.g.dart

docker compose -f docker/tandoor/compose.yml up -d   # local Tandoor 2.6.15 on http://localhost:8080
dart run tool/seed.dart                           # synthetic data; prints the test users' credentials
flutter run -d chrome                             # dev app; Tandoor requests are proxied (web_dev_config.yaml)

dart format --set-exit-if-changed .
flutter analyze
dart run tool/check_imports.dart
flutter test --exclude-tags integration           # unit + widget
flutter test --tags integration                   # needs local Tandoor + seed
flutter build web --release --no-web-resources-cdn --base-href /__BASE_PATH__/
docker build -f docker/web/Dockerfile -t yumdoor .   # serve with BASE_PATH=/app/
```

Integration tests and the seed script refuse to run against anything but `localhost` or the CI service.
Never point them at a real instance.

## Workflow

- One issue → one branch → one PR. Branch names: `<type>/<issue>-<slug>`, e.g. `feat/12-login-screen`.
- Conventional Commits: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`, `ci:`, `build:`; scope optional
  (`feat(search): …`). Reference the issue in the PR body (`Closes #12`).
- `main` is protected: no direct pushes, CI must be green, one approving review from the other developer.
- Keep PRs small enough to review in a few minutes. Split mechanical changes (codegen, renames) from logic.
- Before opening a PR: format, analyze, import check, unit/widget tests. Run integration tests when touching
  `lib/data/` or the seed.
- PR description: what and why, how it was tested, screenshots for UI changes (DE, 390 px wide).
- New domain logic comes with unit tests. New screens come with at least one widget test.

## Bumping the Tandoor version

Do it deliberately, in its own PR (`build(tandoor): bump to X.Y.Z`):

1. Change `TANDOOR_VERSION` (used by the dev compose file, CI and schema tooling).
2. `docker compose -f docker/tandoor/compose.yml up -d` and `dart run tool/fetch_schema.dart` → writes
   `packages/tandoor_api/schema/openapi-<version>.json`; delete the old one.
3. `dart run tool/generate_api.dart`, then fix compile errors. They should only appear in `lib/data/`.
4. Re-run the seed and the integration tests.
5. Re-verify `docs/TANDOOR_API.md` against the new Tandoor source (especially auth, search params, meal plan
   and shopping behavior) and note changes in the PR.
6. Update the version in `README.md`.

## Gotchas worth remembering

Details and source references are in `docs/TANDOOR_API.md`.

- The web build only works same-origin with Tandoor (Tandoor sends no CORS headers for `/api/`).
- `/api-token-auth/` is limited to 10 requests/day/IP and returns the **same** token to every device. Yumdoor
  creates its own per-device token right after login.
- Search `rating` / `lastcooked` filters count only the current user's cook logs.
- Meal plan sharing is per household; the `shared` field on meal plans is unused.
- Step text may contain Jinja-like templates (`{{ ingredients[0] }}`, `{{ scale(100) }}`).
- Shopping entries for a meal plan are built client-side, then created with `bulk_create_entries`.
- Check shopping entries off with the bulk endpoint; a PATCH without `checked` can clear the on-hand flag.

## Contributions

No outside contributions are accepted yet (CLA pending). Don't add contribution templates or bots.

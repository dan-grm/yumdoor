# Architecture

Yumdoor is a Flutter client for self-hosted [Tandoor Recipes](https://github.com/TandoorRecipes/recipes).
It ships first as a PWA served from the Tandoor host, later as native Android and iOS apps.
This document describes the structure and the rules that keep it maintainable. `CLAUDE.md` has the short
version of the rules; `docs/TANDOOR_API.md` has the verified API details.

## Goals that shape the design

1. **Tandoor API changes surface in one place.** Generated API types never leave the data layer.
2. **Platform code is isolated.** The PWA comes first, but wake lock, timers, token storage and connectivity sit
   behind interfaces so native builds can do them properly later.
3. **Domain logic is plain Dart and unit-tested.** Scaling, timer detection, step templates, shopping
   aggregation and recommendations have no Flutter or HTTP dependencies.
4. **Design is swappable.** Widgets read design tokens, never literal colors or sizes.
5. **Untrusted content stays inert.** Nothing from the server is ever injected as HTML.

## Layers

```
┌───────────────────────────────────────────────────────────────┐
│ features/*   screens, widgets, Riverpod controllers           │  Flutter
├───────────────────────────────────────────────────────────────┤
│ domain/      models, value objects, services, repository      │  pure Dart
│              interfaces (RecipeRepository, …)                 │
├───────────────────────────────────────────────────────────────┤
│ data/        repository implementations, mappers, Drift cache │  Dart + IO
│              ↓ only this layer imports package:tandoor_api    │
├───────────────────────────────────────────────────────────────┤
│ packages/tandoor_api   generated client (do not edit)         │
└───────────────────────────────────────────────────────────────┘
  platform/   interfaces + per-platform implementations, used by features and data
  design/     tokens as a ThemeExtension, used by features
```

Dependencies point downward only:

| Layer | May import | Must not import |
|---|---|---|
| `lib/features/` | `domain`, `design`, `platform` interfaces, `core`, `l10n`, Riverpod providers from `app/` | `data`, `tandoor_api`, `drift`, `dio` |
| `lib/domain/` | `core` and pure Dart packages (`freezed_annotation`, `collection`, `meta`) | Flutter, `data`, `tandoor_api`, `platform` |
| `lib/data/` | `domain`, `core`, `tandoor_api`, `drift`, `dio`, `platform` interfaces | `features` |
| `lib/platform/` | `core` | everything else |
| `packages/tandoor_api` | its own generated dependencies | anything in the app |

These rules are checked in CI by `tool/check_imports.dart` (fails the build on a forbidden import), so a Tandoor
schema change shows up as compile errors in `lib/data/mappers/` and nowhere else.

## Repository layout (target after Milestone 1)

```
lib/
  main.dart                 bootstrap: ProviderScope, platform selection
  app/                      MaterialApp.router, go_router config, top-level providers
  core/                     Result/failure types, logging, config (base href, build info)
  design/                   YumdoorTokens ThemeExtension (light/dark), built from docs/design/tokens.json
  domain/
    models/                 Recipe, Step, Ingredient, Food, Keyword, MealPlan, CookLogEntry, ShoppingEntry, …
    repositories/           abstract interfaces
    services/               scaling, step_template, timer_detection, shopping_aggregation, recommendations/
  data/
    api/                    Dio setup, auth interceptor, error mapping
    mappers/                tandoor_api DTO → domain model (the only place DTOs are read)
    repositories/           implementations of domain interfaces
    cache/                  Drift database, tables, DAOs
  platform/
    wake_lock/              WakeLockService + web/native implementations
    timers/                 TimerAlertService (sound, vibration, notification)
    token_store/            TokenStore
    connectivity/           ConnectivityService
  features/
    auth/  search/  recipe/  cooking/  settings/   (M1)
    editor/  planner/  shopping/  home/  books/  feed/   (later milestones)
  l10n/                     app_de.arb, app_en.arb
packages/
  tandoor_api/              generated Dart client + committed schema (schema/openapi-<version>.json)
docker/
  tandoor/                  docker-compose for local Tandoor 2.6.15 + Postgres
  web/                      Dockerfile and nginx config for the PWA image
tool/                       Dart scripts: fetch_schema, generate_api, seed, check_imports, gen_tokens
test/                       unit/ (domain), widget/, integration/ (against docker Tandoor)
web/                        index.html, manifest.json, icons, service worker, drift worker + sqlite3.wasm
```

## Stack

| Concern | Choice | Notes |
|---|---|---|
| Framework | Flutter stable | Web first. Build with `--no-web-resources-cdn` so CanvasKit is served from our origin, not Google's CDN. |
| State | Riverpod 3 with `riverpod_generator` | Repositories are exposed as providers, so tests override them with fakes. |
| Navigation | go_router | Deep links (`/recipe/42`, `/recipe/42/cook`) work in the PWA. |
| HTTP | Dio | Used by the generated client; one interceptor adds the token, another maps errors. |
| API client | openapi-generator `dart-dio` with built_value (pinned Docker image), output in `packages/tandoor_api` | Tandoor's own frontend uses openapi-generator on the same schema. Output is committed; CI regenerates and fails on a diff. See [API client](#api-client). |
| Domain models | `freezed` | Immutable, value equality, `copyWith`. |
| Cache | Drift (`drift/wasm.dart` on web, `sqlite3` native) | Web needs `sqlite3.wasm` and `drift_worker.js` in `web/`. |
| Markdown | `markdown` package (parse to AST) rendered to Flutter widgets | No HTML is rendered; see Security. |
| Localization | `flutter_localizations` + `intl` with ARB files, `de` and `en` | Default from the device locale, switchable in settings. |
| Fonts | Nunito bundled as an asset (SIL OFL) | The design README says "hosted font"; we bundle it instead, for offline use and to avoid third-party requests. |

## API client

`packages/tandoor_api` is generated, committed and a member of the pub workspace in the root `pubspec.yaml`, so a
fresh clone needs only `flutter pub get`.

- `tool/fetch_schema.dart` stores the local Tandoor's schema as `schema/openapi-<version>.json`, pretty-printed with
  sorted keys so a re-fetch is byte-identical.
- `tool/generate_api.dart` patches a copy of it (every read-only field optional and nullable, see
  `docs/TANDOOR_API.md#schema`), runs openapi-generator `dart-dio` from a Docker image pinned by digest, then
  build_runner and `dart format`. Running it twice produces no diff.
- The package's `pubspec.yaml` and `README.md` are written by hand (`.openapi-generator-ignore`); its dependencies
  are pinned like the app's.

**Decision (spike for #5, generator 7.26.0, Tandoor 2.6.15): `dart-dio` with its default built_value serialization.**

| Option | Result |
|---|---|
| `dart-dio` + built_value | Compiles as generated (4 lint warnings in generated code, excluded from analysis). Nullable `allOf` refs become nullable fields; enums get a fallback value with `enumUnknownDefaultCase`; unknown keys are ignored. The 6 `oneOf` blank-able URL/email fields become `OneOf` wrappers. |
| `dart-dio` + json_serializable | Does not compile without workarounds: the generated `pubspec.yaml` sets a language version too old for the null-aware map entries json_serializable emits, the 6 `oneOf` fields become empty classes that fail to parse, and a list default (`AutoMealPlan.keywords = []`) is not const. Would need schema patches on top. |
| `swagger_parser` | Not evaluated: the issue makes it the fallback if `dart-dio` fails, and the built_value variant did not. |

built_value's builders and `BuiltList` are more verbose than plain classes, but only the mappers in `lib/data/`
see them. The read-only patch is needed with any generator: both serializers enforce `required`, and Tandoor's schema
over-declares it.

## Authentication and session

1. The login screen asks for the server URL (default: the PWA's own origin, derived from the base href) and
   calls `GET /api/server-settings/current/` to check that it is Tandoor 2.x and show its version.
2. The user enters username and password, or pastes an API token.
   - Password: `POST /api-token-auth/` returns a token. Yumdoor immediately uses it to create a **device token**
     (`POST /api/access-token/`, scope `read write`) and keeps only the device token. Credentials are never stored.
   - Pasted token: used as is.
3. The token goes into `TokenStore`:
   - native: `flutter_secure_storage` (Keychain / Keystore).
   - web: IndexedDB via the same package. **There is no real secure storage in a browser**; any script on the
     origin can read it. Because the PWA shares its origin with Tandoor, a stored-XSS bug in Tandoor's own UI
     could read our token, just as it could already act with the user's Tandoor session. This risk is accepted
     and documented in the settings screen's About section.
4. Logout deletes the device token on the server (`DELETE /api/access-token/{id}/`) when online, then clears the
   `TokenStore` and the Drift database. If the token was pasted, Yumdoor does not delete it on the server.
5. A 401 anywhere ends the session and returns to login with the server URL prefilled.

## Server URL and deployment

The PWA is deployed **same-origin** with Tandoor, e.g. `https://tandoor.example.com/app/`. That is not just
convenient: Tandoor sends CORS headers only for the bookmarklet endpoint, so a browser cannot call another
origin's Tandoor API. The login screen therefore offers a different server URL only on native builds; on web it
shows the origin and explains the constraint.

- Base path is a runtime setting of the Docker image (`BASE_PATH=/app/`). The build uses a placeholder base href
  that the container entrypoint rewrites in `index.html`, `manifest.json` and the service worker scope.
- nginx serves the SPA with a fallback to `index.html` for unknown paths under the base path.
- Flutter web does not content-hash its main files (`main.dart.js`, `flutter_bootstrap.js`), so caching is:
  `index.html`, `flutter_bootstrap.js`, `main.dart.js`, `version.json`, `manifest.json` and the service worker are
  served with `Cache-Control: no-cache` (revalidate with ETag). Icons and fonts get a long `max-age`.
- Service worker: Flutter has deprecated its generated service worker, so we ship our own small one in `web/`. It
  precaches the app shell for offline start and versions its cache by the build's `version.json`. API requests
  are never cached by the service worker; offline data lives in Drift.
- Local development has the same constraint. `flutter run -d chrome` serves on its own port (8081), so dev
  requests to Tandoor's paths (`/api/`, `/api-token-auth/`, `/openapi/`, `/media/`) are proxied to the local
  Tandoor by Flutter's `web_dev_config.yaml` proxy rules (Flutter 3.35+).

## Offline cache

- Read-only offline: recipes the user has opened and recipes in the visible meal plan are stored in Drift.
- Stored as domain models serialized to JSON in a `cached_recipe` table (id, updatedAt, json, lastOpenedAt), plus
  images as bytes in `cached_image`. Simple, and a domain model change only needs a cache version bump that drops
  old rows. No need to mirror Tandoor's relational schema.
- Repositories are network-first with cache fallback for recipe detail and the meal plan; search is online only
  (offline search works over cached recipes by name, and says so).
- `ConnectivityService` plus failed requests drive an `isOffline` provider. When offline, a banner is shown and
  write actions are disabled (not hidden), with a tooltip explaining why. No writes are queued.
- Logout and switching servers clear the database. Cache size is capped (LRU by `lastOpenedAt`).

## Platform abstraction

Each service is an abstract class in `lib/platform/<name>/` with implementations selected at startup
(conditional imports for web vs. IO). Features only see the interface through a provider.

| Service | Web (now) | Native (later) |
|---|---|---|
| `WakeLockService` | Screen Wake Lock API, reacquired on `visibilitychange`. Reports `unsupported` where missing; cooking mode then shows a hint to keep the screen on. iOS home-screen PWAs had a WebKit bug here (fixed in 18.4 according to WebKit's notes; verify on device). | `wakelock_plus` |
| `TimerAlertService` | Timers store their end time, not a countdown, so they survive the tab being suspended; they are recomputed on resume. Alert by sound + vibration (where available) when visible; `Notification` when permitted. Background alerts on iOS PWAs are not possible; the UI says so once. | Local notifications scheduled at start |
| `TokenStore` | IndexedDB (see Authentication) | Keychain / Keystore |
| `ConnectivityService` | `navigator.onLine` + request failures | `connectivity_plus` + request failures |

## Domain services

- **Scaling:** `factor = chosenServings / recipe.servings`. Ingredient amounts are scaled and formatted with
  sensible rounding (fractions for small amounts, no `0.333333`). `no_amount` and header ingredients are untouched.
  Servings are chosen on the recipe screen and passed to cooking mode as a read-only value.
- **Step templates:** a small parser for Tandoor's `{{ ingredients[n](.amount|.unit|.food|.note) }}` and
  `{{ scale(x) }}`, producing text spans with scaled values. It never evaluates code; anything else is left as text.
- **Timer detection:** finds durations in step text in German and English ("10 Minuten", "1½ Stunden",
  "5-7 min", "1 hour 20 minutes", "über Nacht" is ignored). Returns spans with a duration so the text can be
  highlighted (butter token) and tapped to start a timer. `Step.time` adds an explicit timer.
- **Shopping aggregation:** builds entries for one or more meal plans (scaled, minus on-hand and ignored foods),
  and groups existing entries by supermarket category and store order, merging amounts per food and unit.
- **Recommendations:** see below.

## Recommendations

```dart
abstract interface class RecommendationProvider {
  String get id;
  Future<List<Recommendation>> recommend(RecommendationContext context, {int limit = 10});
}

class Recommendation {
  final RecipeSummary recipe;
  final double score;               // 0..1, only comparable within one provider
  final List<RecommendationReason> reasons; // rendered by the UI, localized
}

sealed class RecommendationReason { … }   // highlyRated, notCookedSince(date), inSeason(keyword),
                                          // cookedRecentlyBy(user), similarTo(recipe), freeText(String)
```

- `RecommendationContext` carries the date, the user, the current meal plan and an optional free-text wish.
- The first implementation, `RuleBasedRecommendationProvider`, works on data from repositories: own ratings
  (search with `rating_gte`), last cooked (`cookedon_lte`), seasonal keywords (a configurable month → keyword
  mapping), recent cook logs by other people, and Jaccard similarity over foods and keywords of recently cooked
  recipes.
- "Cooked recently by household members" cannot be exact: normal users cannot list their household. The rule
  provider uses cook logs from **everyone in the space** and labels them by name ("Anna hat das letzte Woche
  gekocht"). If the user is a space admin, it narrows this to the household.
- An LLM provider later implements the same interface (OpenAI-compatible endpoint, URL and key in settings) and
  returns `freeText` reasons. The UI does not change.

## Security

- Recipe content is untrusted. Markdown is parsed to an AST and rendered to Flutter widgets; raw HTML nodes are
  shown as text. Server-rendered HTML fields (`instructions_markdown`, `note_markdown`) are ignored.
- Links in markdown open only `http`/`https` URLs, in a new tab or the system browser, after showing the host.
- Images load only from the configured server origin or `http(s)` URLs through `Image.network`; no `HtmlElementView`
  or `dart:js_interop` DOM injection with server data.
- No analytics, no crash reporting services, no third-party requests at runtime (CanvasKit and fonts are
  self-hosted).
- Tests never run against a production instance. The integration test harness refuses to run unless the server
  URL is `localhost` or the CI service name.

## Localization

ARB files in `lib/l10n/`, German first (the design's voice: short, friendly, du-form). Every user-visible string
goes through `AppLocalizations`. Units stay metric; numbers and dates use the active locale. Layouts are tested
with German strings at 390 px width.

## Design tokens

`docs/design/tokens.json` is the source. `tool/gen_tokens.dart` generates `lib/design/tokens.g.dart`:
a `YumdoorTokens` `ThemeExtension` with a light and dark instance (colors, text styles, spacing, radii, sizes,
shadow). `ThemeData` is built from it once. Widgets use `context.tokens.sage`, `context.tokens.spaceL` etc.
A redesign replaces `tokens.json` (and possibly component widgets in `lib/design/components/`), not feature code.

## Testing

| Kind | Where | Runs against |
|---|---|---|
| Unit | `test/unit/` | Domain services, mappers (with recorded JSON fixtures from the seeded Tandoor) |
| Widget | `test/widget/` | Key screens with fake repositories via provider overrides; golden tests for cooking mode in DE at 390 px |
| Integration | `test/integration/` | Repositories against the dockerized Tandoor 2.6.15 with seed data (`flutter test --tags integration`, Dart VM, no browser, so no CORS) |

UI end-to-end tests in a browser are not part of M1.

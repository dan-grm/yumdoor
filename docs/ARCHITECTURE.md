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
    models/                 Recipe, Step, Ingredient, Food, Keyword, MealPlan, CookLog, ShoppingEntry, …
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
tool/                       Dart scripts: fetch_schema, generate_api, seed, record_fixtures, check_imports, gen_tokens
test/                       unit/ (domain), widget/, integration/ (against docker Tandoor)
web/                        index.html, manifest.json, icons, service worker, drift worker + sqlite3.wasm
```

## Stack

| Concern | Choice | Notes |
|---|---|---|
| Framework | Flutter stable | Web first. Build with `--no-web-resources-cdn` so CanvasKit is served from our origin, not Google's CDN. |
| State | Riverpod 3 with `riverpod_generator` | Repositories are exposed as providers, so tests override them with fakes. |
| Navigation | go_router | Deep links (`/recipe/42`, `/recipe/42/cook`, `/plan`) work in the PWA. The tabs (`/` for the start screen, `/search`, `/plan`, `/shopping`) are a `StatefulShellRoute` in `AppShell` (bottom bar, rail on wide layouts), one navigator each; recipe, cooking mode, cook log and editor are routes above it and cover the whole screen. Sheets opened from a tab use the root navigator so they cover the bar. Back follows this hierarchy, not the order screens were seen in: on the web, `AppBinding` (`lib/platform/browser_history/`) keeps a single browser history entry, so the browser's back (and the edge swipe in the installed app) reaches the app as a system back, like Android's. A screen opened from a link with nothing below it goes up on back (`UpScope`); on the first screen, back goes to the page before the app, if any (`BrowserHistory.leaveApp`). The browser's forward button has nothing to go to. |
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
   calls `GET /api/server-settings/current/` to check that it is Tandoor 2.x and show its version. On the web, a
   server on another origin is explained instead of requested (the browser would block it silently).
2. The user enters username and password, or pastes an API token.
   - Password: `POST /api-token-auth/` returns a token. Yumdoor immediately uses it to create a **device token**
     (`POST /api/access-token/`, scope `read write`) and keeps only the device token. Credentials are never stored.
   - Pasted token: checked with `GET /api/user-preference/`, then used as is.
   - `AuthRepository` (`lib/data/repositories/tandoor_auth_repository.dart`) talks to the server;
     `SessionController` (`lib/app/session.dart`) keeps the session in `TokenStore`, and the router sends everyone
     without a session to `/login`. Starting the app reads the stored session without a request, so it starts
     offline too.
3. The token goes into `TokenStore`:
   - native: `flutter_secure_storage` (Keychain / Keystore).
   - web: `localStorage` via the same package (AES-GCM encrypted, but the key is stored next to it, so this is
     obfuscation, not protection). **There is no real secure storage in a browser**; any script on the
     origin can read it. Because the PWA shares its origin with Tandoor, a stored-XSS bug in Tandoor's own UI
     could read our token, just as it could already act with the user's Tandoor session. This risk is accepted
     and documented in the settings screen's About section.
4. Logout deletes the device token on the server (`DELETE /api/access-token/{id}/`) when online, then clears the
   `TokenStore` and the Drift database. If the token was pasted, Yumdoor does not delete it on the server.
5. A 401 or 403 anywhere (`UnauthorizedFailure`; Tandoor answers an invalid token with 403) makes Yumdoor check
   the token once; if the server rejects it too, the session ends and login opens with the server URL prefilled.
   Tandoor also answers a missing permission with 403, so one rejected request alone doesn't log out.
6. On the web, unsafe requests carry Django's CSRF token from the `csrftoken` cookie, because a Tandoor session in
   the same browser otherwise makes them fail (docs/TANDOOR_API.md#authentication).

## Server URL and deployment

The PWA is deployed **same-origin** with Tandoor, e.g. `https://tandoor.example.com/app/`. That is not just
convenient: Tandoor sends CORS headers only for the bookmarklet endpoint, so a browser cannot call another
origin's Tandoor API. The login screen therefore offers a different server URL only on native builds; on web it
shows the origin and explains the constraint.

- Base path is a runtime setting of the Docker image (`BASE_PATH=/app/`, `docker/web/`). The build uses the
  placeholder base href `/__BASE_PATH__/`; the container entrypoint writes `index.html` with the real one (to `/tmp`,
  so the image runs read-only). `manifest.json` and the service worker use URLs relative to the base href, so they
  need no rewrite: the worker's scope is the base path.
- nginx serves the SPA with a fallback to `index.html` for unknown paths under the base path; missing files (with
  an extension) are a 404. Everything outside the base path is a 404 too: it belongs to Tandoor's side of the proxy.
- Flutter web does not content-hash its file names (`main.dart.js`, `flutter_bootstrap.js`, `canvaskit/`), so
  everything is served with `Cache-Control: no-cache` (revalidate with ETag), fonts included, except the app icons
  copied from `web/` (`icons/`, `favicon.png`), which get a 30-day `max-age`. The build tree-shakes
  `MaterialIcons-Regular.otf` to the icons the app uses, so it changes under the same URL whenever an icon is added;
  a 30-day `max-age` on fonts once left new icons blank in installed apps (#162).
- Security headers: a CSP with `'wasm-unsafe-eval'` but no `'unsafe-eval'` and `'self'` only,
  `X-Content-Type-Options: nosniff`, `Referrer-Policy: same-origin`.
- `tool/finish_web_build.dart` runs after `flutter build web`: it removes renderer files our dart2js + CanvasKit
  build never loads (skwasm, wimp, webparagraph, `.symbols`), which halves the image, and stamps the service worker.
- Service worker: Flutter has deprecated its generated service worker, so `web/flutter_bootstrap.js` registers our
  own `web/service_worker.js`. It precaches the app shell (every file except the CanvasKit variants; the page
  reports the variant it loaded after the first frame) and serves it network first, fetching with
  `cache: 'no-cache'` so the browser's HTTP cache can't answer with an older file; a new deploy is used as soon as
  the server is reachable. Its cache is named after the build (`version.json` plus a hash of all files); a new
  build installs a new worker, which deletes the old cache. It handles only files of the build and navigations under
  its scope; API requests and media are never touched, and offline data lives in Drift.
- Local development has the same constraint. `flutter run -d chrome` serves on its own port (8081), so dev
  requests to Tandoor's paths (`/api/`, `/api-token-auth/`, `/openapi/`, `/media/`) are proxied to the local
  Tandoor by Flutter's `web_dev_config.yaml` proxy rules (Flutter 3.35+).

## Offline cache

- Read-only offline, except for checking shopping list entries off (below): recipes the user has opened (and, from M4, the recipes of the meal plans the planner shows), the
  plans of the weeks the planner showed and the last loaded shopping list are stored in Drift (`lib/data/cache/`).
- Stored as domain models serialized to JSON (`Recipe.fromJson`/`toJson`) in a `cached_recipe` table (id, name,
  imageUrl, updatedAt, json, lastOpenedAt), plus images as bytes in `cached_image`. Simple, and a domain model change
  only needs a bump of `CacheDatabase.schemaVersion`; any version change (up or down) drops all rows. No need to
  mirror Tandoor's relational schema. A row that no longer decodes is dropped instead of failing.
- `CachingRecipeRepository` wraps the Tandoor repository: network first, cache fallback on `OfflineFailure` for
  recipe detail; every fetched recipe is written through, and its image is downloaded in the background (without
  the token, at most 5 MB). A `NotFoundFailure` removes the recipe from the cache. Search is online only; offline,
  page 1 falls back to the cached recipes (the text against name, ingredient foods and keywords, plus exact
  food/keyword/rating filters without child foods) and `ResultPage.fromCache` makes the UI say so. The universal
  search then uses that one result instead of its separate food and keyword searches.
- Meal plans (M4): `CachingMealPlanRepository` stores each list it reads (`cached_meal_plans`, the `MealPlan`s as JSON
  by first and last day; the 26 most recently read ranges, so the current week and the ones visited). Offline, the same
  days come from the cache with `MealPlanList.cachedAt`, and the planner says "Offline · Stand vom …" above the week
  and reads it again once the server answers (or after 15 s when only a request timed out; the cached week is read-only
  either way); a week never loaded shows the offline failure. After each list from the
  server, the recipes of plans that aren't over yet are stored one after another in the background with their images
  (`CachingRecipeRepository.keepOffline`, skipped without counting as opened when the stored copy has the same
  `updatedAt`); past weeks store none, so browsing them doesn't push opened recipes out of the cache. Plans change only online; the planner reads the week again
  after each change, which stores it anew.
- Shopping list (M4): `CachingShoppingRepository` keeps the list the server last reported: entries as rows of their own
  (`cached_shopping_entry`, `ShoppingEntry` JSON with their position), `syncedAt`, `truncated` and when it was stored in
  `cached_value`, like the supermarkets. Full reads replace it, incremental reads are merged into it, and check-offs,
  added items and deletions are applied once the server accepted them; recipes added to the list come with the next
  read. A read that answers late can't undo that: a full read older than the stored one is dropped, and no read touches
  entries changed on the device, or stored from a newer read, after it started; `syncedAt` never goes back. Offline, a full read answers from it (`ShoppingListSnapshot.cachedAt`, "Offline · Stand vom …" on the list);
  an incremental read fails, pull to refresh on a list already shown says the server can't be reached, and the first
  poll once the server answers reads the list in full. The cache
  holds only what the server has; the offline check-off queue lives in a table of its own and is shown on top of it.
- The caching repositories note `CacheDatabase.clears` when their session starts and store nothing once logout
  cleared the cache, so a request that ends late (or starts before the session's repositories are gone) can't bring
  back the previous user's recipes, saved searches, plans or list. A list shown from the cache is read-only even when
  the app doesn't count as offline (a request that timed out).
- `ConnectivityService` plus requests drive the `isOffline` provider (`lib/app/offline.dart`): a request that can't
  connect sets it, any answer from the server (errors included) or the network coming back clears it. When offline,
  a banner is shown on every screen (`MaterialApp.builder`) and write actions are disabled (not hidden) through
  `OfflineDisabled`, with a tooltip explaining why. No writes are queued, except shopping check-offs (below).
- Shopping list check-offs (`ShoppingList` in `lib/features/shopping/shopping_providers.dart`) are optimistic: the
  check state set on the device is shown over the list read from the server and sent to Tandoor at once (not after
  the undo snackbar), one request after another so an undo can't overtake its check-off. It stays on top until a
  read that started after it was saved; a failure takes it back.
- Checking off (and back on) is the one write that works offline (decided for M4, #116). Offline, on a list from
  the cache, or when sending fails with `OfflineFailure`, the state goes into the `ShoppingCheckQueue`
  (`pending_shopping_check`: per server and entry id the wanted `checked` and when it was set, `ShoppingCheckCache`) instead of
  being taken back. It survives a reload or restart, and a cache version change keeps its table like the drafts'.
  Setting an entry again replaces its pending state, and going back to what the server has (or will have from what
  was already sent) takes it off the queue, so ticking and unticking offline sends nothing. Queued rows show "wird
  synchronisiert" and a line above the list counts them. The queue is sent when `isOffline` clears (network back or
  any answer from the server) and after every read of the list the server answered, as one bulk request per wanted
  state, after the changes sent before it (one failing doesn't hold back the other). Entries deleted on the server
  meanwhile are ignored by the bulk endpoint and dropped from the queue. A failure, a rejected token (403) included,
  keeps the queue for the next try. An online
  tick on a queued entry is sent at once and replaces its pending state. After a restart with a non-empty queue the
  app shell loads the list in the background, so the queue goes out even if the list isn't opened.
- Conflicts: the last check state sent wins. A check-off queued offline is sent even if someone else in the
  household changed the same entry meanwhile, as the bulk endpoint has no condition; their change is overwritten.
- Logout asks before it drops unsent check-offs ("Abmelden?"), then clears the queue with the rest of the database.
  A session that ends because the token was rejected (`SessionController.checkToken`) keeps the queue: each row
  carries the server it belongs to, and only a session on the same server reads (and sends) them; another server's
  session deletes them. Whoever logs in there next can only tick entries of their own household (the bulk endpoint
  ignores other ids), so at worst a household member's ticks are sent by another member. Coming back from an app
  version that didn't know the queue (a rollback) drops it, since that version's logout left it behind.
- The recipe editor keeps unsaved changes as drafts in the same database (`editor_draft`, `DraftStore`): one per
  recipe and one for a new recipe, the `RecipeDraft` as JSON plus a chosen photo's bytes, written a second after the
  last change and when the editor closes or the app is hidden. Reopening the editor offers a draft that differs from
  the recipe (and says if the recipe changed on the server after it); saving or discarding deletes it. Drafts can't
  be fetched again, so a cache version change keeps their table (changing it needs a real migration). Offline,
  editing and drafts go on; saving waits until the app is online. Leaving the editor with changes asks first
  (`GoRoute.onExit`, so back, "Abbrechen" and any other navigation), and `UnloadGuard` makes the browser ask
  before the tab is closed or reloaded.
- Logout (and so switching servers or users) clears the database, drafts and unsent check-offs included. Cache size is capped at 100 recipes (LRU by
  `lastOpenedAt`); images no cached recipe uses are dropped with them.
- The seasonal keyword mapping (month → keyword ids, `SeasonalKeywordStore`) lives in the `LocalStore`, keyed by
  server URL and user id, and empty by default. Logout keeps it: it is a preference, not cached server content, and
  is there again when the same account logs in. Ids of keywords deleted on the server are dropped when the mapping
  is read against the keyword list (`SeasonalKeywords.retainKeywords`), not on save. Reading it needs the user id,
  so it is unavailable until that has been fetched once in the session.
- Starting the PWA offline also needs the app shell from the service worker (#17); the data side doesn't depend on it.
- Web: `web/drift_worker.js` and `web/sqlite3.wasm` are vendored and must match `pubspec.lock`. After bumping
  `drift` or `sqlite3`, replace them from the releases:
  `gh release download drift-<drift> -R simolus3/drift -p drift_worker.js` and
  `gh release download sqlite3-<sqlite3> -R simolus3/sqlite3.dart -p sqlite3.wasm`.

## Platform abstraction

Each service is an abstract class in `lib/platform/<name>/` with implementations selected at startup
(conditional imports for web vs. IO). Features only see the interface through a provider.

| Service | Web (now) | Native (later) |
|---|---|---|
| `WakeLockService` | Screen Wake Lock API, reacquired on `visibilitychange`. Reports `unsupported` where missing; cooking mode then shows a hint to keep the screen on. iOS home-screen PWAs had a WebKit bug here (fixed in 18.4 according to WebKit's notes; verify on device). | `wakelock_plus` |
| `TimerAlertService` | Timers store their end time, not a countdown, so they survive the tab being suspended; they are recomputed on resume. A chime generated with Web Audio (no audio file) + `navigator.vibrate` where available; a `Notification` while the app is hidden, through the service worker (required on Android Chrome; clicking it focuses the app). Permission is asked when the first timer starts. The service reports its capabilities: background alerts work only in desktop browsers (iOS suspends hidden PWAs and tabs, Android's Chrome freezes them), and the UI says so once. The fallback logic is plain Dart over an `AlertChannels` interface, unit-tested with a fake. | Local notifications scheduled at start |
| `TokenStore` | `flutter_secure_storage`: `localStorage`, not secure (see Authentication) | Keychain / Keystore |
| `ConnectivityService` | `navigator.onLine` + request failures | `connectivity_plus` + request failures |
| `LinkOpener` | A temporary `<a target="_blank" rel="noopener noreferrer">`, clicked | `url_launcher` (system browser) |
| `LocalStore` | `localStorage`, keys prefixed `yumdoor.state.` (the token store uses `yumdoor.` too); small non-sensitive state such as ticked-off ingredients | `shared_preferences` |
| `UnloadGuard` | A `beforeunload` listener that cancels the event while the editor has unsaved changes, so the browser asks before closing or reloading the tab (its own text) | Nothing to ask; the draft is kept |
| `ImagePickerService` | A hidden `<input type="file">` (with `capture="environment"` for the camera, offered on touch devices); the window is a drop target (`dragover`/`drop`) while the editor listens. Files are checked by content (JPEG, PNG, WebP, GIF) and size (`maxImageBytes`) before the UI sees them; rejections are typed. | `image_picker` + `desktop_drop` |

## Domain services

- **Scaling:** `factor = chosenServings / recipe.servings`. Ingredient amounts are scaled and formatted with
  sensible rounding (fractions for small amounts, no `0.333333`). `no_amount` and header ingredients are untouched.
  Servings are chosen on the recipe screen and passed to cooking mode as a read-only value.
- **Step templates:** a small parser for Tandoor's `{{ ingredients[n](.amount|.unit|.food|.note) }}` and
  `{{ scale(x) }}`, producing text spans with scaled values. It never evaluates code; anything else is left as text.
- **Timer detection:** finds durations in step text in German and English ("10 Minuten", "1½ Stunden",
  "5-7 min", "1 hour 20 minutes", "über Nacht" is ignored). Returns spans with a duration (a range's upper
  bound) so the text can be highlighted (butter token) and tapped to start a timer, in cooking mode only.
  The "Timer starten" button below a step uses `Step.time`, or else the first detected duration.
- **Shopping aggregation:** builds entries for one or more meal plans (scaled, minus on-hand and ignored foods),
  and groups existing entries by supermarket category and store order, merging amounts per food and unit.
- **Recommendations:** see below.

## Recommendations

```dart
abstract interface class RecommendationProvider {   // domain/services/recommendation_provider.dart
  String get id;
  Future<List<Recommendation>> recommend(RecommendationContext context, {int limit = 10});
}

class Recommendation {                    // domain/models/recommendation.dart (freezed)
  final RecipeSummary recipe;
  final double score;                       // 0..1, only comparable within one provider
  final List<RecommendationReason> reasons; // rendered by the UI, localized
}

sealed class RecommendationReason { … }   // highlyRated(rating), notCookedSince(date), inSeason(keyword),
                                          // cookedRecentlyBy(user, date), similarTo(recipe), freeText(text)
```

- `RecommendationContext` carries the day (`CalendarDay`), the current user's id, this week's meal plans and an
  optional free-text wish.
- `SeasonalKeywords` is the user's month (1–12) → keyword ids mapping, empty by default (nothing is hardcoded). It
  keeps ids only, so renamed keywords stay mapped; ids of deleted keywords are dropped with `retainKeywords`.
  `SeasonalKeywordStore` loads and saves it on the device.
- The first implementation, `RuleBasedRecommendationProvider` (`domain/services/`), works on the repositories:
  - **Highly rated, not cooked for a while:** own rating ≥ 4 and not cooked in the last 21 days (search with
    `rating_gte`, `cookedon_lte`, by rating); the last-cooked date for the reason comes from the cook log.
  - **In season:** recipes with a keyword mapped to the current month (one `keywords_or` search per keyword).
  - **Cooked recently by others:** cook log entries of other people in the last 14 days (`CookLogRepository.recent`),
    one reason per person, labelled by name.
  - **Similar to recently cooked:** Jaccard index ≥ 0.2 over foods and keywords against the user's last 3 cooked
    recipes. Candidates come from `foods_or`/`keywords_or` searches (50 each, by the user's rating); search results
    carry no ingredients, so the 8 best by keywords are loaded with `fetchRecipe(opened: false)`, which neither
    stores them in the offline cache nor looks up their last-cooked date.
  - The cook log is read once (`recent`, the newest 100 entries of the last 6 weeks) for other people's cooking,
    the user's own recent cooking and the similarity sources; in a very active space older entries are missed.
  - Each rule scores a recipe 0–1; a recipe found by several rules gets all their reasons, strongest first, and the
    score `1 − Π(1 − sᵢ)`. Equal scores are ordered by a hash of recipe and day, so the list is stable within a day.
    Recipes planned this week and recipes the user cooked in the last 7 days are left out (the latter only when
    the cook log could be read).
  - The rules run in parallel, each with at most 4 requests at once. A failing rule is left out; `recommend` throws
    only if every rule fails, or if nothing is left and one failed. Results from the offline cache count as offline.
- "Cooked recently by household members" cannot be exact: normal users cannot list their household. The rule
  provider uses cook logs from **everyone in the space** and labels them by name ("Anna hat das letzte Woche
  gekocht"), for space admins too: no narrowing to the household (decided 2026-11-26).
- **Start screen:** "Vorschläge für dich" shows the first 10 suggestions as cards (image, name, first reason);
  "Mehr" opens `/recommendations` with all 20 and every reason. `recommendationsProvider(day)` (keepAlive, by day)
  computes them once per day, shared by both screens; pull to refresh invalidates it. Reasons are worded from the
  sealed type in `features/recommendations/reason_text.dart` (ratings and "not cooked since" share one line).
  Offline the section is replaced by one line saying suggestions need the server. Without a seasonal mapping a
  dismissible hint (kept on the device) links to the settings section (`/settings?section=seasonal`).
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
| Unit | `test/unit/` | Domain services, mappers (with JSON fixtures recorded from the seeded Tandoor by `tool/record_fixtures.dart`) |
| Widget | `test/widget/` | Key screens with fake repositories via provider overrides; golden tests for cooking mode in DE at 390 px |
| Integration | `test/integration/` | Repositories against the dockerized Tandoor 2.6.15 with seed data (`flutter test --tags integration`, Dart VM, no browser, so no CORS) |

UI end-to-end tests in a browser are not part of M1.

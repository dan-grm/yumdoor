# Roadmap

Milestones follow the feature priority. Each milestone is a GitHub milestone; each bullet becomes one or more
issues, each issue one PR. Scope inside a milestone can move; the order of milestones only changes by agreement.

Pinned Tandoor version: **2.6.15**.

## M1 — Walking skeleton

An end-to-end slice through every layer, deployable as a PWA.

- Repo foundation: Flutter app scaffold, lints, `.gitattributes`, layer import check
- Local Tandoor 2.6.15 via Docker Compose, plus a dev proxy so the web app is same-origin
- Seed script with synthetic data (DE/EN recipes, carrots in several, keywords, ratings, cook logs, books,
  two users in one household, shared meal plans, shopping entries)
- Committed OpenAPI schema and generated `tandoor_api` package, reproducible via `tool/`
- Design tokens → `YumdoorTokens` ThemeExtension (light/dark), bundled Nunito
- DE/EN localization wired up
- Platform abstractions: `TokenStore`, `WakeLockService`, `ConnectivityService` (web implementations)
- Login: server URL + version check, password → device token, or pasted token; logout
- Search screen with food and keyword filter chips
- Recipe detail with servings picker and scaled ingredients
- Basic cooking mode: step by step, per-step ingredients, scaled amounts, read-only servings, wake lock
- Offline cache of viewed recipes (Drift, read-only), offline banner, write actions disabled
- CI: format, analyze, import check, unit/widget tests, integration tests against Tandoor in Docker, web build
- Docker image (nginx, configurable base path, SPA fallback, caching headers, own service worker) pushed to GHCR

## M2 — Cooking mode and search, complete

- Step templates (`{{ ingredients[0] }}`, `{{ scale(…) }}`) rendered and scaled
- Timer detection in step text (DE/EN) with tap-to-start, plus `Step.time` and manual timers
- Multiple concurrent timers, end-time based, alerts with graceful fallbacks; `TimerAlertService`
- Tick-off ingredients, step dots, landscape/tablet layout (steps and ingredients side by side)
- "Fertig gekocht": create a CookLog entry with rating and comment. No photo: CookLog has no image field, and
  the photo in mockup 08 is dropped rather than worked around (decided 2026-10-24)
- Universal search: the default search bar matches recipe names, ingredients and keywords at once. Tandoor's
  `query` matches only names under the default `SearchPreference`, and Yumdoor doesn't change the user's
  preference, so the client looks up matching foods and keywords (`/api/food/?query=`, `/api/keyword/?query=`),
  runs the name, `foods_or` and `keywords_or` searches, and merges them page by page (name matches first, no
  duplicates). Results say why they matched; filter chips still narrow every part of the search
- Full search filters as first-class chips: rating, last cooked, times cooked, "cookable now" (on hand),
  books, created by, sort order; saved filters (Tandoor `CustomFilter`)
- Safe markdown renderer for descriptions and steps

## M3 — Recipe editing

- Create and edit recipes: general data, keywords, steps (reorder, per-step ingredients, explicit duration)
- Ingredient entry with Tandoor's ingredient parser (`/api/ingredient-parser/`), food/unit autocomplete and create
- Image upload (camera on phones, file/drag-drop on desktop)
- Desktop-friendly editor: keyboard navigation, unsaved-changes guard, autosave of drafts locally
- Delete recipe with confirmation

## M4 — Meal planning and shopping list

- Week planner: days × meal types, drag and drop of recipes onto days, servings per meal
- Plan sheet from the recipe screen ("Einplanen")
- Household view: plans of everyone in the household (Tandoor shares meal plans per household)
- "Add the week to the shopping list": client-side entries, respects on-hand and ignore-shopping, skips meals
  already on the list
- Shopping list grouped by supermarket category in store order, merged amounts, source recipes, fast check-off
  with the bulk endpoint, on-hand toggle
- Incremental sync of the list (`updated_after`) while the screen is open

## M5 — Recommendations and home

- `RecommendationProvider` interface and `RuleBasedRecommendationProvider`
- Home screen: today's plan, recommendations with reasons, recent activity teaser
- Settings for seasonal keyword mapping

## M6 — Cookbooks

- Browse own and shared recipe books, dynamic books (saved filter), add/remove recipes, create/edit books

## M7 — Social feed

- Newsfeed of the space's cook logs (ratings, comments), newest first, per-recipe history on the recipe screen
- Create, edit and delete own cook log entries

## Later

- Native Android build, iOS via AltStore (native platform implementations, own server URL on native)
- LLM recommendation provider (OpenAI-compatible endpoint)
- Named shopping lists, multiple spaces, unit conversion display
- Donation link

## Out of scope for now

Native store builds, push notifications, LLM provider, recipe import from URLs or social media.

## Open decisions

- **Household activity for recommendations.** Normal users cannot list household members. M5 uses everyone in the
  space unless the user is admin; revisit if Tandoor exposes household members.
- **Licensing for outside contributions.** No outside PRs until a CLA is chosen (possible App Store dual license).
  See `CONTRIBUTING.md`.
- **Tandoor auth changes.** Tandoor is working on new frontend auth (`feature-frontend-auth` branch). Recheck token
  login when bumping the pinned version.

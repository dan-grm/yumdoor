# Tandoor API notes (verified against 2.6.15)

What Yumdoor relies on in the Tandoor API, checked against the source at tag
[`2.6.15`](https://github.com/TandoorRecipes/recipes/tree/2.6.15) (commit `7e1c427`).
Paths below are relative to the Tandoor repo. When the pinned version is bumped, re-check
every section and update this file in the same PR.

## Schema

- `GET /openapi/` serves the schema (drf-spectacular, `cookbook/urls.py:128`). It is **not** under `/api/`.
  YAML by default; `?format=json` for JSON. No authentication needed (spectacular's default `SERVE_PERMISSIONS`).
- Tandoor does not commit a schema. Its own Vue client (`vue3/src/openapi/`) is generated with
  openapi-generator from this endpoint, so that generator is known to handle the schema.
- A custom post-processing hook (`cookbook/helper/drf_spectacular_hooks.py`) makes **every `id` field optional
  and writable** so nested writes work. In generated Dart code every `id` is nullable; the mappers in
  `lib/data/` turn that into non-null ids on domain models.
- **Read-only fields are declared required and non-null, but often aren't.** drf-spectacular marks every read-only
  field required. Against the seeded 2.6.15, Tandoor sends `null` for `Food.parent` and `Keyword.parent` (root
  nodes), `MealPlan.recipe_name` (plan without a recipe) and `User.display_name`, and leaves out
  `RecipeOverview.recent` unless `num_recent` is set (it is a queryset annotation, `cookbook/helper/recipe_search.py`;
  DRF skips a read-only field whose attribute is missing). 138 read-only fields are affected, so
  `tool/generate_api.dart` makes **every read-only field optional and nullable** before generating. The committed
  schema stays as fetched.
- The schema models auth as an API key in the `Authorization` header (`ApiKeyAuth`), so the generated client
  takes the whole header value: `setApiKey('ApiKeyAuth', 'Bearer <token>')`.
- Blank-able Django URL and email fields are `oneOf: [uri/email string, empty string]` (6 fields, e.g.
  `ConnectorConfig.url`, `InviteLink.email`). `dart-dio` with built_value wraps them in a `OneOf` class.
- `makenow` on the recipe search is a boolean in the schema, although the server also accepts an int (number of
  allowed missing foods). The generated client can only send `true`/`false`.

## Authentication

- Auth classes: Django session and OAuth2 bearer token (`recipes/settings.py:396`). Header: `Authorization: Bearer <token>`.
- `POST /api-token-auth/` with `username` and `password` (form or JSON) returns
  `{id, token, scope, expires, user_id}` (`cookbook/views/api.py:2567`).
  - **The schema is wrong here:** it declares the `AuthToken` request body (`username`, `password`, `token`) as the
    response, so the generated client can't read it. `TandoorAuthRepository` calls this endpoint with plain Dio.
  - Wrong credentials: **400** `{"non_field_errors": ["Unable to log in with provided credentials."]}`.
  - Tokens look like `tda_<uuid>`, scope `read write app`, expiry **5 years**.
  - **It reuses** an existing unexpired read+write token for that user if one exists. Every device that logs in
    with a password gets the same token, so revoking it logs out all of them.
  - Throttled to **10 requests per day per IP** for anonymous callers. The login screen must handle HTTP 429
    clearly. Tests and the seed script must not log in repeatedly; they create tokens once.
  - Accounts that only use SSO have no password; they must paste a token (created in Tandoor under
    settings → API tokens).
- Per-device tokens: with a valid token, `POST /api/access-token/` `{scope: "read write", expires}` creates a new
  token. The full token is returned only within 15 seconds of creation; afterwards it is masked
  (`cookbook/serializer.py:1905`). Yumdoor uses this to get its own token per device, so logout can
  `DELETE /api/access-token/{id}/` without logging out other devices.
  - `expires` is required (400 `{"expires": ["This field is required."]}` without it). Yumdoor asks for 5 years,
    like `/api-token-auth/`.
  - A token can delete itself (204); afterwards it gets 403. Other tokens of the user keep working.
- A cheap request to check a token: `GET /api/user-preference/` returns a list with only the caller's own row.
- **Session cookies beat the bearer token** (checked on 2.6.15). Session authentication comes first, so if the
  browser also holds a Tandoor session (the user is logged into Tandoor's UI on the same origin, which the web build
  shares), every request is authenticated **as the session's user**, and every POST, PUT, PATCH and DELETE without a
  CSRF token fails with 403 `CSRF Failed: CSRF token missing.`, `/api-token-auth/` included. Fix: send the
  `csrftoken` cookie (not HttpOnly) as `X-CSRFToken`, like Tandoor's frontend (`lib/data/api/csrf_interceptor.dart`,
  `lib/platform/csrf/`). Requests then work, but still act as the session's user; if that is a different user than
  the one logged into Yumdoor, Yumdoor shows that user's data. A token check can't detect a bad token in that state.
  Native apps don't share cookies and are not affected.
- Scope check: safe methods need `read`, everything else `write` (`CustomTokenHasReadWriteScope`).
  The meal-plan endpoints also accept a `mealplan`-only scope.
- **A missing or invalid token gets 403, not 401** (checked on 2.6.15). Session authentication comes first and
  sends no `WWW-Authenticate` header, so DRF answers `NotAuthenticated` with 403. The `detail` text is translated by
  `Accept-Language` ("Anmeldedaten fehlen."), and a valid token without permission also gets 403, so the two can't
  be told apart. Yumdoor treats every 401 and 403 as `UnauthorizedFailure` (`lib/data/api/api_failures.dart`).
- `GET /api/server-settings/current/` is public and returns `version`; used for the login version check.
  Unknown paths outside `/api/` redirect (302) to Tandoor's HTML login page, so a wrong base path gets HTML with
  status 200 after the redirect, not a 404.
- Tandoor has a `feature-frontend-auth` branch in development (allauth headless). Auth may change in a later
  2.x release; recheck on every version bump.

## CORS and deployment

- CORS headers are sent **only for `/api/bookmarklet-import*`** (`CORS_URLS_REGEX`, `recipes/settings.py:691`),
  and this is not configurable by environment variable.
- Consequence: **the web build only works same-origin with its Tandoor server** (served from the same host, e.g.
  under `/app/`, or behind a reverse proxy that serves both). A server URL that differs from the PWA's origin
  is only usable from native builds. The login screen explains this instead of failing with an opaque
  network error.

## Recipe search

`GET /api/recipe/` (`cookbook/views/api.py:1722`, logic in `cookbook/helper/recipe_search.py`, `cookbook/managers.py`).
Paginated: `page`, `page_size` (default 25, max 100). List items use `RecipeOverview` (no steps; keywords only as
`{id, label}`). A page past the end is a 404; use `next` to know whether there is another page.

| Need | Parameters |
|---|---|
| Text | `query` (search mode and fields come from the user's `SearchPreference`; fuzzy/trigram only on Postgres) |
| Food ("contains carrots") | `foods`/`foods_or`, `foods_and`, `foods_or_not`, `foods_and_not` (ids, repeat param). `include_children` (default true) includes child foods of the food tree. |
| Keyword | `keywords`/`keywords_or`, `keywords_and`, `keywords_or_not`, `keywords_and_not` |
| Book | `books`/`books_or`, `books_and`, … |
| Rating | `rating` (exact; `0` = unrated), `rating_gte`, `rating_lte` |
| Last cooked | `cookedon_gte`, `cookedon_lte` (dates) |
| Times cooked | `timescooked`, `timescooked_gte`, `timescooked_lte` |
| Created / updated / viewed | `createdon*`, `updatedon*`, `viewedon_gte/lte`, `createdby` |
| Cookable from on-hand foods | `makenow` (true, or an int = number of allowed missing foods) |
| Saved filter | `filter` (CustomFilter id) |
| Sort | `sort_order`: `score, name, lastcooked, rating, times_cooked, created_at, lastviewed` (prefix `-` for descending), or `random=true` |

**Text search only matches recipe names by default.** A new user's `SearchPreference` is `plain` with `icontains`,
`trigram` and `unaccent` on `name` only and no fulltext fields (checked on a fresh 2.6.15). `query=Karotte` does not
find a recipe that only has carrots as an ingredient; "contains carrots" needs the `foods` filter.

**Mismatch with our assumption:** `rating`, `lastcooked` and `timescooked` are computed **only from the requesting
user's own cook logs** (`managers.py:51-75`), not the household's or the space's. "Highly rated" in search means
"rated highly by me". Recommendations that need other people's ratings or cooking history read `/api/cook-log/`
directly.

Food and keyword pickers use `GET /api/food/?query=` and `GET /api/keyword/?query=` (trees; `root`, `tree` params).
`parent` is read-only; the tree is changed with `PUT /api/food/{id}/move/{parent_id}/` (`0` = root).
`POST /api/food/`, `/api/keyword/`, `/api/unit/` and the nested writes in a recipe are get-or-create **by name**
(case-insensitive for foods and units): if the name exists, the existing object is returned and the other fields
in the request are ignored.

## Recipe detail and step text

- `GET /api/recipe/{id}/` returns steps, and each step has its **own** `ingredients` list, which matches
  "ingredients per step" in cooking mode directly. `Step.time` is an explicit duration in minutes (use it as a
  timer in addition to durations detected in the text).
- `Recipe.servings` is the base for scaling. `Ingredient` has `amount`, `no_amount`, `is_header`, `unit`, `food`,
  `note` and `original_text`; there are no plural flags in 2.6.15 (`Food` and `Unit` have `plural_name`). A header
  ingredient has its title in `note`, no food or unit, and `no_amount` set.
- Empty text fields come as `""` rather than `null` (`description`, `servings_text`, `note`).
  `User.display_name` is first and last name joined by a space, so it can end in one ("Anna ").
- **Do not use `instructions_markdown`.** It is server-rendered HTML that contains Vue-only custom elements
  (`<scalable-number>`, `<plural-name>`, `cookbook/helper/template_helper.py`). Render the raw `instruction`
  ourselves with a safe Markdown renderer.
- Step text can contain Jinja templates: `{{ ingredients[0] }}`, `{{ ingredients[0].amount }}`, `.unit`, `.food`,
  `.note`, and `{{ scale(100) }}`. Yumdoor implements this small subset in the domain layer (pure Dart,
  no template execution) so the values scale with servings. Unknown template syntax is shown as plain text.
- Same for `MealPlan.note_markdown`: use `note`, not the HTML.
- Images: `PUT /api/recipe/{id}/image/` (multipart `image`, or `image_url`).

## Cook log (ratings, comments, feed)

- `CookLog` fields: `recipe`, `servings` (integer), `rating` (integer, nullable), `comment` (text, nullable),
  `created_by`, `created_at` (settable, defaults to now) (`cookbook/models.py:1492`).
- `GET /api/cook-log/` returns the **whole space**, readable by every member; only the owner or an admin may
  edit or delete. The only filter is `recipe`. Ordering is by **id ascending** with no ordering parameter, so a
  newest-first feed reads `count` and then fetches pages from the end. `page_size` max 200.
- The legacy `Comment` model has no API in v2. Comments live in `CookLog.comment`, as assumed.
- **Mismatch with the mockups:** CookLog has **no image field**. Screen 08 ("Fertig gekocht") shows a photo; that
  is not possible in 2.6.15 without a workaround. Options are in the roadmap.

## Households, meal plans and sharing

- **Mismatch with our assumption:** meal-plan "sharing" in v2 is **household-based**. `MealPlan` still has a `shared`
  many-to-many field, but the serializer does not expose it and the queryset ignores it. A user sees meal plans
  created by themselves and by anyone in their household (`cookbook/views/api.py:1503`). There is nothing to
  configure per plan.
- Same for shopping list entries and shopping-list recipes: visible to the creator and their household.
- A **normal user cannot list household members.** `/api/household/` is space-owner only, and `/api/user-space/`
  returns only the caller's own row for non-admins (that row does include their `household`). `/api/user/` lists all
  users in the space without household information. "What my household cooked" can only be approximated
  (see `docs/ARCHITECTURE.md`, Recommendations).
- `GET /api/meal-plan/?from_date=&to_date=&meal_type=` (paginated: `{count, results}`). Defaults: today − 90 days to
  today + 360 days.
  Fields: `recipe`, `title`, `servings` (decimal), `note`, `from_date`, `to_date` (datetimes), `meal_type`,
  `shopping` (read-only: is it on the shopping list), `addshopping` (write-only).
- `GET /api/meal-type/` returns the space's meal types (name, order, color, time).

## On-hand foods

- `Food.food_onhand` is a boolean that is true if **any household member** has marked the food on hand
  (`CustomOnHandField`, `cookbook/serializer.py:152`). Writing it via `PATCH /api/food/{id}/` sets or clears it for
  the whole household.
- `Food.ignore_shopping` marks foods that never go on the list (salt, water).
- Side effect: if the user preference `shopping_add_onhand` is on, checking a shopping entry marks its food on hand
  for the household, and unchecking clears it. **Gotcha:** `ShoppingListEntrySerializer.update` clears on-hand
  whenever `checked` is missing or false in a PATCH (`serializer.py:1602`). Use the bulk endpoint for checking off,
  and include `checked` in every entry PATCH.

## Meal plan → shopping list

There are two server paths and one client path:

1. Creating a meal plan with `addshopping: true` makes the server add the recipe's ingredients. It honors the
   **creator's** preferences `mealplan_autoexclude_onhand` (default true) and `mealplan_autoinclude_related`, and
   skips `ignore_shopping` foods. Updating a meal plan's servings rescales its linked entries.
2. `PUT /api/recipe/{id}/shopping/` exists, but its `mealplan` argument is read from raw request data (not in the
   schema) and an integer id does not work (`shopping_helper.py:48`). Do not use it for meal plans.
3. What Tandoor's own Vue frontend does, and what Yumdoor does:
   compute the entries client-side (scale by servings, skip `food_onhand` and `ignore_shopping`), then
   `POST /api/shopping-list-recipe/ {recipe, servings, mealplan}` followed by
   `POST /api/shopping-list-recipe/{id}/bulk_create_entries/ {entries: [{amount, food_id, unit_id, ingredient_id}], shopping_lists_ids}`.
   `shopping_lists_ids` is optional in the schema, but the view reads it unconditionally
   (`cookbook/views/api.py:2251`), so always send it (`[]` for none).

Each meal plan becomes its own `ShoppingListRecipe` with one entry per ingredient. The server does **not** merge
amounts across recipes; merging per food and unit for display is our job. "Add the week" skips meal plans whose
`shopping` flag is already true, to avoid duplicates.

## Shopping list

- `GET /api/shopping-list-entry/`: unchecked entries plus entries completed within the user's
  `shopping_recent_days` (max 14), **capped at 1000 rows**. `updated_after` (ISO timestamp) for incremental sync.
  Each entry embeds `food` (with `supermarket_category`), `unit`, `list_recipe_data`.
- Check off: `POST /api/shopping-list-entry/bulk/ {ids, checked}`.
- Supermarket categories: `Food.supermarket_category`. Per-store ordering:
  `GET /api/supermarket/` → each supermarket has `category_to_supermarket` relations with an `order`.
  Group by category, order by the chosen supermarket, uncategorized last.
- v2 also has named lists (`/api/shopping-list/`, `ShoppingListEntry.shopping_lists` many-to-many). A food can
  have default lists. Yumdoor shows all entries in M3 and adds list filtering later.

## Recipe books

`/api/recipe-book/` (name, description, `shared` users, `filter` → a saved search that makes the book dynamic),
`/api/recipe-book-entry/?book=&recipe=`. Search can also filter by `books`.

## Other useful endpoints

`/api/user/` (space members, `display_name`), `/api/user-preference/{user_id}/`, `/api/space/current/`,
`/api/view-log/` (own views only), `/api/unit/`, `/api/supermarket-category/`.

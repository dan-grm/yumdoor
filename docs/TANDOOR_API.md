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
- `makenow` on the recipe search is a boolean in the schema, but the server reads an int: the number of foods that
  may be missing (`true` means `0`, `false` or anything else that isn't a number turns the filter off;
  `RecipeSearchParams._parse_makenow`, checked on 2.6.15). `tool/generate_api.dart` patches it to an integer, so the
  generated client sends `makenow=0` for "cookable now" and `makenow=1` for "one food missing".

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
| Book | `books`/`books_or`, `books_and`, … (only recipes added by hand, see below) |
| Rating | `rating` (exact; `0` = unrated), `rating_gte`, `rating_lte` |
| Last cooked | `cookedon_gte`, `cookedon_lte` (dates) |
| Times cooked | `timescooked`, `timescooked_gte`, `timescooked_lte` |
| Created / updated / viewed | `createdon*`, `updatedon*`, `viewedon_gte/lte`, `createdby` |
| Cookable from on-hand foods | `makenow` (true, or an int = number of allowed missing foods) |
| Saved filter | `filter` (CustomFilter id). **Replaces every other parameter**, paging aside (see below) |
| Sort | `sort_order`: one of `score, name, lastcooked, rating, created_at, lastviewed` (prefix `-` for descending), or `random=true`. **Not** `times_cooked` (see below) |

**Text search only matches recipe names by default.** A new user's `SearchPreference` is `plain` with `icontains`,
`trigram` and `unaccent` on `name` only and no fulltext fields (checked on a fresh 2.6.15). `query=Karotte` does not
find a recipe that only has carrots as an ingredient; "contains carrots" needs the `foods` filter.

**Every parameter is combined with AND** (checked on 2.6.15): `query=Suppe&foods_or=<Karotte>` returns only recipes
that match both, and `foods_and` with `foods_or` (or `keywords_and` with `keywords_or`) means "all of these and at
least one of those". One request cannot mean "name **or** ingredient **or** keyword", so the universal search
(`lib/domain/services/universal_search.dart`) runs three: `query=<text>`, `foods_or=<foods matching the text>` and
`keywords_or=<keywords matching the text>`, each with the user's other filters, and merges them page by page, each recipe
once: by name, rating or newest (the id) in that order over all three, otherwise name matches first. The total is counted with inclusion–exclusion (`page_size=1` requests for the
overlaps) when the results don't fit on the first pages. `foods_or` and `keywords_or` include child foods and
keywords (`include_children`), and a `RecipeOverview` has no ingredients, so a food match can't tell which of the
foods the recipe contains.

**Sort order** (`cookbook/helper/recipe_search.py`, `_build_sort_order`; checked on 2.6.15): `sort_order` takes a
**single** key; a second key or an unknown one (also a comma list) is a 500. Without `sort_order` the order is
`-score, name` when the search preference scores text (trigram or full text), else `name`; `score` is dropped
without a text search. `name` is `Lower(name)`. `rating`, `lastcooked` and `lastviewed` sort nulls last in both
directions and, like the filters, count only the caller's own cook logs and views. Sorting by `rating` fills in the
overview's `rating` (otherwise it can be `null`); `lastcooked` and `lastviewed` are not in the response.
**`times_cooked` and `-times_cooked` are a 500** (`FieldError`: the annotation is called `favorite`, which isn't an
allowed key), so Yumdoor can't sort by how often a recipe was cooked. There is no tie-breaker, so recipes with the
same key can move between pages. `random=true` (or `sort_order=random`) orders by `?` **on every request**: pages
overlap and some recipes never show; the universal search drops the repeats. Views are recorded only by
`POST /api/view-log/ {recipe}`, which Tandoor's web UI sends when a recipe is opened, and so does Yumdoor when it
loads a recipe. Tandoor keeps at most one view per recipe and user every 5 minutes (`ViewLogSerializer.create`), and
`GET /api/view-log/` lists only the caller's own.

**Times cooked:** `timescooked_lte` adds `.exclude(favorite=0)` (`managers.py:179`), so it never returns recipes
cooked 0 times; "never cooked" is `timescooked=0` (exact, which also wins over `_gte`/`_lte`). Overviews carry no cook
count, so the offline cache can only separate cooked (`lastCooked` set, filled in from the cook log when a recipe is
opened) from never cooked; "at least n times" offline shows every recipe cooked at least once.

**Cookable (`makenow`):** a recipe matches if at most `makenow` of its distinct foods are missing
(`RecipeQuerySet.cookable`, `managers.py:377`). A food counts as there if anyone in the user's household has it on
hand (or it is in a household inventory), if a substitute is on hand, through `substitute_children`/
`substitute_siblings`, or if it is `ignore_shopping` (and not itself a recipe). A user without a space membership
gets no results. Checked on 2.6.15 with `makenow=0` and `makenow=1`. Offline, Yumdoor counts the `food_onhand`
flags stored with each recipe and ignores substitutes.

**Books (`books_or`):** matches recipes added to any of the books (`RecipeBookEntry`, `managers.py:243`).
A dynamic book's saved filter (`RecipeBook.filter`) is **not** applied, so it only finds the recipes added to it by
hand (checked on 2.6.15). Tandoor's own book page shows both: the entries, then every recipe the filter finds
(`vue3/src/pages/BookViewPage.vue`). A dynamic book that has no entries finds nothing with `books_or`
(issue #71). `GET /api/recipe-book/` lists only books the user created or that are shared with them (paginated),
each with its `filter` (`id`, `name`, `search`) or `null`. Book entries aren't stored offline, so an offline book
filter finds nothing.

**Saved filters (`filter=<id>`)** replace the request's parameters with the filter's `search`, a JSON object of
search parameters (`{"keywords_or": [3], "version": "2"}`, `_resolve_params` in
`cookbook/helper/recipe_search.py`). Every other parameter except `page`/`page_size` is ignored: `filter=1&query=x`
returns the same as `filter=1` (checked on 2.6.15). It is ignored if the user can't see the filter (not the
creator, not shared with them, not on a book shared with them). So Yumdoor never sends `filter` for a dynamic
book. It reads the book's filter (`GET /api/recipe-book/<id>/`, once per search) and sends the decoded `search`
parameters next to its own, without the ones that only order or pin (`sort_order`, `random`, `new`, `num_recent`,
`version`). `keywords`, `foods` and `books` are read only when `keywords_or` (and so on) is missing, so they count
as the same parameter. Where both use the same parameter (Yumdoor's `keywords_or` for search text, say), or an
exact value and a range of the same field (`timescooked` and `rating` win over their `_gte`/`_lte`, checked on
2.6.15), it sends its own and keeps only the recipes whose ids the saved search finds on its own. It does the same
if the saved search has `include_children: false`, which would change Yumdoor's food and keyword parameters too.
Loading those ids takes one request per 100 recipes the saved search finds (sorted by `created_at`, as names can
tie). When Yumdoor's parameters are much broader than the saved search, most pages filtered that way come back
empty. The union of a book's entries and its filter needs separate searches: the universal search runs each of its
searches (name, foods, keywords) once more per selected book and merges them.

### Saved searches

`/api/custom-filter/` (`CustomFilterViewSet`, `cookbook/views/api.py:2530`; checked on 2.6.15): `{id, name, search,
shared, created_by}`, paginated. `search` is a JSON **string** of search parameters. The list holds the filters the
user created or that are shared with them (`shared`, a list of users), dynamic books' filters included (they are
the same model). The permission is `CustomIsOwner`: only the **creator** can retrieve, change or delete one by id;
someone it is shared with gets **403** even for `GET /api/custom-filter/<id>/`, but can list it and search with it.
So Yumdoor reads a filter's `search` from the list. `type` exists on the model but not in the serializer. The list
is ordered by id. **Names are unique per space** (`cf_unique_name_per_space`), including filters the user can't
see: a taken name is a **500** (`IntegrityError`), not a validation error. Yumdoor refuses the names it can see and
explains a 500 on save or rename as a probably taken name.

Tandoor's search page (`vue3/src/pages/SearchPage.vue`) saves the parameters that differ from their defaults, in
snake case, plus `"version": "2"`: `query`, `keywords`/`keywords_and`/…, `foods…`, `books…`, `units`,
`rating`/`rating_gte`/`rating_lte`, `timescooked…`, `makenow` (`"true"`), `cookedon_gte`/`_lte` (a JSON date-time
of local midnight, e.g. `2026-10-31T23:00:00.000Z`), `createdby`, `sort_order` (`random` is a sort order there),
`include_children`. A filter without `version` is in the 1.x format, which the page converts on load. Yumdoor
writes the same format, so its saved searches open in Tandoor: `query`, `foods_and`, `keywords_and`, `books`,
`rating_gte`, `cookedon_lte` (`YYYY-MM-DD`), `timescooked: 0` or `timescooked_gte`, `makenow` (`"true"` for
cookable now, as the search page reads it; else the number of missing foods), `createdby`, `sort_order` (`-score` for relevance) and `version`. Yumdoor's search text matches ingredients
and keywords too; saved, it is `query`, which Tandoor matches by name only.

A saved search whose parameters all have a chip in Yumdoor is applied as chips (a single "any of" food or keyword
counts as one chip). Otherwise it is applied the way a dynamic book's is: its parameters are sent next to Yumdoor's
own (never as `filter=<id>`, which drops every other parameter), and where they clash, only the recipes the saved
search finds on its own are kept (see above). Applying both a saved search and a dynamic book works the same way;
the book's parameters go first. A saved search's own parameters never clash with each other (`timescooked` and
`timescooked_gte` together are sent as they are; Tandoor lets the exact one win).

Writing a book with a nested `filter` object (`POST`/`PATCH /api/recipe-book/`) **updates that CustomFilter**
with the fields given (`WritableNestedModelSerializer`): send the whole filter, or its `search` is overwritten.

**Creator (`createdby`):** one user id, exact. `GET /api/user/` lists every user of the space, **not paginated**
(a plain array).

**Mismatch with our assumption:** `rating`, `lastcooked` and `timescooked` are computed **only from the requesting
user's own cook logs** (`managers.py:51-75`), not the household's or the space's. "Highly rated" in search means
"rated highly by me". Recommendations that need other people's ratings or cooking history read `/api/cook-log/`
directly.

Food and keyword pickers use `GET /api/food/?query=` and `GET /api/keyword/?query=` (trees; `root`, `tree` params).
`query` matches `name` with `icontains` (plus `unaccent` if the search preference has it on that model), names
starting with the text first; the plural name is not searched (`Karotten` doesn't find `Karotte`). **With a fuzzy
search preference** (`lookup`, or `trigram` on the model) it doesn't filter at all and only orders by trigram
similarity (`FuzzyFilterMixin`, `cookbook/views/api.py:291`), so `query=Karotte` can return `Kartoffel`. The
universal search keeps only foods and keywords whose name contains the text.
`parent` is read-only; the tree is changed with `PUT /api/food/{id}/move/{parent_id}/` (`0` = root).
`POST /api/food/`, `/api/keyword/`, `/api/unit/` and the nested writes in a recipe are get-or-create **by name**,
ignoring case (foods and units also match the plural name; keywords go through `TreeManager.get_or_create`,
`cookbook/models.py:73`, which uses `name__iexact`): if the name exists, the existing object is returned and the
other fields in the request are ignored. The status is `201` either way, so the response doesn't say whether
anything was created. A new unit gets its name as plural name too (`serializer.py:745`). The unit list
(`GET /api/unit/?query=`) uses the same `FuzzyFilterMixin` as foods and keywords; Yumdoor's unit autocomplete
keeps only units whose name contains the text and asks for the maximum page size (`200`) when there
is a text, since fuzzy ordering of a short text puts matches anywhere in the list.

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
  - `ingredients[n]` indexes the step's ingredients in `['order', 'pk']` order, **headers included**; a header
    renders as empty text (verified on 2.6.15). `ingredients[n]` alone is `amount unit food`, without the note.
  - Tandoor replaces the **whole step** with "Could not parse template code" on a Jinja error and strips every
    leftover `{` and `}`. Yumdoor keeps the step and shows unknown expressions as written instead.
- Same for `MealPlan.note_markdown`: use `note`, not the HTML.
- Images: `PUT /api/recipe/{id}/image/`, see [Recipe images](#recipe-images).

## Recipe images

`PUT /api/recipe/{id}/image/` (`RecipeViewSet.image`, `cookbook/views/api.py:1856`; `RecipeImageSerializer`,
`cookbook/serializer.py:1237`; `cookbook/helper/image_processing.py`). Verified on 2.6.15:

- **Multipart only** (`MultiPartParser`); JSON is a 415. The file goes in `image`; `image_url` instead makes the
  server download it. The generated client types `image` as a string, so Yumdoor sends the form with plain Dio
  (`TandoorRecipeRepository.uploadImage`).
- **Formats:** the file name must end in `.jpg`, `.jpeg`, `.png`, `.webp` or `.gif` (any case); without one, or
  with another (`photo.heic`), it's a 400 from Django's `ImageField`. The content must be an image Pillow can
  open, else 400 ("Upload a valid image"). A PNG named `.jpg` is accepted and stored as PNG. Yumdoor sniffs the
  type from the content and sends a matching name (`PickedImage.fileName`).
- **Size:** Tandoor has no limit of its own; the nginx in the official image allows 512 MB. A reverse proxy in
  front of it often allows less (nginx's default is 1 MB) and answers **413**, which Yumdoor explains as "too large
  for the server". Yumdoor itself accepts up to 20 MiB (`maxImageBytes`).
- **Processing:** files over 500 KB are scaled to **1020 px wide** (aspect kept, also upscaled if narrower; JPEG at
  quality 90, EXIF orientation applied). Smaller ones are re-encoded without metadata. Animated GIFs stay animated.
  A 6 MB 3000×2000 JPEG came back as 1020×680, 360 KB.
- **Response:** 200 with `{"image": "/media/recipes/<uuid>_<id>.<ext>", "image_url": null}`, the path relative to
  the server's origin (whatever `MEDIA_URL` makes it); `GET /api/recipe/{id}/` has the same path as an absolute URL
  (`build_absolute_uri`). Yumdoor resolves the path against the server URL instead of fetching the recipe again. Every upload gets a
  new file name, so cached copies never go stale. Media under `/media/` is served without authentication.
- **Removing:** a PUT with an empty form (no `image`, no `image_url`) sets the image to `null` (200). An `image`
  field with an empty value is a **500**.
- **Permissions:** like a recipe update: 403 for a user who may not change the recipe (also for someone else's
  private recipe), 404 for a recipe that doesn't exist.

## Recipe writes

`POST /api/recipe/` creates a recipe, `PATCH /api/recipe/{id}/` changes one, both with steps, ingredients, foods,
units and keywords nested in the body. `RecipeSerializer` and the nested serializers are drf-writable-nested
(0.7.2) `WritableNestedModelSerializer`s (`cookbook/serializer.py:48`, `:1054`, `:1193`). Verified on 2.6.15:

- **Required:** `name` and `steps` on create (`steps` may be one empty step, not missing). A new step needs
  `ingredients` (may be `[]`); a new ingredient needs `food`, `unit` (both may be `null`) and `amount`. A PATCH
  needs nothing; fields it leaves out keep their value.
- **Nested lists are matched by `id`.** An item with an `id` updates that step, ingredient or keyword; one
  without is created. Items left out of a list that is sent are **removed from the recipe but not deleted**: steps
  and ingredients are many-to-many, so drf-writable-nested only removes the link (`mixins.py:298`). They stay in the
  database as orphans; the API no longer finds them (404). A list that isn't sent at all is left alone.
- **Partial all the way down.** On a PATCH, nested items that have an `id` are updated partially too
  (`mixins.py:85`), so a step sent as `{id, name, instruction, time, order, ingredients}` keeps its
  `step_recipe` (sub-recipe), `file`, `show_as_header` and `show_ingredients_table`. New items are created with
  model defaults: `show_as_header` and `show_ingredients_table` `true`, `time` and `order` `0`, `note` `null`.
- **`order`** is stored as sent and nothing renumbers it. Steps and ingredients come back sorted by
  `['order', 'pk']` (`cookbook/models.py:955`, `:986`), so a save sends every item's position as its `order`.
- **`original_text`** is kept only when an ingredient is created; an update drops it (`serializer.py:1009`).
- **Foods, units and keywords are get-or-create by name** when sent without an `id`: keywords by name
  (`serializer.py:725`; on the PostgreSQL setup `{"name": "backen"}` found "Backen"), units by name or plural name ignoring case (`:747`), foods by name or plural name
  ignoring case (`:922`; `{"name": "karotte"}` finds "Karotte"). **With an `id` they are updated**: the
  name sent renames the food, unit or keyword everywhere it is used, so send the current name. A unit with an `id`
  but no `name` is a 500 (`UnitSerializer.update` reads `name`).
- **What a PATCH keeps when left out:** `nutrition`, `properties`, `private`, `shared`, `internal`,
  `show_ingredient_overview`, `image` and so on. An empty `source_url` (`""`) clears it; `null` fields are
  left out by the generated client.
- **`internal`** defaults to `false` through the API; Tandoor's own editor sets it to `true` on recipes it
  creates (`vue3/src/components/model_editors/RecipeEditor.vue`), and Yumdoor does the same.
- The PATCH response is the saved recipe in the same shape as `GET /api/recipe/{id}/`, so no second request is
  needed. `food_properties` is `{}` in the create response.
- A private recipe (`private: true`) is invisible to other users of the space (403 by id, absent from searches)
  unless they are in `shared`. The integration tests rely on that to keep their recipes out of other tests.

**What Yumdoor sends** (`lib/data/mappers/recipe_draft_mapper.dart`): on update a PATCH with `name`,
`description`, `servings`, `servings_text`, `working_time`, `waiting_time`, `source_url`, `keywords` and `steps`;
each step with `id` (if saved), `name`, `instruction`, `time`, `order` and `ingredients`; each ingredient with
`id` (if saved), `food` and `unit` as `{id?, name}`, `amount`, `no_amount`, `is_header`, `note`, `order` and
`original_text` (and `checked: false`, a default of the generated client; read-only on the server).
Everything else of the recipe, its steps and its ingredients is left out and so survives a save.
On create the same without step and ingredient ids (a draft made from another recipe would otherwise share its
steps and ingredients) plus `internal: true`.

## Cook log (ratings, comments, feed)

- `CookLog` fields: `recipe`, `servings` (integer, nullable), `rating` (integer, nullable), `comment` (text,
  nullable), `created_by`, `created_at` (settable, defaults to now) (`cookbook/models.py:1492`).
  `POST /api/cook-log/` with `{recipe, servings, rating?, comment?}` creates an entry for the caller (201).
- **`rating` is not validated:** the server stores any integer (`6` and `0` are accepted). Yumdoor only sends 1–5
  (`NewCookLog`).
- `GET /api/cook-log/` returns the **whole space**, readable by every member; only the owner or an admin may
  edit or delete (others get 403). The only filter is `recipe`. Ordering is by **id ascending** with no ordering
  parameter, so a newest-first feed reads `count` and then fetches pages from the end. `page_size` max 200.
- **`last_cooked` on recipes is always `null`** in 2.6.15, in the list and the detail: the queryset annotates
  `lastcooked` (`managers.py:60`), but `RecipeSerializer` reads `last_cooked`. The `cookedon_*` filters and the
  `lastcooked` sort order work. Yumdoor reads the recipe's cook log instead (`GET /api/cook-log/?recipe=<id>`,
  newest pages first, at most 300 entries back) and takes the caller's newest `created_at`; search results
  have no last-cooked date. `rating` on recipes works (the caller's own average).
- There is no "current user" endpoint. `GET /api/user-preference/` returns only the caller's own preferences
  (`views/api.py:795`), each with the `user`, for every user.
- The legacy `Comment` model has no API in v2. Comments live in `CookLog.comment`, as assumed.
- **Mismatch with the mockups:** CookLog has **no image field**. Screen 08 ("Fertig gekocht") shows a photo; that
  is not possible in 2.6.15 without a workaround, so Yumdoor drops the photo (see the roadmap, M2).

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
`/api/recipe-book-entry/?book=&recipe=`. Search can also filter by `books`, which leaves out what a dynamic book's
filter finds (see [Recipe search](#recipe-search)).

## Ingredient parser

`POST /api/ingredient-parser/post/` splits ingredient lines into amount, unit, food and note
(`IngredientParserView`, `cookbook/views/api.py:3319`; the parser is `cookbook/helper/ingredient_parser.py`).
Tandoor's own editor uses it for its "paste ingredients" dialog (`vue3/src/components/inputs/StepEditor.vue`).
Verified on 2.6.15:

- **Request:** `{"ingredient": "<line>"}` and/or `{"ingredients": ["<line>", …]}` (both optional). Lines are sent
  as typed; the server trims them. Any space member may call it, guests included.
- **Response:** `{"ingredient": IngredientSimple | null, "ingredients": [IngredientSimple, …]}`, 200. Each result
  has `amount` (`0` without one), `unit` and `food` (full objects **with `id`**, or `null`), `note` (`""` if none),
  `original_text` (the line as sent), `id: null`, `no_amount: false`, `is_header: false`. Nothing is saved as an
  ingredient.
- **Unknown foods and units are created.** The parser gets or creates both (`get_food`, `get_unit`): a food by
  exact name or plural name, else `Food.objects.create`, which returns an existing food whose name matches
  ignoring case (`models.py:73`), so `KAROTTE` finds "Karotte" but `karotten` (plural, other case) creates a new
  food. Units by exact name or plural name only: `G` or `el` create new units next to "g" and "EL". The space's
  automations (food/unit aliases, replacements, never-unit, transpose) are applied first. So parse a line once it
  is finished, not on every keystroke, and treat parsing as a write (it needs to be online).
- **Blank lines in `ingredients` are left out** of the response, so results line up with the non-blank lines
  only. A blank `ingredient` is a 400 (`"This field may not be blank."`).
- **A line the parser can't handle is a 500** (HTML, not JSON), and in `ingredients` it fails the **whole
  list**. Seen with lines that are only symbols after stripping leading `,.-_=+#*|\/` (`-`, `,`), lines over 512
  characters, and an empty food (`"1 g\t,\tSalz"`). Yumdoor skips the first two without a request and turns a 500
  into a food-less line with the text as note, once a request to `/api/server-settings/current/` shows that the
  server itself works; a list that fails is split in halves until the failing line is
  found.
- **Amounts:** decimal comma or point (`1,5`, `1.5`), vulgar fractions (`½`), `1/2`, `1 1/2`, `1 ½`, and an amount
  glued to the unit (`200g`). A range `2-3 Zwiebeln` gives amount `2` and the range as note. No amount: `0`
  (`Salz` → food "Salz", amount 0, no unit). The parser doesn't depend on the user's language.
- **Note:** what follows the food after a comma, semicolon or colon (`Karotten, geschält`), or in trailing
  brackets (`Butter (weich)`). Words before the food that aren't a unit become the food ("a pinch of salt" is one
  food).
- The old `POST /api/ingredient-from-string/` is commented out in `urls.py`.

## Other useful endpoints

`/api/user/` (space members, `display_name`), `/api/user-preference/{user_id}/`, `/api/space/current/`,
`/api/view-log/` (own views only), `/api/unit/`, `/api/supermarket-category/`.

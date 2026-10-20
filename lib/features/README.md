# features

One folder per screen area (`auth/`, `search/`, `recipe/`, `cooking/`, `settings/`, …) with its screens, widgets
and Riverpod controllers. Talks to `domain` through providers from `app/`; never imports `data`.

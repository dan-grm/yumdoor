# Yumdoor

A friendly client for self-hosted [Tandoor Recipes](https://github.com/TandoorRecipes/recipes), built with Flutter.

Yumdoor focuses on everyday use in the kitchen: finding recipes fast ("which recipes have carrots?"),
cooking step by step with timers and scaled amounts, planning the week with your household and shopping
from a list sorted by supermarket aisle.

> **Status:** early development. Nothing is usable yet. See the [roadmap](docs/ROADMAP.md).

## Features (planned)

- **Cooking mode:** one step at a time, ingredients per step scaled to your servings, large buttons, screen stays on,
  timers detected from the step text
- **Search:** filter by ingredient, keyword, rating, last cooked and more, as a first-class screen
- **Recipe editing** that works on phones and desktop browsers
- **Meal planning** for the week with drag and drop, shared with your household, and one tap to add the week's
  ingredients to the shopping list
- **Shopping list** grouped by supermarket category
- **Recommendations**, **cookbooks** and an **activity feed** of what people cooked and how they liked it
- German and English, light and dark theme, works offline for recipes you've opened

No ads, no tracking, no analytics.

## Requirements

- A Tandoor server running **2.6.15** (Yumdoor targets the latest 2.x release and is tested against the pinned
  version).
- For the web app (PWA): Yumdoor must be served **from the same origin** as Tandoor, for example
  `https://recipes.example.com/app/`, because Tandoor does not allow cross-origin API requests.
  Native apps (later) can connect to any server.

## Deployment (PWA)

The image `ghcr.io/dan-grm/yumdoor` (amd64 and arm64) serves the web app with nginx under a configurable base
path. Tags: `main` (latest build of the main branch), `sha-<commit>`, and from the first release `1.2.3`, `1.2`,
`1` and `latest`. Put it behind the same reverse proxy as Tandoor, so both share one origin: Tandoor at `/`,
Yumdoor at `/app/`.

```yaml
# Next to Tandoor in its compose.yml
  yumdoor:
    image: ghcr.io/dan-grm/yumdoor:main
    restart: unless-stopped
    environment:
      BASE_PATH: /app/   # default; must start and end with "/"
    read_only: true      # optional: the container only writes to /tmp
    tmpfs: [/tmp]
```

```nginx
# Reverse proxy (nginx). The container listens on 8080.
server {
    server_name recipes.example.com;
    # listen 443 ssl; ssl_certificate …

    # No path after the port: the request path (/app/…) is passed on unchanged.
    location /app/ {
        proxy_pass http://yumdoor:8080;
        proxy_set_header Host $host;
    }

    # Tandoor, as before.
    location / {
        proxy_pass http://web_recipes:80;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Then open `https://recipes.example.com/app/` and log in with your Tandoor account. The app can be installed from
the browser and starts offline with the recipes you've opened. With Caddy, the same is
`handle /app/* { reverse_proxy yumdoor:8080 }` before Tandoor's `reverse_proxy`.

## Development

See [CLAUDE.md](CLAUDE.md) for setup, commands and conventions, [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
for the design of the app, and [docs/TANDOOR_API.md](docs/TANDOOR_API.md) for notes on the Tandoor API.

## Contributing

We are not accepting outside contributions yet. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Yumdoor is free software under the [GNU Affero General Public License v3.0](LICENSE).
Yumdoor is an independent project and is not affiliated with the Tandoor project.

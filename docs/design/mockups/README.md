# Yumdoor mockups

Phone mockups at 390×844 in the Kräutergarten design (see `../README.md` and `../tokens.json`).
Each screen exists as a PNG (2× render) and a standalone HTML file that opens in any browser;
links between the HTML screens work. Copy is German on purpose; long German strings are the layout stress test.

## Screens

| File | What it shows |
|---|---|
| `screens/01-anmelden` | Login: server address with version check, password or API token. |
| `screens/02-start` | Start: today's plan, recommendations with reasons, server-wide activity feed, profile/settings button. |
| `screens/03-suche` | Search: ingredient/keyword/time/rating filter chips; results echo the matched ingredient. |
| `screens/04-rezept` | Recipe detail: servings picker before cooking, scaled ingredients, plan/shop/edit actions. |
| `screens/05-kochmodus` | Cooking mode (light): step dots, running timer, detected duration, per-step ingredients, read-only servings. |
| `screens/06-kochmodus-dunkel` | Cooking mode (dark theme reference). |
| `screens/07-kochmodus-letzter-schritt` | Cooking mode, last step: finished timer, 'Fertig gekocht'. |
| `screens/08-fertig-gekocht` | Done: rating, comment, photo; saved as CookLog entry, appears in the feed. |
| `screens/09-rezept-bearbeiten` | Recipe editor, steps tab: reorder, inline edit, per-step ingredients, explicit duration. |
| `screens/10-wochenplan` | Week planner: vertical days, drag and drop, shared plan, 'Einkauf für die Woche'. |
| `screens/11-einplanen` | Plan sheet: day, meal type, servings, add missing ingredients to the list. |
| `screens/12-einkaufsliste` | Shopping list: grouped by supermarket category, merged amounts, source recipes. |
| `screens/13-kochbuecher` | Cookbooks: own and shared books. |
| `screens/14-einstellungen` | Settings: account, household sharing, appearance, cooking mode, offline cache, about. |

## Explored directions

`richtungen/` holds the three cooking-mode directions (A Küchenheft, B Kräutergarten, C Abendlicht) in light and dark.
**B was chosen.** A and C are kept for reference only; do not implement them.
In the B versions in `richtungen/`, servings are already read-only, as in the final design.

## Not mocked yet

Tablet and desktop layouts, dark versions of most screens, a single cookbook's view, the editor's
Allgemein and Zutaten tabs, and empty, offline and error states. Derive these from the design system.

## Sources

`../source/` contains the raw artifact files (`.dc.html` canvas files and the design-system project).
They need the design editor's runtime to render; use the flattened HTML here instead.

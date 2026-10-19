# Yumdoor

Yumdoor is a Flutter client for self-hosted Tandoor Recipes: cooking mode, recipe editing, a week planner with shopping lists, recommendations, cookbooks and a household activity feed. This system is its visual language, called *Kräutergarten*: warm off-white, sage green, butter yellow, and the rounded Nunito typeface.

It is the reference for both the mockups and the Flutter code. In the app, every token below becomes a value in a `ThemeExtension` (one instance per theme); widgets read tokens, never hex values.

## Principles

1. **Kitchen-proof.** Every tappable thing is at least `size-touch` (44px). Primary actions are `size-button` (56px) pills. Cooking-mode text uses the `step` style so it reads from arm's length. Nothing important hides behind a long press or a swipe alone.
2. **Calm, then one clear action.** Screens are mostly `bg`, `surface` and `ink`. `sage` marks the one or two things to do next. If three sage elements compete on a screen, demote one to `sage-soft` or an outline.
3. **Butter means time.** `butter` is reserved for timers, detected durations in step text and "today" in the planner. Users learn to scan for it.
4. **Borders, not shadows.** Cards are `surface` with a `line` border. `shadow-lift` exists only for something being dragged and for bottom sheets.
5. **No accidental changes while cooking.** Settings that change the recipe (servings, units) are chosen before cooking mode starts and are read-only inside it. Cooking mode offers only navigation, timers and ticking off ingredients.

## Color

| Role | Tokens | Rule |
|---|---|---|
| Ground | `bg`, `surface`, `surface-sunken` | `bg` for screens, `surface` for cards on it, `surface-sunken` for neutral fills and placeholders. |
| Text | `ink`, `ink-muted` | Both pass 4.5:1 on `bg` and `surface` in both themes. Muted is for meta lines and completed items, never for body text. |
| Accent | `sage`, `on-sage`, `sage-soft` | Filled `sage` for the primary action; `sage-soft` for amounts, selected chips and toggled icons. |
| Time | `butter`, `on-butter` | Timers and highlights only. |
| Lines | `line`, `control-border` | `line` decorates; `control-border` outlines controls and meets 3:1. |
| Danger | `danger`, `on-danger` | Destructive actions only. |

Dark mode is a full theme, not an inversion: `sage` becomes a lighter green with dark text on it, and `butter` becomes a dark olive with light text, so highlights stay readable without glowing at night.

## Typography

One family, Nunito (Google Fonts, weights 400/600/700/800), loaded as a hosted font. Titles are 800, list rows 600, running text 400. Numbers in timers use tabular figures. German strings run long: layouts must survive "Kreuzkümmel, gemahlen" and "Weiter zu Schritt 4" without truncation at 390px width.

## Spacing and shape

Screens use a `space-5` side gutter on phones. Vertical rhythm comes from `space-4` between sections and `space-2` inside groups. Shapes are soft: `radius-l` for cards and pill buttons, `radius-m` for chips, `radius-full` for round buttons, dots and amount pills.

## Iconography

Outline icons on a 24px grid, 2–2.4px stroke, round caps and joins, drawn in `currentColor`. A rounded outline set such as Lucide matches. No emoji, no filled icons except the play triangle. Icon-only buttons always carry an accessible label.

## Voice

German first, English second. Short, friendly, du-form for messages ("Du hast noch nichts geplant"). Recipe steps keep the recipe's own wording. Buttons say what happens: "Timer starten", "Kochen starten", "Zur Einkaufsliste".

## Components

- **Button**: ink primary, sage accent, outline secondary, round icon button.
- **StepDots**: progress through recipe steps in cooking mode.
- **TimerChip**: a running timer, plus the inline highlight for detected durations.
- **IngredientRow**: tick-off row with an amount pill.
- **FilterChip**: selectable chips for search filters (ingredient, keyword, rating).
- **ServingsPicker**: the stepper used before cooking starts.
- **RecipeCard**: a recipe in lists, search results and the planner.

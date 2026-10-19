# StepDots

Numbered dots showing progress through a recipe's steps in cooking mode.

- Done steps: `sage` fill with an `on-sage` check. Current step: 2.5px `sage` ring with the number in `sage`. Upcoming: `surface-sunken` with the number in `ink-muted`.
- Each dot is `size-dot` (28px) with `space-2` gaps minus 2px (6px). From 9 steps on, collapse to "3 / 12" text plus a thin bar, so the row never wraps.
- Dots are visual only (`aria-hidden`); the top bar states "Schritt 3 von 6" in text. Tapping a dot to jump is allowed, with each dot's hit area extended to `size-touch`.

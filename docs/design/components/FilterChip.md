# FilterChip

Selectable chips that build a search: ingredients ("enthält Karotten"), keywords, rating, time, last cooked.

- `size-chip` tall (hit area extended to `size-touch`), `radius-m`, `label` style.
- Unselected: `surface` with a 1px `line` border, `ink` text. Selected: `sage-soft` fill, `ink` text, a leading check, and a trailing × to remove when the chip came from typing.
- Ingredient chips read "enthält Karotten"; a chip reading "ohne Koriander" excludes. Several ingredient chips combine with AND by default; the filter sheet can switch to OR.
- An outline "+ Filter" chip opens the full filter sheet. Chips scroll horizontally in one row on phones; they never wrap into more than two rows.
- Selection state uses `aria-pressed` on a real button.

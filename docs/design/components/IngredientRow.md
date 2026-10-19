# IngredientRow

An ingredient with a tick-off circle and its amount, used in cooking mode, on the recipe screen and (with a supermarket category) in the shopping list.

- 48px row: a `size-touch` check button holding a 26px circle, the name in `body-l`, the amount in a `sage-soft` pill (`label`, `radius-full`).
- Unchecked: 2px `control-border` ring. Checked: `sage` fill with an `on-sage` check; the name turns `ink-muted` with a line-through and the pill turns `surface-sunken`.
- Amounts are already scaled to the servings chosen before cooking. The row never offers to change them.
- The check button carries `aria-pressed` and a label like "Karotten abhaken".

# RecipeCard

A recipe in search results, lists, recommendations and the week planner.

- `surface` card, 1px `line` border, `radius-l`, 12px padding. A 72px square image at `radius-m` on the left; title in `title-s` (two lines max), one `caption` meta line in `ink-muted`.
- Meta order: time, rating, last cooked ("35 Min · 4,5 ★ · vor 3 Wochen"). In search results, the matched filter is echoed as a `sage-soft` pill ("enthält Karotten · 600 g") so users see why the recipe matched.
- No photo: a `sage-soft` square with a `sage` outline pot icon. Never a grey box or a stock image.
- The whole card is one link to the recipe; secondary actions (plan, add to book) sit behind a trailing icon button with its own label.

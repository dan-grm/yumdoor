# ServingsPicker

The stepper that sets servings before cooking starts. It lives on the recipe screen above the ingredient list and in the planner's meal sheet, never inside cooking mode.

- A `sage-soft` pill, `size-touch` tall: two round `size-touch` buttons (− and +) around the value in `label` style ("4 Portionen").
- Changing it rescales the ingredient list immediately; a `caption` line under the list notes the original yield when it differs ("Rezept ist für 2 Portionen").
- "Kochen starten" carries the current value into cooking mode, where it is shown read-only ("für 4 Portionen").
- Minimum 1; the minus button is disabled (not hidden) at the minimum.

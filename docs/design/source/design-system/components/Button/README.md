# Button

Pill and round buttons in four roles: ink primary for navigation, sage accent for the one main action, outline secondary, and round icon buttons.

- **Accent** (`sage` fill, `on-sage` text, `label` style at 17px, `size-button` tall, `radius-l`): the single most important action on a screen, e.g. "Timer starten", "Kochen starten". At most one per screen region.
- **Primary** (`ink` fill, `on-ink` text): forward navigation such as "Weiter zu Schritt 4". Takes the remaining width beside a round back button.
- **Secondary** (transparent, 2px `control-border`): cancel, back, less important alternatives.
- **Icon button** (`size-touch` round, `surface` with `line` border; toggled: `sage-soft` with `sage` icon and `aria-pressed`): close, menus, toggles like "Bildschirm bleibt an".
- **Danger** (`danger` fill, `on-danger` text): destructive confirmations only, never as the first button a user sees.

Always a real button with a text label or an accessible label. Never shorter than `size-touch`.

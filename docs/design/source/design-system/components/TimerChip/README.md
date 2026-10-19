# TimerChip

A running timer, and the inline highlight that marks a detected duration in step text.

- **Chip**: `butter` fill, `on-butter` text, `size-chip` tall, `radius-m`. Clock icon, a short label ("Ofen"), then the remaining time in `label` weight with tabular figures. Several running timers stack as chips; tapping one opens the timer sheet.
- **Inline highlight**: the detected phrase ("25 Minuten") in `step` text gets a `butter` background, `radius-s`, 6px side padding and weight 800. It is the visual promise that a matching "Timer starten" button exists below.
- When a timer finishes, the chip switches to `sage` with `on-sage` text and the app plays a sound. Butter never flashes.

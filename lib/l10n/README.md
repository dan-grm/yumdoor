# l10n

`app_de.arb` (German first, the template) and `app_en.arb`. Every user-visible string goes here. `flutter gen-l10n`
(configured in `/l10n.yaml`, also run by `flutter pub get`) writes `generated/`; don't edit it, but commit it.

- Strings: `context.l10n.someKey` (import `l10n.dart`).
- Numbers and dates: `LocaleFormat.of(context).amount(1.5)` → "1,5" (`formatting.dart`). Never `toString()`.
- Locale: the device's language if supported, else German; `localeOverrideProvider` (in `lib/app/`) overrides it.
- `test/unit/l10n/arb_parity_test.dart` fails if the two files differ in keys or placeholders.

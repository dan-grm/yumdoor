# design

`YumdoorTokens` `ThemeExtension` (light and dark) in `tokens.g.dart`, generated from `docs/design/tokens.json` by
`dart run tool/gen_tokens.dart`; `theme.dart` builds the Material `ThemeData` from it. Widgets import `design.dart`
and read tokens via `context.tokens`. Shared component widgets go in `components/`.

- Change a token: edit `tokens.json`, re-run the tool. `test/tool/gen_tokens_test.dart` fails if the generated file
  is out of date.
- Don't add a hand-written `tokens.dart` here: `build_runner -d` would treat `tokens.g.dart` as its output and
  delete it.
- Debug builds have a token gallery at `/debug/tokens` (`token_gallery.dart`); goldens are in
  `test/widget/goldens/`. Update them with `flutter test --update-goldens test/widget/token_gallery_test.dart`.
- Nunito 400/600/700/800 is bundled from `assets/fonts/nunito/` (static instances served by Google Fonts for
  Nunito v32, SIL OFL 1.1 in `OFL.txt`), so the app makes no font requests.

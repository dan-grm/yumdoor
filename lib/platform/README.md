# platform

Platform services behind interfaces (`wake_lock/`, `timers/`, `token_store/`, `connectivity/`, `csrf/`), with web and
native implementations chosen by conditional imports. The only place `dart:html`, `package:web` or `dart:io` may
appear. May import `core` only.

- Each service's interface file picks the implementation:
  `import 'x_stub.dart' if (dart.library.js_interop) 'x_web.dart';` and a factory constructor redirects to it.
  The `_stub` files are the native placeholders until the native builds land.
- Providers live in `lib/app/platform_providers.dart`. Tests override them with the fakes in `test/fakes/`.
- `test/platform/contracts.dart` describes what every implementation must do. It runs against the fakes on the VM
  and against the web implementations with `flutter test --platform chrome test/web/`.
- `TokenStore` on the web is **not secure** (localStorage); see `secure_storage_token_store.dart`.

# platform

Platform services behind interfaces (`wake_lock/`, `timers/`, `token_store/`, `connectivity/`), with web and
native implementations chosen by conditional imports. The only place `dart:html`, `package:web` or `dart:io` may
appear. May import `core` only.

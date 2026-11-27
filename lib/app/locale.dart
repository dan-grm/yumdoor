import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../l10n/l10n.dart';
import 'platform_providers.dart';

part 'locale.g.dart';

const _key = 'settings.language';

/// The locale chosen in settings, or `null` to follow the device (the
/// default). Kept on the device in the `LocalStore`, across restarts and
/// logout; unsupported values mean the device language.
@Riverpod(keepAlive: true)
class LocaleOverride extends _$LocaleOverride {
  @override
  Locale? build() {
    final saved = ref.watch(localStoreProvider).read(_key);
    return AppLocalizations.supportedLocales
        .where((l) => l.languageCode == saved)
        .firstOrNull;
  }

  void set(Locale? locale) {
    state = locale;
    final store = ref.read(localStoreProvider);
    if (locale == null) {
      store.delete(_key);
    } else {
      store.write(_key, locale.languageCode);
    }
  }
}

/// The first device locale whose language the app supports, else German.
Locale resolveLocale(List<Locale>? deviceLocales) {
  for (final device in deviceLocales ?? const <Locale>[]) {
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == device.languageCode) return supported;
    }
  }
  return const Locale('de');
}

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../l10n/l10n.dart';

part 'locale.g.dart';

/// The locale chosen in settings, or `null` to follow the device.
@Riverpod(keepAlive: true)
class LocaleOverride extends _$LocaleOverride {
  @override
  Locale? build() => null;

  void set(Locale? locale) => state = locale;
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

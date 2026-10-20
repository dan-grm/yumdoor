import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  /// The strings for the active locale: `context.l10n.appTitle`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

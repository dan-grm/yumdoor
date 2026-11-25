import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'platform/browser_history/single_entry_history.dart';

void main() {
  AppBinding.ensureInitialized();
  LicenseRegistry.addLicense(_bundledFontLicenses);
  runApp(const ProviderScope(child: YumdoorApp()));
}

/// Fonts are bundled assets, so their licenses don't come from a package.
Stream<LicenseEntry> _bundledFontLicenses() async* {
  yield LicenseEntryWithLineBreaks([
    'Nunito',
  ], await rootBundle.loadString('assets/fonts/nunito/OFL.txt'));
}

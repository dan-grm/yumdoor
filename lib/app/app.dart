import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import 'locale.dart';
import 'router.dart';

/// Root widget: wires the router and localization into [MaterialApp.router].
class YumdoorApp extends ConsumerWidget {
  const YumdoorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: ref.watch(localeOverrideProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (deviceLocales, _) =>
          resolveLocale(deviceLocales),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

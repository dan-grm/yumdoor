import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/common/offline_banner.dart';
import 'package:yumdoor/l10n/l10n.dart';

/// Phone width of the mockups.
const phoneSize = Size(390, 844);

/// Pumps [routes] in German at [phoneSize], starting at [location], and
/// returns the router to inspect or drive navigation.
Future<GoRouter> pumpRoutes(
  WidgetTester tester, {
  required String location,
  required List<RouteBase> routes,
  List<Override> overrides = const [],
  ThemeData? theme,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = phoneSize;
  addTearDown(tester.view.reset);

  final router = GoRouter(initialLocation: location, routes: routes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme ?? lightTheme,
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
        // As in YumdoorApp.
        builder: (context, child) => OfflineBanner(child: child!),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

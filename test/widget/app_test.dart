import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/features/auth/login_screen.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../fakes/app_overrides.dart';

void main() {
  testWidgets('starts on search with a stored session', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: appOverrides(tokenStore: loggedInTokenStore()),
        child: const YumdoorApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
  });

  testWidgets('starts on login without a session', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: appOverrides(), child: const YumdoorApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

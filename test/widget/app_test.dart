import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/features/home/home_screen.dart';

void main() {
  testWidgets('starts on the home route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: YumdoorApp()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

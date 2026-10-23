import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/design/components/step_dots.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/l10n/l10n.dart';

void main() {
  Future<void> pumpDots(WidgetTester tester, int count, {int current = 2}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: lightTheme,
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: StepDots(count: count, current: current),
          ),
        ),
      );

  testWidgets('shows a check for done steps and numbers for the rest', (
    tester,
  ) async {
    await pumpDots(tester, 6);

    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    for (final number in ['3', '4', '5', '6']) {
      expect(find.text(number), findsOneWidget);
    }
  });

  testWidgets('collapses to text and a bar from 9 steps on', (tester) async {
    await pumpDots(tester, StepDots.collapseAt);

    expect(find.text('3 / 9'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });
}

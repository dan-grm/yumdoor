import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yumdoor/domain/services/scaling_service.dart';
import 'package:yumdoor/l10n/formatting.dart';

void main() {
  setUpAll(() async {
    // In the app, GlobalMaterialLocalizations loads these.
    await initializeDateFormatting('de');
    await initializeDateFormatting('en');
  });

  final de = LocaleFormat(const Locale('de'));
  final en = LocaleFormat(const Locale('en'));

  test('amounts use the locale decimal separator, at most two decimals', () {
    expect(de.amount(1.5), '1,5');
    expect(en.amount(1.5), '1.5');
    expect(de.amount(2), '2');
    expect(de.amount(1 / 3), '0,33');
    expect(de.amount(1250), '1.250');
    expect(en.amount(1250), '1,250');
  });

  test('quantities use fraction glyphs and the locale decimal separator', () {
    expect(de.quantity(Quantity.of(1.5)), '1½');
    expect(de.quantity(Quantity.of(0.25)), '¼');
    expect(en.quantity(Quantity.of(2.75)), '2¾');
    expect(de.quantity(Quantity.of(2.4)), '2,4');
    expect(en.quantity(Quantity.of(2.4)), '2.4');
    expect(de.quantity(Quantity.of(0.004)), '0,004');
    expect(de.quantity(Quantity.of(1250)), '1.250');
    expect(en.quantity(Quantity.of(2500000)), '2,500,000');
  });

  test('integers group thousands', () {
    expect(de.integer(12345), '12.345');
    expect(en.integer(12345), '12,345');
  });

  test('dates and times follow the locale', () {
    final evening = DateTime(2026, 10, 20, 18, 30);
    expect(de.date(evening), '20. Okt. 2026');
    expect(en.date(evening), 'Oct 20, 2026');
    expect(de.time(evening), '18:30');
    expect(en.time(evening), matches(RegExp(r'^6:30\sPM$')));
  });

  test('regional locales use their language data', () {
    expect(LocaleFormat(const Locale('de', 'AT')).amount(1.5), '1,5');
  });
}

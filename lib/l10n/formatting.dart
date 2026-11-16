import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../domain/services/scaling_service.dart';

/// Number and date formatting in the active locale ("1,5" in German,
/// "1.5" in English). Never format user-visible numbers with `toString()`.
class LocaleFormat {
  LocaleFormat(Locale locale)
    : _locale = Intl.canonicalizedLocale(locale.toString());

  /// The format for the locale of the nearest [Localizations].
  factory LocaleFormat.of(BuildContext context) =>
      LocaleFormat(Localizations.localeOf(context));

  final String _locale;

  /// An ingredient amount or other quantity: at most two decimals, no trailing
  /// zeros, grouped thousands (`1,5`, `1.000`, `0,33`).
  String amount(num value) => (NumberFormat.decimalPattern(
    _locale,
  )..maximumFractionDigits = 2).format(value);

  /// An amount to edit in a text field: up to three decimals, without
  /// thousands separators, so `parseAmount` reads it back (`1250`, `1,5`).
  String amountInput(num value) =>
      (NumberFormat.decimalPattern(_locale)
            ..maximumFractionDigits = 3
            ..turnOffGrouping())
          .format(value);

  /// A scaled ingredient amount: `1½`, `¼`, `0,3`, `1.250`. The domain has
  /// already rounded it (see [Quantity.of]).
  String quantity(Quantity value) => switch (value) {
    FractionQuantity(whole: 0, :final fraction) => fraction.symbol,
    FractionQuantity(:final whole, :final fraction) =>
      '${integer(whole)}${fraction.symbol}',
    DecimalQuantity(:final value) => (NumberFormat.decimalPattern(
      _locale,
    )..maximumFractionDigits = 6).format(value),
  };

  /// Time left on a timer: `04:12`, `1:04:12` from an hour on. The same in
  /// every locale. Rounds up, so `00:00` only shows once it is over.
  String countdown(Duration value) {
    final seconds = (value.inMilliseconds + 999) ~/ 1000;
    String two(int n) => n.toString().padLeft(2, '0');
    final clock = '${two(seconds ~/ 60 % 60)}:${two(seconds % 60)}';
    return seconds >= 3600 ? '${seconds ~/ 3600}:$clock' : clock;
  }

  /// A whole number with grouped thousands (`1.234`).
  String integer(int value) =>
      NumberFormat.decimalPattern(_locale).format(value);

  /// A calendar date with abbreviated month (`20. Okt. 2026`, `Oct 20, 2026`).
  String date(DateTime value) => DateFormat.yMMMd(_locale).format(value);

  /// A time of day in the locale's usual clock (`18:30`, `6:30 PM`).
  String time(DateTime value) => DateFormat.jm(_locale).format(value);
}

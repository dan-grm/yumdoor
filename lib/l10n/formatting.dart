import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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

  /// A whole number with grouped thousands (`1.234`).
  String integer(int value) =>
      NumberFormat.decimalPattern(_locale).format(value);

  /// A calendar date with abbreviated month (`20. Okt. 2026`, `Oct 20, 2026`).
  String date(DateTime value) => DateFormat.yMMMd(_locale).format(value);

  /// A time of day in the locale's usual clock (`18:30`, `6:30 PM`).
  String time(DateTime value) => DateFormat.jm(_locale).format(value);
}

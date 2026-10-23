// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Yumdoor';

  @override
  String get back => 'Zurück';

  @override
  String get retry => 'Nochmal versuchen';

  @override
  String get errorOffline =>
      'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.';

  @override
  String get errorUnauthorized =>
      'Deine Anmeldung gilt nicht mehr. Melde dich neu an.';

  @override
  String get errorThrottled =>
      'Zu viele Anfragen. Versuch es später noch einmal.';

  @override
  String get errorServer => 'Der Server hat einen Fehler gemeldet.';

  @override
  String get recipeNotFound =>
      'Dieses Rezept gibt es nicht, oder du darfst es nicht sehen.';

  @override
  String servings(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Portionen',
      one: '1 Portion',
    );
    return '$_temp0';
  }

  @override
  String servingsCustom(int count, String unit) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString $unit';
  }

  @override
  String get servingsDecrease => 'Weniger Portionen';

  @override
  String get servingsIncrease => 'Mehr Portionen';

  @override
  String recipeMinutes(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString Min';
  }

  @override
  String recipeRating(String rating) {
    return '$rating von 5 Sternen';
  }

  @override
  String recipeLastCooked(String date) {
    return 'zuletzt am $date';
  }

  @override
  String get recipePlan => 'Planen';

  @override
  String get recipeShop => 'Einkaufen';

  @override
  String get recipeEdit => 'Bearbeiten';

  @override
  String get recipeActionsComingSoon =>
      'Planen, Einkaufen und Bearbeiten kommen bald.';

  @override
  String get recipeIngredients => 'Zutaten';

  @override
  String recipeScaledFrom(String servings) {
    return 'Rezept ist für $servings, Mengen umgerechnet';
  }

  @override
  String get recipeNoIngredients => 'Dieses Rezept hat keine Zutaten.';

  @override
  String recipeStepTitle(int number) {
    return 'Schritt $number';
  }

  @override
  String recipeStartCooking(String servings) {
    return 'Kochen starten · $servings';
  }
}

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
  String get loginTagline => 'Verbinde dich mit deinem Tandoor-Server.';

  @override
  String get loginServerLabel => 'Server-Adresse';

  @override
  String get loginServerRequired =>
      'Gib die Adresse deines Tandoor-Servers ein.';

  @override
  String get loginServerInvalid => 'Das ist keine gültige Adresse.';

  @override
  String get loginServerChecking => 'Server wird geprüft …';

  @override
  String loginServerFound(String version) {
    return 'Tandoor $version gefunden';
  }

  @override
  String loginServerUnsupported(String version) {
    return 'Tandoor $version wird nicht unterstützt. Yumdoor braucht Tandoor 2.x.';
  }

  @override
  String get loginServerNotTandoor =>
      'Unter dieser Adresse läuft kein Tandoor 2.x.';

  @override
  String get loginServerUnreachable =>
      'Der Server ist nicht erreichbar. Prüf die Adresse und deine Verbindung.';

  @override
  String get loginServerError =>
      'Der Server hat einen Fehler gemeldet. Versuch es später noch einmal.';

  @override
  String loginServerOtherOrigin(String origin) {
    return 'Im Browser erreicht Yumdoor nur den Tandoor-Server unter $origin, weil Tandoor keine Anfragen von anderen Adressen zulässt. Für andere Server nutze die App für Android oder iOS.';
  }

  @override
  String get loginMethodLabel => 'Anmeldeart';

  @override
  String get loginMethodPassword => 'Passwort';

  @override
  String get loginMethodToken => 'API-Token';

  @override
  String get loginUsernameLabel => 'Benutzername';

  @override
  String get loginUsernameRequired => 'Gib deinen Benutzernamen ein.';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordRequired => 'Gib dein Passwort ein.';

  @override
  String get loginShowPassword => 'Passwort anzeigen';

  @override
  String get loginHidePassword => 'Passwort verbergen';

  @override
  String get loginPasswordNote =>
      'Dein Passwort wird nur gegen ein Token getauscht und nicht gespeichert.';

  @override
  String get loginTokenLabel => 'API-Token';

  @override
  String get loginTokenRequired => 'Füge dein API-Token ein.';

  @override
  String get loginTokenNote =>
      'Ein Token erstellst du in Tandoor unter Einstellungen › API-Tokens. Beim Abmelden löscht Yumdoor es nicht.';

  @override
  String get loginSubmit => 'Anmelden';

  @override
  String get loginErrorCredentials =>
      'Benutzername oder Passwort stimmt nicht.';

  @override
  String get loginErrorToken =>
      'Der Server hat dieses Token nicht angenommen. Prüf, ob es vollständig ist und noch gilt.';

  @override
  String get loginErrorThrottled =>
      'Zu viele Anmeldeversuche heute: Tandoor erlaubt zehn pro Tag. Versuch es morgen wieder oder melde dich mit einem API-Token an.';

  @override
  String get loginWhatIsTandoor => 'Was ist Tandoor?';

  @override
  String get loginWhatIsTandoorText =>
      'Tandoor ist eine freie Rezeptverwaltung, die du auf deinem eigenen Server betreibst. Yumdoor ist eine App für deinen Tandoor-Server und funktioniert nicht ohne ihn. Mehr dazu unter tandoor.dev.';

  @override
  String get logout => 'Abmelden';

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
  String get cookingClose => 'Kochmodus beenden';

  @override
  String cookingStepOf(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String cookingStepProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String cookingLastStep(int number) {
    return 'Schritt $number · Letzter';
  }

  @override
  String cookingForServings(String servings) {
    return 'für $servings';
  }

  @override
  String cookingPrevious(int number) {
    return 'Zurück zu Schritt $number';
  }

  @override
  String cookingNext(int number) {
    return 'Weiter zu Schritt $number';
  }

  @override
  String get cookingDone => 'Fertig';

  @override
  String get cookingNoSteps => 'Dieses Rezept hat keine Schritte.';

  @override
  String get cookingScreenOn => 'Bildschirm bleibt an';

  @override
  String get cookingScreenOff => 'Bildschirm anlassen';

  @override
  String get cookingScreenUnavailable => 'Bildschirm kann nicht anbleiben';

  @override
  String get cookingWakeLockHint =>
      'Dein Gerät kann den Bildschirm hier nicht anlassen. Stell die automatische Sperre zum Kochen länger ein.';

  @override
  String recipeStartCooking(String servings) {
    return 'Kochen starten · $servings';
  }

  @override
  String get searchTitle => 'Suchen';

  @override
  String get searchFieldLabel => 'Rezepte durchsuchen';

  @override
  String get searchFieldHint => 'Rezeptname';

  @override
  String get searchClear => 'Suchtext löschen';

  @override
  String get searchAddFood => 'Zutat';

  @override
  String get searchAddKeyword => 'Stichwort';

  @override
  String searchFoodFilter(String food) {
    return 'enthält $food';
  }

  @override
  String get searchFilterLoading => '…';

  @override
  String get searchFilterUnknown => 'Unbekannter Filter';

  @override
  String searchRemoveFilter(String filter) {
    return '$filter entfernen';
  }

  @override
  String searchResultCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Rezepte',
      one: '1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String get searchEmpty => 'Keine Rezepte gefunden';

  @override
  String get searchEmptyHint =>
      'Probier weniger Filter oder einen anderen Suchtext.';

  @override
  String get searchEmptyServer =>
      'Auf deinem Tandoor-Server gibt es noch keine Rezepte.';

  @override
  String get searchLoadMoreFailed =>
      'Weitere Rezepte konnten nicht geladen werden.';

  @override
  String get pickerFoodTitle => 'Zutat hinzufügen';

  @override
  String get pickerKeywordTitle => 'Stichwort hinzufügen';

  @override
  String get pickerFoodHint => 'Zutat suchen';

  @override
  String get pickerKeywordHint => 'Stichwort suchen';

  @override
  String get pickerFoodNote => 'Untergeordnete Zutaten zählen mit.';

  @override
  String get pickerEmpty => 'Nichts gefunden';
}

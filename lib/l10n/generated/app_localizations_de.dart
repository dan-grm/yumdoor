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
  String get offlineBanner =>
      'Du bist offline. Rezepte, die du schon geöffnet hast, kannst du weiter ansehen.';

  @override
  String get offlineWriteDisabled =>
      'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, geht es weiter.';

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
  String get cookingDone => 'Fertig gekocht';

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
  String get searchFieldHint => 'Rezept, Zutat oder Stichwort';

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
  String searchMatchKeyword(String keyword) {
    return 'Stichwort: $keyword';
  }

  @override
  String searchMatchOr(String first, String last) {
    return '$first oder $last';
  }

  @override
  String searchMatchList(String first, String next) {
    return '$first, $next';
  }

  @override
  String get searchMatchMore => 'weitere';

  @override
  String searchMatchJoin(String first, String second) {
    return '$first · $second';
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
  String get searchOfflineResults =>
      'Offline: Gesucht wird nur in Rezepten, die du schon geöffnet hast.';

  @override
  String get searchOfflineEmpty => 'Keins der gespeicherten Rezepte passt.';

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

  @override
  String get markdownLinkTitle => 'Link öffnen?';

  @override
  String markdownLinkText(String host) {
    return 'Der Link führt zu $host und öffnet sich in einem neuen Tab.';
  }

  @override
  String get markdownLinkOpen => 'Öffnen';

  @override
  String ingredientTickOff(String name) {
    return '$name abhaken';
  }

  @override
  String get cookingIngredientsOfStep => 'Dieser Schritt';

  @override
  String get cookingIngredientsAll => 'Alle';

  @override
  String get cookingNoStepIngredients =>
      'Für diesen Schritt brauchst du keine Zutaten.';

  @override
  String get recipeMethod => 'Zubereitung';

  @override
  String timerStart(String time) {
    return 'Timer starten · $time';
  }

  @override
  String timerHighlight(String duration) {
    return '$duration, Timer starten';
  }

  @override
  String get timerFinished => 'fertig';

  @override
  String timerChipRunning(String label, String time) {
    return '$label, noch $time';
  }

  @override
  String timerChipPaused(String label, String time) {
    return '$label, angehalten bei $time';
  }

  @override
  String timerChipFinished(String label) {
    return '$label ist fertig';
  }

  @override
  String get timerAdd => 'Timer stellen';

  @override
  String get timerManualLabel => 'Timer';

  @override
  String get timerNew => 'Neuer Timer';

  @override
  String timerMinutes(int count) {
    return '$count Min';
  }

  @override
  String get timerLess => 'Eine Minute weniger';

  @override
  String get timerMore => 'Eine Minute mehr';

  @override
  String get timerStartManual => 'Starten';

  @override
  String get timerPause => 'Anhalten';

  @override
  String get timerResume => 'Fortsetzen';

  @override
  String get timerAddMinute => '+1 Min';

  @override
  String get timerDelete => 'Timer löschen';

  @override
  String get timerTurnOff => 'Ausschalten';

  @override
  String get timerBackgroundHint =>
      'Timer melden sich nur, solange Yumdoor geöffnet ist.';

  @override
  String get searchAddRating => 'Bewertung';

  @override
  String get searchAddLastCooked => 'Zuletzt gekocht';

  @override
  String get searchAddTimesCooked => 'Gekocht';

  @override
  String get searchRatingTitle => 'Nach Bewertung filtern';

  @override
  String get searchLastCookedTitle => 'Nach letztem Kochen filtern';

  @override
  String get searchTimesTitle => 'Nach Kochhäufigkeit filtern';

  @override
  String get searchHistoryHint => 'Zählt nur deine eigenen Kochprotokolle.';

  @override
  String searchRatingOption(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: 'ab $stars Sternen',
      one: 'ab 1 Stern',
    );
    return '$_temp0';
  }

  @override
  String searchRatingFilter(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: 'ab $stars Sternen',
      one: 'ab 1 Stern',
    );
    return 'Von dir bewertet: $_temp0';
  }

  @override
  String get searchLastCookedWeeks => 'Nicht seit 2 Wochen';

  @override
  String get searchLastCookedMonth => 'Nicht seit 1 Monat';

  @override
  String get searchLastCookedMonths => 'Nicht seit 3 Monaten';

  @override
  String searchLastCookedFilter(String date) {
    return 'Von dir zuletzt gekocht bis $date';
  }

  @override
  String get searchTimesNever => 'Nie gekocht';

  @override
  String get searchTimesOften => 'Oft gekocht (mind. 5-mal)';

  @override
  String get searchTimesNeverFilter => 'Von dir nie gekocht';

  @override
  String searchTimesMinFilter(int count) {
    return 'Von dir mind. $count-mal gekocht';
  }

  @override
  String get searchOfflineTimesNote =>
      'Offline lässt sich nicht zählen, wie oft du ein Rezept gekocht hast. Gezeigt werden alle schon gekochten.';

  @override
  String get cookLogTitle => 'Guten Appetit!';

  @override
  String cookLogSubtitle(String recipe, String servings) {
    return '$recipe · $servings';
  }

  @override
  String get cookLogClose => 'Schließen, ohne zu speichern';

  @override
  String get cookLogRatingQuestion => 'Wie war\'s?';

  @override
  String cookLogRatingStar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
    );
    return '$_temp0';
  }

  @override
  String get cookLogComment => 'Kommentar (optional)';

  @override
  String get cookLogVisibility => 'Für alle in diesem Tandoor-Space sichtbar';

  @override
  String get cookLogSave => 'Speichern';

  @override
  String get cookLogSkip => 'Überspringen';

  @override
  String get cookLogSaved => 'Im Kochprotokoll gespeichert';

  @override
  String cookLogFailed(String reason) {
    return 'Nicht gespeichert. $reason';
  }

  @override
  String get recipeCooked => 'Als gekocht eintragen';

  @override
  String get searchAddCookable => 'Kochbar';

  @override
  String get searchCookableTitle => 'Nach Vorrat filtern';

  @override
  String get searchCookableHint =>
      'Zählt, was jemand in deinem Haushalt vorrätig hat, und Ersatzzutaten.';

  @override
  String get searchCookableNow => 'Jetzt kochbar';

  @override
  String get searchCookableOneMissing => 'Höchstens 1 Zutat fehlt';

  @override
  String get searchAddBook => 'Buch';

  @override
  String get searchBookTitle => 'Nach Kochbuch filtern';

  @override
  String get searchBookHint =>
      'Mehrere Bücher: Rezepte aus einem davon. Ein Buch mit gespeicherter Suche zählt nur die fest hinzugefügten Rezepte.';

  @override
  String get searchBookEmpty => 'Du hast noch keine Kochbücher.';

  @override
  String searchBookFilter(String book) {
    return 'Buch: $book';
  }

  @override
  String get searchAddCreator => 'Erstellt von';

  @override
  String get searchCreatorTitle => 'Nach Ersteller filtern';

  @override
  String searchCreatorFilter(String name) {
    return 'Erstellt von $name';
  }

  @override
  String get searchOfflineCookableNote =>
      'Offline zählt der Vorrat vom letzten Öffnen eines Rezepts, ohne Ersatzzutaten.';

  @override
  String get searchOfflineBookNote =>
      'Offline ist nicht bekannt, welche Rezepte in einem Buch stehen.';

  @override
  String get searchBookAllChosen => 'Alle deine Bücher sind schon ausgewählt.';

  @override
  String searchSortButton(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'relevance': 'passend',
      'name': 'nach Name',
      'lastCooked': 'zuletzt gekocht',
      'rating': 'nach Bewertung',
      'newest': 'neueste zuerst',
      'recentlyViewed': 'zuletzt angesehen',
      'random': 'zufällig',
      'other': 'passend',
    });
    return 'Sortiert: $_temp0';
  }

  @override
  String get searchSortTitle => 'Sortieren';

  @override
  String get searchSortHint =>
      'Zuletzt gekocht, Bewertung und Zuletzt angesehen zählen nur deine eigenen Kochprotokolle und Aufrufe.';

  @override
  String searchSortOption(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'relevance': 'Passend zur Suche',
      'name': 'Name (A–Z)',
      'lastCooked': 'Zuletzt gekocht',
      'rating': 'Beste Bewertung',
      'newest': 'Neueste zuerst',
      'recentlyViewed': 'Zuletzt angesehen',
      'random': 'Zufällig',
      'other': 'Passend zur Suche',
    });
    return '$_temp0';
  }
}

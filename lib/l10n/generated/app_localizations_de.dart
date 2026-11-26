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
  String get logoutPendingTitle => 'Abmelden?';

  @override
  String get logoutPendingBody =>
      'Was du offline auf der Einkaufsliste abgehakt hast, ist noch nicht an Tandoor gesendet. Beim Abmelden geht es verloren.';

  @override
  String get logoutPendingConfirm => 'Trotzdem abmelden';

  @override
  String get logoutPendingKeep => 'Angemeldet bleiben';

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
      'Du bist offline. Du siehst geöffnete Rezepte, Wochenplan und Einkaufsliste, wie sie zuletzt geladen wurden.';

  @override
  String get offlineWriteDisabled =>
      'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, geht es weiter.';

  @override
  String offlineAsOf(String date, String time) {
    return 'Offline · Stand vom $date, $time';
  }

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
  String recipeShopAdded(int needed) {
    final intl.NumberFormat neededNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String neededString = neededNumberFormat.format(needed);

    String _temp0 = intl.Intl.pluralLogic(
      needed,
      locale: localeName,
      other: '$neededString Zutaten',
      one: '1 Zutat',
    );
    return '$_temp0 auf der Liste';
  }

  @override
  String recipeShopAddedOnHand(int needed, int onHand) {
    final intl.NumberFormat neededNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String neededString = neededNumberFormat.format(needed);
    final intl.NumberFormat onHandNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String onHandString = onHandNumberFormat.format(onHand);

    String _temp0 = intl.Intl.pluralLogic(
      needed,
      locale: localeName,
      other: '$neededString Zutaten',
      one: '1 Zutat',
    );
    return '$_temp0 auf der Liste · $onHandString hast du schon';
  }

  @override
  String get recipeShopNothing =>
      'Alles hast du schon, es kommt nichts auf die Liste.';

  @override
  String get recipeShopNoIngredients =>
      'Das Rezept hat keine Zutaten für die Einkaufsliste.';

  @override
  String get recipeShopOpen => 'Zur Liste';

  @override
  String recipeShopFailed(String reason) {
    return 'Nicht auf die Liste gekommen. $reason';
  }

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

  @override
  String get searchSavedSave => 'Suche speichern';

  @override
  String get searchSavedSaveHint =>
      'Text und Filter werden unter diesem Namen in Tandoor gespeichert.';

  @override
  String get searchSavedName => 'Name';

  @override
  String get searchSavedNameEmpty => 'Gib einen Namen ein.';

  @override
  String get searchSavedConfirm => 'Speichern';

  @override
  String searchSavedSaved(String name) {
    return '„$name“ gespeichert';
  }

  @override
  String searchSavedFailed(String reason) {
    return 'Das hat nicht geklappt. $reason';
  }

  @override
  String get searchSavedManage => 'Verwalten';

  @override
  String get searchSavedManageTitle => 'Gespeicherte Suchen';

  @override
  String get searchSavedManageHint =>
      'Umbenennen und löschen kannst du deine eigenen; geteilte nur verwenden.';

  @override
  String get searchSavedNone => 'Du hast noch keine Suche gespeichert.';

  @override
  String get searchSavedShared => 'Mit dir geteilt';

  @override
  String get searchSavedRenameTitle => 'Suche umbenennen';

  @override
  String searchSavedRenameLabel(String name) {
    return '$name umbenennen';
  }

  @override
  String searchSavedDeleteLabel(String name) {
    return '$name löschen';
  }

  @override
  String searchSavedDeleteTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get searchSavedDeleteText =>
      'Die Suche wird auch in Tandoor gelöscht, für alle, mit denen sie geteilt ist. Ein Kochbuch mit dieser Suche zeigt danach nur noch seine fest hinzugefügten Rezepte. Rezepte bleiben erhalten.';

  @override
  String get searchSavedDelete => 'Löschen';

  @override
  String searchSavedFilter(String name) {
    return 'Gespeichert: $name';
  }

  @override
  String get searchOfflineSavedNote =>
      'Offline lässt sich diese gespeicherte Suche nicht anwenden.';

  @override
  String get searchSavedNameTaken =>
      'Eine gespeicherte Suche mit diesem Namen gibt es schon.';

  @override
  String get searchSavedNameConflict =>
      'Nicht gespeichert. In Tandoor gibt es den Namen vielleicht schon – versuch einen anderen.';

  @override
  String searchPickTitle(String day) {
    return 'Rezept für $day';
  }

  @override
  String get searchNewRecipe => 'Neues Rezept';

  @override
  String get editorCancel => 'Abbrechen';

  @override
  String get editorSave => 'Speichern';

  @override
  String get editorSaving => 'Wird gespeichert …';

  @override
  String get editorTitleEdit => 'Bearbeiten';

  @override
  String get editorTitleNew => 'Neues Rezept';

  @override
  String get editorTabGeneral => 'Allgemein';

  @override
  String get editorTabIngredients => 'Zutaten';

  @override
  String get editorTabSteps => 'Schritte';

  @override
  String get editorTabIngredientsSteps => 'Zutaten & Schritte';

  @override
  String get editorShortcuts =>
      'Tastenkürzel: Strg/Cmd+S speichert, Esc bricht ab, Alt+1 bis Alt+3 wechseln den Tab, Alt+Pfeil hoch/runter verschiebt einen Schritt, Enter fügt eine Zutat hinzu.';

  @override
  String get stepsEmpty => 'Noch keine Schritte. Füge unten den ersten hinzu.';

  @override
  String get stepAdd => 'Schritt hinzufügen';

  @override
  String get stepEmptyPreview => 'Noch kein Text';

  @override
  String stepExpand(int number) {
    return 'Schritt $number aufklappen';
  }

  @override
  String stepCollapse(int number) {
    return 'Schritt $number zuklappen';
  }

  @override
  String stepDragHandle(int number) {
    return 'Schritt $number verschieben';
  }

  @override
  String stepActions(int number) {
    return 'Aktionen für Schritt $number';
  }

  @override
  String get stepMoveUp => 'Nach oben';

  @override
  String get stepMoveDown => 'Nach unten';

  @override
  String get stepDelete => 'Schritt löschen';

  @override
  String stepDeleteTitle(int number) {
    return 'Schritt $number löschen?';
  }

  @override
  String stepDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Der Text und die $count Zutaten dieses Schritts werden gelöscht.',
      one: 'Der Text und die Zutat dieses Schritts werden gelöscht.',
      zero: 'Der Text dieses Schritts wird gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get stepInstruction => 'Anleitung';

  @override
  String get stepName => 'Name (optional)';

  @override
  String get stepIngredients => 'Zutaten in diesem Schritt';

  @override
  String get stepAddIngredient => 'Zutat';

  @override
  String stepAddIngredientTooltip(int number) {
    return 'Zutat zu Schritt $number hinzufügen';
  }

  @override
  String stepRemoveIngredient(String name) {
    return '$name aus diesem Schritt entfernen';
  }

  @override
  String stepMoveIngredient(String name) {
    return '$name in einen anderen Schritt verschieben';
  }

  @override
  String stepMoveIngredientTo(int number) {
    return 'Nach Schritt $number';
  }

  @override
  String get stepDuration => 'Dauer';

  @override
  String get stepDurationUnit => 'Min';

  @override
  String get stepDurationHelp => 'wird als Timer angeboten';

  @override
  String stepTemplateWarning(int number) {
    return 'Der Text von Schritt $number verweist auf Zutaten nach ihrer Position (ingredients[0]). Prüfe, ob er noch passt.';
  }

  @override
  String get editorName => 'Name';

  @override
  String get editorDescription => 'Beschreibung';

  @override
  String get editorDescriptionHelp =>
      'Markdown geht, z. B. **fett** oder *kursiv*.';

  @override
  String get editorServings => 'Portionen';

  @override
  String get editorServingsText => 'Bezeichnung';

  @override
  String get editorServingsTextHint => 'z. B. Stück';

  @override
  String get editorWorkingTime => 'Arbeitszeit (Min.)';

  @override
  String get editorWaitingTime => 'Wartezeit (Min.)';

  @override
  String get editorKeywords => 'Stichwörter';

  @override
  String get editorAddKeyword => 'Stichwort';

  @override
  String get editorAddKeywordTooltip => 'Stichwort hinzufügen';

  @override
  String editorRemoveKeyword(String keyword) {
    return '$keyword entfernen';
  }

  @override
  String get editorSource => 'Quelle';

  @override
  String get editorSourceHint => 'https://…';

  @override
  String get editorNameMissing => 'Gib dem Rezept einen Namen.';

  @override
  String editorTooLong(int max) {
    return 'Höchstens $max Zeichen.';
  }

  @override
  String get editorServingsTooSmall => 'Mindestens 1.';

  @override
  String get editorProblems => 'Bitte prüf die markierten Felder.';

  @override
  String editorSaveFailed(String reason) {
    return 'Nicht gespeichert. $reason';
  }

  @override
  String get editorForbidden =>
      'Nicht gespeichert: Du darfst dieses Rezept nicht ändern. Deine Änderungen sind noch da.';

  @override
  String get editorRecipeGone => 'Dieses Rezept gibt es nicht mehr.';

  @override
  String get editorSaved => 'Rezept gespeichert';

  @override
  String get editorDiscardTitle => 'Änderungen verwerfen?';

  @override
  String get editorDiscardBody =>
      'Deine Änderungen an diesem Rezept sind noch nicht gespeichert.';

  @override
  String get editorDiscardKeepEditing => 'Weiter bearbeiten';

  @override
  String get editorDiscard => 'Verwerfen';

  @override
  String get editorDraftTitle => 'Ungespeicherter Entwurf';

  @override
  String editorDraftBody(String date, String time) {
    return 'Du hast hier am $date um $time Änderungen gemacht, die nicht gespeichert sind.';
  }

  @override
  String get editorDraftStale =>
      'Das Rezept wurde danach auf dem Server geändert. Speicherst du den Entwurf, überschreibt er diese Änderungen.';

  @override
  String get editorDraftRestore => 'Entwurf wiederherstellen';

  @override
  String get editorDraftDiscard => 'Verwerfen';

  @override
  String get keywordPickerTitle => 'Stichwort hinzufügen';

  @override
  String get keywordPickerHint => 'Stichwort suchen oder anlegen';

  @override
  String get foodPickerTitle => 'Zutat wählen';

  @override
  String get foodPickerHint => 'Zutat suchen oder anlegen';

  @override
  String get unitPickerTitle => 'Einheit wählen';

  @override
  String get unitPickerHint => 'Einheit suchen oder anlegen';

  @override
  String ingredientsBaseServings(String servings) {
    return 'Mengen für $servings (Grundrezept)';
  }

  @override
  String get ingredientsEmpty =>
      'Noch keine Zutaten. Gib unten eine Zeile ein, z. B. „200 g Karotten“.';

  @override
  String get ingredientEntryLabel => 'Zutat hinzufügen';

  @override
  String get ingredientEntryHint => 'z. B. 200 g Karotten, geschält';

  @override
  String get ingredientEntryAdd => 'Hinzufügen';

  @override
  String ingredientEntryAdded(String ingredient) {
    return '$ingredient hinzugefügt';
  }

  @override
  String ingredientEntryUnparsed(String line) {
    return '„$line“ nicht erkannt und als Notiz übernommen. Tipp die Zeile an, um eine Zutat zu wählen.';
  }

  @override
  String ingredientEntryFailed(String reason) {
    return 'Nicht hinzugefügt. $reason';
  }

  @override
  String get ingredientEntryDone => 'Fertig';

  @override
  String get ingredientAddHeader => 'Abschnitt hinzufügen';

  @override
  String get ingredientHeaderTitle => 'Abschnitt';

  @override
  String get ingredientHeaderLabel => 'Überschrift';

  @override
  String get ingredientHeaderHint => 'z. B. Für den Teig';

  @override
  String get ingredientEditTitle => 'Zutat bearbeiten';

  @override
  String get ingredientAmount => 'Menge';

  @override
  String get ingredientAmountInvalid => 'Eine Zahl wie 1,5 oder ½.';

  @override
  String get ingredientUnit => 'Einheit';

  @override
  String get ingredientNoUnit => 'Keine';

  @override
  String get ingredientRemoveUnit => 'Einheit entfernen';

  @override
  String get ingredientFood => 'Zutat';

  @override
  String get ingredientNote => 'Notiz';

  @override
  String get ingredientNoAmount => 'Ohne Menge';

  @override
  String get ingredientApply => 'Übernehmen';

  @override
  String ingredientActions(String name) {
    return 'Aktionen für $name';
  }

  @override
  String get ingredientEdit => 'Bearbeiten';

  @override
  String get ingredientMoveUp => 'Nach oben';

  @override
  String get ingredientMoveDown => 'Nach unten';

  @override
  String get ingredientDelete => 'Löschen';

  @override
  String get ingredientUnnamed => 'Ohne Zutat';

  @override
  String pickerCreate(String name) {
    return '„$name“ anlegen';
  }

  @override
  String pickerCreateFailed(String reason) {
    return 'Nicht angelegt. $reason';
  }

  @override
  String get editorImage => 'Foto';

  @override
  String get editorImageTakePhoto => 'Foto aufnehmen';

  @override
  String get editorImagePick => 'Bild auswählen';

  @override
  String get editorImageRemove => 'Entfernen';

  @override
  String get editorImageNone => 'Noch kein Foto';

  @override
  String get editorImageDrop => 'Bild hierher ziehen';

  @override
  String get editorImageDropRelease => 'Loslassen, um das Bild zu verwenden';

  @override
  String get editorImagePending => 'Wird beim Speichern hochgeladen.';

  @override
  String get editorImageRemoved => 'Das Foto wird beim Speichern entfernt.';

  @override
  String get editorImageNotAnImage =>
      'Das ist kein Bild. Es gehen JPEG, PNG, WebP und GIF.';

  @override
  String editorImageTooLarge(int megabytes) {
    return 'Das Bild ist größer als $megabytes MB.';
  }

  @override
  String get editorImageUnreadable => 'Die Datei ließ sich nicht lesen.';

  @override
  String editorImageNotSaved(String reason) {
    return 'Rezept gespeichert, das Foto aber nicht. $reason';
  }

  @override
  String get editorImageServerTooLarge =>
      'Der Server nimmt so große Bilder nicht an.';

  @override
  String get editorImageInterrupted =>
      'Die Verbindung brach beim Hochladen ab. Vielleicht ist das Bild zu groß für den Server.';

  @override
  String get editorDelete => 'Rezept löschen';

  @override
  String get editorDeleteTitle => 'Rezept löschen?';

  @override
  String editorDeleteBody(String name) {
    return '„$name“ wird endgültig gelöscht. Dazu gehören auch die Einträge im Kochprotokoll, im Essensplan, in Büchern und in Einkaufslisten. Das lässt sich nicht rückgängig machen.';
  }

  @override
  String get editorDeleteKeep => 'Behalten';

  @override
  String get editorDeleteConfirm => 'Endgültig löschen';

  @override
  String get editorDeleted => 'Rezept gelöscht';

  @override
  String editorDeleteFailed(String reason) {
    return 'Nicht gelöscht. $reason';
  }

  @override
  String get editorDeleteForbidden =>
      'Nicht gelöscht: Du darfst dieses Rezept nicht löschen.';

  @override
  String get editorDeleteInUse =>
      'Nicht gelöscht: Vielleicht wird das Rezept in einem anderen Rezept als Schritt verwendet. Dann lässt Tandoor das Löschen nicht zu.';

  @override
  String get navSearch => 'Suchen';

  @override
  String get navPlan => 'Planer';

  @override
  String get navShopping => 'Einkauf';

  @override
  String get navPlanTitle => 'Wochenplan';

  @override
  String get navShoppingTitle => 'Einkaufsliste';

  @override
  String get planWeekPrevious => 'Vorherige Woche';

  @override
  String get planWeekNext => 'Nächste Woche';

  @override
  String get planThisWeek => 'Diese Woche';

  @override
  String get planBackToThisWeek => 'Zu dieser Woche';

  @override
  String get planAddRecipe => 'Rezept planen';

  @override
  String get planEmptyWeek => 'In dieser Woche ist noch nichts geplant.';

  @override
  String planRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String planMealLine(String meal, String servings) {
    return '$meal · $servings Port.';
  }

  @override
  String planDayLabel(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String planToday(String day) {
    return 'Heute, $day';
  }

  @override
  String get planSharedWithHousehold => 'Geteilt mit deinem Haushalt';

  @override
  String get planFilterAll => 'Alle';

  @override
  String get planFilterMine => 'Nur meine';

  @override
  String planPlannedBy(String name) {
    return 'Geplant von $name';
  }

  @override
  String get planPlannedByOther => 'Von jemand anderem geplant';

  @override
  String get planSheetTitle => 'Einplanen';

  @override
  String get planSheetDay => 'Tag';

  @override
  String get planSheetMealType => 'Mahlzeit';

  @override
  String get planSheetServings => 'Portionen';

  @override
  String planSheetDayHasPlans(String day) {
    return '$day, schon etwas geplant';
  }

  @override
  String get planSheetAddMissing => 'Fehlendes auf die Einkaufsliste';

  @override
  String planSheetMissing(int missing, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing von $total Zutaten fehlen noch',
      one: '1 von $total Zutaten fehlt noch',
    );
    return '$_temp0';
  }

  @override
  String get planSheetNothingMissing => 'Alle Zutaten sind schon da.';

  @override
  String get planSheetNoIngredients =>
      'Das Rezept hat keine Zutaten für die Einkaufsliste.';

  @override
  String get planSheetIngredientsFailed =>
      'Die Zutaten konnten nicht geladen werden.';

  @override
  String get planSheetNoMealTypes =>
      'Auf diesem Server gibt es noch keine Mahlzeiten wie Frühstück oder Abendessen. Leg die erste an.';

  @override
  String get planSheetMealTypeName => 'Name der Mahlzeit';

  @override
  String get planSheetMealTypeHint => 'z. B. Abendessen';

  @override
  String get planSheetMealTypeCreate => 'Mahlzeit anlegen';

  @override
  String planSheetMealTypeCreateFailed(String reason) {
    return 'Die Mahlzeit wurde nicht angelegt. $reason';
  }

  @override
  String planSheetSubmit(String day) {
    return 'Für $day einplanen';
  }

  @override
  String get planSheetSubmitToday => 'Für heute einplanen';

  @override
  String planSheetSaveFailed(String reason) {
    return 'Nicht eingeplant. $reason';
  }

  @override
  String planSaved(String day) {
    return 'Für $day eingeplant.';
  }

  @override
  String planSavedWithShopping(String day) {
    return 'Für $day eingeplant, Fehlendes steht auf der Einkaufsliste.';
  }

  @override
  String planSavedShoppingFailed(String day, String reason) {
    return 'Für $day eingeplant, aber nicht auf die Einkaufsliste gesetzt. $reason';
  }

  @override
  String get planSavedOpen => 'Zum Plan';

  @override
  String planMealMenu(String name) {
    return 'Optionen für $name';
  }

  @override
  String get planEdit => 'Bearbeiten';

  @override
  String get planMove => 'Verschieben';

  @override
  String get planDelete => 'Löschen';

  @override
  String get planDropHere => 'Hier ablegen';

  @override
  String planMoved(String day) {
    return 'Auf $day verschoben.';
  }

  @override
  String planMoveFailed(String reason) {
    return 'Nicht verschoben. $reason';
  }

  @override
  String get planMoveTitle => 'Mahlzeit verschieben';

  @override
  String planMoveSubmit(String day) {
    return 'Auf $day verschieben';
  }

  @override
  String get planEditTitle => 'Mahlzeit bearbeiten';

  @override
  String get planEditSave => 'Speichern';

  @override
  String get planEditShoppingNote =>
      'Steht auf der Einkaufsliste. Änderst du die Portionen, passen sich die Mengen dort an.';

  @override
  String get planEditSaved => 'Gespeichert.';

  @override
  String planEditFailed(String reason) {
    return 'Nicht gespeichert. $reason';
  }

  @override
  String get planDeleteTitle => 'Mahlzeit löschen?';

  @override
  String planDeleteBody(String name) {
    return '„$name“ wird für alle im Haushalt aus dem Plan gelöscht.';
  }

  @override
  String planDeleteBodyShopping(String name) {
    return '„$name“ wird für alle im Haushalt aus dem Plan gelöscht, und seine Zutaten verschwinden von der Einkaufsliste.';
  }

  @override
  String get planDeleteKeep => 'Behalten';

  @override
  String get planDeleted => 'Aus dem Plan gelöscht.';

  @override
  String planDeleteFailed(String reason) {
    return 'Nicht gelöscht. $reason';
  }

  @override
  String planServingsCustom(String servings, String unit) {
    return '$servings $unit';
  }

  @override
  String get planWeekShoppingTitle => 'Einkauf für die Woche';

  @override
  String planWeekShoppingCount(int needed, int onHand) {
    final intl.NumberFormat neededNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String neededString = neededNumberFormat.format(needed);
    final intl.NumberFormat onHandNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String onHandString = onHandNumberFormat.format(onHand);

    String _temp0 = intl.Intl.pluralLogic(
      needed,
      locale: localeName,
      other: '$neededString Zutaten',
      one: '1 Zutat',
    );
    return '$_temp0 · $onHandString hast du schon';
  }

  @override
  String get planWeekShoppingCounting => 'Zutaten werden gezählt …';

  @override
  String get planWeekShoppingCountFailed =>
      'Die Zutaten konnten nicht gezählt werden.';

  @override
  String get planWeekShoppingDone =>
      'Alles für diese Woche steht schon auf der Liste.';

  @override
  String get planWeekShoppingAdd => 'Alles auf die Liste';

  @override
  String get planWeekShoppingOpen => 'Zur Liste';

  @override
  String planWeekShoppingProgress(int done, int total) {
    return 'Mahlzeit $done von $total …';
  }

  @override
  String planWeekShoppingFailed(String meals) {
    return 'Nicht auf die Liste gekommen: $meals. Die anderen stehen drauf.';
  }

  @override
  String shoppingShared(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Geteilt mit deinem Haushalt · $countString offen';
  }

  @override
  String shoppingSupermarket(String name) {
    return 'Supermarkt: $name';
  }

  @override
  String get shoppingSupermarketNone => 'Supermarkt wählen';

  @override
  String get shoppingSupermarketTitle => 'Supermarkt';

  @override
  String get shoppingSupermarketHint =>
      'Die Abteilungen kommen in der Reihenfolge dieses Ladens. Gilt nur auf diesem Gerät.';

  @override
  String get shoppingSupermarketByName => 'Keiner (Abteilungen nach Name)';

  @override
  String get shoppingUncategorized => 'Sonstiges';

  @override
  String shoppingAddedBy(String names) {
    return 'von $names hinzugefügt';
  }

  @override
  String get shoppingAddedByMe => 'dir';

  @override
  String shoppingNamesAnd(String first, String last) {
    return '$first und $last';
  }

  @override
  String shoppingAmountMore(String amount) {
    return '$amount +';
  }

  @override
  String shoppingDone(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Erledigt · $countString';
  }

  @override
  String get shoppingEmpty => 'Die Einkaufsliste ist leer.';

  @override
  String get shoppingEmptyHint =>
      'Zutaten kommen vom Rezept oder aus dem Wochenplan auf die Liste.';

  @override
  String get shoppingAllDone => 'Alles erledigt.';

  @override
  String shoppingChecked(String name) {
    return '$name abgehakt';
  }

  @override
  String shoppingUnchecked(String name) {
    return '$name wieder auf der Liste';
  }

  @override
  String get shoppingUndo => 'Rückgängig';

  @override
  String get shoppingSyncing => 'wird synchronisiert';

  @override
  String shoppingPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Änderungen noch nicht gesendet',
      one: '1 Änderung noch nicht gesendet',
    );
    return '$_temp0';
  }

  @override
  String shoppingCheckFailed(String name, String reason) {
    return '$name nicht abgehakt. $reason';
  }

  @override
  String shoppingUncheckFailed(String name, String reason) {
    return '$name nicht wieder auf die Liste gesetzt. $reason';
  }

  @override
  String shoppingRefreshFailed(String reason) {
    return 'Nicht aktualisiert. $reason';
  }

  @override
  String shoppingTruncated(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Tandoor schickt höchstens $countString Einträge. Die neuesten fehlen hier vielleicht.';
  }

  @override
  String get shoppingAddLabel => 'Artikel hinzufügen';

  @override
  String get shoppingAddHint => 'Artikel hinzufügen';

  @override
  String shoppingAdded(String name) {
    return '$name auf die Liste gesetzt';
  }

  @override
  String shoppingAddFailed(String reason) {
    return 'Nicht hinzugefügt. $reason';
  }

  @override
  String shoppingAddUnparsed(String text) {
    return '„$text“ habe ich nicht verstanden. Versuch es mit Menge und Artikel, etwa „2 Zitronen“.';
  }

  @override
  String shoppingActions(String name) {
    return 'Mehr zu $name';
  }

  @override
  String get shoppingShowSources => 'Herkunft der Artikel';

  @override
  String get shoppingSelectMany => 'Mehrere auswählen';

  @override
  String shoppingSelect(String name) {
    return '$name auswählen';
  }

  @override
  String get shoppingSelectionEnd => 'Auswahl beenden';

  @override
  String shoppingSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get shoppingDeleteSelected => 'Ausgewählte löschen';

  @override
  String shoppingDeletedSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel gelöscht',
      one: '1 Artikel gelöscht',
    );
    return '$_temp0';
  }

  @override
  String shoppingDeleteSelectedFailed(String reason) {
    return 'Nicht alles gelöscht. $reason';
  }

  @override
  String shoppingRestoreSelectedFailed(String reason) {
    return 'Nicht zurückgeholt. $reason';
  }

  @override
  String get shoppingOnHand => 'Habe ich da';

  @override
  String get shoppingOnHandHint =>
      '„Habe ich da“ gilt für den ganzen Haushalt und hakt den Eintrag ab.';

  @override
  String get shoppingDelete => 'Löschen';

  @override
  String get shoppingRename => 'Umbenennen';

  @override
  String get shoppingRenameTitle => 'Artikel umbenennen';

  @override
  String get shoppingRenameHint =>
      'Gilt für den ganzen Haushalt. Gibt es in Tandoor schon ein Lebensmittel mit diesem Namen, kommt der Artikel dorthin, sonst wird es angelegt. Rezepte bleiben, wie sie sind.';

  @override
  String get shoppingRenameLabel => 'Name';

  @override
  String get shoppingRenameEmpty => 'Gib einen Namen ein.';

  @override
  String shoppingRenameTooLong(int max) {
    return 'Höchstens $max Zeichen.';
  }

  @override
  String shoppingRenamed(String name, String newName) {
    return '$name heißt jetzt $newName';
  }

  @override
  String shoppingRenameFailed(String name, String reason) {
    return '$name nicht umbenannt. $reason';
  }

  @override
  String shoppingRenameChecked(String name) {
    return '$name ist inzwischen abgehakt und wurde nicht umbenannt.';
  }

  @override
  String shoppingRenameNothing(String name) {
    return '$name ist unverändert: Tandoor kennt den Namen schon als dieses Lebensmittel, oder es wurde gerade abgehakt.';
  }

  @override
  String shoppingOnHandDone(String name) {
    return '$name ist als vorrätig markiert';
  }

  @override
  String shoppingOnHandFailed(String name, String reason) {
    return '$name nicht als vorrätig markiert. $reason';
  }

  @override
  String shoppingDeleted(String name) {
    return '$name gelöscht';
  }

  @override
  String shoppingDeleteFailed(String name, String reason) {
    return '$name nicht gelöscht. $reason';
  }

  @override
  String shoppingRestoreFailed(String name, String reason) {
    return '$name nicht zurückgeholt. $reason';
  }

  @override
  String get settingsOpen => 'Einstellungen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsName => 'Name';

  @override
  String get settingsUsername => 'Benutzername';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsTandoorVersion => 'Tandoor-Version';

  @override
  String get settingsUnavailable => 'nicht verfügbar';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAbout => 'Über Yumdoor';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Lizenz';

  @override
  String get settingsSource => 'Quellcode';

  @override
  String get settingsAuthTitle => 'Authentication';

  @override
  String get settingsAuthBody =>
      'Yumdoor speichert nur ein Zugriffstoken, nie dein Passwort. In der App liegt es im sicheren Speicher des Geräts. Im Browser gibt es keinen sicheren Speicher: Der Token liegt im lokalen Speicher der Seite, verschlüsselt, aber der Schlüssel liegt daneben. Da Yumdoor im Browser dieselbe Adresse wie Tandoor nutzt, könnte eine Sicherheitslücke in Tandoors eigener Oberfläche den Token lesen, so wie sie schon jetzt in deinem Namen handeln könnte. Dieses Risiko nehmen wir in Kauf.';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get keywordPickerSearchHint => 'Stichwort suchen';

  @override
  String get settingsSeasonal => 'Saisonale Vorschläge';

  @override
  String get settingsSeasonalBody =>
      'Stichwörter, die in einem Monat Saison haben. Passende Rezepte erscheinen dann als Vorschlag.';

  @override
  String settingsSeasonalAdd(String month) {
    return 'Stichwort für $month hinzufügen';
  }

  @override
  String settingsSeasonalRemove(String keyword, String month) {
    return '$keyword aus $month entfernen';
  }

  @override
  String get settingsSeasonalCopy => 'Für mehrere Monate übernehmen';

  @override
  String settingsSeasonalCopyTitle(String month) {
    return 'Stichwörter von $month übernehmen';
  }

  @override
  String get settingsSeasonalCopyBody =>
      'Ersetzt die Stichwörter der gewählten Monate.';

  @override
  String get settingsSeasonalCopyApply => 'Übernehmen';
}

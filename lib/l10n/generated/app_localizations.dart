import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Product name, shown as the browser tab title and on the start screen.
  ///
  /// In de, this message translates to:
  /// **'Yumdoor'**
  String get appTitle;

  /// Subtitle under the app name on the login screen.
  ///
  /// In de, this message translates to:
  /// **'Verbinde dich mit deinem Tandoor-Server.'**
  String get loginTagline;

  /// Label of the server URL field on the login screen.
  ///
  /// In de, this message translates to:
  /// **'Server-Adresse'**
  String get loginServerLabel;

  /// Validation message when the server URL field is empty.
  ///
  /// In de, this message translates to:
  /// **'Gib die Adresse deines Tandoor-Servers ein.'**
  String get loginServerRequired;

  /// Shown under the server URL field when the text can't be a URL.
  ///
  /// In de, this message translates to:
  /// **'Das ist keine gültige Adresse.'**
  String get loginServerInvalid;

  /// Shown under the server URL field while the version check runs.
  ///
  /// In de, this message translates to:
  /// **'Server wird geprüft …'**
  String get loginServerChecking;

  /// Shown under the server URL field when a supported Tandoor answered.
  ///
  /// In de, this message translates to:
  /// **'Tandoor {version} gefunden'**
  String loginServerFound(String version);

  /// Shown when the server runs a Tandoor version other than 2.x.
  ///
  /// In de, this message translates to:
  /// **'Tandoor {version} wird nicht unterstützt. Yumdoor braucht Tandoor 2.x.'**
  String loginServerUnsupported(String version);

  /// Shown when something answered at the URL, but not Tandoor.
  ///
  /// In de, this message translates to:
  /// **'Unter dieser Adresse läuft kein Tandoor 2.x.'**
  String get loginServerNotTandoor;

  /// Shown when the server URL can't be reached, or login fails for lack of a connection.
  ///
  /// In de, this message translates to:
  /// **'Der Server ist nicht erreichbar. Prüf die Adresse und deine Verbindung.'**
  String get loginServerUnreachable;

  /// Shown when the server answers the version check or login with an unexpected error.
  ///
  /// In de, this message translates to:
  /// **'Der Server hat einen Fehler gemeldet. Versuch es später noch einmal.'**
  String get loginServerError;

  /// Shown in the web build when the entered server is on a different origin than the app.
  ///
  /// In de, this message translates to:
  /// **'Im Browser erreicht Yumdoor nur den Tandoor-Server unter {origin}, weil Tandoor keine Anfragen von anderen Adressen zulässt. Für andere Server nutze die App für Android oder iOS.'**
  String loginServerOtherOrigin(String origin);

  /// Accessible label of the password / API token switch.
  ///
  /// In de, this message translates to:
  /// **'Anmeldeart'**
  String get loginMethodLabel;

  /// Tab for logging in with username and password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get loginMethodPassword;

  /// Tab for logging in with a pasted API token.
  ///
  /// In de, this message translates to:
  /// **'API-Token'**
  String get loginMethodToken;

  /// Label of the username field.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get loginUsernameLabel;

  /// Validation message when the username field is empty.
  ///
  /// In de, this message translates to:
  /// **'Gib deinen Benutzernamen ein.'**
  String get loginUsernameRequired;

  /// Label of the password field.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get loginPasswordLabel;

  /// Validation message when the password field is empty.
  ///
  /// In de, this message translates to:
  /// **'Gib dein Passwort ein.'**
  String get loginPasswordRequired;

  /// Accessible label of the button that reveals the password.
  ///
  /// In de, this message translates to:
  /// **'Passwort anzeigen'**
  String get loginShowPassword;

  /// Accessible label of the button that hides the password again.
  ///
  /// In de, this message translates to:
  /// **'Passwort verbergen'**
  String get loginHidePassword;

  /// Reassurance under the password field.
  ///
  /// In de, this message translates to:
  /// **'Dein Passwort wird nur gegen ein Token getauscht und nicht gespeichert.'**
  String get loginPasswordNote;

  /// Label of the API token field.
  ///
  /// In de, this message translates to:
  /// **'API-Token'**
  String get loginTokenLabel;

  /// Validation message when the token field is empty.
  ///
  /// In de, this message translates to:
  /// **'Füge dein API-Token ein.'**
  String get loginTokenRequired;

  /// Hint under the API token field.
  ///
  /// In de, this message translates to:
  /// **'Ein Token erstellst du in Tandoor unter Einstellungen › API-Tokens. Beim Abmelden löscht Yumdoor es nicht.'**
  String get loginTokenNote;

  /// Main button of the login screen.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get loginSubmit;

  /// Login error for a wrong username or password.
  ///
  /// In de, this message translates to:
  /// **'Benutzername oder Passwort stimmt nicht.'**
  String get loginErrorCredentials;

  /// Login error when the server rejects a pasted API token.
  ///
  /// In de, this message translates to:
  /// **'Der Server hat dieses Token nicht angenommen. Prüf, ob es vollständig ist und noch gilt.'**
  String get loginErrorToken;

  /// Login error when Tandoor's daily password login limit (HTTP 429) is reached.
  ///
  /// In de, this message translates to:
  /// **'Zu viele Anmeldeversuche heute: Tandoor erlaubt zehn pro Tag. Versuch es morgen wieder oder melde dich mit einem API-Token an.'**
  String get loginErrorThrottled;

  /// Link at the bottom of the login screen that explains Tandoor.
  ///
  /// In de, this message translates to:
  /// **'Was ist Tandoor?'**
  String get loginWhatIsTandoor;

  /// Explanation in the dialog opened from 'What is Tandoor?'.
  ///
  /// In de, this message translates to:
  /// **'Tandoor ist eine freie Rezeptverwaltung, die du auf deinem eigenen Server betreibst. Yumdoor ist eine App für deinen Tandoor-Server und funktioniert nicht ohne ihn. Mehr dazu unter tandoor.dev.'**
  String get loginWhatIsTandoorText;

  /// Action that ends the session.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get logout;

  /// Accessible label of the round back button in top bars.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get back;

  /// Button under an error message that repeats the failed request.
  ///
  /// In de, this message translates to:
  /// **'Nochmal versuchen'**
  String get retry;

  /// Error message when the Tandoor server cannot be reached.
  ///
  /// In de, this message translates to:
  /// **'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.'**
  String get errorOffline;

  /// Error message when the token is invalid or lacks permission.
  ///
  /// In de, this message translates to:
  /// **'Deine Anmeldung gilt nicht mehr. Melde dich neu an.'**
  String get errorUnauthorized;

  /// Error message when the server rate-limits requests (HTTP 429).
  ///
  /// In de, this message translates to:
  /// **'Zu viele Anfragen. Versuch es später noch einmal.'**
  String get errorThrottled;

  /// Error message for unexpected server errors.
  ///
  /// In de, this message translates to:
  /// **'Der Server hat einen Fehler gemeldet.'**
  String get errorServer;

  /// Banner at the top of every screen while the server can't be reached.
  ///
  /// In de, this message translates to:
  /// **'Du bist offline. Rezepte, die du schon geöffnet hast, kannst du weiter ansehen.'**
  String get offlineBanner;

  /// Tooltip and caption explaining why actions that change data are disabled while offline.
  ///
  /// In de, this message translates to:
  /// **'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, geht es weiter.'**
  String get offlineWriteDisabled;

  /// Error message when a recipe does not exist or is not visible to the user.
  ///
  /// In de, this message translates to:
  /// **'Dieses Rezept gibt es nicht, oder du darfst es nicht sehen.'**
  String get recipeNotFound;

  /// Number of servings, used when the recipe does not name its own serving unit.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Portion} other{{count} Portionen}}'**
  String servings(int count);

  /// Number of servings with the recipe's own serving unit, e.g. '12 Stück'.
  ///
  /// In de, this message translates to:
  /// **'{count} {unit}'**
  String servingsCustom(int count, String unit);

  /// Accessible label of the minus button in the servings picker.
  ///
  /// In de, this message translates to:
  /// **'Weniger Portionen'**
  String get servingsDecrease;

  /// Accessible label of the plus button in the servings picker.
  ///
  /// In de, this message translates to:
  /// **'Mehr Portionen'**
  String get servingsIncrease;

  /// Total time of a recipe in the meta line under its title.
  ///
  /// In de, this message translates to:
  /// **'{minutes} Min'**
  String recipeMinutes(int minutes);

  /// Screen reader text for the user's own average rating; shown as the number and a star icon.
  ///
  /// In de, this message translates to:
  /// **'{rating} von 5 Sternen'**
  String recipeRating(String rating);

  /// When the user last cooked the recipe, in the meta line.
  ///
  /// In de, this message translates to:
  /// **'zuletzt am {date}'**
  String recipeLastCooked(String date);

  /// Button on the recipe screen: add the recipe to the meal plan.
  ///
  /// In de, this message translates to:
  /// **'Planen'**
  String get recipePlan;

  /// Button on the recipe screen: put the ingredients on the shopping list.
  ///
  /// In de, this message translates to:
  /// **'Einkaufen'**
  String get recipeShop;

  /// Button on the recipe screen: edit the recipe.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get recipeEdit;

  /// Explains why the plan and shop buttons are disabled.
  ///
  /// In de, this message translates to:
  /// **'Planen und Einkaufen kommen bald.'**
  String get recipeActionsComingSoon;

  /// Heading of the ingredient list.
  ///
  /// In de, this message translates to:
  /// **'Zutaten'**
  String get recipeIngredients;

  /// Shown under the servings picker when the chosen servings differ from the recipe's.
  ///
  /// In de, this message translates to:
  /// **'Rezept ist für {servings}, Mengen umgerechnet'**
  String recipeScaledFrom(String servings);

  /// Empty state of the ingredient list.
  ///
  /// In de, this message translates to:
  /// **'Dieses Rezept hat keine Zutaten.'**
  String get recipeNoIngredients;

  /// Title of a step without its own name, e.g. above its ingredients.
  ///
  /// In de, this message translates to:
  /// **'Schritt {number}'**
  String recipeStepTitle(int number);

  /// Accessible label of the close button in cooking mode.
  ///
  /// In de, this message translates to:
  /// **'Kochmodus beenden'**
  String get cookingClose;

  /// Top bar of cooking mode: the current step.
  ///
  /// In de, this message translates to:
  /// **'Schritt {current} von {total}'**
  String cookingStepOf(int current, int total);

  /// Compact step progress next to the bar that replaces the step dots from 9 steps on.
  ///
  /// In de, this message translates to:
  /// **'{current} / {total}'**
  String cookingStepProgress(int current, int total);

  /// Small label above the text of the last step.
  ///
  /// In de, this message translates to:
  /// **'Schritt {number} · Letzter'**
  String cookingLastStep(int number);

  /// Read-only servings next to the step's ingredients, e.g. 'für 4 Portionen'.
  ///
  /// In de, this message translates to:
  /// **'für {servings}'**
  String cookingForServings(String servings);

  /// Accessible label of the round back button in cooking mode.
  ///
  /// In de, this message translates to:
  /// **'Zurück zu Schritt {number}'**
  String cookingPrevious(int number);

  /// Main navigation button in cooking mode.
  ///
  /// In de, this message translates to:
  /// **'Weiter zu Schritt {number}'**
  String cookingNext(int number);

  /// Button on the last step; opens the screen to rate the recipe and log it as cooked.
  ///
  /// In de, this message translates to:
  /// **'Fertig gekocht'**
  String get cookingDone;

  /// Cooking mode for a recipe without steps.
  ///
  /// In de, this message translates to:
  /// **'Dieses Rezept hat keine Schritte.'**
  String get cookingNoSteps;

  /// Label of the wake lock toggle while the screen is kept on.
  ///
  /// In de, this message translates to:
  /// **'Bildschirm bleibt an'**
  String get cookingScreenOn;

  /// Label of the wake lock toggle while the screen may turn off.
  ///
  /// In de, this message translates to:
  /// **'Bildschirm anlassen'**
  String get cookingScreenOff;

  /// Label of the disabled wake lock toggle when the device can't keep the screen on.
  ///
  /// In de, this message translates to:
  /// **'Bildschirm kann nicht anbleiben'**
  String get cookingScreenUnavailable;

  /// Shown once when the wake lock is unsupported or refused.
  ///
  /// In de, this message translates to:
  /// **'Dein Gerät kann den Bildschirm hier nicht anlassen. Stell die automatische Sperre zum Kochen länger ein.'**
  String get cookingWakeLockHint;

  /// Main button on the recipe screen; opens cooking mode with the chosen servings.
  ///
  /// In de, this message translates to:
  /// **'Kochen starten · {servings}'**
  String recipeStartCooking(String servings);

  /// Heading of the search screen.
  ///
  /// In de, this message translates to:
  /// **'Suchen'**
  String get searchTitle;

  /// Accessible label of the search text field.
  ///
  /// In de, this message translates to:
  /// **'Rezepte durchsuchen'**
  String get searchFieldLabel;

  /// Placeholder of the search text field. The text matches recipe names, ingredients and keywords.
  ///
  /// In de, this message translates to:
  /// **'Rezept, Zutat oder Stichwort'**
  String get searchFieldHint;

  /// Button in the search field that empties it.
  ///
  /// In de, this message translates to:
  /// **'Suchtext löschen'**
  String get searchClear;

  /// Dashed chip that opens the ingredient picker; shown with a plus icon.
  ///
  /// In de, this message translates to:
  /// **'Zutat'**
  String get searchAddFood;

  /// Dashed chip that opens the keyword picker; shown with a plus icon.
  ///
  /// In de, this message translates to:
  /// **'Stichwort'**
  String get searchAddKeyword;

  /// Label of an ingredient filter chip, and the pill on a result that echoes it. The food in its plural form if it has one.
  ///
  /// In de, this message translates to:
  /// **'enthält {food}'**
  String searchFoodFilter(String food);

  /// Pill on a search result that matched the search text by one of its keywords. Several keywords are separated by commas.
  ///
  /// In de, this message translates to:
  /// **'Stichwort: {keyword}'**
  String searchMatchKeyword(String keyword);

  /// The last two names of a list of alternatives on a result's pill: the recipe contains at least one of these foods.
  ///
  /// In de, this message translates to:
  /// **'{first} oder {last}'**
  String searchMatchOr(String first, String last);

  /// Joins names in a list on a result's pill.
  ///
  /// In de, this message translates to:
  /// **'{first}, {next}'**
  String searchMatchList(String first, String next);

  /// Ends a shortened list of names on a result's pill: "Karotten, Möhren, Rüben oder weitere".
  ///
  /// In de, this message translates to:
  /// **'weitere'**
  String get searchMatchMore;

  /// Joins the reasons a result matched on its pill.
  ///
  /// In de, this message translates to:
  /// **'{first} · {second}'**
  String searchMatchJoin(String first, String second);

  /// Label of a filter chip while its name loads, after opening a search link.
  ///
  /// In de, this message translates to:
  /// **'…'**
  String get searchFilterLoading;

  /// Label of a filter chip whose food or keyword no longer exists.
  ///
  /// In de, this message translates to:
  /// **'Unbekannter Filter'**
  String get searchFilterUnknown;

  /// Accessible label of a selected filter chip; tapping it removes the filter.
  ///
  /// In de, this message translates to:
  /// **'{filter} entfernen'**
  String searchRemoveFilter(String filter);

  /// Number of search results above the list.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Rezept} other{{count} Rezepte}}'**
  String searchResultCount(int count);

  /// Empty state of the search results.
  ///
  /// In de, this message translates to:
  /// **'Keine Rezepte gefunden'**
  String get searchEmpty;

  /// Below the empty state when the search has text or filters.
  ///
  /// In de, this message translates to:
  /// **'Probier weniger Filter oder einen anderen Suchtext.'**
  String get searchEmptyHint;

  /// Empty state when an unfiltered search finds nothing.
  ///
  /// In de, this message translates to:
  /// **'Auf deinem Tandoor-Server gibt es noch keine Rezepte.'**
  String get searchEmptyServer;

  /// Note above search results that come from the offline cache.
  ///
  /// In de, this message translates to:
  /// **'Offline: Gesucht wird nur in Rezepten, die du schon geöffnet hast.'**
  String get searchOfflineResults;

  /// Empty state when an offline search finds no cached recipe.
  ///
  /// In de, this message translates to:
  /// **'Keins der gespeicherten Rezepte passt.'**
  String get searchOfflineEmpty;

  /// At the end of the results when the next page failed; a retry button follows.
  ///
  /// In de, this message translates to:
  /// **'Weitere Rezepte konnten nicht geladen werden.'**
  String get searchLoadMoreFailed;

  /// Title of the ingredient picker sheet, and the accessible label of the chip that opens it.
  ///
  /// In de, this message translates to:
  /// **'Zutat hinzufügen'**
  String get pickerFoodTitle;

  /// Title of the keyword picker sheet, and the accessible label of the chip that opens it.
  ///
  /// In de, this message translates to:
  /// **'Stichwort hinzufügen'**
  String get pickerKeywordTitle;

  /// Placeholder of the text field in the ingredient picker.
  ///
  /// In de, this message translates to:
  /// **'Zutat suchen'**
  String get pickerFoodHint;

  /// Placeholder of the text field in the keyword picker.
  ///
  /// In de, this message translates to:
  /// **'Stichwort suchen'**
  String get pickerKeywordHint;

  /// Note in the ingredient picker: picking a food also finds recipes with its child foods in the food tree.
  ///
  /// In de, this message translates to:
  /// **'Untergeordnete Zutaten zählen mit.'**
  String get pickerFoodNote;

  /// Empty state of the ingredient, keyword and creator pickers.
  ///
  /// In de, this message translates to:
  /// **'Nichts gefunden'**
  String get pickerEmpty;

  /// Title of the dialog shown before a link from a recipe opens.
  ///
  /// In de, this message translates to:
  /// **'Link öffnen?'**
  String get markdownLinkTitle;

  /// Body of the link dialog: where a link from recipe text leads.
  ///
  /// In de, this message translates to:
  /// **'Der Link führt zu {host} und öffnet sich in einem neuen Tab.'**
  String markdownLinkText(String host);

  /// Button in the link dialog that opens the link.
  ///
  /// In de, this message translates to:
  /// **'Öffnen'**
  String get markdownLinkOpen;

  /// Screen-reader label of an ingredient row in cooking mode; tapping ticks the ingredient off or back on.
  ///
  /// In de, this message translates to:
  /// **'{name} abhaken'**
  String ingredientTickOff(String name);

  /// Chip in wide cooking mode: show only the current step's ingredients.
  ///
  /// In de, this message translates to:
  /// **'Dieser Schritt'**
  String get cookingIngredientsOfStep;

  /// Chip in wide cooking mode: show the ingredients of every step.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get cookingIngredientsAll;

  /// Wide cooking mode, when the current step has no ingredients.
  ///
  /// In de, this message translates to:
  /// **'Für diesen Schritt brauchst du keine Zutaten.'**
  String get cookingNoStepIngredients;

  /// Title of the steps column on the recipe screen on tablets and in landscape.
  ///
  /// In de, this message translates to:
  /// **'Zubereitung'**
  String get recipeMethod;

  /// Button below a step with an explicit time, or a duration in its text: starts a timer of that length.
  ///
  /// In de, this message translates to:
  /// **'Timer starten · {time}'**
  String timerStart(String time);

  /// Screen-reader label of a duration highlighted in step text; tapping it starts a timer.
  ///
  /// In de, this message translates to:
  /// **'{duration}, Timer starten'**
  String timerHighlight(String duration);

  /// On a finished timer chip, after its label: "Rösten fertig".
  ///
  /// In de, this message translates to:
  /// **'fertig'**
  String get timerFinished;

  /// Screen-reader label of a running timer chip.
  ///
  /// In de, this message translates to:
  /// **'{label}, noch {time}'**
  String timerChipRunning(String label, String time);

  /// Screen-reader label of a paused timer chip.
  ///
  /// In de, this message translates to:
  /// **'{label}, angehalten bei {time}'**
  String timerChipPaused(String label, String time);

  /// Screen-reader label of a finished timer chip, and the notification title.
  ///
  /// In de, this message translates to:
  /// **'{label} ist fertig'**
  String timerChipFinished(String label);

  /// Tooltip of the button in cooking mode that sets a new timer by hand.
  ///
  /// In de, this message translates to:
  /// **'Timer stellen'**
  String get timerAdd;

  /// Name of a timer set by hand.
  ///
  /// In de, this message translates to:
  /// **'Timer'**
  String get timerManualLabel;

  /// Title of the sheet that sets a timer by hand.
  ///
  /// In de, this message translates to:
  /// **'Neuer Timer'**
  String get timerNew;

  /// Length of a new timer in the sheet.
  ///
  /// In de, this message translates to:
  /// **'{count} Min'**
  String timerMinutes(int count);

  /// Tooltip: shortens the new timer by a minute.
  ///
  /// In de, this message translates to:
  /// **'Eine Minute weniger'**
  String get timerLess;

  /// Tooltip: lengthens the new timer by a minute.
  ///
  /// In de, this message translates to:
  /// **'Eine Minute mehr'**
  String get timerMore;

  /// Button in the sheet that starts the new timer.
  ///
  /// In de, this message translates to:
  /// **'Starten'**
  String get timerStartManual;

  /// Button in the timer sheet that pauses a running timer.
  ///
  /// In de, this message translates to:
  /// **'Anhalten'**
  String get timerPause;

  /// Button in the timer sheet that resumes a paused timer.
  ///
  /// In de, this message translates to:
  /// **'Fortsetzen'**
  String get timerResume;

  /// Button in the timer sheet that adds a minute.
  ///
  /// In de, this message translates to:
  /// **'+1 Min'**
  String get timerAddMinute;

  /// Button in the timer sheet that cancels a timer.
  ///
  /// In de, this message translates to:
  /// **'Timer löschen'**
  String get timerDelete;

  /// Button in the timer sheet that turns off a finished timer.
  ///
  /// In de, this message translates to:
  /// **'Ausschalten'**
  String get timerTurnOff;

  /// Shown once when a timer starts on a device that can't alert in the background (phones).
  ///
  /// In de, this message translates to:
  /// **'Timer melden sich nur, solange Yumdoor geöffnet ist.'**
  String get timerBackgroundHint;

  /// Dashed chip that opens the rating filter.
  ///
  /// In de, this message translates to:
  /// **'Bewertung'**
  String get searchAddRating;

  /// Dashed chip that opens the last-cooked filter.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gekocht'**
  String get searchAddLastCooked;

  /// Dashed chip that opens the times-cooked filter.
  ///
  /// In de, this message translates to:
  /// **'Gekocht'**
  String get searchAddTimesCooked;

  /// Title and accessible label of the rating filter.
  ///
  /// In de, this message translates to:
  /// **'Nach Bewertung filtern'**
  String get searchRatingTitle;

  /// Title and accessible label of the last-cooked filter.
  ///
  /// In de, this message translates to:
  /// **'Nach letztem Kochen filtern'**
  String get searchLastCookedTitle;

  /// Title and accessible label of the times-cooked filter.
  ///
  /// In de, this message translates to:
  /// **'Nach Kochhäufigkeit filtern'**
  String get searchTimesTitle;

  /// Under the title of the rating, last-cooked and times-cooked filter sheets: Tandoor counts only the user's own cook logs.
  ///
  /// In de, this message translates to:
  /// **'Zählt nur deine eigenen Kochprotokolle.'**
  String get searchHistoryHint;

  /// Choice in the rating filter sheet. The minimum rating.
  ///
  /// In de, this message translates to:
  /// **'{stars, plural, =1{ab 1 Stern} other{ab {stars} Sternen}}'**
  String searchRatingOption(int stars);

  /// Label of the selected rating filter chip.
  ///
  /// In de, this message translates to:
  /// **'Von dir bewertet: {stars, plural, =1{ab 1 Stern} other{ab {stars} Sternen}}'**
  String searchRatingFilter(int stars);

  /// Choice in the last-cooked filter: last cooked at least two weeks ago.
  ///
  /// In de, this message translates to:
  /// **'Nicht seit 2 Wochen'**
  String get searchLastCookedWeeks;

  /// Choice in the last-cooked filter: last cooked at least a month ago.
  ///
  /// In de, this message translates to:
  /// **'Nicht seit 1 Monat'**
  String get searchLastCookedMonth;

  /// Choice in the last-cooked filter: last cooked at least three months ago.
  ///
  /// In de, this message translates to:
  /// **'Nicht seit 3 Monaten'**
  String get searchLastCookedMonths;

  /// Label of the selected last-cooked filter chip.
  ///
  /// In de, this message translates to:
  /// **'Von dir zuletzt gekocht bis {date}'**
  String searchLastCookedFilter(String date);

  /// Choice in the times-cooked filter: the user never cooked the recipe.
  ///
  /// In de, this message translates to:
  /// **'Nie gekocht'**
  String get searchTimesNever;

  /// Choice in the times-cooked filter.
  ///
  /// In de, this message translates to:
  /// **'Oft gekocht (mind. 5-mal)'**
  String get searchTimesOften;

  /// Label of the selected never-cooked filter chip.
  ///
  /// In de, this message translates to:
  /// **'Von dir nie gekocht'**
  String get searchTimesNeverFilter;

  /// Label of the selected times-cooked filter chip.
  ///
  /// In de, this message translates to:
  /// **'Von dir mind. {count}-mal gekocht'**
  String searchTimesMinFilter(int count);

  /// Shown above offline results when the times-cooked filter asks for several times.
  ///
  /// In de, this message translates to:
  /// **'Offline lässt sich nicht zählen, wie oft du ein Rezept gekocht hast. Gezeigt werden alle schon gekochten.'**
  String get searchOfflineTimesNote;

  /// Heading of the screen after cooking, where the user rates the recipe.
  ///
  /// In de, this message translates to:
  /// **'Guten Appetit!'**
  String get cookLogTitle;

  /// Below the heading: the recipe name and the cooked servings, e.g. "Ofenkarotten mit Feta · 4 Portionen".
  ///
  /// In de, this message translates to:
  /// **'{recipe} · {servings}'**
  String cookLogSubtitle(String recipe, String servings);

  /// Tooltip of the close button on the cook log screen.
  ///
  /// In de, this message translates to:
  /// **'Schließen, ohne zu speichern'**
  String get cookLogClose;

  /// Card title above the rating stars.
  ///
  /// In de, this message translates to:
  /// **'Wie war\'s?'**
  String get cookLogRatingQuestion;

  /// Screen-reader label of one rating star button.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Stern} other{{count} Sterne}}'**
  String cookLogRatingStar(int count);

  /// Label of the comment field.
  ///
  /// In de, this message translates to:
  /// **'Kommentar (optional)'**
  String get cookLogComment;

  /// Note below the card: every member of the space can read cook log entries.
  ///
  /// In de, this message translates to:
  /// **'Für alle in diesem Tandoor-Space sichtbar'**
  String get cookLogVisibility;

  /// Saves the rating and comment to the cook log.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get cookLogSave;

  /// Returns to the recipe without saving.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get cookLogSkip;

  /// Snackbar after saving a cook log entry.
  ///
  /// In de, this message translates to:
  /// **'Im Kochprotokoll gespeichert'**
  String get cookLogSaved;

  /// Shown when saving the cook log entry failed; the reason is one of the error messages.
  ///
  /// In de, this message translates to:
  /// **'Nicht gespeichert. {reason}'**
  String cookLogFailed(String reason);

  /// Button on the recipe screen that opens the cook log screen to rate the recipe.
  ///
  /// In de, this message translates to:
  /// **'Als gekocht eintragen'**
  String get recipeCooked;

  /// Add chip for the filter on what is on hand at home.
  ///
  /// In de, this message translates to:
  /// **'Kochbar'**
  String get searchAddCookable;

  /// Title of the cookable filter sheet; also the accessible label of its add chip.
  ///
  /// In de, this message translates to:
  /// **'Nach Vorrat filtern'**
  String get searchCookableTitle;

  /// Under the title of the cookable filter sheet.
  ///
  /// In de, this message translates to:
  /// **'Zählt, was jemand in deinem Haushalt vorrätig hat, und Ersatzzutaten.'**
  String get searchCookableHint;

  /// Choice in the cookable filter sheet and label of its selected chip: every ingredient is on hand.
  ///
  /// In de, this message translates to:
  /// **'Jetzt kochbar'**
  String get searchCookableNow;

  /// Choice in the cookable filter sheet and label of its selected chip.
  ///
  /// In de, this message translates to:
  /// **'Höchstens 1 Zutat fehlt'**
  String get searchCookableOneMissing;

  /// Add chip for the cookbook filter.
  ///
  /// In de, this message translates to:
  /// **'Buch'**
  String get searchAddBook;

  /// Title of the cookbook filter sheet; also the accessible label of its add chip.
  ///
  /// In de, this message translates to:
  /// **'Nach Kochbuch filtern'**
  String get searchBookTitle;

  /// Under the title of the cookbook filter sheet.
  ///
  /// In de, this message translates to:
  /// **'Mehrere Bücher: Rezepte aus einem davon. Ein Buch mit gespeicherter Suche zählt nur die fest hinzugefügten Rezepte.'**
  String get searchBookHint;

  /// Cookbook filter sheet when the user has no books.
  ///
  /// In de, this message translates to:
  /// **'Du hast noch keine Kochbücher.'**
  String get searchBookEmpty;

  /// Label of a selected cookbook filter chip.
  ///
  /// In de, this message translates to:
  /// **'Buch: {book}'**
  String searchBookFilter(String book);

  /// Add chip for the filter on who created a recipe.
  ///
  /// In de, this message translates to:
  /// **'Erstellt von'**
  String get searchAddCreator;

  /// Title of the created-by filter sheet; also the accessible label of its add chip.
  ///
  /// In de, this message translates to:
  /// **'Nach Ersteller filtern'**
  String get searchCreatorTitle;

  /// Label of the selected created-by filter chip.
  ///
  /// In de, this message translates to:
  /// **'Erstellt von {name}'**
  String searchCreatorFilter(String name);

  /// Shown above offline results when the cookable filter is set.
  ///
  /// In de, this message translates to:
  /// **'Offline zählt der Vorrat vom letzten Öffnen eines Rezepts, ohne Ersatzzutaten.'**
  String get searchOfflineCookableNote;

  /// Shown with offline results when the cookbook filter is set.
  ///
  /// In de, this message translates to:
  /// **'Offline ist nicht bekannt, welche Rezepte in einem Buch stehen.'**
  String get searchOfflineBookNote;

  /// Cookbook filter sheet when every book is already a filter.
  ///
  /// In de, this message translates to:
  /// **'Alle deine Bücher sind schon ausgewählt.'**
  String get searchBookAllChosen;

  /// Button next to the result count that opens the sort sheet; shows the current order (mockup 03-suche: 'Sortiert: passend').
  ///
  /// In de, this message translates to:
  /// **'Sortiert: {sort, select, relevance{passend} name{nach Name} lastCooked{zuletzt gekocht} rating{nach Bewertung} newest{neueste zuerst} recentlyViewed{zuletzt angesehen} random{zufällig} other{passend}}'**
  String searchSortButton(String sort);

  /// Title of the sort sheet.
  ///
  /// In de, this message translates to:
  /// **'Sortieren'**
  String get searchSortTitle;

  /// Under the title of the sort sheet: Tandoor sorts by the user's own cook logs and views.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gekocht, Bewertung und Zuletzt angesehen zählen nur deine eigenen Kochprotokolle und Aufrufe.'**
  String get searchSortHint;

  /// A choice in the sort sheet.
  ///
  /// In de, this message translates to:
  /// **'{sort, select, relevance{Passend zur Suche} name{Name (A–Z)} lastCooked{Zuletzt gekocht} rating{Beste Bewertung} newest{Neueste zuerst} recentlyViewed{Zuletzt angesehen} random{Zufällig} other{Passend zur Suche}}'**
  String searchSortOption(String sort);

  /// Chip after the saved searches that saves the current search; also the title of its dialog.
  ///
  /// In de, this message translates to:
  /// **'Suche speichern'**
  String get searchSavedSave;

  /// Explanation in the save-search dialog.
  ///
  /// In de, this message translates to:
  /// **'Text und Filter werden unter diesem Namen in Tandoor gespeichert.'**
  String get searchSavedSaveHint;

  /// Label of the name field when saving or renaming a search.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get searchSavedName;

  /// Error under an empty name field.
  ///
  /// In de, this message translates to:
  /// **'Gib einen Namen ein.'**
  String get searchSavedNameEmpty;

  /// Confirm button of the save-search and rename dialogs.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get searchSavedConfirm;

  /// Message after a search was saved.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ gespeichert'**
  String searchSavedSaved(String name);

  /// Message when saving, renaming or deleting a saved search failed; reason is an error message.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. {reason}'**
  String searchSavedFailed(String reason);

  /// Button at the end of the saved searches that opens the list to rename and delete them.
  ///
  /// In de, this message translates to:
  /// **'Verwalten'**
  String get searchSavedManage;

  /// Title of the sheet that lists the saved searches.
  ///
  /// In de, this message translates to:
  /// **'Gespeicherte Suchen'**
  String get searchSavedManageTitle;

  /// Explanation under the title of the saved searches sheet.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen und löschen kannst du deine eigenen; geteilte nur verwenden.'**
  String get searchSavedManageHint;

  /// Saved searches sheet without any.
  ///
  /// In de, this message translates to:
  /// **'Du hast noch keine Suche gespeichert.'**
  String get searchSavedNone;

  /// Under a saved search someone else created.
  ///
  /// In de, this message translates to:
  /// **'Mit dir geteilt'**
  String get searchSavedShared;

  /// Title of the rename dialog.
  ///
  /// In de, this message translates to:
  /// **'Suche umbenennen'**
  String get searchSavedRenameTitle;

  /// Accessible label of the rename button of a saved search.
  ///
  /// In de, this message translates to:
  /// **'{name} umbenennen'**
  String searchSavedRenameLabel(String name);

  /// Accessible label of the delete button of a saved search.
  ///
  /// In de, this message translates to:
  /// **'{name} löschen'**
  String searchSavedDeleteLabel(String name);

  /// Title of the dialog that confirms deleting a saved search.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ löschen?'**
  String searchSavedDeleteTitle(String name);

  /// Text of the dialog that confirms deleting a saved search.
  ///
  /// In de, this message translates to:
  /// **'Die Suche wird auch in Tandoor gelöscht, für alle, mit denen sie geteilt ist. Ein Kochbuch mit dieser Suche zeigt danach nur noch seine fest hinzugefügten Rezepte. Rezepte bleiben erhalten.'**
  String get searchSavedDeleteText;

  /// Confirm button of the delete dialog.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get searchSavedDelete;

  /// Label of the filter chip of a saved search that the other chips can't show.
  ///
  /// In de, this message translates to:
  /// **'Gespeichert: {name}'**
  String searchSavedFilter(String name);

  /// Shown with offline results when a saved search the chips can't show is applied.
  ///
  /// In de, this message translates to:
  /// **'Offline lässt sich diese gespeicherte Suche nicht anwenden.'**
  String get searchOfflineSavedNote;

  /// Error under the name field when another saved search the user can see has that name.
  ///
  /// In de, this message translates to:
  /// **'Eine gespeicherte Suche mit diesem Namen gibt es schon.'**
  String get searchSavedNameTaken;

  /// Message when Tandoor refused a saved search's name, most likely because a saved search in the space (perhaps one the user can't see) has it.
  ///
  /// In de, this message translates to:
  /// **'Nicht gespeichert. In Tandoor gibt es den Namen vielleicht schon – versuch einen anderen.'**
  String get searchSavedNameConflict;

  /// Button on the search screen that opens the editor for a new recipe.
  ///
  /// In de, this message translates to:
  /// **'Neues Rezept'**
  String get searchNewRecipe;

  /// Leaves the recipe editor without saving.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get editorCancel;

  /// Saves the recipe in the editor.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get editorSave;

  /// Accessible label of the save button while saving.
  ///
  /// In de, this message translates to:
  /// **'Wird gespeichert …'**
  String get editorSaving;

  /// Title of the editor for an existing recipe; the recipe name is shown above it.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get editorTitleEdit;

  /// Title of the editor for a new recipe.
  ///
  /// In de, this message translates to:
  /// **'Neues Rezept'**
  String get editorTitleNew;

  /// Editor tab with the recipe's name, description, servings, times, keywords and source.
  ///
  /// In de, this message translates to:
  /// **'Allgemein'**
  String get editorTabGeneral;

  /// Editor tab for the ingredients.
  ///
  /// In de, this message translates to:
  /// **'Zutaten'**
  String get editorTabIngredients;

  /// Editor tab for the steps.
  ///
  /// In de, this message translates to:
  /// **'Schritte'**
  String get editorTabSteps;

  /// Placeholder of the Zutaten and Schritte tabs until they are built.
  ///
  /// In de, this message translates to:
  /// **'Das kommt bald. Bis dahin bleiben die Schritte beim Speichern, wie sie sind.'**
  String get editorTabComingSoon;

  /// Label of the recipe name field.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get editorName;

  /// Label of the description field.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get editorDescription;

  /// Help below the description field: it takes Markdown.
  ///
  /// In de, this message translates to:
  /// **'Markdown geht, z. B. **fett** oder *kursiv*.'**
  String get editorDescriptionHelp;

  /// Label of the servings field (a number).
  ///
  /// In de, this message translates to:
  /// **'Portionen'**
  String get editorServings;

  /// Label of the field for what a serving is called.
  ///
  /// In de, this message translates to:
  /// **'Bezeichnung'**
  String get editorServingsText;

  /// Hint in the servings text field.
  ///
  /// In de, this message translates to:
  /// **'z. B. Stück'**
  String get editorServingsTextHint;

  /// Label of the working time field, in minutes.
  ///
  /// In de, this message translates to:
  /// **'Arbeitszeit (Min.)'**
  String get editorWorkingTime;

  /// Label of the waiting time field, in minutes.
  ///
  /// In de, this message translates to:
  /// **'Wartezeit (Min.)'**
  String get editorWaitingTime;

  /// Label of the keyword chips.
  ///
  /// In de, this message translates to:
  /// **'Stichwörter'**
  String get editorKeywords;

  /// Dashed chip that adds a keyword.
  ///
  /// In de, this message translates to:
  /// **'Stichwort'**
  String get editorAddKeyword;

  /// Accessible label of the chip that adds a keyword.
  ///
  /// In de, this message translates to:
  /// **'Stichwort hinzufügen'**
  String get editorAddKeywordTooltip;

  /// Accessible label of a keyword chip; tapping it removes the keyword.
  ///
  /// In de, this message translates to:
  /// **'{keyword} entfernen'**
  String editorRemoveKeyword(String keyword);

  /// Label of the source URL field.
  ///
  /// In de, this message translates to:
  /// **'Quelle'**
  String get editorSource;

  /// Hint in the source field.
  ///
  /// In de, this message translates to:
  /// **'https://…'**
  String get editorSourceHint;

  /// Error at the name field when it is empty.
  ///
  /// In de, this message translates to:
  /// **'Gib dem Rezept einen Namen.'**
  String get editorNameMissing;

  /// Error at a text field that is longer than Tandoor stores.
  ///
  /// In de, this message translates to:
  /// **'Höchstens {max} Zeichen.'**
  String editorTooLong(int max);

  /// Error at the servings field when it is empty or 0.
  ///
  /// In de, this message translates to:
  /// **'Mindestens 1.'**
  String get editorServingsTooSmall;

  /// Shown above the form when the draft has problems after trying to save.
  ///
  /// In de, this message translates to:
  /// **'Bitte prüf die markierten Felder.'**
  String get editorProblems;

  /// Shown when saving failed; the reason is one of the error messages. The edits stay.
  ///
  /// In de, this message translates to:
  /// **'Nicht gespeichert. {reason}'**
  String editorSaveFailed(String reason);

  /// Shown when Tandoor refused the save (403), e.g. for a guest. The edits stay on screen.
  ///
  /// In de, this message translates to:
  /// **'Nicht gespeichert: Du darfst dieses Rezept nicht ändern. Deine Änderungen sind noch da.'**
  String get editorForbidden;

  /// Shown when the recipe to edit doesn't exist (anymore) or can't be seen.
  ///
  /// In de, this message translates to:
  /// **'Dieses Rezept gibt es nicht mehr.'**
  String get editorRecipeGone;

  /// Snackbar after the recipe was saved.
  ///
  /// In de, this message translates to:
  /// **'Rezept gespeichert'**
  String get editorSaved;

  /// Title of the sheet that adds a keyword to the recipe.
  ///
  /// In de, this message translates to:
  /// **'Stichwort hinzufügen'**
  String get keywordPickerTitle;

  /// Hint and accessible name of the keyword search field.
  ///
  /// In de, this message translates to:
  /// **'Stichwort suchen oder anlegen'**
  String get keywordPickerHint;

  /// Title of the sheet that picks the food of an ingredient; also the placeholder of an ingredient without food.
  ///
  /// In de, this message translates to:
  /// **'Zutat wählen'**
  String get foodPickerTitle;

  /// Hint and accessible name of the food search field.
  ///
  /// In de, this message translates to:
  /// **'Zutat suchen oder anlegen'**
  String get foodPickerHint;

  /// Title of the sheet that picks the unit of an ingredient.
  ///
  /// In de, this message translates to:
  /// **'Einheit wählen'**
  String get unitPickerTitle;

  /// Hint and accessible name of the unit search field.
  ///
  /// In de, this message translates to:
  /// **'Einheit suchen oder anlegen'**
  String get unitPickerHint;

  /// Above the ingredients in the editor: amounts are for the recipe's base servings.
  ///
  /// In de, this message translates to:
  /// **'Mengen für {servings} (Grundrezept)'**
  String ingredientsBaseServings(String servings);

  /// Empty state of the editor's ingredient list.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Zutaten. Gib unten eine Zeile ein, z. B. „200 g Karotten“.'**
  String get ingredientsEmpty;

  /// Accessible name of the ingredient entry field and title of the sheet that adds ingredients to a step.
  ///
  /// In de, this message translates to:
  /// **'Zutat hinzufügen'**
  String get ingredientEntryLabel;

  /// Hint of the ingredient entry field.
  ///
  /// In de, this message translates to:
  /// **'z. B. 200 g Karotten, geschält'**
  String get ingredientEntryHint;

  /// Tooltip of the button that adds the typed ingredient line.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get ingredientEntryAdd;

  /// Shown after a line was added.
  ///
  /// In de, this message translates to:
  /// **'{ingredient} hinzugefügt'**
  String ingredientEntryAdded(String ingredient);

  /// Shown when the ingredient parser could not split a line.
  ///
  /// In de, this message translates to:
  /// **'„{line}“ nicht erkannt und als Notiz übernommen. Tipp die Zeile an, um eine Zutat zu wählen.'**
  String ingredientEntryUnparsed(String line);

  /// Shown when parsing an ingredient line failed.
  ///
  /// In de, this message translates to:
  /// **'Nicht hinzugefügt. {reason}'**
  String ingredientEntryFailed(String reason);

  /// Closes the sheet that adds ingredients to a step.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get ingredientEntryDone;

  /// Adds a section header (such as 'Für den Teig') to the ingredients.
  ///
  /// In de, this message translates to:
  /// **'Abschnitt hinzufügen'**
  String get ingredientAddHeader;

  /// Title of the sheet that adds or edits a section header.
  ///
  /// In de, this message translates to:
  /// **'Abschnitt'**
  String get ingredientHeaderTitle;

  /// Label of the section header text field.
  ///
  /// In de, this message translates to:
  /// **'Überschrift'**
  String get ingredientHeaderLabel;

  /// Hint of the section header text field.
  ///
  /// In de, this message translates to:
  /// **'z. B. Für den Teig'**
  String get ingredientHeaderHint;

  /// Title of the sheet that edits an ingredient.
  ///
  /// In de, this message translates to:
  /// **'Zutat bearbeiten'**
  String get ingredientEditTitle;

  /// Label of the amount field.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get ingredientAmount;

  /// Error of an amount field that holds no number.
  ///
  /// In de, this message translates to:
  /// **'Eine Zahl wie 1,5 oder ½.'**
  String get ingredientAmountInvalid;

  /// Label of the unit field.
  ///
  /// In de, this message translates to:
  /// **'Einheit'**
  String get ingredientUnit;

  /// Unit field of an ingredient without unit.
  ///
  /// In de, this message translates to:
  /// **'Keine'**
  String get ingredientNoUnit;

  /// Tooltip of the button that removes the unit.
  ///
  /// In de, this message translates to:
  /// **'Einheit entfernen'**
  String get ingredientRemoveUnit;

  /// Label of the food field.
  ///
  /// In de, this message translates to:
  /// **'Zutat'**
  String get ingredientFood;

  /// Label of the note field.
  ///
  /// In de, this message translates to:
  /// **'Notiz'**
  String get ingredientNote;

  /// Switch for an ingredient without amount, such as 'Salz nach Geschmack'.
  ///
  /// In de, this message translates to:
  /// **'Ohne Menge'**
  String get ingredientNoAmount;

  /// Applies the changes of the ingredient or section sheet to the recipe draft.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get ingredientApply;

  /// Tooltip of the menu button of an ingredient row.
  ///
  /// In de, this message translates to:
  /// **'Aktionen für {name}'**
  String ingredientActions(String name);

  /// Menu item: edit the ingredient.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get ingredientEdit;

  /// Menu item: move the ingredient one place up.
  ///
  /// In de, this message translates to:
  /// **'Nach oben'**
  String get ingredientMoveUp;

  /// Menu item: move the ingredient one place down.
  ///
  /// In de, this message translates to:
  /// **'Nach unten'**
  String get ingredientMoveDown;

  /// Menu item: delete the ingredient.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get ingredientDelete;

  /// Name of an ingredient row without food and note.
  ///
  /// In de, this message translates to:
  /// **'Ohne Zutat'**
  String get ingredientUnnamed;

  /// Creates a new keyword, food or unit with the typed name.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ anlegen'**
  String pickerCreate(String name);

  /// Shown when creating a keyword, food or unit failed.
  ///
  /// In de, this message translates to:
  /// **'Nicht angelegt. {reason}'**
  String pickerCreateFailed(String reason);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

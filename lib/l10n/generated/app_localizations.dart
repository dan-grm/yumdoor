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

  /// Explains why the plan, shop and edit buttons are disabled.
  ///
  /// In de, this message translates to:
  /// **'Planen, Einkaufen und Bearbeiten kommen bald.'**
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

  /// Button on the last step; returns to the recipe.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
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

  /// Placeholder of the search text field. By default Tandoor's text search only matches recipe names.
  ///
  /// In de, this message translates to:
  /// **'Rezeptname'**
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
  /// **'Offline: Gesucht wird nur in Rezepten, die du schon geöffnet hast, und nur im Namen.'**
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

  /// Empty state of the ingredient and keyword pickers.
  ///
  /// In de, this message translates to:
  /// **'Nichts gefunden'**
  String get pickerEmpty;
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

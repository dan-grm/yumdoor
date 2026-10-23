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

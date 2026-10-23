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

  /// Main button on the recipe screen; opens cooking mode with the chosen servings.
  ///
  /// In de, this message translates to:
  /// **'Kochen starten · {servings}'**
  String recipeStartCooking(String servings);
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

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
}

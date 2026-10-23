// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yumdoor';

  @override
  String get loginTagline => 'Connect to your Tandoor server.';

  @override
  String get loginServerLabel => 'Server address';

  @override
  String get loginServerRequired => 'Enter the address of your Tandoor server.';

  @override
  String get loginServerInvalid => 'That isn\'t a valid address.';

  @override
  String get loginServerChecking => 'Checking server …';

  @override
  String loginServerFound(String version) {
    return 'Found Tandoor $version';
  }

  @override
  String loginServerUnsupported(String version) {
    return 'Tandoor $version isn\'t supported. Yumdoor needs Tandoor 2.x.';
  }

  @override
  String get loginServerNotTandoor =>
      'There is no Tandoor 2.x at this address.';

  @override
  String get loginServerUnreachable =>
      'Can\'t reach the server. Check the address and your connection.';

  @override
  String get loginServerError =>
      'The server reported an error. Please try again later.';

  @override
  String loginServerOtherOrigin(String origin) {
    return 'In the browser, Yumdoor can only reach the Tandoor server at $origin, because Tandoor doesn\'t accept requests from other addresses. For other servers, use the Android or iOS app.';
  }

  @override
  String get loginMethodLabel => 'Login method';

  @override
  String get loginMethodPassword => 'Password';

  @override
  String get loginMethodToken => 'API token';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameRequired => 'Enter your username.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter your password.';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginPasswordNote =>
      'Your password is only exchanged for a token and never stored.';

  @override
  String get loginTokenLabel => 'API token';

  @override
  String get loginTokenRequired => 'Paste your API token.';

  @override
  String get loginTokenNote =>
      'Create a token in Tandoor under Settings › API Tokens. Yumdoor doesn\'t delete it when you log out.';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginErrorCredentials => 'Wrong username or password.';

  @override
  String get loginErrorToken =>
      'The server didn\'t accept this token. Check that it\'s complete and still valid.';

  @override
  String get loginErrorThrottled =>
      'Too many login attempts today: Tandoor allows ten a day. Try again tomorrow or log in with an API token.';

  @override
  String get loginWhatIsTandoor => 'What is Tandoor?';

  @override
  String get loginWhatIsTandoorText =>
      'Tandoor is a free recipe manager that you run on your own server. Yumdoor is an app for your Tandoor server and doesn\'t work without one. Learn more at tandoor.dev.';

  @override
  String get logout => 'Log out';
}

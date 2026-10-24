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

  @override
  String get back => 'Back';

  @override
  String get retry => 'Try again';

  @override
  String get errorOffline =>
      'The server can\'t be reached right now. Check your connection.';

  @override
  String get errorUnauthorized =>
      'Your login is no longer valid. Please log in again.';

  @override
  String get errorThrottled => 'Too many requests. Please try again later.';

  @override
  String get errorServer => 'The server reported an error.';

  @override
  String get offlineBanner =>
      'You\'re offline. Recipes you\'ve already opened are still available.';

  @override
  String get offlineWriteDisabled =>
      'You can\'t change anything while offline. It works again once you\'re connected.';

  @override
  String get recipeNotFound =>
      'This recipe doesn\'t exist, or you\'re not allowed to see it.';

  @override
  String servings(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString servings',
      one: '1 serving',
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
  String get servingsDecrease => 'Fewer servings';

  @override
  String get servingsIncrease => 'More servings';

  @override
  String recipeMinutes(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString min';
  }

  @override
  String recipeRating(String rating) {
    return '$rating out of 5 stars';
  }

  @override
  String recipeLastCooked(String date) {
    return 'last cooked $date';
  }

  @override
  String get recipePlan => 'Plan';

  @override
  String get recipeShop => 'Shop';

  @override
  String get recipeEdit => 'Edit';

  @override
  String get recipeActionsComingSoon =>
      'Planning, shopping and editing are coming soon.';

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String recipeScaledFrom(String servings) {
    return 'Recipe is for $servings, amounts converted';
  }

  @override
  String get recipeNoIngredients => 'This recipe has no ingredients.';

  @override
  String recipeStepTitle(int number) {
    return 'Step $number';
  }

  @override
  String get cookingClose => 'Leave cooking mode';

  @override
  String cookingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String cookingStepProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String cookingLastStep(int number) {
    return 'Step $number · Last';
  }

  @override
  String cookingForServings(String servings) {
    return 'for $servings';
  }

  @override
  String cookingPrevious(int number) {
    return 'Back to step $number';
  }

  @override
  String cookingNext(int number) {
    return 'Next: step $number';
  }

  @override
  String get cookingDone => 'Done';

  @override
  String get cookingNoSteps => 'This recipe has no steps.';

  @override
  String get cookingScreenOn => 'Screen stays on';

  @override
  String get cookingScreenOff => 'Keep screen on';

  @override
  String get cookingScreenUnavailable => 'Screen can\'t stay on';

  @override
  String get cookingWakeLockHint =>
      'Your device can\'t keep the screen on here. Set a longer auto-lock while cooking.';

  @override
  String recipeStartCooking(String servings) {
    return 'Start cooking · $servings';
  }

  @override
  String get searchTitle => 'Search';

  @override
  String get searchFieldLabel => 'Search recipes';

  @override
  String get searchFieldHint => 'Recipe name';

  @override
  String get searchClear => 'Clear search text';

  @override
  String get searchAddFood => 'Ingredient';

  @override
  String get searchAddKeyword => 'Keyword';

  @override
  String searchFoodFilter(String food) {
    return 'with $food';
  }

  @override
  String get searchFilterLoading => '…';

  @override
  String get searchFilterUnknown => 'Unknown filter';

  @override
  String searchRemoveFilter(String filter) {
    return 'Remove $filter';
  }

  @override
  String searchResultCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get searchEmpty => 'No recipes found';

  @override
  String get searchEmptyHint => 'Try fewer filters or different search text.';

  @override
  String get searchEmptyServer =>
      'There are no recipes on your Tandoor server yet.';

  @override
  String get searchOfflineResults =>
      'Offline: only searching names of recipes you\'ve already opened.';

  @override
  String get searchOfflineEmpty => 'None of the saved recipes match.';

  @override
  String get searchLoadMoreFailed => 'Couldn\'t load more recipes.';

  @override
  String get pickerFoodTitle => 'Add ingredient';

  @override
  String get pickerKeywordTitle => 'Add keyword';

  @override
  String get pickerFoodHint => 'Search ingredients';

  @override
  String get pickerKeywordHint => 'Search keywords';

  @override
  String get pickerFoodNote => 'Child ingredients count too.';

  @override
  String get pickerEmpty => 'Nothing found';
}

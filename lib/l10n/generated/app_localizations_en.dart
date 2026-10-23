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
  String recipeStartCooking(String servings) {
    return 'Start cooking · $servings';
  }
}

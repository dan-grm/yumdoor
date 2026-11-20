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
      'Planning and shopping are coming soon.';

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
  String get cookingDone => 'Done cooking';

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
  String get searchFieldHint => 'Recipe, ingredient or keyword';

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
  String searchMatchKeyword(String keyword) {
    return 'Keyword: $keyword';
  }

  @override
  String searchMatchOr(String first, String last) {
    return '$first or $last';
  }

  @override
  String searchMatchList(String first, String next) {
    return '$first, $next';
  }

  @override
  String get searchMatchMore => 'others';

  @override
  String searchMatchJoin(String first, String second) {
    return '$first · $second';
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
      'Offline: only searching recipes you\'ve already opened.';

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

  @override
  String get markdownLinkTitle => 'Open link?';

  @override
  String markdownLinkText(String host) {
    return 'This link goes to $host and opens in a new tab.';
  }

  @override
  String get markdownLinkOpen => 'Open';

  @override
  String ingredientTickOff(String name) {
    return 'Tick off $name';
  }

  @override
  String get cookingIngredientsOfStep => 'This step';

  @override
  String get cookingIngredientsAll => 'All';

  @override
  String get cookingNoStepIngredients => 'This step needs no ingredients.';

  @override
  String get recipeMethod => 'Method';

  @override
  String timerStart(String time) {
    return 'Start timer · $time';
  }

  @override
  String timerHighlight(String duration) {
    return '$duration, start timer';
  }

  @override
  String get timerFinished => 'done';

  @override
  String timerChipRunning(String label, String time) {
    return '$label, $time left';
  }

  @override
  String timerChipPaused(String label, String time) {
    return '$label, paused at $time';
  }

  @override
  String timerChipFinished(String label) {
    return '$label is done';
  }

  @override
  String get timerAdd => 'Set a timer';

  @override
  String get timerManualLabel => 'Timer';

  @override
  String get timerNew => 'New timer';

  @override
  String timerMinutes(int count) {
    return '$count min';
  }

  @override
  String get timerLess => 'One minute less';

  @override
  String get timerMore => 'One minute more';

  @override
  String get timerStartManual => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerAddMinute => '+1 min';

  @override
  String get timerDelete => 'Delete timer';

  @override
  String get timerTurnOff => 'Turn off';

  @override
  String get timerBackgroundHint => 'Timers only alert while Yumdoor is open.';

  @override
  String get searchAddRating => 'Rating';

  @override
  String get searchAddLastCooked => 'Last cooked';

  @override
  String get searchAddTimesCooked => 'Times cooked';

  @override
  String get searchRatingTitle => 'Filter by rating';

  @override
  String get searchLastCookedTitle => 'Filter by last cooked';

  @override
  String get searchTimesTitle => 'Filter by times cooked';

  @override
  String get searchHistoryHint => 'Counts only your own cook logs.';

  @override
  String searchRatingOption(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: '$stars stars or more',
      one: '1 star or more',
    );
    return '$_temp0';
  }

  @override
  String searchRatingFilter(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: '$stars stars or more',
      one: '1 star or more',
    );
    return 'Rated by you: $_temp0';
  }

  @override
  String get searchLastCookedWeeks => 'Not in 2 weeks';

  @override
  String get searchLastCookedMonth => 'Not in 1 month';

  @override
  String get searchLastCookedMonths => 'Not in 3 months';

  @override
  String searchLastCookedFilter(String date) {
    return 'Last cooked by you on or before $date';
  }

  @override
  String get searchTimesNever => 'Never cooked';

  @override
  String get searchTimesOften => 'Often cooked (5 times or more)';

  @override
  String get searchTimesNeverFilter => 'Never cooked by you';

  @override
  String searchTimesMinFilter(int count) {
    return 'Cooked by you $count+ times';
  }

  @override
  String get searchOfflineTimesNote =>
      'Offline, how often you cooked a recipe isn\'t known. Showing every recipe you\'ve cooked.';

  @override
  String get cookLogTitle => 'Enjoy your meal!';

  @override
  String cookLogSubtitle(String recipe, String servings) {
    return '$recipe · $servings';
  }

  @override
  String get cookLogClose => 'Close without saving';

  @override
  String get cookLogRatingQuestion => 'How was it?';

  @override
  String cookLogRatingStar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get cookLogComment => 'Comment (optional)';

  @override
  String get cookLogVisibility => 'Visible to everyone in this Tandoor space';

  @override
  String get cookLogSave => 'Save';

  @override
  String get cookLogSkip => 'Skip';

  @override
  String get cookLogSaved => 'Saved to the cook log';

  @override
  String cookLogFailed(String reason) {
    return 'Not saved. $reason';
  }

  @override
  String get recipeCooked => 'Log as cooked';

  @override
  String get searchAddCookable => 'Cookable';

  @override
  String get searchCookableTitle => 'Filter by what you have';

  @override
  String get searchCookableHint =>
      'Counts what anyone in your household has on hand, and substitutes.';

  @override
  String get searchCookableNow => 'Cookable now';

  @override
  String get searchCookableOneMissing => 'At most 1 ingredient missing';

  @override
  String get searchAddBook => 'Book';

  @override
  String get searchBookTitle => 'Filter by cookbook';

  @override
  String get searchBookHint =>
      'Several books: recipes from any of them. A book with a saved search counts only the recipes added to it.';

  @override
  String get searchBookEmpty => 'You don\'t have any cookbooks yet.';

  @override
  String searchBookFilter(String book) {
    return 'Book: $book';
  }

  @override
  String get searchAddCreator => 'Created by';

  @override
  String get searchCreatorTitle => 'Filter by creator';

  @override
  String searchCreatorFilter(String name) {
    return 'Created by $name';
  }

  @override
  String get searchOfflineCookableNote =>
      'Offline, what was on hand when a recipe was last opened counts, without substitutes.';

  @override
  String get searchOfflineBookNote =>
      'Offline, which recipes are in a book isn\'t known.';

  @override
  String get searchBookAllChosen => 'All your books are chosen already.';

  @override
  String searchSortButton(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'relevance': 'best match',
      'name': 'by name',
      'lastCooked': 'last cooked',
      'rating': 'by rating',
      'newest': 'newest first',
      'recentlyViewed': 'recently viewed',
      'random': 'random',
      'other': 'best match',
    });
    return 'Sorted: $_temp0';
  }

  @override
  String get searchSortTitle => 'Sort';

  @override
  String get searchSortHint =>
      'Last cooked, rating and recently viewed count only your own cook logs and views.';

  @override
  String searchSortOption(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'relevance': 'Best match',
      'name': 'Name (A–Z)',
      'lastCooked': 'Last cooked',
      'rating': 'Best rated',
      'newest': 'Newest first',
      'recentlyViewed': 'Recently viewed',
      'random': 'Random',
      'other': 'Best match',
    });
    return '$_temp0';
  }

  @override
  String get searchSavedSave => 'Save search';

  @override
  String get searchSavedSaveHint =>
      'The text and filters are saved under this name in Tandoor.';

  @override
  String get searchSavedName => 'Name';

  @override
  String get searchSavedNameEmpty => 'Enter a name.';

  @override
  String get searchSavedConfirm => 'Save';

  @override
  String searchSavedSaved(String name) {
    return 'Saved “$name”';
  }

  @override
  String searchSavedFailed(String reason) {
    return 'That didn\'t work. $reason';
  }

  @override
  String get searchSavedManage => 'Manage';

  @override
  String get searchSavedManageTitle => 'Saved searches';

  @override
  String get searchSavedManageHint =>
      'You can rename and delete your own; shared ones can only be used.';

  @override
  String get searchSavedNone => 'You haven\'t saved a search yet.';

  @override
  String get searchSavedShared => 'Shared with you';

  @override
  String get searchSavedRenameTitle => 'Rename search';

  @override
  String searchSavedRenameLabel(String name) {
    return 'Rename $name';
  }

  @override
  String searchSavedDeleteLabel(String name) {
    return 'Delete $name';
  }

  @override
  String searchSavedDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get searchSavedDeleteText =>
      'The search is deleted in Tandoor too, for everyone it is shared with. A cookbook using this search then shows only the recipes added to it. No recipes are deleted.';

  @override
  String get searchSavedDelete => 'Delete';

  @override
  String searchSavedFilter(String name) {
    return 'Saved: $name';
  }

  @override
  String get searchOfflineSavedNote =>
      'This saved search can\'t be applied offline.';

  @override
  String get searchSavedNameTaken =>
      'A saved search with this name already exists.';

  @override
  String get searchSavedNameConflict =>
      'Not saved. The name may already exist in Tandoor – try another one.';

  @override
  String get searchNewRecipe => 'New recipe';

  @override
  String get editorCancel => 'Cancel';

  @override
  String get editorSave => 'Save';

  @override
  String get editorSaving => 'Saving …';

  @override
  String get editorTitleEdit => 'Edit';

  @override
  String get editorTitleNew => 'New recipe';

  @override
  String get editorTabGeneral => 'General';

  @override
  String get editorTabIngredients => 'Ingredients';

  @override
  String get editorTabSteps => 'Steps';

  @override
  String get editorTabIngredientsSteps => 'Ingredients & steps';

  @override
  String get editorShortcuts =>
      'Shortcuts: Ctrl/Cmd+S saves, Esc cancels, Alt+1 to Alt+3 switch tabs, Alt+Up/Down moves a step, Enter adds an ingredient.';

  @override
  String get stepsEmpty => 'No steps yet. Add the first one below.';

  @override
  String get stepAdd => 'Add step';

  @override
  String get stepEmptyPreview => 'No text yet';

  @override
  String stepExpand(int number) {
    return 'Expand step $number';
  }

  @override
  String stepCollapse(int number) {
    return 'Collapse step $number';
  }

  @override
  String stepDragHandle(int number) {
    return 'Move step $number';
  }

  @override
  String stepActions(int number) {
    return 'Actions for step $number';
  }

  @override
  String get stepMoveUp => 'Move up';

  @override
  String get stepMoveDown => 'Move down';

  @override
  String get stepDelete => 'Delete step';

  @override
  String stepDeleteTitle(int number) {
    return 'Delete step $number?';
  }

  @override
  String stepDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The text and the $count ingredients of this step are deleted.',
      one: 'The text and the ingredient of this step are deleted.',
      zero: 'The text of this step is deleted.',
    );
    return '$_temp0';
  }

  @override
  String get stepInstruction => 'Instructions';

  @override
  String get stepName => 'Name (optional)';

  @override
  String get stepIngredients => 'Ingredients in this step';

  @override
  String get stepAddIngredient => 'Ingredient';

  @override
  String stepAddIngredientTooltip(int number) {
    return 'Add an ingredient to step $number';
  }

  @override
  String stepRemoveIngredient(String name) {
    return 'Remove $name from this step';
  }

  @override
  String stepMoveIngredient(String name) {
    return 'Move $name to another step';
  }

  @override
  String stepMoveIngredientTo(int number) {
    return 'To step $number';
  }

  @override
  String get stepDuration => 'Duration';

  @override
  String get stepDurationUnit => 'min';

  @override
  String get stepDurationHelp => 'offered as a timer';

  @override
  String stepTemplateWarning(int number) {
    return 'The text of step $number refers to ingredients by position (ingredients[0]). Check that it still fits.';
  }

  @override
  String get editorName => 'Name';

  @override
  String get editorDescription => 'Description';

  @override
  String get editorDescriptionHelp =>
      'Markdown works, e.g. **bold** or *italic*.';

  @override
  String get editorServings => 'Servings';

  @override
  String get editorServingsText => 'Called';

  @override
  String get editorServingsTextHint => 'e.g. pieces';

  @override
  String get editorWorkingTime => 'Working time (min)';

  @override
  String get editorWaitingTime => 'Waiting time (min)';

  @override
  String get editorKeywords => 'Keywords';

  @override
  String get editorAddKeyword => 'Keyword';

  @override
  String get editorAddKeywordTooltip => 'Add keyword';

  @override
  String editorRemoveKeyword(String keyword) {
    return 'Remove $keyword';
  }

  @override
  String get editorSource => 'Source';

  @override
  String get editorSourceHint => 'https://…';

  @override
  String get editorNameMissing => 'Give the recipe a name.';

  @override
  String editorTooLong(int max) {
    return 'At most $max characters.';
  }

  @override
  String get editorServingsTooSmall => 'At least 1.';

  @override
  String get editorProblems => 'Please check the marked fields.';

  @override
  String editorSaveFailed(String reason) {
    return 'Not saved. $reason';
  }

  @override
  String get editorForbidden =>
      'Not saved: you may not change this recipe. Your changes are still here.';

  @override
  String get editorRecipeGone => 'This recipe no longer exists.';

  @override
  String get editorSaved => 'Recipe saved';

  @override
  String get editorDiscardTitle => 'Discard changes?';

  @override
  String get editorDiscardBody =>
      'Your changes to this recipe aren\'t saved yet.';

  @override
  String get editorDiscardKeepEditing => 'Keep editing';

  @override
  String get editorDiscard => 'Discard';

  @override
  String get editorDraftTitle => 'Unsaved draft';

  @override
  String editorDraftBody(String date, String time) {
    return 'You made changes here on $date at $time that aren\'t saved.';
  }

  @override
  String get editorDraftStale =>
      'The recipe was changed on the server after that. Saving the draft overwrites those changes.';

  @override
  String get editorDraftRestore => 'Restore draft';

  @override
  String get editorDraftDiscard => 'Discard';

  @override
  String get keywordPickerTitle => 'Add keyword';

  @override
  String get keywordPickerHint => 'Find or create a keyword';

  @override
  String get foodPickerTitle => 'Choose ingredient';

  @override
  String get foodPickerHint => 'Find or create an ingredient';

  @override
  String get unitPickerTitle => 'Choose unit';

  @override
  String get unitPickerHint => 'Find or create a unit';

  @override
  String ingredientsBaseServings(String servings) {
    return 'Amounts for $servings (base recipe)';
  }

  @override
  String get ingredientsEmpty =>
      'No ingredients yet. Type a line below, e.g. “200 g carrots”.';

  @override
  String get ingredientEntryLabel => 'Add ingredient';

  @override
  String get ingredientEntryHint => 'e.g. 200 g carrots, peeled';

  @override
  String get ingredientEntryAdd => 'Add';

  @override
  String ingredientEntryAdded(String ingredient) {
    return 'Added $ingredient';
  }

  @override
  String ingredientEntryUnparsed(String line) {
    return 'Couldn\'t read “$line”, so it was added as a note. Tap the line to choose an ingredient.';
  }

  @override
  String ingredientEntryFailed(String reason) {
    return 'Not added. $reason';
  }

  @override
  String get ingredientEntryDone => 'Done';

  @override
  String get ingredientAddHeader => 'Add section';

  @override
  String get ingredientHeaderTitle => 'Section';

  @override
  String get ingredientHeaderLabel => 'Heading';

  @override
  String get ingredientHeaderHint => 'e.g. For the dough';

  @override
  String get ingredientEditTitle => 'Edit ingredient';

  @override
  String get ingredientAmount => 'Amount';

  @override
  String get ingredientAmountInvalid => 'A number like 1.5 or ½.';

  @override
  String get ingredientUnit => 'Unit';

  @override
  String get ingredientNoUnit => 'None';

  @override
  String get ingredientRemoveUnit => 'Remove unit';

  @override
  String get ingredientFood => 'Ingredient';

  @override
  String get ingredientNote => 'Note';

  @override
  String get ingredientNoAmount => 'No amount';

  @override
  String get ingredientApply => 'Apply';

  @override
  String ingredientActions(String name) {
    return 'Actions for $name';
  }

  @override
  String get ingredientEdit => 'Edit';

  @override
  String get ingredientMoveUp => 'Move up';

  @override
  String get ingredientMoveDown => 'Move down';

  @override
  String get ingredientDelete => 'Delete';

  @override
  String get ingredientUnnamed => 'No ingredient';

  @override
  String pickerCreate(String name) {
    return 'Create “$name”';
  }

  @override
  String pickerCreateFailed(String reason) {
    return 'Not created. $reason';
  }

  @override
  String get editorImage => 'Photo';

  @override
  String get editorImageTakePhoto => 'Take photo';

  @override
  String get editorImagePick => 'Choose image';

  @override
  String get editorImageRemove => 'Remove';

  @override
  String get editorImageNone => 'No photo yet';

  @override
  String get editorImageDrop => 'Drag an image here';

  @override
  String get editorImageDropRelease => 'Release to use the image';

  @override
  String get editorImagePending => 'Uploaded when you save.';

  @override
  String get editorImageRemoved => 'The photo is removed when you save.';

  @override
  String get editorImageNotAnImage =>
      'That is not an image. JPEG, PNG, WebP and GIF work.';

  @override
  String editorImageTooLarge(int megabytes) {
    return 'The image is larger than $megabytes MB.';
  }

  @override
  String get editorImageUnreadable => 'The file could not be read.';

  @override
  String editorImageNotSaved(String reason) {
    return 'Recipe saved, but not its photo. $reason';
  }

  @override
  String get editorImageServerTooLarge =>
      'The server does not accept images this large.';

  @override
  String get editorImageInterrupted =>
      'The connection broke off during the upload. The image may be too large for the server.';

  @override
  String get editorDelete => 'Delete recipe';

  @override
  String get editorDeleteTitle => 'Delete recipe?';

  @override
  String editorDeleteBody(String name) {
    return '“$name” will be deleted for good. That includes its entries in the cook log, meal plans, books and shopping lists. This cannot be undone.';
  }

  @override
  String get editorDeleteKeep => 'Keep';

  @override
  String get editorDeleteConfirm => 'Delete for good';

  @override
  String get editorDeleted => 'Recipe deleted';

  @override
  String editorDeleteFailed(String reason) {
    return 'Not deleted. $reason';
  }

  @override
  String get editorDeleteForbidden =>
      'Not deleted: you may not delete this recipe.';

  @override
  String get editorDeleteInUse =>
      'Not deleted: the recipe may be used as a step in another recipe. Tandoor does not allow deleting it then.';

  @override
  String get navSearch => 'Search';

  @override
  String get navPlan => 'Planner';

  @override
  String get navShopping => 'Shopping';

  @override
  String get navPlanTitle => 'Meal plan';

  @override
  String get navShoppingTitle => 'Shopping list';

  @override
  String get navComingSoon =>
      'This part is coming in one of the next versions.';

  @override
  String get planWeekPrevious => 'Previous week';

  @override
  String get planWeekNext => 'Next week';

  @override
  String get planThisWeek => 'This week';

  @override
  String get planBackToThisWeek => 'Back to this week';

  @override
  String get planAddRecipe => 'Plan a recipe';

  @override
  String get planEmptyWeek => 'Nothing is planned for this week yet.';

  @override
  String planRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String planMealLine(String meal, String servings) {
    return '$meal · $servings serv.';
  }

  @override
  String planDayLabel(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String planToday(String day) {
    return 'Today, $day';
  }

  @override
  String get planSharedWithHousehold => 'Shared with your household';

  @override
  String get planFilterAll => 'All';

  @override
  String get planFilterMine => 'Only mine';

  @override
  String planPlannedBy(String name) {
    return 'Planned by $name';
  }

  @override
  String get planPlannedByOther => 'Planned by someone else';
}

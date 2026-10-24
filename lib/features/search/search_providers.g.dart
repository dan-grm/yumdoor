// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Results for [query], one page at a time.
///
/// A new query is a new provider; the old one is disposed and its request
/// cancelled, so a slow answer to an old query can't replace a newer one.

@ProviderFor(SearchResults)
final searchResultsProvider = SearchResultsFamily._();

/// Results for [query], one page at a time.
///
/// A new query is a new provider; the old one is disposed and its request
/// cancelled, so a slow answer to an old query can't replace a newer one.
final class SearchResultsProvider
    extends $AsyncNotifierProvider<SearchResults, RecipeResults> {
  /// Results for [query], one page at a time.
  ///
  /// A new query is a new provider; the old one is disposed and its request
  /// cancelled, so a slow answer to an old query can't replace a newer one.
  SearchResultsProvider._({
    required SearchResultsFamily super.from,
    required RecipeQuery super.argument,
  }) : super(
         retry: _noRetry,
         name: r'searchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @override
  String toString() {
    return r'searchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchResults create() => SearchResults();

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultsHash() => r'8d32db28f1f69d77d03e90add84e6a199ff0d4c9';

/// Results for [query], one page at a time.
///
/// A new query is a new provider; the old one is disposed and its request
/// cancelled, so a slow answer to an old query can't replace a newer one.

final class SearchResultsFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchResults,
          AsyncValue<RecipeResults>,
          RecipeResults,
          FutureOr<RecipeResults>,
          RecipeQuery
        > {
  SearchResultsFamily._()
    : super(
        retry: _noRetry,
        name: r'searchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Results for [query], one page at a time.
  ///
  /// A new query is a new provider; the old one is disposed and its request
  /// cancelled, so a slow answer to an old query can't replace a newer one.

  SearchResultsProvider call(RecipeQuery query) =>
      SearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchResultsProvider';
}

/// Results for [query], one page at a time.
///
/// A new query is a new provider; the old one is disposed and its request
/// cancelled, so a slow answer to an old query can't replace a newer one.

abstract class _$SearchResults extends $AsyncNotifier<RecipeResults> {
  late final _$args = ref.$arg as RecipeQuery;
  RecipeQuery get query => _$args;

  FutureOr<RecipeResults> build(RecipeQuery query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RecipeResults>, RecipeResults>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RecipeResults>, RecipeResults>,
              AsyncValue<RecipeResults>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// A food by id, for the label of a filter chip opened from a link.

@ProviderFor(food)
final foodProvider = FoodFamily._();

/// A food by id, for the label of a filter chip opened from a link.

final class FoodProvider
    extends $FunctionalProvider<AsyncValue<Food>, Food, FutureOr<Food>>
    with $FutureModifier<Food>, $FutureProvider<Food> {
  /// A food by id, for the label of a filter chip opened from a link.
  FoodProvider._({required FoodFamily super.from, required int super.argument})
    : super(
        retry: _noRetry,
        name: r'foodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodHash();

  @override
  String toString() {
    return r'foodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Food> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Food> create(Ref ref) {
    final argument = this.argument as int;
    return food(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodHash() => r'762f6ecdc95c5ecaf7dc77489c78ddcb51440cb3';

/// A food by id, for the label of a filter chip opened from a link.

final class FoodFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Food>, int> {
  FoodFamily._()
    : super(
        retry: _noRetry,
        name: r'foodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A food by id, for the label of a filter chip opened from a link.

  FoodProvider call(int id) => FoodProvider._(argument: id, from: this);

  @override
  String toString() => r'foodProvider';
}

/// A keyword by id, for the label of a filter chip opened from a link.

@ProviderFor(keyword)
final keywordProvider = KeywordFamily._();

/// A keyword by id, for the label of a filter chip opened from a link.

final class KeywordProvider
    extends $FunctionalProvider<AsyncValue<Keyword>, Keyword, FutureOr<Keyword>>
    with $FutureModifier<Keyword>, $FutureProvider<Keyword> {
  /// A keyword by id, for the label of a filter chip opened from a link.
  KeywordProvider._({
    required KeywordFamily super.from,
    required int super.argument,
  }) : super(
         retry: _noRetry,
         name: r'keywordProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$keywordHash();

  @override
  String toString() {
    return r'keywordProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Keyword> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Keyword> create(Ref ref) {
    final argument = this.argument as int;
    return keyword(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KeywordProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$keywordHash() => r'26ff0886636db41dd02ad49ddeba50d472dcca7a';

/// A keyword by id, for the label of a filter chip opened from a link.

final class KeywordFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Keyword>, int> {
  KeywordFamily._()
    : super(
        retry: _noRetry,
        name: r'keywordProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A keyword by id, for the label of a filter chip opened from a link.

  KeywordProvider call(int id) => KeywordProvider._(argument: id, from: this);

  @override
  String toString() => r'keywordProvider';
}

/// Foods matching what was typed into the food picker.

@ProviderFor(foodSuggestions)
final foodSuggestionsProvider = FoodSuggestionsFamily._();

/// Foods matching what was typed into the food picker.

final class FoodSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          FutureOr<List<Food>>
        >
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  /// Foods matching what was typed into the food picker.
  FoodSuggestionsProvider._({
    required FoodSuggestionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'foodSuggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodSuggestionsHash();

  @override
  String toString() {
    return r'foodSuggestionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    final argument = this.argument as String;
    return foodSuggestions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodSuggestionsHash() => r'dfe4a8f558d125f13a1ecf33f5be528e4a3411f6';

/// Foods matching what was typed into the food picker.

final class FoodSuggestionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Food>>, String> {
  FoodSuggestionsFamily._()
    : super(
        retry: _noRetry,
        name: r'foodSuggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Foods matching what was typed into the food picker.

  FoodSuggestionsProvider call(String query) =>
      FoodSuggestionsProvider._(argument: query, from: this);

  @override
  String toString() => r'foodSuggestionsProvider';
}

/// Keywords matching what was typed into the keyword picker.

@ProviderFor(keywordSuggestions)
final keywordSuggestionsProvider = KeywordSuggestionsFamily._();

/// Keywords matching what was typed into the keyword picker.

final class KeywordSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Keyword>>,
          List<Keyword>,
          FutureOr<List<Keyword>>
        >
    with $FutureModifier<List<Keyword>>, $FutureProvider<List<Keyword>> {
  /// Keywords matching what was typed into the keyword picker.
  KeywordSuggestionsProvider._({
    required KeywordSuggestionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'keywordSuggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$keywordSuggestionsHash();

  @override
  String toString() {
    return r'keywordSuggestionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Keyword>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Keyword>> create(Ref ref) {
    final argument = this.argument as String;
    return keywordSuggestions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KeywordSuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$keywordSuggestionsHash() =>
    r'a0344170a94ffec10f0b1235416cf8283c449071';

/// Keywords matching what was typed into the keyword picker.

final class KeywordSuggestionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Keyword>>, String> {
  KeywordSuggestionsFamily._()
    : super(
        retry: _noRetry,
        name: r'keywordSuggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keywords matching what was typed into the keyword picker.

  KeywordSuggestionsProvider call(String query) =>
      KeywordSuggestionsProvider._(argument: query, from: this);

  @override
  String toString() => r'keywordSuggestionsProvider';
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Recipe extends Recipe {
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
  @override
  final String? description;
  @override
  final int? diameter;
  @override
  final String? diameterText;
  @override
  final String? filePath;
  @override
  final JsonObject? foodProperties;
  @override
  final int? id;
  @override
  final String? image;
  @override
  final bool? internal;
  @override
  final BuiltList<Keyword>? keywords;
  @override
  final DateTime? lastCooked;
  @override
  final String name;
  @override
  final NutritionInformation? nutrition;
  @override
  final bool? private;
  @override
  final BuiltList<Property>? properties;
  @override
  final double? rating;
  @override
  final int? servings;
  @override
  final String? servingsText;
  @override
  final BuiltList<User>? shared;
  @override
  final bool? showIngredientOverview;
  @override
  final String? sourceUrl;
  @override
  final BuiltList<Step> steps;
  @override
  final DateTime? updatedAt;
  @override
  final int? waitingTime;
  @override
  final int? workingTime;

  factory _$Recipe([void Function(RecipeBuilder)? updates]) =>
      (RecipeBuilder()..update(updates))._build();

  _$Recipe._({
    this.createdAt,
    this.createdBy,
    this.description,
    this.diameter,
    this.diameterText,
    this.filePath,
    this.foodProperties,
    this.id,
    this.image,
    this.internal,
    this.keywords,
    this.lastCooked,
    required this.name,
    this.nutrition,
    this.private,
    this.properties,
    this.rating,
    this.servings,
    this.servingsText,
    this.shared,
    this.showIngredientOverview,
    this.sourceUrl,
    required this.steps,
    this.updatedAt,
    this.waitingTime,
    this.workingTime,
  }) : super._();
  @override
  Recipe rebuild(void Function(RecipeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeBuilder toBuilder() => RecipeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Recipe &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        description == other.description &&
        diameter == other.diameter &&
        diameterText == other.diameterText &&
        filePath == other.filePath &&
        foodProperties == other.foodProperties &&
        id == other.id &&
        image == other.image &&
        internal == other.internal &&
        keywords == other.keywords &&
        lastCooked == other.lastCooked &&
        name == other.name &&
        nutrition == other.nutrition &&
        private == other.private &&
        properties == other.properties &&
        rating == other.rating &&
        servings == other.servings &&
        servingsText == other.servingsText &&
        shared == other.shared &&
        showIngredientOverview == other.showIngredientOverview &&
        sourceUrl == other.sourceUrl &&
        steps == other.steps &&
        updatedAt == other.updatedAt &&
        waitingTime == other.waitingTime &&
        workingTime == other.workingTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, diameter.hashCode);
    _$hash = $jc(_$hash, diameterText.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, foodProperties.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, internal.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, lastCooked.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nutrition.hashCode);
    _$hash = $jc(_$hash, private.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, servingsText.hashCode);
    _$hash = $jc(_$hash, shared.hashCode);
    _$hash = $jc(_$hash, showIngredientOverview.hashCode);
    _$hash = $jc(_$hash, sourceUrl.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, waitingTime.hashCode);
    _$hash = $jc(_$hash, workingTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Recipe')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('diameter', diameter)
          ..add('diameterText', diameterText)
          ..add('filePath', filePath)
          ..add('foodProperties', foodProperties)
          ..add('id', id)
          ..add('image', image)
          ..add('internal', internal)
          ..add('keywords', keywords)
          ..add('lastCooked', lastCooked)
          ..add('name', name)
          ..add('nutrition', nutrition)
          ..add('private', private)
          ..add('properties', properties)
          ..add('rating', rating)
          ..add('servings', servings)
          ..add('servingsText', servingsText)
          ..add('shared', shared)
          ..add('showIngredientOverview', showIngredientOverview)
          ..add('sourceUrl', sourceUrl)
          ..add('steps', steps)
          ..add('updatedAt', updatedAt)
          ..add('waitingTime', waitingTime)
          ..add('workingTime', workingTime))
        .toString();
  }
}

class RecipeBuilder implements Builder<Recipe, RecipeBuilder> {
  _$Recipe? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _diameter;
  int? get diameter => _$this._diameter;
  set diameter(int? diameter) => _$this._diameter = diameter;

  String? _diameterText;
  String? get diameterText => _$this._diameterText;
  set diameterText(String? diameterText) => _$this._diameterText = diameterText;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  JsonObject? _foodProperties;
  JsonObject? get foodProperties => _$this._foodProperties;
  set foodProperties(JsonObject? foodProperties) =>
      _$this._foodProperties = foodProperties;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _internal;
  bool? get internal => _$this._internal;
  set internal(bool? internal) => _$this._internal = internal;

  ListBuilder<Keyword>? _keywords;
  ListBuilder<Keyword> get keywords =>
      _$this._keywords ??= ListBuilder<Keyword>();
  set keywords(ListBuilder<Keyword>? keywords) => _$this._keywords = keywords;

  DateTime? _lastCooked;
  DateTime? get lastCooked => _$this._lastCooked;
  set lastCooked(DateTime? lastCooked) => _$this._lastCooked = lastCooked;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  NutritionInformationBuilder? _nutrition;
  NutritionInformationBuilder get nutrition =>
      _$this._nutrition ??= NutritionInformationBuilder();
  set nutrition(NutritionInformationBuilder? nutrition) =>
      _$this._nutrition = nutrition;

  bool? _private;
  bool? get private => _$this._private;
  set private(bool? private) => _$this._private = private;

  ListBuilder<Property>? _properties;
  ListBuilder<Property> get properties =>
      _$this._properties ??= ListBuilder<Property>();
  set properties(ListBuilder<Property>? properties) =>
      _$this._properties = properties;

  double? _rating;
  double? get rating => _$this._rating;
  set rating(double? rating) => _$this._rating = rating;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  String? _servingsText;
  String? get servingsText => _$this._servingsText;
  set servingsText(String? servingsText) => _$this._servingsText = servingsText;

  ListBuilder<User>? _shared;
  ListBuilder<User> get shared => _$this._shared ??= ListBuilder<User>();
  set shared(ListBuilder<User>? shared) => _$this._shared = shared;

  bool? _showIngredientOverview;
  bool? get showIngredientOverview => _$this._showIngredientOverview;
  set showIngredientOverview(bool? showIngredientOverview) =>
      _$this._showIngredientOverview = showIngredientOverview;

  String? _sourceUrl;
  String? get sourceUrl => _$this._sourceUrl;
  set sourceUrl(String? sourceUrl) => _$this._sourceUrl = sourceUrl;

  ListBuilder<Step>? _steps;
  ListBuilder<Step> get steps => _$this._steps ??= ListBuilder<Step>();
  set steps(ListBuilder<Step>? steps) => _$this._steps = steps;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _waitingTime;
  int? get waitingTime => _$this._waitingTime;
  set waitingTime(int? waitingTime) => _$this._waitingTime = waitingTime;

  int? _workingTime;
  int? get workingTime => _$this._workingTime;
  set workingTime(int? workingTime) => _$this._workingTime = workingTime;

  RecipeBuilder() {
    Recipe._defaults(this);
  }

  RecipeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
      _description = $v.description;
      _diameter = $v.diameter;
      _diameterText = $v.diameterText;
      _filePath = $v.filePath;
      _foodProperties = $v.foodProperties;
      _id = $v.id;
      _image = $v.image;
      _internal = $v.internal;
      _keywords = $v.keywords?.toBuilder();
      _lastCooked = $v.lastCooked;
      _name = $v.name;
      _nutrition = $v.nutrition?.toBuilder();
      _private = $v.private;
      _properties = $v.properties?.toBuilder();
      _rating = $v.rating;
      _servings = $v.servings;
      _servingsText = $v.servingsText;
      _shared = $v.shared?.toBuilder();
      _showIngredientOverview = $v.showIngredientOverview;
      _sourceUrl = $v.sourceUrl;
      _steps = $v.steps.toBuilder();
      _updatedAt = $v.updatedAt;
      _waitingTime = $v.waitingTime;
      _workingTime = $v.workingTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Recipe other) {
    _$v = other as _$Recipe;
  }

  @override
  void update(void Function(RecipeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Recipe build() => _build();

  _$Recipe _build() {
    _$Recipe _$result;
    try {
      _$result =
          _$v ??
          _$Recipe._(
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            description: description,
            diameter: diameter,
            diameterText: diameterText,
            filePath: filePath,
            foodProperties: foodProperties,
            id: id,
            image: image,
            internal: internal,
            keywords: _keywords?.build(),
            lastCooked: lastCooked,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Recipe',
              'name',
            ),
            nutrition: _nutrition?.build(),
            private: private,
            properties: _properties?.build(),
            rating: rating,
            servings: servings,
            servingsText: servingsText,
            shared: _shared?.build(),
            showIngredientOverview: showIngredientOverview,
            sourceUrl: sourceUrl,
            steps: steps.build(),
            updatedAt: updatedAt,
            waitingTime: waitingTime,
            workingTime: workingTime,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();

        _$failedField = 'keywords';
        _keywords?.build();

        _$failedField = 'nutrition';
        _nutrition?.build();

        _$failedField = 'properties';
        _properties?.build();

        _$failedField = 'shared';
        _shared?.build();

        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Recipe',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

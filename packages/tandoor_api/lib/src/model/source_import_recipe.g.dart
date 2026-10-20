// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_recipe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportRecipe extends SourceImportRecipe {
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final bool? internal;
  @override
  final BuiltList<SourceImportKeyword>? keywords;
  @override
  final String name;
  @override
  final BuiltList<SourceImportProperty>? properties;
  @override
  final int? servings;
  @override
  final String? servingsText;
  @override
  final String sourceUrl;
  @override
  final BuiltList<SourceImportStep> steps;
  @override
  final int? waitingTime;
  @override
  final int? workingTime;

  factory _$SourceImportRecipe([
    void Function(SourceImportRecipeBuilder)? updates,
  ]) => (SourceImportRecipeBuilder()..update(updates))._build();

  _$SourceImportRecipe._({
    this.description,
    this.imageUrl,
    this.internal,
    this.keywords,
    required this.name,
    this.properties,
    this.servings,
    this.servingsText,
    required this.sourceUrl,
    required this.steps,
    this.waitingTime,
    this.workingTime,
  }) : super._();
  @override
  SourceImportRecipe rebuild(
    void Function(SourceImportRecipeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportRecipeBuilder toBuilder() =>
      SourceImportRecipeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportRecipe &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        internal == other.internal &&
        keywords == other.keywords &&
        name == other.name &&
        properties == other.properties &&
        servings == other.servings &&
        servingsText == other.servingsText &&
        sourceUrl == other.sourceUrl &&
        steps == other.steps &&
        waitingTime == other.waitingTime &&
        workingTime == other.workingTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, internal.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, servingsText.hashCode);
    _$hash = $jc(_$hash, sourceUrl.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, waitingTime.hashCode);
    _$hash = $jc(_$hash, workingTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportRecipe')
          ..add('description', description)
          ..add('imageUrl', imageUrl)
          ..add('internal', internal)
          ..add('keywords', keywords)
          ..add('name', name)
          ..add('properties', properties)
          ..add('servings', servings)
          ..add('servingsText', servingsText)
          ..add('sourceUrl', sourceUrl)
          ..add('steps', steps)
          ..add('waitingTime', waitingTime)
          ..add('workingTime', workingTime))
        .toString();
  }
}

class SourceImportRecipeBuilder
    implements Builder<SourceImportRecipe, SourceImportRecipeBuilder> {
  _$SourceImportRecipe? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  bool? _internal;
  bool? get internal => _$this._internal;
  set internal(bool? internal) => _$this._internal = internal;

  ListBuilder<SourceImportKeyword>? _keywords;
  ListBuilder<SourceImportKeyword> get keywords =>
      _$this._keywords ??= ListBuilder<SourceImportKeyword>();
  set keywords(ListBuilder<SourceImportKeyword>? keywords) =>
      _$this._keywords = keywords;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<SourceImportProperty>? _properties;
  ListBuilder<SourceImportProperty> get properties =>
      _$this._properties ??= ListBuilder<SourceImportProperty>();
  set properties(ListBuilder<SourceImportProperty>? properties) =>
      _$this._properties = properties;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  String? _servingsText;
  String? get servingsText => _$this._servingsText;
  set servingsText(String? servingsText) => _$this._servingsText = servingsText;

  String? _sourceUrl;
  String? get sourceUrl => _$this._sourceUrl;
  set sourceUrl(String? sourceUrl) => _$this._sourceUrl = sourceUrl;

  ListBuilder<SourceImportStep>? _steps;
  ListBuilder<SourceImportStep> get steps =>
      _$this._steps ??= ListBuilder<SourceImportStep>();
  set steps(ListBuilder<SourceImportStep>? steps) => _$this._steps = steps;

  int? _waitingTime;
  int? get waitingTime => _$this._waitingTime;
  set waitingTime(int? waitingTime) => _$this._waitingTime = waitingTime;

  int? _workingTime;
  int? get workingTime => _$this._workingTime;
  set workingTime(int? workingTime) => _$this._workingTime = workingTime;

  SourceImportRecipeBuilder() {
    SourceImportRecipe._defaults(this);
  }

  SourceImportRecipeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _imageUrl = $v.imageUrl;
      _internal = $v.internal;
      _keywords = $v.keywords?.toBuilder();
      _name = $v.name;
      _properties = $v.properties?.toBuilder();
      _servings = $v.servings;
      _servingsText = $v.servingsText;
      _sourceUrl = $v.sourceUrl;
      _steps = $v.steps.toBuilder();
      _waitingTime = $v.waitingTime;
      _workingTime = $v.workingTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportRecipe other) {
    _$v = other as _$SourceImportRecipe;
  }

  @override
  void update(void Function(SourceImportRecipeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportRecipe build() => _build();

  _$SourceImportRecipe _build() {
    _$SourceImportRecipe _$result;
    try {
      _$result =
          _$v ??
          _$SourceImportRecipe._(
            description: description,
            imageUrl: imageUrl,
            internal: internal,
            keywords: _keywords?.build(),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'SourceImportRecipe',
              'name',
            ),
            properties: _properties?.build(),
            servings: servings,
            servingsText: servingsText,
            sourceUrl: BuiltValueNullFieldError.checkNotNull(
              sourceUrl,
              r'SourceImportRecipe',
              'sourceUrl',
            ),
            steps: steps.build(),
            waitingTime: waitingTime,
            workingTime: workingTime,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keywords';
        _keywords?.build();

        _$failedField = 'properties';
        _properties?.build();

        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SourceImportRecipe',
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

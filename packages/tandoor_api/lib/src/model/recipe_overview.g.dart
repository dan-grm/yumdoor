// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_overview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeOverview extends RecipeOverview {
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? image;
  @override
  final bool? internal;
  @override
  final BuiltList<KeywordLabel>? keywords;
  @override
  final DateTime? lastCooked;
  @override
  final String name;
  @override
  final bool? new_;
  @override
  final bool? private;
  @override
  final double? rating;
  @override
  final String? recent;
  @override
  final int? servings;
  @override
  final String? servingsText;
  @override
  final DateTime? updatedAt;
  @override
  final int? waitingTime;
  @override
  final int? workingTime;

  factory _$RecipeOverview([void Function(RecipeOverviewBuilder)? updates]) =>
      (RecipeOverviewBuilder()..update(updates))._build();

  _$RecipeOverview._({
    this.createdAt,
    this.createdBy,
    this.description,
    this.id,
    this.image,
    this.internal,
    this.keywords,
    this.lastCooked,
    required this.name,
    this.new_,
    this.private,
    this.rating,
    this.recent,
    this.servings,
    this.servingsText,
    this.updatedAt,
    this.waitingTime,
    this.workingTime,
  }) : super._();
  @override
  RecipeOverview rebuild(void Function(RecipeOverviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeOverviewBuilder toBuilder() => RecipeOverviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeOverview &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        description == other.description &&
        id == other.id &&
        image == other.image &&
        internal == other.internal &&
        keywords == other.keywords &&
        lastCooked == other.lastCooked &&
        name == other.name &&
        new_ == other.new_ &&
        private == other.private &&
        rating == other.rating &&
        recent == other.recent &&
        servings == other.servings &&
        servingsText == other.servingsText &&
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
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, internal.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, lastCooked.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, new_.hashCode);
    _$hash = $jc(_$hash, private.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recent.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, servingsText.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, waitingTime.hashCode);
    _$hash = $jc(_$hash, workingTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeOverview')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('id', id)
          ..add('image', image)
          ..add('internal', internal)
          ..add('keywords', keywords)
          ..add('lastCooked', lastCooked)
          ..add('name', name)
          ..add('new_', new_)
          ..add('private', private)
          ..add('rating', rating)
          ..add('recent', recent)
          ..add('servings', servings)
          ..add('servingsText', servingsText)
          ..add('updatedAt', updatedAt)
          ..add('waitingTime', waitingTime)
          ..add('workingTime', workingTime))
        .toString();
  }
}

class RecipeOverviewBuilder
    implements Builder<RecipeOverview, RecipeOverviewBuilder> {
  _$RecipeOverview? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _internal;
  bool? get internal => _$this._internal;
  set internal(bool? internal) => _$this._internal = internal;

  ListBuilder<KeywordLabel>? _keywords;
  ListBuilder<KeywordLabel> get keywords =>
      _$this._keywords ??= ListBuilder<KeywordLabel>();
  set keywords(ListBuilder<KeywordLabel>? keywords) =>
      _$this._keywords = keywords;

  DateTime? _lastCooked;
  DateTime? get lastCooked => _$this._lastCooked;
  set lastCooked(DateTime? lastCooked) => _$this._lastCooked = lastCooked;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _new_;
  bool? get new_ => _$this._new_;
  set new_(bool? new_) => _$this._new_ = new_;

  bool? _private;
  bool? get private => _$this._private;
  set private(bool? private) => _$this._private = private;

  double? _rating;
  double? get rating => _$this._rating;
  set rating(double? rating) => _$this._rating = rating;

  String? _recent;
  String? get recent => _$this._recent;
  set recent(String? recent) => _$this._recent = recent;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  String? _servingsText;
  String? get servingsText => _$this._servingsText;
  set servingsText(String? servingsText) => _$this._servingsText = servingsText;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _waitingTime;
  int? get waitingTime => _$this._waitingTime;
  set waitingTime(int? waitingTime) => _$this._waitingTime = waitingTime;

  int? _workingTime;
  int? get workingTime => _$this._workingTime;
  set workingTime(int? workingTime) => _$this._workingTime = workingTime;

  RecipeOverviewBuilder() {
    RecipeOverview._defaults(this);
  }

  RecipeOverviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
      _description = $v.description;
      _id = $v.id;
      _image = $v.image;
      _internal = $v.internal;
      _keywords = $v.keywords?.toBuilder();
      _lastCooked = $v.lastCooked;
      _name = $v.name;
      _new_ = $v.new_;
      _private = $v.private;
      _rating = $v.rating;
      _recent = $v.recent;
      _servings = $v.servings;
      _servingsText = $v.servingsText;
      _updatedAt = $v.updatedAt;
      _waitingTime = $v.waitingTime;
      _workingTime = $v.workingTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeOverview other) {
    _$v = other as _$RecipeOverview;
  }

  @override
  void update(void Function(RecipeOverviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeOverview build() => _build();

  _$RecipeOverview _build() {
    _$RecipeOverview _$result;
    try {
      _$result =
          _$v ??
          _$RecipeOverview._(
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            description: description,
            id: id,
            image: image,
            internal: internal,
            keywords: _keywords?.build(),
            lastCooked: lastCooked,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'RecipeOverview',
              'name',
            ),
            new_: new_,
            private: private,
            rating: rating,
            recent: recent,
            servings: servings,
            servingsText: servingsText,
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
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeOverview',
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

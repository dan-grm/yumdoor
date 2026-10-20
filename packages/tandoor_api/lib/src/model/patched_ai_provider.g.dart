// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_ai_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedAiProvider extends PatchedAiProvider {
  @override
  final String? apiKey;
  @override
  final DateTime? createdAt;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final bool? logCreditCost;
  @override
  final String? modelName;
  @override
  final String? name;
  @override
  final int? space;
  @override
  final DateTime? updatedAt;
  @override
  final String? url;

  factory _$PatchedAiProvider([
    void Function(PatchedAiProviderBuilder)? updates,
  ]) => (PatchedAiProviderBuilder()..update(updates))._build();

  _$PatchedAiProvider._({
    this.apiKey,
    this.createdAt,
    this.description,
    this.id,
    this.logCreditCost,
    this.modelName,
    this.name,
    this.space,
    this.updatedAt,
    this.url,
  }) : super._();
  @override
  PatchedAiProvider rebuild(void Function(PatchedAiProviderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedAiProviderBuilder toBuilder() =>
      PatchedAiProviderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedAiProvider &&
        apiKey == other.apiKey &&
        createdAt == other.createdAt &&
        description == other.description &&
        id == other.id &&
        logCreditCost == other.logCreditCost &&
        modelName == other.modelName &&
        name == other.name &&
        space == other.space &&
        updatedAt == other.updatedAt &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apiKey.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, logCreditCost.hashCode);
    _$hash = $jc(_$hash, modelName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, space.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedAiProvider')
          ..add('apiKey', apiKey)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('id', id)
          ..add('logCreditCost', logCreditCost)
          ..add('modelName', modelName)
          ..add('name', name)
          ..add('space', space)
          ..add('updatedAt', updatedAt)
          ..add('url', url))
        .toString();
  }
}

class PatchedAiProviderBuilder
    implements Builder<PatchedAiProvider, PatchedAiProviderBuilder> {
  _$PatchedAiProvider? _$v;

  String? _apiKey;
  String? get apiKey => _$this._apiKey;
  set apiKey(String? apiKey) => _$this._apiKey = apiKey;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _logCreditCost;
  bool? get logCreditCost => _$this._logCreditCost;
  set logCreditCost(bool? logCreditCost) =>
      _$this._logCreditCost = logCreditCost;

  String? _modelName;
  String? get modelName => _$this._modelName;
  set modelName(String? modelName) => _$this._modelName = modelName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _space;
  int? get space => _$this._space;
  set space(int? space) => _$this._space = space;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  PatchedAiProviderBuilder() {
    PatchedAiProvider._defaults(this);
  }

  PatchedAiProviderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apiKey = $v.apiKey;
      _createdAt = $v.createdAt;
      _description = $v.description;
      _id = $v.id;
      _logCreditCost = $v.logCreditCost;
      _modelName = $v.modelName;
      _name = $v.name;
      _space = $v.space;
      _updatedAt = $v.updatedAt;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedAiProvider other) {
    _$v = other as _$PatchedAiProvider;
  }

  @override
  void update(void Function(PatchedAiProviderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedAiProvider build() => _build();

  _$PatchedAiProvider _build() {
    final _$result =
        _$v ??
        _$PatchedAiProvider._(
          apiKey: apiKey,
          createdAt: createdAt,
          description: description,
          id: id,
          logCreditCost: logCreditCost,
          modelName: modelName,
          name: name,
          space: space,
          updatedAt: updatedAt,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

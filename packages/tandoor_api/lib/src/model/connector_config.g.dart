// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_config.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectorConfig extends ConnectorConfig {
  @override
  final int? createdBy;
  @override
  final bool? enabled;
  @override
  final int? id;
  @override
  final String name;
  @override
  final bool? onShoppingListEntryCreatedEnabled;
  @override
  final bool? onShoppingListEntryDeletedEnabled;
  @override
  final bool? onShoppingListEntryUpdatedEnabled;
  @override
  final bool? supportsDescriptionField;
  @override
  final String? todoEntity;
  @override
  final String? token;
  @override
  final ConnectorConfigTypeEnum? type;
  @override
  final ConnectorConfigUrl? url;

  factory _$ConnectorConfig([void Function(ConnectorConfigBuilder)? updates]) =>
      (ConnectorConfigBuilder()..update(updates))._build();

  _$ConnectorConfig._({
    this.createdBy,
    this.enabled,
    this.id,
    required this.name,
    this.onShoppingListEntryCreatedEnabled,
    this.onShoppingListEntryDeletedEnabled,
    this.onShoppingListEntryUpdatedEnabled,
    this.supportsDescriptionField,
    this.todoEntity,
    this.token,
    this.type,
    this.url,
  }) : super._();
  @override
  ConnectorConfig rebuild(void Function(ConnectorConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectorConfigBuilder toBuilder() => ConnectorConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectorConfig &&
        createdBy == other.createdBy &&
        enabled == other.enabled &&
        id == other.id &&
        name == other.name &&
        onShoppingListEntryCreatedEnabled ==
            other.onShoppingListEntryCreatedEnabled &&
        onShoppingListEntryDeletedEnabled ==
            other.onShoppingListEntryDeletedEnabled &&
        onShoppingListEntryUpdatedEnabled ==
            other.onShoppingListEntryUpdatedEnabled &&
        supportsDescriptionField == other.supportsDescriptionField &&
        todoEntity == other.todoEntity &&
        token == other.token &&
        type == other.type &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, onShoppingListEntryCreatedEnabled.hashCode);
    _$hash = $jc(_$hash, onShoppingListEntryDeletedEnabled.hashCode);
    _$hash = $jc(_$hash, onShoppingListEntryUpdatedEnabled.hashCode);
    _$hash = $jc(_$hash, supportsDescriptionField.hashCode);
    _$hash = $jc(_$hash, todoEntity.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectorConfig')
          ..add('createdBy', createdBy)
          ..add('enabled', enabled)
          ..add('id', id)
          ..add('name', name)
          ..add(
            'onShoppingListEntryCreatedEnabled',
            onShoppingListEntryCreatedEnabled,
          )
          ..add(
            'onShoppingListEntryDeletedEnabled',
            onShoppingListEntryDeletedEnabled,
          )
          ..add(
            'onShoppingListEntryUpdatedEnabled',
            onShoppingListEntryUpdatedEnabled,
          )
          ..add('supportsDescriptionField', supportsDescriptionField)
          ..add('todoEntity', todoEntity)
          ..add('token', token)
          ..add('type', type)
          ..add('url', url))
        .toString();
  }
}

class ConnectorConfigBuilder
    implements Builder<ConnectorConfig, ConnectorConfigBuilder> {
  _$ConnectorConfig? _$v;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _onShoppingListEntryCreatedEnabled;
  bool? get onShoppingListEntryCreatedEnabled =>
      _$this._onShoppingListEntryCreatedEnabled;
  set onShoppingListEntryCreatedEnabled(
    bool? onShoppingListEntryCreatedEnabled,
  ) => _$this._onShoppingListEntryCreatedEnabled =
      onShoppingListEntryCreatedEnabled;

  bool? _onShoppingListEntryDeletedEnabled;
  bool? get onShoppingListEntryDeletedEnabled =>
      _$this._onShoppingListEntryDeletedEnabled;
  set onShoppingListEntryDeletedEnabled(
    bool? onShoppingListEntryDeletedEnabled,
  ) => _$this._onShoppingListEntryDeletedEnabled =
      onShoppingListEntryDeletedEnabled;

  bool? _onShoppingListEntryUpdatedEnabled;
  bool? get onShoppingListEntryUpdatedEnabled =>
      _$this._onShoppingListEntryUpdatedEnabled;
  set onShoppingListEntryUpdatedEnabled(
    bool? onShoppingListEntryUpdatedEnabled,
  ) => _$this._onShoppingListEntryUpdatedEnabled =
      onShoppingListEntryUpdatedEnabled;

  bool? _supportsDescriptionField;
  bool? get supportsDescriptionField => _$this._supportsDescriptionField;
  set supportsDescriptionField(bool? supportsDescriptionField) =>
      _$this._supportsDescriptionField = supportsDescriptionField;

  String? _todoEntity;
  String? get todoEntity => _$this._todoEntity;
  set todoEntity(String? todoEntity) => _$this._todoEntity = todoEntity;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  ConnectorConfigTypeEnum? _type;
  ConnectorConfigTypeEnum? get type => _$this._type;
  set type(ConnectorConfigTypeEnum? type) => _$this._type = type;

  ConnectorConfigUrlBuilder? _url;
  ConnectorConfigUrlBuilder get url =>
      _$this._url ??= ConnectorConfigUrlBuilder();
  set url(ConnectorConfigUrlBuilder? url) => _$this._url = url;

  ConnectorConfigBuilder() {
    ConnectorConfig._defaults(this);
  }

  ConnectorConfigBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy;
      _enabled = $v.enabled;
      _id = $v.id;
      _name = $v.name;
      _onShoppingListEntryCreatedEnabled = $v.onShoppingListEntryCreatedEnabled;
      _onShoppingListEntryDeletedEnabled = $v.onShoppingListEntryDeletedEnabled;
      _onShoppingListEntryUpdatedEnabled = $v.onShoppingListEntryUpdatedEnabled;
      _supportsDescriptionField = $v.supportsDescriptionField;
      _todoEntity = $v.todoEntity;
      _token = $v.token;
      _type = $v.type;
      _url = $v.url?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectorConfig other) {
    _$v = other as _$ConnectorConfig;
  }

  @override
  void update(void Function(ConnectorConfigBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectorConfig build() => _build();

  _$ConnectorConfig _build() {
    _$ConnectorConfig _$result;
    try {
      _$result =
          _$v ??
          _$ConnectorConfig._(
            createdBy: createdBy,
            enabled: enabled,
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ConnectorConfig',
              'name',
            ),
            onShoppingListEntryCreatedEnabled:
                onShoppingListEntryCreatedEnabled,
            onShoppingListEntryDeletedEnabled:
                onShoppingListEntryDeletedEnabled,
            onShoppingListEntryUpdatedEnabled:
                onShoppingListEntryUpdatedEnabled,
            supportsDescriptionField: supportsDescriptionField,
            todoEntity: todoEntity,
            token: token,
            type: type,
            url: _url?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'url';
        _url?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ConnectorConfig',
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

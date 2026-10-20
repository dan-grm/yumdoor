// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_config_url.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectorConfigUrl extends ConnectorConfigUrl {
  @override
  final OneOf oneOf;

  factory _$ConnectorConfigUrl([
    void Function(ConnectorConfigUrlBuilder)? updates,
  ]) => (ConnectorConfigUrlBuilder()..update(updates))._build();

  _$ConnectorConfigUrl._({required this.oneOf}) : super._();
  @override
  ConnectorConfigUrl rebuild(
    void Function(ConnectorConfigUrlBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ConnectorConfigUrlBuilder toBuilder() =>
      ConnectorConfigUrlBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectorConfigUrl && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ConnectorConfigUrl',
    )..add('oneOf', oneOf)).toString();
  }
}

class ConnectorConfigUrlBuilder
    implements Builder<ConnectorConfigUrl, ConnectorConfigUrlBuilder> {
  _$ConnectorConfigUrl? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  ConnectorConfigUrlBuilder() {
    ConnectorConfigUrl._defaults(this);
  }

  ConnectorConfigUrlBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectorConfigUrl other) {
    _$v = other as _$ConnectorConfigUrl;
  }

  @override
  void update(void Function(ConnectorConfigUrlBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectorConfigUrl build() => _build();

  _$ConnectorConfigUrl _build() {
    final _$result =
        _$v ??
        _$ConnectorConfigUrl._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'ConnectorConfigUrl',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

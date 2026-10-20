// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_config_type_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConnectorConfigTypeEnum _$homeAssistant = const ConnectorConfigTypeEnum._(
  'homeAssistant',
);
const ConnectorConfigTypeEnum _$unknownDefaultOpenApi =
    const ConnectorConfigTypeEnum._('unknownDefaultOpenApi');

ConnectorConfigTypeEnum _$valueOf(String name) {
  switch (name) {
    case 'homeAssistant':
      return _$homeAssistant;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<ConnectorConfigTypeEnum> _$values =
    BuiltSet<ConnectorConfigTypeEnum>(const <ConnectorConfigTypeEnum>[
      _$homeAssistant,
      _$unknownDefaultOpenApi,
    ]);

class _$ConnectorConfigTypeEnumMeta {
  const _$ConnectorConfigTypeEnumMeta();
  ConnectorConfigTypeEnum get homeAssistant => _$homeAssistant;
  ConnectorConfigTypeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  ConnectorConfigTypeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<ConnectorConfigTypeEnum> get values => _$values;
}

mixin _$ConnectorConfigTypeEnumMixin {
  // ignore: non_constant_identifier_names
  _$ConnectorConfigTypeEnumMeta get ConnectorConfigTypeEnum =>
      const _$ConnectorConfigTypeEnumMeta();
}

Serializer<ConnectorConfigTypeEnum> _$connectorConfigTypeEnumSerializer =
    _$ConnectorConfigTypeEnumSerializer();

class _$ConnectorConfigTypeEnumSerializer
    implements PrimitiveSerializer<ConnectorConfigTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'homeAssistant': 'HomeAssistant',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HomeAssistant': 'homeAssistant',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ConnectorConfigTypeEnum];
  @override
  final String wireName = 'ConnectorConfigTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ConnectorConfigTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ConnectorConfigTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ConnectorConfigTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

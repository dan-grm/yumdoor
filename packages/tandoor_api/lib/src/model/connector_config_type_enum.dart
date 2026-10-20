//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connector_config_type_enum.g.dart';

/// * `HomeAssistant` - HomeAssistant
class ConnectorConfigTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'HomeAssistant')
  static const ConnectorConfigTypeEnum homeAssistant = _$homeAssistant;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ConnectorConfigTypeEnum unknownDefaultOpenApi =
      _$unknownDefaultOpenApi;

  static Serializer<ConnectorConfigTypeEnum> get serializer =>
      _$connectorConfigTypeEnumSerializer;

  const ConnectorConfigTypeEnum._(String name) : super(name);

  static BuiltSet<ConnectorConfigTypeEnum> get values => _$values;
  static ConnectorConfigTypeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ConnectorConfigTypeEnumMixin = Object
    with _$ConnectorConfigTypeEnumMixin;

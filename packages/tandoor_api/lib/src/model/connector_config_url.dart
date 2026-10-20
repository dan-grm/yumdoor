//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'connector_config_url.g.dart';

/// ConnectorConfigUrl
@BuiltValue()
abstract class ConnectorConfigUrl
    implements Built<ConnectorConfigUrl, ConnectorConfigUrlBuilder> {
  /// One Of [String]
  OneOf get oneOf;

  ConnectorConfigUrl._();

  factory ConnectorConfigUrl([void updates(ConnectorConfigUrlBuilder b)]) =
      _$ConnectorConfigUrl;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectorConfigUrlBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectorConfigUrl> get serializer =>
      _$ConnectorConfigUrlSerializer();
}

class _$ConnectorConfigUrlSerializer
    implements PrimitiveSerializer<ConnectorConfigUrl> {
  @override
  final Iterable<Type> types = const [ConnectorConfigUrl, _$ConnectorConfigUrl];

  @override
  final String wireName = r'ConnectorConfigUrl';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectorConfigUrl object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    ConnectorConfigUrl object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  ConnectorConfigUrl deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectorConfigUrlBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(String),
      FullType(String),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(
      oneOfDataSrc,
      specifiedType: targetType,
    ) as OneOf;
    return result.build();
  }
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'invite_link_email.g.dart';

/// InviteLinkEmail
@BuiltValue()
abstract class InviteLinkEmail
    implements Built<InviteLinkEmail, InviteLinkEmailBuilder> {
  /// One Of [String]
  OneOf get oneOf;

  InviteLinkEmail._();

  factory InviteLinkEmail([void updates(InviteLinkEmailBuilder b)]) =
      _$InviteLinkEmail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InviteLinkEmailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InviteLinkEmail> get serializer =>
      _$InviteLinkEmailSerializer();
}

class _$InviteLinkEmailSerializer
    implements PrimitiveSerializer<InviteLinkEmail> {
  @override
  final Iterable<Type> types = const [InviteLinkEmail, _$InviteLinkEmail];

  @override
  final String wireName = r'InviteLinkEmail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InviteLinkEmail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    InviteLinkEmail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  InviteLinkEmail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InviteLinkEmailBuilder();
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

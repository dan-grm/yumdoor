//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/source_import_property_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_property.g.dart';

/// SourceImportProperty
///
/// Properties:
/// * [propertyAmount]
/// * [propertyType]
@BuiltValue()
abstract class SourceImportProperty
    implements Built<SourceImportProperty, SourceImportPropertyBuilder> {
  @BuiltValueField(wireName: r'property_amount')
  double get propertyAmount;

  @BuiltValueField(wireName: r'property_type')
  SourceImportPropertyType get propertyType;

  SourceImportProperty._();

  factory SourceImportProperty([void updates(SourceImportPropertyBuilder b)]) =
      _$SourceImportProperty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportPropertyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportProperty> get serializer =>
      _$SourceImportPropertySerializer();
}

class _$SourceImportPropertySerializer
    implements PrimitiveSerializer<SourceImportProperty> {
  @override
  final Iterable<Type> types = const [
    SourceImportProperty,
    _$SourceImportProperty,
  ];

  @override
  final String wireName = r'SourceImportProperty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportProperty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'property_amount';
    yield serializers.serialize(
      object.propertyAmount,
      specifiedType: const FullType(double),
    );
    yield r'property_type';
    yield serializers.serialize(
      object.propertyType,
      specifiedType: const FullType(SourceImportPropertyType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportProperty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SourceImportPropertyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'property_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.propertyAmount = valueDes;
          break;
        case r'property_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SourceImportPropertyType),
          ) as SourceImportPropertyType;
          result.propertyType.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SourceImportProperty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportPropertyBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_property_type.g.dart';

/// SourceImportPropertyType
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class SourceImportPropertyType
    implements
        Built<SourceImportPropertyType, SourceImportPropertyTypeBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  SourceImportPropertyType._();

  factory SourceImportPropertyType([
    void updates(SourceImportPropertyTypeBuilder b),
  ]) = _$SourceImportPropertyType;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportPropertyTypeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportPropertyType> get serializer =>
      _$SourceImportPropertyTypeSerializer();
}

class _$SourceImportPropertyTypeSerializer
    implements PrimitiveSerializer<SourceImportPropertyType> {
  @override
  final Iterable<Type> types = const [
    SourceImportPropertyType,
    _$SourceImportPropertyType,
  ];

  @override
  final String wireName = r'SourceImportPropertyType';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportPropertyType object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportPropertyType object, {
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
    required SourceImportPropertyTypeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SourceImportPropertyType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportPropertyTypeBuilder();
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

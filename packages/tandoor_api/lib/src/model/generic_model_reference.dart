//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generic_model_reference.g.dart';

/// GenericModelReference
///
/// Properties:
/// * [id]
/// * [model]
/// * [name]
@BuiltValue()
abstract class GenericModelReference
    implements Built<GenericModelReference, GenericModelReferenceBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'model')
  String get model;

  @BuiltValueField(wireName: r'name')
  String get name;

  GenericModelReference._();

  factory GenericModelReference([
    void updates(GenericModelReferenceBuilder b),
  ]) = _$GenericModelReference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenericModelReferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenericModelReference> get serializer =>
      _$GenericModelReferenceSerializer();
}

class _$GenericModelReferenceSerializer
    implements PrimitiveSerializer<GenericModelReference> {
  @override
  final Iterable<Type> types = const [
    GenericModelReference,
    _$GenericModelReference,
  ];

  @override
  final String wireName = r'GenericModelReference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenericModelReference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'model';
    yield serializers.serialize(
      object.model,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenericModelReference object, {
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
    required GenericModelReferenceBuilder result,
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
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.model = valueDes;
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
  GenericModelReference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenericModelReferenceBuilder();
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

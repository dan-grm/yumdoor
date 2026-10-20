//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_food.g.dart';

/// SourceImportFood
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class SourceImportFood
    implements Built<SourceImportFood, SourceImportFoodBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  SourceImportFood._();

  factory SourceImportFood([void updates(SourceImportFoodBuilder b)]) =
      _$SourceImportFood;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportFoodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportFood> get serializer =>
      _$SourceImportFoodSerializer();
}

class _$SourceImportFoodSerializer
    implements PrimitiveSerializer<SourceImportFood> {
  @override
  final Iterable<Type> types = const [SourceImportFood, _$SourceImportFood];

  @override
  final String wireName = r'SourceImportFood';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportFood object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportFood object, {
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
    required SourceImportFoodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  SourceImportFood deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportFoodBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_open_data_version_meta_data.g.dart';

/// ImportOpenDataVersionMetaData
///
/// Properties:
/// * [category]
/// * [conversion]
/// * [food]
/// * [property]
/// * [store]
/// * [unit]
@BuiltValue()
abstract class ImportOpenDataVersionMetaData
    implements
        Built<
          ImportOpenDataVersionMetaData,
          ImportOpenDataVersionMetaDataBuilder
        > {
  @BuiltValueField(wireName: r'category')
  int get category;

  @BuiltValueField(wireName: r'conversion')
  int get conversion;

  @BuiltValueField(wireName: r'food')
  int get food;

  @BuiltValueField(wireName: r'property')
  int get property;

  @BuiltValueField(wireName: r'store')
  int get store;

  @BuiltValueField(wireName: r'unit')
  int get unit;

  ImportOpenDataVersionMetaData._();

  factory ImportOpenDataVersionMetaData([
    void updates(ImportOpenDataVersionMetaDataBuilder b),
  ]) = _$ImportOpenDataVersionMetaData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportOpenDataVersionMetaDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportOpenDataVersionMetaData> get serializer =>
      _$ImportOpenDataVersionMetaDataSerializer();
}

class _$ImportOpenDataVersionMetaDataSerializer
    implements PrimitiveSerializer<ImportOpenDataVersionMetaData> {
  @override
  final Iterable<Type> types = const [
    ImportOpenDataVersionMetaData,
    _$ImportOpenDataVersionMetaData,
  ];

  @override
  final String wireName = r'ImportOpenDataVersionMetaData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportOpenDataVersionMetaData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(int),
    );
    yield r'conversion';
    yield serializers.serialize(
      object.conversion,
      specifiedType: const FullType(int),
    );
    yield r'food';
    yield serializers.serialize(
      object.food,
      specifiedType: const FullType(int),
    );
    yield r'property';
    yield serializers.serialize(
      object.property,
      specifiedType: const FullType(int),
    );
    yield r'store';
    yield serializers.serialize(
      object.store,
      specifiedType: const FullType(int),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportOpenDataVersionMetaData object, {
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
    required ImportOpenDataVersionMetaDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.category = valueDes;
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.conversion = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.food = valueDes;
          break;
        case r'property':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.property = valueDes;
          break;
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.store = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportOpenDataVersionMetaData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportOpenDataVersionMetaDataBuilder();
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

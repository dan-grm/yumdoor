//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/import_open_data_response_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_open_data_response.g.dart';

/// ImportOpenDataResponse
///
/// Properties:
/// * [category]
/// * [conversion]
/// * [food]
/// * [property]
/// * [store]
/// * [unit]
@BuiltValue()
abstract class ImportOpenDataResponse
    implements Built<ImportOpenDataResponse, ImportOpenDataResponseBuilder> {
  @BuiltValueField(wireName: r'category')
  ImportOpenDataResponseDetail? get category;

  @BuiltValueField(wireName: r'conversion')
  ImportOpenDataResponseDetail? get conversion;

  @BuiltValueField(wireName: r'food')
  ImportOpenDataResponseDetail? get food;

  @BuiltValueField(wireName: r'property')
  ImportOpenDataResponseDetail? get property;

  @BuiltValueField(wireName: r'store')
  ImportOpenDataResponseDetail? get store;

  @BuiltValueField(wireName: r'unit')
  ImportOpenDataResponseDetail? get unit;

  ImportOpenDataResponse._();

  factory ImportOpenDataResponse([
    void updates(ImportOpenDataResponseBuilder b),
  ]) = _$ImportOpenDataResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportOpenDataResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportOpenDataResponse> get serializer =>
      _$ImportOpenDataResponseSerializer();
}

class _$ImportOpenDataResponseSerializer
    implements PrimitiveSerializer<ImportOpenDataResponse> {
  @override
  final Iterable<Type> types = const [
    ImportOpenDataResponse,
    _$ImportOpenDataResponse,
  ];

  @override
  final String wireName = r'ImportOpenDataResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportOpenDataResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
    if (object.conversion != null) {
      yield r'conversion';
      yield serializers.serialize(
        object.conversion,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
    if (object.property != null) {
      yield r'property';
      yield serializers.serialize(
        object.property,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
    if (object.store != null) {
      yield r'store';
      yield serializers.serialize(
        object.store,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType(ImportOpenDataResponseDetail),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportOpenDataResponse object, {
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
    required ImportOpenDataResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.category.replace(valueDes);
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.conversion.replace(valueDes);
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.food.replace(valueDes);
          break;
        case r'property':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.property.replace(valueDes);
          break;
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.store.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              ImportOpenDataResponseDetail,
            ),
          ) as ImportOpenDataResponseDetail?;
          if (valueDes == null) continue;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportOpenDataResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportOpenDataResponseBuilder();
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

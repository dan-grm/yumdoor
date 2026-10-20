//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fdc_query_foods.g.dart';

/// FdcQueryFoods
///
/// Properties:
/// * [dataType]
/// * [description]
/// * [fdcId]
@BuiltValue()
abstract class FdcQueryFoods
    implements Built<FdcQueryFoods, FdcQueryFoodsBuilder> {
  @BuiltValueField(wireName: r'dataType')
  String get dataType;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'fdcId')
  int get fdcId;

  FdcQueryFoods._();

  factory FdcQueryFoods([void updates(FdcQueryFoodsBuilder b)]) =
      _$FdcQueryFoods;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FdcQueryFoodsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FdcQueryFoods> get serializer =>
      _$FdcQueryFoodsSerializer();
}

class _$FdcQueryFoodsSerializer implements PrimitiveSerializer<FdcQueryFoods> {
  @override
  final Iterable<Type> types = const [FdcQueryFoods, _$FdcQueryFoods];

  @override
  final String wireName = r'FdcQueryFoods';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FdcQueryFoods object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dataType';
    yield serializers.serialize(
      object.dataType,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'fdcId';
    yield serializers.serialize(
      object.fdcId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FdcQueryFoods object, {
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
    required FdcQueryFoodsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dataType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dataType = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'fdcId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fdcId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FdcQueryFoods deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FdcQueryFoodsBuilder();
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

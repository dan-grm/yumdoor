//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/fdc_query_foods.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fdc_query.g.dart';

/// FdcQuery
///
/// Properties:
/// * [currentPage]
/// * [foods]
/// * [totalHits]
/// * [totalPages]
@BuiltValue()
abstract class FdcQuery implements Built<FdcQuery, FdcQueryBuilder> {
  @BuiltValueField(wireName: r'currentPage')
  int get currentPage;

  @BuiltValueField(wireName: r'foods')
  BuiltList<FdcQueryFoods> get foods;

  @BuiltValueField(wireName: r'totalHits')
  int get totalHits;

  @BuiltValueField(wireName: r'totalPages')
  int get totalPages;

  FdcQuery._();

  factory FdcQuery([void updates(FdcQueryBuilder b)]) = _$FdcQuery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FdcQueryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FdcQuery> get serializer => _$FdcQuerySerializer();
}

class _$FdcQuerySerializer implements PrimitiveSerializer<FdcQuery> {
  @override
  final Iterable<Type> types = const [FdcQuery, _$FdcQuery];

  @override
  final String wireName = r'FdcQuery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FdcQuery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currentPage';
    yield serializers.serialize(
      object.currentPage,
      specifiedType: const FullType(int),
    );
    yield r'foods';
    yield serializers.serialize(
      object.foods,
      specifiedType: const FullType(BuiltList, [FullType(FdcQueryFoods)]),
    );
    yield r'totalHits';
    yield serializers.serialize(
      object.totalHits,
      specifiedType: const FullType(int),
    );
    yield r'totalPages';
    yield serializers.serialize(
      object.totalPages,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FdcQuery object, {
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
    required FdcQueryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentPage = valueDes;
          break;
        case r'foods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FdcQueryFoods)]),
          ) as BuiltList<FdcQueryFoods>;
          result.foods.replace(valueDes);
          break;
        case r'totalHits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalHits = valueDes;
          break;
        case r'totalPages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPages = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FdcQuery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FdcQueryBuilder();
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

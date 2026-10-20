//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/unit_conversion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paginated_unit_conversion_list.g.dart';

/// PaginatedUnitConversionList
///
/// Properties:
/// * [count]
/// * [next]
/// * [previous]
/// * [results]
/// * [timestamp]
@BuiltValue()
abstract class PaginatedUnitConversionList
    implements
        Built<PaginatedUnitConversionList, PaginatedUnitConversionListBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'previous')
  String? get previous;

  @BuiltValueField(wireName: r'results')
  BuiltList<UnitConversion> get results;

  @BuiltValueField(wireName: r'timestamp')
  DateTime? get timestamp;

  PaginatedUnitConversionList._();

  factory PaginatedUnitConversionList([
    void updates(PaginatedUnitConversionListBuilder b),
  ]) = _$PaginatedUnitConversionList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaginatedUnitConversionListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaginatedUnitConversionList> get serializer =>
      _$PaginatedUnitConversionListSerializer();
}

class _$PaginatedUnitConversionListSerializer
    implements PrimitiveSerializer<PaginatedUnitConversionList> {
  @override
  final Iterable<Type> types = const [
    PaginatedUnitConversionList,
    _$PaginatedUnitConversionList,
  ];

  @override
  final String wireName = r'PaginatedUnitConversionList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaginatedUnitConversionList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.previous != null) {
      yield r'previous';
      yield serializers.serialize(
        object.previous,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'results';
    yield serializers.serialize(
      object.results,
      specifiedType: const FullType(BuiltList, [FullType(UnitConversion)]),
    );
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaginatedUnitConversionList object, {
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
    required PaginatedUnitConversionListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.previous = valueDes;
          break;
        case r'results':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(UnitConversion),
            ]),
          ) as BuiltList<UnitConversion>;
          result.results.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaginatedUnitConversionList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaginatedUnitConversionListBuilder();
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

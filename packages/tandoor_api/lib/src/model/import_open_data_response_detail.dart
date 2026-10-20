//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_open_data_response_detail.g.dart';

/// ImportOpenDataResponseDetail
///
/// Properties:
/// * [totalCreated]
/// * [totalErrored]
/// * [totalUntouched]
/// * [totalUpdated]
@BuiltValue()
abstract class ImportOpenDataResponseDetail
    implements
        Built<
          ImportOpenDataResponseDetail,
          ImportOpenDataResponseDetailBuilder
        > {
  @BuiltValueField(wireName: r'total_created')
  int? get totalCreated;

  @BuiltValueField(wireName: r'total_errored')
  int? get totalErrored;

  @BuiltValueField(wireName: r'total_untouched')
  int? get totalUntouched;

  @BuiltValueField(wireName: r'total_updated')
  int? get totalUpdated;

  ImportOpenDataResponseDetail._();

  factory ImportOpenDataResponseDetail([
    void updates(ImportOpenDataResponseDetailBuilder b),
  ]) = _$ImportOpenDataResponseDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportOpenDataResponseDetailBuilder b) => b
    ..totalCreated = 0
    ..totalErrored = 0
    ..totalUntouched = 0
    ..totalUpdated = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportOpenDataResponseDetail> get serializer =>
      _$ImportOpenDataResponseDetailSerializer();
}

class _$ImportOpenDataResponseDetailSerializer
    implements PrimitiveSerializer<ImportOpenDataResponseDetail> {
  @override
  final Iterable<Type> types = const [
    ImportOpenDataResponseDetail,
    _$ImportOpenDataResponseDetail,
  ];

  @override
  final String wireName = r'ImportOpenDataResponseDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportOpenDataResponseDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.totalCreated != null) {
      yield r'total_created';
      yield serializers.serialize(
        object.totalCreated,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalErrored != null) {
      yield r'total_errored';
      yield serializers.serialize(
        object.totalErrored,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalUntouched != null) {
      yield r'total_untouched';
      yield serializers.serialize(
        object.totalUntouched,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalUpdated != null) {
      yield r'total_updated';
      yield serializers.serialize(
        object.totalUpdated,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportOpenDataResponseDetail object, {
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
    required ImportOpenDataResponseDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total_created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalCreated = valueDes;
          break;
        case r'total_errored':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalErrored = valueDes;
          break;
        case r'total_untouched':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalUntouched = valueDes;
          break;
        case r'total_updated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalUpdated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportOpenDataResponseDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportOpenDataResponseDetailBuilder();
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

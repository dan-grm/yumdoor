//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_view_log.g.dart';

/// PatchedViewLog
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [id]
/// * [recipe]
@BuiltValue()
abstract class PatchedViewLog
    implements Built<PatchedViewLog, PatchedViewLogBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'recipe')
  int? get recipe;

  PatchedViewLog._();

  factory PatchedViewLog([void updates(PatchedViewLogBuilder b)]) =
      _$PatchedViewLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedViewLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedViewLog> get serializer =>
      _$PatchedViewLogSerializer();
}

class _$PatchedViewLogSerializer
    implements PrimitiveSerializer<PatchedViewLog> {
  @override
  final Iterable<Type> types = const [PatchedViewLog, _$PatchedViewLog];

  @override
  final String wireName = r'PatchedViewLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedViewLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.recipe != null) {
      yield r'recipe';
      yield serializers.serialize(
        object.recipe,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedViewLog object, {
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
    required PatchedViewLogBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recipe = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedViewLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedViewLogBuilder();
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

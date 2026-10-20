//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/model_sync.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_log.g.dart';

/// SyncLog
///
/// Properties:
/// * [createdAt]
/// * [id]
/// * [msg]
/// * [status]
/// * [sync_]
@BuiltValue()
abstract class SyncLog implements Built<SyncLog, SyncLogBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'msg')
  String? get msg;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'sync')
  ModelSync? get sync_;

  SyncLog._();

  factory SyncLog([void updates(SyncLogBuilder b)]) = _$SyncLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncLog> get serializer => _$SyncLogSerializer();
}

class _$SyncLogSerializer implements PrimitiveSerializer<SyncLog> {
  @override
  final Iterable<Type> types = const [SyncLog, _$SyncLog];

  @override
  final String wireName = r'SyncLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.msg != null) {
      yield r'msg';
      yield serializers.serialize(
        object.msg,
        specifiedType: const FullType(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.sync_ != null) {
      yield r'sync';
      yield serializers.serialize(
        object.sync_,
        specifiedType: const FullType.nullable(ModelSync),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncLog object, {
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
    required SyncLogBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'msg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.msg = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'sync':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModelSync),
          ) as ModelSync?;
          if (valueDes == null) continue;
          result.sync_.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncLogBuilder();
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

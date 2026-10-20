//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'export_log.g.dart';

/// ExportLog
///
/// Properties:
/// * [cacheDuration]
/// * [createdAt]
/// * [createdBy]
/// * [exportedRecipes]
/// * [id]
/// * [msg]
/// * [possiblyNotExpired]
/// * [running]
/// * [totalRecipes]
/// * [type]
@BuiltValue()
abstract class ExportLog implements Built<ExportLog, ExportLogBuilder> {
  @BuiltValueField(wireName: r'cache_duration')
  int? get cacheDuration;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'exported_recipes')
  int? get exportedRecipes;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'msg')
  String? get msg;

  @BuiltValueField(wireName: r'possibly_not_expired')
  bool? get possiblyNotExpired;

  @BuiltValueField(wireName: r'running')
  bool? get running;

  @BuiltValueField(wireName: r'total_recipes')
  int? get totalRecipes;

  @BuiltValueField(wireName: r'type')
  String get type;

  ExportLog._();

  factory ExportLog([void updates(ExportLogBuilder b)]) = _$ExportLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExportLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExportLog> get serializer => _$ExportLogSerializer();
}

class _$ExportLogSerializer implements PrimitiveSerializer<ExportLog> {
  @override
  final Iterable<Type> types = const [ExportLog, _$ExportLog];

  @override
  final String wireName = r'ExportLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExportLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cacheDuration != null) {
      yield r'cache_duration';
      yield serializers.serialize(
        object.cacheDuration,
        specifiedType: const FullType(int),
      );
    }
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
    if (object.exportedRecipes != null) {
      yield r'exported_recipes';
      yield serializers.serialize(
        object.exportedRecipes,
        specifiedType: const FullType(int),
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
    if (object.possiblyNotExpired != null) {
      yield r'possibly_not_expired';
      yield serializers.serialize(
        object.possiblyNotExpired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.running != null) {
      yield r'running';
      yield serializers.serialize(
        object.running,
        specifiedType: const FullType(bool),
      );
    }
    if (object.totalRecipes != null) {
      yield r'total_recipes';
      yield serializers.serialize(
        object.totalRecipes,
        specifiedType: const FullType(int),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExportLog object, {
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
    required ExportLogBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cache_duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cacheDuration = valueDes;
          break;
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
        case r'exported_recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.exportedRecipes = valueDes;
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
        case r'possibly_not_expired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.possiblyNotExpired = valueDes;
          break;
        case r'running':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.running = valueDes;
          break;
        case r'total_recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalRecipes = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExportLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExportLogBuilder();
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

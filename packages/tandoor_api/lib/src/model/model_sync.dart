//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/storage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'model_sync.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [active]
/// * [createdAt]
/// * [id]
/// * [lastChecked]
/// * [path]
/// * [storage]
/// * [updatedAt]
@BuiltValue()
abstract class ModelSync implements Built<ModelSync, ModelSyncBuilder> {
  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'last_checked')
  DateTime? get lastChecked;

  @BuiltValueField(wireName: r'path')
  String? get path;

  @BuiltValueField(wireName: r'storage')
  Storage get storage;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  ModelSync._();

  factory ModelSync([void updates(ModelSyncBuilder b)]) = _$ModelSync;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModelSyncBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModelSync> get serializer => _$ModelSyncSerializer();
}

class _$ModelSyncSerializer implements PrimitiveSerializer<ModelSync> {
  @override
  final Iterable<Type> types = const [ModelSync, _$ModelSync];

  @override
  final String wireName = r'ModelSync';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModelSync object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
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
    if (object.lastChecked != null) {
      yield r'last_checked';
      yield serializers.serialize(
        object.lastChecked,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.path != null) {
      yield r'path';
      yield serializers.serialize(
        object.path,
        specifiedType: const FullType(String),
      );
    }
    yield r'storage';
    yield serializers.serialize(
      object.storage,
      specifiedType: const FullType(Storage),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModelSync object, {
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
    required ModelSyncBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.active = valueDes;
          break;
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
        case r'last_checked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastChecked = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.path = valueDes;
          break;
        case r'storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Storage),
          ) as Storage;
          result.storage.replace(valueDes);
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModelSync deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModelSyncBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/storage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_import.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdAt]
/// * [filePath]
/// * [fileUid]
/// * [id]
/// * [name]
/// * [storage]
@BuiltValue()
abstract class RecipeImport
    implements Built<RecipeImport, RecipeImportBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'file_path')
  String? get filePath;

  @BuiltValueField(wireName: r'file_uid')
  String? get fileUid;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'storage')
  Storage get storage;

  RecipeImport._();

  factory RecipeImport([void updates(RecipeImportBuilder b)]) = _$RecipeImport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeImportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeImport> get serializer => _$RecipeImportSerializer();
}

class _$RecipeImportSerializer implements PrimitiveSerializer<RecipeImport> {
  @override
  final Iterable<Type> types = const [RecipeImport, _$RecipeImport];

  @override
  final String wireName = r'RecipeImport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeImport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.filePath != null) {
      yield r'file_path';
      yield serializers.serialize(
        object.filePath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fileUid != null) {
      yield r'file_uid';
      yield serializers.serialize(
        object.fileUid,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'storage';
    yield serializers.serialize(
      object.storage,
      specifiedType: const FullType(Storage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeImport object, {
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
    required RecipeImportBuilder result,
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
        case r'file_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.filePath = valueDes;
          break;
        case r'file_uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileUid = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Storage),
          ) as Storage;
          result.storage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeImport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeImportBuilder();
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

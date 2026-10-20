//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/storage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_recipe_import.g.dart';

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
abstract class PatchedRecipeImport
    implements Built<PatchedRecipeImport, PatchedRecipeImportBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'file_path')
  String? get filePath;

  @BuiltValueField(wireName: r'file_uid')
  String? get fileUid;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'storage')
  Storage? get storage;

  PatchedRecipeImport._();

  factory PatchedRecipeImport([void updates(PatchedRecipeImportBuilder b)]) =
      _$PatchedRecipeImport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedRecipeImportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedRecipeImport> get serializer =>
      _$PatchedRecipeImportSerializer();
}

class _$PatchedRecipeImportSerializer
    implements PrimitiveSerializer<PatchedRecipeImport> {
  @override
  final Iterable<Type> types = const [
    PatchedRecipeImport,
    _$PatchedRecipeImport,
  ];

  @override
  final String wireName = r'PatchedRecipeImport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedRecipeImport object, {
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.storage != null) {
      yield r'storage';
      yield serializers.serialize(
        object.storage,
        specifiedType: const FullType(Storage),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedRecipeImport object, {
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
    required PatchedRecipeImportBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Storage),
          ) as Storage?;
          if (valueDes == null) continue;
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
  PatchedRecipeImport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedRecipeImportBuilder();
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

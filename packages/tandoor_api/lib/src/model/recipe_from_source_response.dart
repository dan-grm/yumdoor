//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/source_import_duplicate.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/source_import_recipe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_from_source_response.g.dart';

/// RecipeFromSourceResponse
///
/// Properties:
/// * [duplicates]
/// * [error]
/// * [images]
/// * [msg]
/// * [recipe]
/// * [recipeId]
@BuiltValue()
abstract class RecipeFromSourceResponse
    implements
        Built<RecipeFromSourceResponse, RecipeFromSourceResponseBuilder> {
  @BuiltValueField(wireName: r'duplicates')
  BuiltList<SourceImportDuplicate>? get duplicates;

  @BuiltValueField(wireName: r'error')
  bool? get error;

  @BuiltValueField(wireName: r'images')
  BuiltList<String>? get images;

  @BuiltValueField(wireName: r'msg')
  String? get msg;

  @BuiltValueField(wireName: r'recipe')
  SourceImportRecipe? get recipe;

  @BuiltValueField(wireName: r'recipe_id')
  int? get recipeId;

  RecipeFromSourceResponse._();

  factory RecipeFromSourceResponse([
    void updates(RecipeFromSourceResponseBuilder b),
  ]) = _$RecipeFromSourceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeFromSourceResponseBuilder b) => b
    ..duplicates = ListBuilder()
    ..error = false
    ..images = ListBuilder()
    ..msg = '';

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeFromSourceResponse> get serializer =>
      _$RecipeFromSourceResponseSerializer();
}

class _$RecipeFromSourceResponseSerializer
    implements PrimitiveSerializer<RecipeFromSourceResponse> {
  @override
  final Iterable<Type> types = const [
    RecipeFromSourceResponse,
    _$RecipeFromSourceResponse,
  ];

  @override
  final String wireName = r'RecipeFromSourceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeFromSourceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.duplicates != null) {
      yield r'duplicates';
      yield serializers.serialize(
        object.duplicates,
        specifiedType: const FullType(BuiltList, [
          FullType(SourceImportDuplicate),
        ]),
      );
    }
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(bool),
      );
    }
    if (object.images != null) {
      yield r'images';
      yield serializers.serialize(
        object.images,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.msg != null) {
      yield r'msg';
      yield serializers.serialize(
        object.msg,
        specifiedType: const FullType(String),
      );
    }
    if (object.recipe != null) {
      yield r'recipe';
      yield serializers.serialize(
        object.recipe,
        specifiedType: const FullType(SourceImportRecipe),
      );
    }
    if (object.recipeId != null) {
      yield r'recipe_id';
      yield serializers.serialize(
        object.recipeId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeFromSourceResponse object, {
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
    required RecipeFromSourceResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duplicates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SourceImportDuplicate),
            ]),
          ) as BuiltList<SourceImportDuplicate>?;
          if (valueDes == null) continue;
          result.duplicates.replace(valueDes);
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(String),
            ]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.images.replace(valueDes);
          break;
        case r'msg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.msg = valueDes;
          break;
        case r'recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SourceImportRecipe),
          ) as SourceImportRecipe?;
          if (valueDes == null) continue;
          result.recipe.replace(valueDes);
          break;
        case r'recipe_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recipeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeFromSourceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeFromSourceResponseBuilder();
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

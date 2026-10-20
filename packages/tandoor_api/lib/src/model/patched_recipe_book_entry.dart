//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/recipe_overview.dart';
import 'package:tandoor_api/src/model/recipe_book.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_recipe_book_entry.g.dart';

/// PatchedRecipeBookEntry
///
/// Properties:
/// * [book]
/// * [bookContent]
/// * [id]
/// * [recipe]
/// * [recipeContent]
@BuiltValue()
abstract class PatchedRecipeBookEntry
    implements Built<PatchedRecipeBookEntry, PatchedRecipeBookEntryBuilder> {
  @BuiltValueField(wireName: r'book')
  int? get book;

  @BuiltValueField(wireName: r'book_content')
  RecipeBook? get bookContent;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'recipe')
  int? get recipe;

  @BuiltValueField(wireName: r'recipe_content')
  RecipeOverview? get recipeContent;

  PatchedRecipeBookEntry._();

  factory PatchedRecipeBookEntry([
    void updates(PatchedRecipeBookEntryBuilder b),
  ]) = _$PatchedRecipeBookEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedRecipeBookEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedRecipeBookEntry> get serializer =>
      _$PatchedRecipeBookEntrySerializer();
}

class _$PatchedRecipeBookEntrySerializer
    implements PrimitiveSerializer<PatchedRecipeBookEntry> {
  @override
  final Iterable<Type> types = const [
    PatchedRecipeBookEntry,
    _$PatchedRecipeBookEntry,
  ];

  @override
  final String wireName = r'PatchedRecipeBookEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedRecipeBookEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.book != null) {
      yield r'book';
      yield serializers.serialize(
        object.book,
        specifiedType: const FullType(int),
      );
    }
    if (object.bookContent != null) {
      yield r'book_content';
      yield serializers.serialize(
        object.bookContent,
        specifiedType: const FullType.nullable(RecipeBook),
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
    if (object.recipeContent != null) {
      yield r'recipe_content';
      yield serializers.serialize(
        object.recipeContent,
        specifiedType: const FullType.nullable(RecipeOverview),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedRecipeBookEntry object, {
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
    required PatchedRecipeBookEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'book':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.book = valueDes;
          break;
        case r'book_content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecipeBook),
          ) as RecipeBook?;
          if (valueDes == null) continue;
          result.bookContent.replace(valueDes);
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
        case r'recipe_content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecipeOverview),
          ) as RecipeOverview?;
          if (valueDes == null) continue;
          result.recipeContent.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedRecipeBookEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedRecipeBookEntryBuilder();
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

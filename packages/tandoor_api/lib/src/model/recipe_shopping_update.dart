//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_shopping_update.g.dart';

/// RecipeShoppingUpdate
///
/// Properties:
/// * [id]
/// * [ingredients]
/// * [listRecipe] - Existing shopping list to update
/// * [servings] - Providing a list_recipe ID and servings of 0 will delete that shopping list.
@BuiltValue()
abstract class RecipeShoppingUpdate
    implements Built<RecipeShoppingUpdate, RecipeShoppingUpdateBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'ingredients')
  BuiltList<int?> get ingredients;

  /// Existing shopping list to update
  @BuiltValueField(wireName: r'list_recipe')
  int? get listRecipe;

  /// Providing a list_recipe ID and servings of 0 will delete that shopping list.
  @BuiltValueField(wireName: r'servings')
  int? get servings;

  RecipeShoppingUpdate._();

  factory RecipeShoppingUpdate([void updates(RecipeShoppingUpdateBuilder b)]) =
      _$RecipeShoppingUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeShoppingUpdateBuilder b) => b..servings = 1;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeShoppingUpdate> get serializer =>
      _$RecipeShoppingUpdateSerializer();
}

class _$RecipeShoppingUpdateSerializer
    implements PrimitiveSerializer<RecipeShoppingUpdate> {
  @override
  final Iterable<Type> types = const [
    RecipeShoppingUpdate,
    _$RecipeShoppingUpdate,
  ];

  @override
  final String wireName = r'RecipeShoppingUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeShoppingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'ingredients';
    yield serializers.serialize(
      object.ingredients,
      specifiedType: const FullType(BuiltList, [FullType.nullable(int)]),
    );
    if (object.listRecipe != null) {
      yield r'list_recipe';
      yield serializers.serialize(
        object.listRecipe,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.servings != null) {
      yield r'servings';
      yield serializers.serialize(
        object.servings,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeShoppingUpdate object, {
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
    required RecipeShoppingUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(int)]),
          ) as BuiltList<int?>;
          result.ingredients.replace(valueDes);
          break;
        case r'list_recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.listRecipe = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.servings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeShoppingUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeShoppingUpdateBuilder();
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

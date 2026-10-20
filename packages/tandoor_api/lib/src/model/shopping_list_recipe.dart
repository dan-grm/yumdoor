//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/recipe_overview.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:tandoor_api/src/model/meal_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shopping_list_recipe.g.dart';

/// ShoppingListRecipe
///
/// Properties:
/// * [createdBy]
/// * [id]
/// * [mealPlanData]
/// * [mealplan]
/// * [name]
/// * [recipe]
/// * [recipeData]
/// * [servings]
@BuiltValue()
abstract class ShoppingListRecipe
    implements Built<ShoppingListRecipe, ShoppingListRecipeBuilder> {
  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'meal_plan_data')
  MealPlan? get mealPlanData;

  @BuiltValueField(wireName: r'mealplan')
  int? get mealplan;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'recipe')
  int? get recipe;

  @BuiltValueField(wireName: r'recipe_data')
  RecipeOverview? get recipeData;

  @BuiltValueField(wireName: r'servings')
  double get servings;

  ShoppingListRecipe._();

  factory ShoppingListRecipe([void updates(ShoppingListRecipeBuilder b)]) =
      _$ShoppingListRecipe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShoppingListRecipeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShoppingListRecipe> get serializer =>
      _$ShoppingListRecipeSerializer();
}

class _$ShoppingListRecipeSerializer
    implements PrimitiveSerializer<ShoppingListRecipe> {
  @override
  final Iterable<Type> types = const [ShoppingListRecipe, _$ShoppingListRecipe];

  @override
  final String wireName = r'ShoppingListRecipe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShoppingListRecipe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.mealPlanData != null) {
      yield r'meal_plan_data';
      yield serializers.serialize(
        object.mealPlanData,
        specifiedType: const FullType.nullable(MealPlan),
      );
    }
    if (object.mealplan != null) {
      yield r'mealplan';
      yield serializers.serialize(
        object.mealplan,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.recipe != null) {
      yield r'recipe';
      yield serializers.serialize(
        object.recipe,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.recipeData != null) {
      yield r'recipe_data';
      yield serializers.serialize(
        object.recipeData,
        specifiedType: const FullType.nullable(RecipeOverview),
      );
    }
    yield r'servings';
    yield serializers.serialize(
      object.servings,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ShoppingListRecipe object, {
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
    required ShoppingListRecipeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.createdBy.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'meal_plan_data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MealPlan),
          ) as MealPlan?;
          if (valueDes == null) continue;
          result.mealPlanData.replace(valueDes);
          break;
        case r'mealplan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mealplan = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recipe = valueDes;
          break;
        case r'recipe_data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecipeOverview),
          ) as RecipeOverview?;
          if (valueDes == null) continue;
          result.recipeData.replace(valueDes);
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
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
  ShoppingListRecipe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShoppingListRecipeBuilder();
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

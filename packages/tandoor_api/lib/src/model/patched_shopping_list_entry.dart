//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/food_shopping.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:tandoor_api/src/model/shopping_list.dart';
import 'package:tandoor_api/src/model/shopping_list_recipe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_shopping_list_entry.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [amount]
/// * [checked]
/// * [completedAt]
/// * [createdAt]
/// * [createdBy]
/// * [delayUntil]
/// * [food]
/// * [id]
/// * [ingredient]
/// * [listRecipe]
/// * [listRecipeData]
/// * [mealplanId] - If a mealplan id is given try to find existing or create new ShoppingListRecipe with that meal plan and link entry to it
/// * [order]
/// * [shoppingLists]
/// * [unit]
/// * [updatedAt]
@BuiltValue()
abstract class PatchedShoppingListEntry
    implements
        Built<PatchedShoppingListEntry, PatchedShoppingListEntryBuilder> {
  @BuiltValueField(wireName: r'amount')
  double? get amount;

  @BuiltValueField(wireName: r'checked')
  bool? get checked;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'delay_until')
  DateTime? get delayUntil;

  @BuiltValueField(wireName: r'food')
  FoodShopping? get food;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'ingredient')
  int? get ingredient;

  @BuiltValueField(wireName: r'list_recipe')
  int? get listRecipe;

  @BuiltValueField(wireName: r'list_recipe_data')
  ShoppingListRecipe? get listRecipeData;

  /// If a mealplan id is given try to find existing or create new ShoppingListRecipe with that meal plan and link entry to it
  @BuiltValueField(wireName: r'mealplan_id')
  int? get mealplanId;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'shopping_lists')
  BuiltList<ShoppingList>? get shoppingLists;

  @BuiltValueField(wireName: r'unit')
  Unit? get unit;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  PatchedShoppingListEntry._();

  factory PatchedShoppingListEntry([
    void updates(PatchedShoppingListEntryBuilder b),
  ]) = _$PatchedShoppingListEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedShoppingListEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedShoppingListEntry> get serializer =>
      _$PatchedShoppingListEntrySerializer();
}

class _$PatchedShoppingListEntrySerializer
    implements PrimitiveSerializer<PatchedShoppingListEntry> {
  @override
  final Iterable<Type> types = const [
    PatchedShoppingListEntry,
    _$PatchedShoppingListEntry,
  ];

  @override
  final String wireName = r'PatchedShoppingListEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedShoppingListEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.amount != null) {
      yield r'amount';
      yield serializers.serialize(
        object.amount,
        specifiedType: const FullType(double),
      );
    }
    if (object.checked != null) {
      yield r'checked';
      yield serializers.serialize(
        object.checked,
        specifiedType: const FullType(bool),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
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
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.delayUntil != null) {
      yield r'delay_until';
      yield serializers.serialize(
        object.delayUntil,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType.nullable(FoodShopping),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.ingredient != null) {
      yield r'ingredient';
      yield serializers.serialize(
        object.ingredient,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.listRecipe != null) {
      yield r'list_recipe';
      yield serializers.serialize(
        object.listRecipe,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.listRecipeData != null) {
      yield r'list_recipe_data';
      yield serializers.serialize(
        object.listRecipeData,
        specifiedType: const FullType.nullable(ShoppingListRecipe),
      );
    }
    if (object.mealplanId != null) {
      yield r'mealplan_id';
      yield serializers.serialize(
        object.mealplanId,
        specifiedType: const FullType(int),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(int),
      );
    }
    if (object.shoppingLists != null) {
      yield r'shopping_lists';
      yield serializers.serialize(
        object.shoppingLists,
        specifiedType: const FullType(BuiltList, [FullType(ShoppingList)]),
      );
    }
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType.nullable(Unit),
      );
    }
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
    PatchedShoppingListEntry object, {
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
    required PatchedShoppingListEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'checked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.checked = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
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
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.createdBy.replace(valueDes);
          break;
        case r'delay_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.delayUntil = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FoodShopping),
          ) as FoodShopping?;
          if (valueDes == null) continue;
          result.food.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'ingredient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ingredient = valueDes;
          break;
        case r'list_recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.listRecipe = valueDes;
          break;
        case r'list_recipe_data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ShoppingListRecipe),
          ) as ShoppingListRecipe?;
          if (valueDes == null) continue;
          result.listRecipeData.replace(valueDes);
          break;
        case r'mealplan_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mealplanId = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'shopping_lists':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(ShoppingList),
            ]),
          ) as BuiltList<ShoppingList>?;
          if (valueDes == null) continue;
          result.shoppingLists.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Unit),
          ) as Unit?;
          if (valueDes == null) continue;
          result.unit.replace(valueDes);
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
  PatchedShoppingListEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedShoppingListEntryBuilder();
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

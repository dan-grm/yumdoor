//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/recipe_simple.dart';
import 'package:tandoor_api/src/model/property.dart';
import 'package:tandoor_api/src/model/supermarket_category.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:tandoor_api/src/model/shopping_list.dart';
import 'package:tandoor_api/src/model/food_inherit_field.dart';
import 'package:tandoor_api/src/model/food_simple.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_food.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [childInheritFields]
/// * [description]
/// * [fdcId]
/// * [foodOnhand]
/// * [fullName] - Returns a string representation of a tree node and it's ancestors, e.g. 'Cuisine > Asian > Chinese > Catonese'.
/// * [id]
/// * [ignoreShopping]
/// * [inheritFields]
/// * [name]
/// * [numchild]
/// * [openDataSlug]
/// * [parent]
/// * [pluralName]
/// * [properties]
/// * [propertiesFoodAmount]
/// * [propertiesFoodUnit]
/// * [recipe]
/// * [shopping]
/// * [shoppingLists]
/// * [substitute]
/// * [substituteChildren]
/// * [substituteOnhand]
/// * [substituteSiblings]
/// * [supermarketCategory]
/// * [url]
@BuiltValue()
abstract class PatchedFood implements Built<PatchedFood, PatchedFoodBuilder> {
  @BuiltValueField(wireName: r'child_inherit_fields')
  BuiltList<FoodInheritField>? get childInheritFields;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'fdc_id')
  int? get fdcId;

  @BuiltValueField(wireName: r'food_onhand')
  bool? get foodOnhand;

  /// Returns a string representation of a tree node and it's ancestors, e.g. 'Cuisine > Asian > Chinese > Catonese'.
  @BuiltValueField(wireName: r'full_name')
  String? get fullName;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'ignore_shopping')
  bool? get ignoreShopping;

  @BuiltValueField(wireName: r'inherit_fields')
  BuiltList<FoodInheritField>? get inheritFields;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'numchild')
  int? get numchild;

  @BuiltValueField(wireName: r'open_data_slug')
  String? get openDataSlug;

  @BuiltValueField(wireName: r'parent')
  int? get parent;

  @BuiltValueField(wireName: r'plural_name')
  String? get pluralName;

  @BuiltValueField(wireName: r'properties')
  BuiltList<Property>? get properties;

  @BuiltValueField(wireName: r'properties_food_amount')
  double? get propertiesFoodAmount;

  @BuiltValueField(wireName: r'properties_food_unit')
  Unit? get propertiesFoodUnit;

  @BuiltValueField(wireName: r'recipe')
  RecipeSimple? get recipe;

  @BuiltValueField(wireName: r'shopping')
  String? get shopping;

  @BuiltValueField(wireName: r'shopping_lists')
  BuiltList<ShoppingList>? get shoppingLists;

  @BuiltValueField(wireName: r'substitute')
  BuiltList<FoodSimple>? get substitute;

  @BuiltValueField(wireName: r'substitute_children')
  bool? get substituteChildren;

  @BuiltValueField(wireName: r'substitute_onhand')
  bool? get substituteOnhand;

  @BuiltValueField(wireName: r'substitute_siblings')
  bool? get substituteSiblings;

  @BuiltValueField(wireName: r'supermarket_category')
  SupermarketCategory? get supermarketCategory;

  @BuiltValueField(wireName: r'url')
  String? get url;

  PatchedFood._();

  factory PatchedFood([void updates(PatchedFoodBuilder b)]) = _$PatchedFood;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedFoodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedFood> get serializer => _$PatchedFoodSerializer();
}

class _$PatchedFoodSerializer implements PrimitiveSerializer<PatchedFood> {
  @override
  final Iterable<Type> types = const [PatchedFood, _$PatchedFood];

  @override
  final String wireName = r'PatchedFood';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedFood object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.childInheritFields != null) {
      yield r'child_inherit_fields';
      yield serializers.serialize(
        object.childInheritFields,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(FoodInheritField),
        ]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.fdcId != null) {
      yield r'fdc_id';
      yield serializers.serialize(
        object.fdcId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.foodOnhand != null) {
      yield r'food_onhand';
      yield serializers.serialize(
        object.foodOnhand,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.fullName != null) {
      yield r'full_name';
      yield serializers.serialize(
        object.fullName,
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
    if (object.ignoreShopping != null) {
      yield r'ignore_shopping';
      yield serializers.serialize(
        object.ignoreShopping,
        specifiedType: const FullType(bool),
      );
    }
    if (object.inheritFields != null) {
      yield r'inherit_fields';
      yield serializers.serialize(
        object.inheritFields,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(FoodInheritField),
        ]),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.numchild != null) {
      yield r'numchild';
      yield serializers.serialize(
        object.numchild,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.openDataSlug != null) {
      yield r'open_data_slug';
      yield serializers.serialize(
        object.openDataSlug,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.parent != null) {
      yield r'parent';
      yield serializers.serialize(
        object.parent,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.pluralName != null) {
      yield r'plural_name';
      yield serializers.serialize(
        object.pluralName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.properties != null) {
      yield r'properties';
      yield serializers.serialize(
        object.properties,
        specifiedType: const FullType.nullable(BuiltList, [FullType(Property)]),
      );
    }
    if (object.propertiesFoodAmount != null) {
      yield r'properties_food_amount';
      yield serializers.serialize(
        object.propertiesFoodAmount,
        specifiedType: const FullType(double),
      );
    }
    if (object.propertiesFoodUnit != null) {
      yield r'properties_food_unit';
      yield serializers.serialize(
        object.propertiesFoodUnit,
        specifiedType: const FullType.nullable(Unit),
      );
    }
    if (object.recipe != null) {
      yield r'recipe';
      yield serializers.serialize(
        object.recipe,
        specifiedType: const FullType.nullable(RecipeSimple),
      );
    }
    if (object.shopping != null) {
      yield r'shopping';
      yield serializers.serialize(
        object.shopping,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.shoppingLists != null) {
      yield r'shopping_lists';
      yield serializers.serialize(
        object.shoppingLists,
        specifiedType: const FullType(BuiltList, [FullType(ShoppingList)]),
      );
    }
    if (object.substitute != null) {
      yield r'substitute';
      yield serializers.serialize(
        object.substitute,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(FoodSimple),
        ]),
      );
    }
    if (object.substituteChildren != null) {
      yield r'substitute_children';
      yield serializers.serialize(
        object.substituteChildren,
        specifiedType: const FullType(bool),
      );
    }
    if (object.substituteOnhand != null) {
      yield r'substitute_onhand';
      yield serializers.serialize(
        object.substituteOnhand,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.substituteSiblings != null) {
      yield r'substitute_siblings';
      yield serializers.serialize(
        object.substituteSiblings,
        specifiedType: const FullType(bool),
      );
    }
    if (object.supermarketCategory != null) {
      yield r'supermarket_category';
      yield serializers.serialize(
        object.supermarketCategory,
        specifiedType: const FullType.nullable(SupermarketCategory),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedFood object, {
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
    required PatchedFoodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'child_inherit_fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(FoodInheritField),
            ]),
          ) as BuiltList<FoodInheritField>?;
          if (valueDes == null) continue;
          result.childInheritFields.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'fdc_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fdcId = valueDes;
          break;
        case r'food_onhand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.foodOnhand = valueDes;
          break;
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fullName = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'ignore_shopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.ignoreShopping = valueDes;
          break;
        case r'inherit_fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(FoodInheritField),
            ]),
          ) as BuiltList<FoodInheritField>?;
          if (valueDes == null) continue;
          result.inheritFields.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'numchild':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numchild = valueDes;
          break;
        case r'open_data_slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.openDataSlug = valueDes;
          break;
        case r'parent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.parent = valueDes;
          break;
        case r'plural_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pluralName = valueDes;
          break;
        case r'properties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(Property),
            ]),
          ) as BuiltList<Property>?;
          if (valueDes == null) continue;
          result.properties.replace(valueDes);
          break;
        case r'properties_food_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.propertiesFoodAmount = valueDes;
          break;
        case r'properties_food_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Unit),
          ) as Unit?;
          if (valueDes == null) continue;
          result.propertiesFoodUnit.replace(valueDes);
          break;
        case r'recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecipeSimple),
          ) as RecipeSimple?;
          if (valueDes == null) continue;
          result.recipe.replace(valueDes);
          break;
        case r'shopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.shopping = valueDes;
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
        case r'substitute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(FoodSimple),
            ]),
          ) as BuiltList<FoodSimple>?;
          if (valueDes == null) continue;
          result.substitute.replace(valueDes);
          break;
        case r'substitute_children':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteChildren = valueDes;
          break;
        case r'substitute_onhand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteOnhand = valueDes;
          break;
        case r'substitute_siblings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteSiblings = valueDes;
          break;
        case r'supermarket_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SupermarketCategory),
          ) as SupermarketCategory?;
          if (valueDes == null) continue;
          result.supermarketCategory.replace(valueDes);
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedFood deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedFoodBuilder();
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

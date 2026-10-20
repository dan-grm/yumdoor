//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food_batch_update.g.dart';

/// FoodBatchUpdate
///
/// Properties:
/// * [category]
/// * [childInheritFieldsAdd]
/// * [childInheritFieldsRemove]
/// * [childInheritFieldsRemoveAll]
/// * [childInheritFieldsSet]
/// * [foods]
/// * [ignoreShopping]
/// * [inheritFieldsAdd]
/// * [inheritFieldsRemove]
/// * [inheritFieldsRemoveAll]
/// * [inheritFieldsSet]
/// * [onHand]
/// * [parentRemove]
/// * [parentSet]
/// * [shoppingListsAdd]
/// * [shoppingListsRemove]
/// * [shoppingListsRemoveAll]
/// * [shoppingListsSet]
/// * [substituteAdd]
/// * [substituteChildren]
/// * [substituteRemove]
/// * [substituteRemoveAll]
/// * [substituteSet]
/// * [substituteSiblings]
@BuiltValue()
abstract class FoodBatchUpdate
    implements Built<FoodBatchUpdate, FoodBatchUpdateBuilder> {
  @BuiltValueField(wireName: r'category')
  int? get category;

  @BuiltValueField(wireName: r'child_inherit_fields_add')
  BuiltList<int> get childInheritFieldsAdd;

  @BuiltValueField(wireName: r'child_inherit_fields_remove')
  BuiltList<int> get childInheritFieldsRemove;

  @BuiltValueField(wireName: r'child_inherit_fields_remove_all')
  bool? get childInheritFieldsRemoveAll;

  @BuiltValueField(wireName: r'child_inherit_fields_set')
  BuiltList<int> get childInheritFieldsSet;

  @BuiltValueField(wireName: r'foods')
  BuiltList<int> get foods;

  @BuiltValueField(wireName: r'ignore_shopping')
  bool? get ignoreShopping;

  @BuiltValueField(wireName: r'inherit_fields_add')
  BuiltList<int> get inheritFieldsAdd;

  @BuiltValueField(wireName: r'inherit_fields_remove')
  BuiltList<int> get inheritFieldsRemove;

  @BuiltValueField(wireName: r'inherit_fields_remove_all')
  bool? get inheritFieldsRemoveAll;

  @BuiltValueField(wireName: r'inherit_fields_set')
  BuiltList<int> get inheritFieldsSet;

  @BuiltValueField(wireName: r'on_hand')
  bool? get onHand;

  @BuiltValueField(wireName: r'parent_remove')
  bool? get parentRemove;

  @BuiltValueField(wireName: r'parent_set')
  int? get parentSet;

  @BuiltValueField(wireName: r'shopping_lists_add')
  BuiltList<int>? get shoppingListsAdd;

  @BuiltValueField(wireName: r'shopping_lists_remove')
  BuiltList<int>? get shoppingListsRemove;

  @BuiltValueField(wireName: r'shopping_lists_remove_all')
  bool? get shoppingListsRemoveAll;

  @BuiltValueField(wireName: r'shopping_lists_set')
  BuiltList<int>? get shoppingListsSet;

  @BuiltValueField(wireName: r'substitute_add')
  BuiltList<int> get substituteAdd;

  @BuiltValueField(wireName: r'substitute_children')
  bool? get substituteChildren;

  @BuiltValueField(wireName: r'substitute_remove')
  BuiltList<int> get substituteRemove;

  @BuiltValueField(wireName: r'substitute_remove_all')
  bool? get substituteRemoveAll;

  @BuiltValueField(wireName: r'substitute_set')
  BuiltList<int> get substituteSet;

  @BuiltValueField(wireName: r'substitute_siblings')
  bool? get substituteSiblings;

  FoodBatchUpdate._();

  factory FoodBatchUpdate([void updates(FoodBatchUpdateBuilder b)]) =
      _$FoodBatchUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoodBatchUpdateBuilder b) => b
    ..childInheritFieldsRemoveAll = false
    ..inheritFieldsRemoveAll = false
    ..shoppingListsRemoveAll = false
    ..substituteRemoveAll = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<FoodBatchUpdate> get serializer =>
      _$FoodBatchUpdateSerializer();
}

class _$FoodBatchUpdateSerializer
    implements PrimitiveSerializer<FoodBatchUpdate> {
  @override
  final Iterable<Type> types = const [FoodBatchUpdate, _$FoodBatchUpdate];

  @override
  final String wireName = r'FoodBatchUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FoodBatchUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'child_inherit_fields_add';
    yield serializers.serialize(
      object.childInheritFieldsAdd,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'child_inherit_fields_remove';
    yield serializers.serialize(
      object.childInheritFieldsRemove,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.childInheritFieldsRemoveAll != null) {
      yield r'child_inherit_fields_remove_all';
      yield serializers.serialize(
        object.childInheritFieldsRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    yield r'child_inherit_fields_set';
    yield serializers.serialize(
      object.childInheritFieldsSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'foods';
    yield serializers.serialize(
      object.foods,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.ignoreShopping != null) {
      yield r'ignore_shopping';
      yield serializers.serialize(
        object.ignoreShopping,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'inherit_fields_add';
    yield serializers.serialize(
      object.inheritFieldsAdd,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'inherit_fields_remove';
    yield serializers.serialize(
      object.inheritFieldsRemove,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.inheritFieldsRemoveAll != null) {
      yield r'inherit_fields_remove_all';
      yield serializers.serialize(
        object.inheritFieldsRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    yield r'inherit_fields_set';
    yield serializers.serialize(
      object.inheritFieldsSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.onHand != null) {
      yield r'on_hand';
      yield serializers.serialize(
        object.onHand,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.parentRemove != null) {
      yield r'parent_remove';
      yield serializers.serialize(
        object.parentRemove,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.parentSet != null) {
      yield r'parent_set';
      yield serializers.serialize(
        object.parentSet,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.shoppingListsAdd != null) {
      yield r'shopping_lists_add';
      yield serializers.serialize(
        object.shoppingListsAdd,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.shoppingListsRemove != null) {
      yield r'shopping_lists_remove';
      yield serializers.serialize(
        object.shoppingListsRemove,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    if (object.shoppingListsRemoveAll != null) {
      yield r'shopping_lists_remove_all';
      yield serializers.serialize(
        object.shoppingListsRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shoppingListsSet != null) {
      yield r'shopping_lists_set';
      yield serializers.serialize(
        object.shoppingListsSet,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    yield r'substitute_add';
    yield serializers.serialize(
      object.substituteAdd,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.substituteChildren != null) {
      yield r'substitute_children';
      yield serializers.serialize(
        object.substituteChildren,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'substitute_remove';
    yield serializers.serialize(
      object.substituteRemove,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.substituteRemoveAll != null) {
      yield r'substitute_remove_all';
      yield serializers.serialize(
        object.substituteRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    yield r'substitute_set';
    yield serializers.serialize(
      object.substituteSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.substituteSiblings != null) {
      yield r'substitute_siblings';
      yield serializers.serialize(
        object.substituteSiblings,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FoodBatchUpdate object, {
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
    required FoodBatchUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'child_inherit_fields_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.childInheritFieldsAdd.replace(valueDes);
          break;
        case r'child_inherit_fields_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.childInheritFieldsRemove.replace(valueDes);
          break;
        case r'child_inherit_fields_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.childInheritFieldsRemoveAll = valueDes;
          break;
        case r'child_inherit_fields_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.childInheritFieldsSet.replace(valueDes);
          break;
        case r'foods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.foods.replace(valueDes);
          break;
        case r'ignore_shopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.ignoreShopping = valueDes;
          break;
        case r'inherit_fields_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.inheritFieldsAdd.replace(valueDes);
          break;
        case r'inherit_fields_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.inheritFieldsRemove.replace(valueDes);
          break;
        case r'inherit_fields_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inheritFieldsRemoveAll = valueDes;
          break;
        case r'inherit_fields_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.inheritFieldsSet.replace(valueDes);
          break;
        case r'on_hand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.onHand = valueDes;
          break;
        case r'parent_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.parentRemove = valueDes;
          break;
        case r'parent_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.parentSet = valueDes;
          break;
        case r'shopping_lists_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.shoppingListsAdd.replace(valueDes);
          break;
        case r'shopping_lists_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.shoppingListsRemove.replace(valueDes);
          break;
        case r'shopping_lists_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.shoppingListsRemoveAll = valueDes;
          break;
        case r'shopping_lists_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.shoppingListsSet.replace(valueDes);
          break;
        case r'substitute_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.substituteAdd.replace(valueDes);
          break;
        case r'substitute_children':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteChildren = valueDes;
          break;
        case r'substitute_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.substituteRemove.replace(valueDes);
          break;
        case r'substitute_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteRemoveAll = valueDes;
          break;
        case r'substitute_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.substituteSet.replace(valueDes);
          break;
        case r'substitute_siblings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.substituteSiblings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FoodBatchUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoodBatchUpdateBuilder();
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

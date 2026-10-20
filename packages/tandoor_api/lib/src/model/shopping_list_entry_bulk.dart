//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shopping_list_entry_bulk.g.dart';

/// ShoppingListEntryBulk
///
/// Properties:
/// * [checked]
/// * [ids]
/// * [shoppingListsAdd]
/// * [shoppingListsRemove]
/// * [shoppingListsRemoveAll]
/// * [shoppingListsSet]
/// * [timestamp]
@BuiltValue()
abstract class ShoppingListEntryBulk
    implements Built<ShoppingListEntryBulk, ShoppingListEntryBulkBuilder> {
  @BuiltValueField(wireName: r'checked')
  bool? get checked;

  @BuiltValueField(wireName: r'ids')
  BuiltList<JsonObject?> get ids;

  @BuiltValueField(wireName: r'shopping_lists_add')
  BuiltList<int>? get shoppingListsAdd;

  @BuiltValueField(wireName: r'shopping_lists_remove')
  BuiltList<int>? get shoppingListsRemove;

  @BuiltValueField(wireName: r'shopping_lists_remove_all')
  bool? get shoppingListsRemoveAll;

  @BuiltValueField(wireName: r'shopping_lists_set')
  BuiltList<int>? get shoppingListsSet;

  @BuiltValueField(wireName: r'timestamp')
  DateTime? get timestamp;

  ShoppingListEntryBulk._();

  factory ShoppingListEntryBulk([
    void updates(ShoppingListEntryBulkBuilder b),
  ]) = _$ShoppingListEntryBulk;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShoppingListEntryBulkBuilder b) =>
      b..shoppingListsRemoveAll = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShoppingListEntryBulk> get serializer =>
      _$ShoppingListEntryBulkSerializer();
}

class _$ShoppingListEntryBulkSerializer
    implements PrimitiveSerializer<ShoppingListEntryBulk> {
  @override
  final Iterable<Type> types = const [
    ShoppingListEntryBulk,
    _$ShoppingListEntryBulk,
  ];

  @override
  final String wireName = r'ShoppingListEntryBulk';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShoppingListEntryBulk object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checked != null) {
      yield r'checked';
      yield serializers.serialize(
        object.checked,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType.nullable(JsonObject)]),
    );
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
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ShoppingListEntryBulk object, {
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
    required ShoppingListEntryBulkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.checked = valueDes;
          break;
        case r'ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType.nullable(JsonObject),
            ]),
          ) as BuiltList<JsonObject?>;
          result.ids.replace(valueDes);
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
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ShoppingListEntryBulk deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShoppingListEntryBulkBuilder();
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

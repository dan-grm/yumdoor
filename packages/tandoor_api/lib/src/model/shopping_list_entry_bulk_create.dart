//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/shopping_list_entry_simple_create.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shopping_list_entry_bulk_create.g.dart';

/// ShoppingListEntryBulkCreate
///
/// Properties:
/// * [entries]
/// * [shoppingListsIds]
@BuiltValue()
abstract class ShoppingListEntryBulkCreate
    implements
        Built<ShoppingListEntryBulkCreate, ShoppingListEntryBulkCreateBuilder> {
  @BuiltValueField(wireName: r'entries')
  BuiltList<ShoppingListEntrySimpleCreate> get entries;

  @BuiltValueField(wireName: r'shopping_lists_ids')
  BuiltList<int>? get shoppingListsIds;

  ShoppingListEntryBulkCreate._();

  factory ShoppingListEntryBulkCreate([
    void updates(ShoppingListEntryBulkCreateBuilder b),
  ]) = _$ShoppingListEntryBulkCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShoppingListEntryBulkCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShoppingListEntryBulkCreate> get serializer =>
      _$ShoppingListEntryBulkCreateSerializer();
}

class _$ShoppingListEntryBulkCreateSerializer
    implements PrimitiveSerializer<ShoppingListEntryBulkCreate> {
  @override
  final Iterable<Type> types = const [
    ShoppingListEntryBulkCreate,
    _$ShoppingListEntryBulkCreate,
  ];

  @override
  final String wireName = r'ShoppingListEntryBulkCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShoppingListEntryBulkCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(ShoppingListEntrySimpleCreate),
      ]),
    );
    if (object.shoppingListsIds != null) {
      yield r'shopping_lists_ids';
      yield serializers.serialize(
        object.shoppingListsIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ShoppingListEntryBulkCreate object, {
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
    required ShoppingListEntryBulkCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entries':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(ShoppingListEntrySimpleCreate),
            ]),
          ) as BuiltList<ShoppingListEntrySimpleCreate>;
          result.entries.replace(valueDes);
          break;
        case r'shopping_lists_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.shoppingListsIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ShoppingListEntryBulkCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShoppingListEntryBulkCreateBuilder();
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

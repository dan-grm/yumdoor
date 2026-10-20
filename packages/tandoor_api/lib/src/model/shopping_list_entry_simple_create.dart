//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shopping_list_entry_simple_create.g.dart';

/// ShoppingListEntrySimpleCreate
///
/// Properties:
/// * [amount]
/// * [foodId]
/// * [ingredientId]
/// * [unitId]
@BuiltValue()
abstract class ShoppingListEntrySimpleCreate
    implements
        Built<
          ShoppingListEntrySimpleCreate,
          ShoppingListEntrySimpleCreateBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  double get amount;

  @BuiltValueField(wireName: r'food_id')
  int? get foodId;

  @BuiltValueField(wireName: r'ingredient_id')
  int? get ingredientId;

  @BuiltValueField(wireName: r'unit_id')
  int? get unitId;

  ShoppingListEntrySimpleCreate._();

  factory ShoppingListEntrySimpleCreate([
    void updates(ShoppingListEntrySimpleCreateBuilder b),
  ]) = _$ShoppingListEntrySimpleCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShoppingListEntrySimpleCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShoppingListEntrySimpleCreate> get serializer =>
      _$ShoppingListEntrySimpleCreateSerializer();
}

class _$ShoppingListEntrySimpleCreateSerializer
    implements PrimitiveSerializer<ShoppingListEntrySimpleCreate> {
  @override
  final Iterable<Type> types = const [
    ShoppingListEntrySimpleCreate,
    _$ShoppingListEntrySimpleCreate,
  ];

  @override
  final String wireName = r'ShoppingListEntrySimpleCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShoppingListEntrySimpleCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(double),
    );
    yield r'food_id';
    yield object.foodId == null
        ? null
        : serializers.serialize(
            object.foodId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'ingredient_id';
    yield object.ingredientId == null
        ? null
        : serializers.serialize(
            object.ingredientId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'unit_id';
    yield object.unitId == null
        ? null
        : serializers.serialize(
            object.unitId,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ShoppingListEntrySimpleCreate object, {
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
    required ShoppingListEntrySimpleCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.amount = valueDes;
          break;
        case r'food_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.foodId = valueDes;
          break;
        case r'ingredient_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ingredientId = valueDes;
          break;
        case r'unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.unitId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ShoppingListEntrySimpleCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShoppingListEntrySimpleCreateBuilder();
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

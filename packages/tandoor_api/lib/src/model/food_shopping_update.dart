//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/delete_enum.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food_shopping_update.g.dart';

/// FoodShoppingUpdate
///
/// Properties:
/// * [amount] - Amount of food to add to the shopping list
/// * [delete] - When set to true will delete all food from active shopping lists.  * `true` - true
/// * [id]
/// * [unit] - ID of unit to use for the shopping list
@BuiltValue()
abstract class FoodShoppingUpdate
    implements Built<FoodShoppingUpdate, FoodShoppingUpdateBuilder> {
  /// Amount of food to add to the shopping list
  @BuiltValueField(wireName: r'amount')
  int? get amount;

  /// When set to true will delete all food from active shopping lists.  * `true` - true
  @BuiltValueField(wireName: r'delete')
  DeleteEnum? get delete;
  // enum deleteEnum {  true,  };

  @BuiltValueField(wireName: r'id')
  int? get id;

  /// ID of unit to use for the shopping list
  @BuiltValueField(wireName: r'unit')
  int? get unit;

  FoodShoppingUpdate._();

  factory FoodShoppingUpdate([void updates(FoodShoppingUpdateBuilder b)]) =
      _$FoodShoppingUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoodShoppingUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FoodShoppingUpdate> get serializer =>
      _$FoodShoppingUpdateSerializer();
}

class _$FoodShoppingUpdateSerializer
    implements PrimitiveSerializer<FoodShoppingUpdate> {
  @override
  final Iterable<Type> types = const [FoodShoppingUpdate, _$FoodShoppingUpdate];

  @override
  final String wireName = r'FoodShoppingUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FoodShoppingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.amount != null) {
      yield r'amount';
      yield serializers.serialize(
        object.amount,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'delete';
    yield object.delete == null
        ? null
        : serializers.serialize(
            object.delete,
            specifiedType: const FullType.nullable(DeleteEnum),
          );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FoodShoppingUpdate object, {
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
    required FoodShoppingUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'delete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeleteEnum),
          ) as DeleteEnum?;
          if (valueDes == null) continue;
          result.delete = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.unit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FoodShoppingUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoodShoppingUpdateBuilder();
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

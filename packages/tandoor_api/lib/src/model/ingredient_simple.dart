//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/unit.dart';
import 'package:tandoor_api/src/model/food_simple.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_simple.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [amount]
/// * [checked] - Just laziness to have a checked field on the frontend API client
/// * [food]
/// * [id]
/// * [isHeader]
/// * [noAmount]
/// * [note]
/// * [order]
/// * [originalText]
/// * [unit]
@BuiltValue()
abstract class IngredientSimple
    implements Built<IngredientSimple, IngredientSimpleBuilder> {
  @BuiltValueField(wireName: r'amount')
  double get amount;

  /// Just laziness to have a checked field on the frontend API client
  @BuiltValueField(wireName: r'checked')
  bool? get checked;

  @BuiltValueField(wireName: r'food')
  FoodSimple? get food;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'is_header')
  bool? get isHeader;

  @BuiltValueField(wireName: r'no_amount')
  bool? get noAmount;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'original_text')
  String? get originalText;

  @BuiltValueField(wireName: r'unit')
  Unit? get unit;

  IngredientSimple._();

  factory IngredientSimple([void updates(IngredientSimpleBuilder b)]) =
      _$IngredientSimple;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientSimpleBuilder b) => b..checked = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientSimple> get serializer =>
      _$IngredientSimpleSerializer();
}

class _$IngredientSimpleSerializer
    implements PrimitiveSerializer<IngredientSimple> {
  @override
  final Iterable<Type> types = const [IngredientSimple, _$IngredientSimple];

  @override
  final String wireName = r'IngredientSimple';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientSimple object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(double),
    );
    if (object.checked != null) {
      yield r'checked';
      yield serializers.serialize(
        object.checked,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'food';
    yield object.food == null
        ? null
        : serializers.serialize(
            object.food,
            specifiedType: const FullType.nullable(FoodSimple),
          );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.isHeader != null) {
      yield r'is_header';
      yield serializers.serialize(
        object.isHeader,
        specifiedType: const FullType(bool),
      );
    }
    if (object.noAmount != null) {
      yield r'no_amount';
      yield serializers.serialize(
        object.noAmount,
        specifiedType: const FullType(bool),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(int),
      );
    }
    if (object.originalText != null) {
      yield r'original_text';
      yield serializers.serialize(
        object.originalText,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'unit';
    yield object.unit == null
        ? null
        : serializers.serialize(
            object.unit,
            specifiedType: const FullType.nullable(Unit),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientSimple object, {
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
    required IngredientSimpleBuilder result,
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
        case r'checked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.checked = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FoodSimple),
          ) as FoodSimple?;
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
        case r'is_header':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHeader = valueDes;
          break;
        case r'no_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.noAmount = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'original_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originalText = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Unit),
          ) as Unit?;
          if (valueDes == null) continue;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IngredientSimple deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientSimpleBuilder();
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

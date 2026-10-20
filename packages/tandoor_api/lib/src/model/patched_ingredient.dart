//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/food.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_ingredient.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [amount]
/// * [checked] - Just laziness to have a checked field on the frontend API client
/// * [conversions]
/// * [food]
/// * [id]
/// * [isHeader]
/// * [noAmount]
/// * [note]
/// * [order]
/// * [originalText]
/// * [unit]
/// * [usedInRecipes]
@BuiltValue()
abstract class PatchedIngredient
    implements Built<PatchedIngredient, PatchedIngredientBuilder> {
  @BuiltValueField(wireName: r'amount')
  double? get amount;

  /// Just laziness to have a checked field on the frontend API client
  @BuiltValueField(wireName: r'checked')
  bool? get checked;

  @BuiltValueField(wireName: r'conversions')
  BuiltList<JsonObject?>? get conversions;

  @BuiltValueField(wireName: r'food')
  Food? get food;

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

  @BuiltValueField(wireName: r'used_in_recipes')
  BuiltList<JsonObject?>? get usedInRecipes;

  PatchedIngredient._();

  factory PatchedIngredient([void updates(PatchedIngredientBuilder b)]) =
      _$PatchedIngredient;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedIngredientBuilder b) => b..checked = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedIngredient> get serializer =>
      _$PatchedIngredientSerializer();
}

class _$PatchedIngredientSerializer
    implements PrimitiveSerializer<PatchedIngredient> {
  @override
  final Iterable<Type> types = const [PatchedIngredient, _$PatchedIngredient];

  @override
  final String wireName = r'PatchedIngredient';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedIngredient object, {
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
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.conversions != null) {
      yield r'conversions';
      yield serializers.serialize(
        object.conversions,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType.nullable(JsonObject),
        ]),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType.nullable(Food),
      );
    }
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
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType.nullable(Unit),
      );
    }
    if (object.usedInRecipes != null) {
      yield r'used_in_recipes';
      yield serializers.serialize(
        object.usedInRecipes,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType.nullable(JsonObject),
        ]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedIngredient object, {
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
    required PatchedIngredientBuilder result,
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
        case r'conversions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType.nullable(JsonObject),
            ]),
          ) as BuiltList<JsonObject?>?;
          if (valueDes == null) continue;
          result.conversions.replace(valueDes);
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Food),
          ) as Food?;
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
        case r'used_in_recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType.nullable(JsonObject),
            ]),
          ) as BuiltList<JsonObject?>?;
          if (valueDes == null) continue;
          result.usedInRecipes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedIngredient deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedIngredientBuilder();
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

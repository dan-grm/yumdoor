//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/ingredient_simple.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_parser_response.g.dart';

/// IngredientParserResponse
///
/// Properties:
/// * [ingredient]
/// * [ingredients]
@BuiltValue()
abstract class IngredientParserResponse
    implements
        Built<IngredientParserResponse, IngredientParserResponseBuilder> {
  @BuiltValueField(wireName: r'ingredient')
  IngredientSimple? get ingredient;

  @BuiltValueField(wireName: r'ingredients')
  BuiltList<IngredientSimple> get ingredients;

  IngredientParserResponse._();

  factory IngredientParserResponse([
    void updates(IngredientParserResponseBuilder b),
  ]) = _$IngredientParserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientParserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientParserResponse> get serializer =>
      _$IngredientParserResponseSerializer();
}

class _$IngredientParserResponseSerializer
    implements PrimitiveSerializer<IngredientParserResponse> {
  @override
  final Iterable<Type> types = const [
    IngredientParserResponse,
    _$IngredientParserResponse,
  ];

  @override
  final String wireName = r'IngredientParserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientParserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ingredient';
    yield object.ingredient == null
        ? null
        : serializers.serialize(
            object.ingredient,
            specifiedType: const FullType.nullable(IngredientSimple),
          );
    yield r'ingredients';
    yield serializers.serialize(
      object.ingredients,
      specifiedType: const FullType(BuiltList, [FullType(IngredientSimple)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientParserResponse object, {
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
    required IngredientParserResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ingredient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IngredientSimple),
          ) as IngredientSimple?;
          if (valueDes == null) continue;
          result.ingredient.replace(valueDes);
          break;
        case r'ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(IngredientSimple),
            ]),
          ) as BuiltList<IngredientSimple>;
          result.ingredients.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IngredientParserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientParserResponseBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ingredient_parser_request.g.dart';

/// IngredientParserRequest
///
/// Properties:
/// * [ingredient]
/// * [ingredients]
@BuiltValue()
abstract class IngredientParserRequest
    implements Built<IngredientParserRequest, IngredientParserRequestBuilder> {
  @BuiltValueField(wireName: r'ingredient')
  String? get ingredient;

  @BuiltValueField(wireName: r'ingredients')
  BuiltList<String>? get ingredients;

  IngredientParserRequest._();

  factory IngredientParserRequest([
    void updates(IngredientParserRequestBuilder b),
  ]) = _$IngredientParserRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IngredientParserRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IngredientParserRequest> get serializer =>
      _$IngredientParserRequestSerializer();
}

class _$IngredientParserRequestSerializer
    implements PrimitiveSerializer<IngredientParserRequest> {
  @override
  final Iterable<Type> types = const [
    IngredientParserRequest,
    _$IngredientParserRequest,
  ];

  @override
  final String wireName = r'IngredientParserRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IngredientParserRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.ingredient != null) {
      yield r'ingredient';
      yield serializers.serialize(
        object.ingredient,
        specifiedType: const FullType(String),
      );
    }
    if (object.ingredients != null) {
      yield r'ingredients';
      yield serializers.serialize(
        object.ingredients,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IngredientParserRequest object, {
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
    required IngredientParserRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ingredient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ingredient = valueDes;
          break;
        case r'ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(String),
            ]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
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
  IngredientParserRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IngredientParserRequestBuilder();
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

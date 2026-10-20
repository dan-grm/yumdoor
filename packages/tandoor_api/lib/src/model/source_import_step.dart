//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/source_import_ingredient.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_step.g.dart';

/// SourceImportStep
///
/// Properties:
/// * [ingredients]
/// * [instruction]
/// * [showIngredientsTable]
@BuiltValue()
abstract class SourceImportStep
    implements Built<SourceImportStep, SourceImportStepBuilder> {
  @BuiltValueField(wireName: r'ingredients')
  BuiltList<SourceImportIngredient> get ingredients;

  @BuiltValueField(wireName: r'instruction')
  String get instruction;

  @BuiltValueField(wireName: r'show_ingredients_table')
  bool? get showIngredientsTable;

  SourceImportStep._();

  factory SourceImportStep([void updates(SourceImportStepBuilder b)]) =
      _$SourceImportStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportStepBuilder b) =>
      b..showIngredientsTable = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportStep> get serializer =>
      _$SourceImportStepSerializer();
}

class _$SourceImportStepSerializer
    implements PrimitiveSerializer<SourceImportStep> {
  @override
  final Iterable<Type> types = const [SourceImportStep, _$SourceImportStep];

  @override
  final String wireName = r'SourceImportStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ingredients';
    yield serializers.serialize(
      object.ingredients,
      specifiedType: const FullType(BuiltList, [
        FullType(SourceImportIngredient),
      ]),
    );
    yield r'instruction';
    yield serializers.serialize(
      object.instruction,
      specifiedType: const FullType(String),
    );
    if (object.showIngredientsTable != null) {
      yield r'show_ingredients_table';
      yield serializers.serialize(
        object.showIngredientsTable,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportStep object, {
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
    required SourceImportStepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(SourceImportIngredient),
            ]),
          ) as BuiltList<SourceImportIngredient>;
          result.ingredients.replace(valueDes);
          break;
        case r'instruction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.instruction = valueDes;
          break;
        case r'show_ingredients_table':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showIngredientsTable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SourceImportStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportStepBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/user_file_view.dart';
import 'package:tandoor_api/src/model/ingredient.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'step.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [file]
/// * [id]
/// * [ingredients]
/// * [instruction]
/// * [instructionsMarkdown]
/// * [name]
/// * [numrecipe]
/// * [order]
/// * [showAsHeader]
/// * [showIngredientsTable]
/// * [stepRecipe]
/// * [stepRecipeData]
/// * [time]
@BuiltValue()
abstract class Step implements Built<Step, StepBuilder> {
  @BuiltValueField(wireName: r'file')
  UserFileView? get file;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'ingredients')
  BuiltList<Ingredient> get ingredients;

  @BuiltValueField(wireName: r'instruction')
  String? get instruction;

  @BuiltValueField(wireName: r'instructions_markdown')
  String? get instructionsMarkdown;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'numrecipe')
  int? get numrecipe;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'show_as_header')
  bool? get showAsHeader;

  @BuiltValueField(wireName: r'show_ingredients_table')
  bool? get showIngredientsTable;

  @BuiltValueField(wireName: r'step_recipe')
  int? get stepRecipe;

  @BuiltValueField(wireName: r'step_recipe_data')
  JsonObject? get stepRecipeData;

  @BuiltValueField(wireName: r'time')
  int? get time;

  Step._();

  factory Step([void updates(StepBuilder b)]) = _$Step;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Step> get serializer => _$StepSerializer();
}

class _$StepSerializer implements PrimitiveSerializer<Step> {
  @override
  final Iterable<Type> types = const [Step, _$Step];

  @override
  final String wireName = r'Step';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Step object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.file != null) {
      yield r'file';
      yield serializers.serialize(
        object.file,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'ingredients';
    yield serializers.serialize(
      object.ingredients,
      specifiedType: const FullType(BuiltList, [FullType(Ingredient)]),
    );
    if (object.instruction != null) {
      yield r'instruction';
      yield serializers.serialize(
        object.instruction,
        specifiedType: const FullType(String),
      );
    }
    if (object.instructionsMarkdown != null) {
      yield r'instructions_markdown';
      yield serializers.serialize(
        object.instructionsMarkdown,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.numrecipe != null) {
      yield r'numrecipe';
      yield serializers.serialize(
        object.numrecipe,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(int),
      );
    }
    if (object.showAsHeader != null) {
      yield r'show_as_header';
      yield serializers.serialize(
        object.showAsHeader,
        specifiedType: const FullType(bool),
      );
    }
    if (object.showIngredientsTable != null) {
      yield r'show_ingredients_table';
      yield serializers.serialize(
        object.showIngredientsTable,
        specifiedType: const FullType(bool),
      );
    }
    if (object.stepRecipe != null) {
      yield r'step_recipe';
      yield serializers.serialize(
        object.stepRecipe,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.stepRecipeData != null) {
      yield r'step_recipe_data';
      yield serializers.serialize(
        object.stepRecipeData,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    if (object.time != null) {
      yield r'time';
      yield serializers.serialize(
        object.time,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Step object, {
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
    required StepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.file.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Ingredient)]),
          ) as BuiltList<Ingredient>;
          result.ingredients.replace(valueDes);
          break;
        case r'instruction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.instruction = valueDes;
          break;
        case r'instructions_markdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.instructionsMarkdown = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'numrecipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numrecipe = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'show_as_header':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showAsHeader = valueDes;
          break;
        case r'show_ingredients_table':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showIngredientsTable = valueDes;
          break;
        case r'step_recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.stepRecipe = valueDes;
          break;
        case r'step_recipe_data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.stepRecipeData = valueDes;
          break;
        case r'time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.time = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Step deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StepBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/keyword.dart';
import 'package:tandoor_api/src/model/nutrition_information.dart';
import 'package:tandoor_api/src/model/property.dart';
import 'package:built_value/json_object.dart';
import 'package:tandoor_api/src/model/step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [diameter]
/// * [diameterText]
/// * [filePath]
/// * [foodProperties]
/// * [id]
/// * [image]
/// * [internal]
/// * [keywords]
/// * [lastCooked]
/// * [name]
/// * [nutrition]
/// * [private]
/// * [properties]
/// * [rating]
/// * [servings]
/// * [servingsText]
/// * [shared]
/// * [showIngredientOverview]
/// * [sourceUrl]
/// * [steps]
/// * [updatedAt]
/// * [waitingTime]
/// * [workingTime]
@BuiltValue()
abstract class Recipe implements Built<Recipe, RecipeBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'diameter')
  int? get diameter;

  @BuiltValueField(wireName: r'diameter_text')
  String? get diameterText;

  @BuiltValueField(wireName: r'file_path')
  String? get filePath;

  @BuiltValueField(wireName: r'food_properties')
  JsonObject? get foodProperties;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'internal')
  bool? get internal;

  @BuiltValueField(wireName: r'keywords')
  BuiltList<Keyword>? get keywords;

  @BuiltValueField(wireName: r'last_cooked')
  DateTime? get lastCooked;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nutrition')
  NutritionInformation? get nutrition;

  @BuiltValueField(wireName: r'private')
  bool? get private;

  @BuiltValueField(wireName: r'properties')
  BuiltList<Property>? get properties;

  @BuiltValueField(wireName: r'rating')
  double? get rating;

  @BuiltValueField(wireName: r'servings')
  int? get servings;

  @BuiltValueField(wireName: r'servings_text')
  String? get servingsText;

  @BuiltValueField(wireName: r'shared')
  BuiltList<User>? get shared;

  @BuiltValueField(wireName: r'show_ingredient_overview')
  bool? get showIngredientOverview;

  @BuiltValueField(wireName: r'source_url')
  String? get sourceUrl;

  @BuiltValueField(wireName: r'steps')
  BuiltList<Step> get steps;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'waiting_time')
  int? get waitingTime;

  @BuiltValueField(wireName: r'working_time')
  int? get workingTime;

  Recipe._();

  factory Recipe([void updates(RecipeBuilder b)]) = _$Recipe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Recipe> get serializer => _$RecipeSerializer();
}

class _$RecipeSerializer implements PrimitiveSerializer<Recipe> {
  @override
  final Iterable<Type> types = const [Recipe, _$Recipe];

  @override
  final String wireName = r'Recipe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Recipe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.diameter != null) {
      yield r'diameter';
      yield serializers.serialize(
        object.diameter,
        specifiedType: const FullType(int),
      );
    }
    if (object.diameterText != null) {
      yield r'diameter_text';
      yield serializers.serialize(
        object.diameterText,
        specifiedType: const FullType(String),
      );
    }
    if (object.filePath != null) {
      yield r'file_path';
      yield serializers.serialize(
        object.filePath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.foodProperties != null) {
      yield r'food_properties';
      yield serializers.serialize(
        object.foodProperties,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.internal != null) {
      yield r'internal';
      yield serializers.serialize(
        object.internal,
        specifiedType: const FullType(bool),
      );
    }
    if (object.keywords != null) {
      yield r'keywords';
      yield serializers.serialize(
        object.keywords,
        specifiedType: const FullType(BuiltList, [FullType(Keyword)]),
      );
    }
    if (object.lastCooked != null) {
      yield r'last_cooked';
      yield serializers.serialize(
        object.lastCooked,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.nutrition != null) {
      yield r'nutrition';
      yield serializers.serialize(
        object.nutrition,
        specifiedType: const FullType.nullable(NutritionInformation),
      );
    }
    if (object.private != null) {
      yield r'private';
      yield serializers.serialize(
        object.private,
        specifiedType: const FullType(bool),
      );
    }
    if (object.properties != null) {
      yield r'properties';
      yield serializers.serialize(
        object.properties,
        specifiedType: const FullType(BuiltList, [FullType(Property)]),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.servings != null) {
      yield r'servings';
      yield serializers.serialize(
        object.servings,
        specifiedType: const FullType(int),
      );
    }
    if (object.servingsText != null) {
      yield r'servings_text';
      yield serializers.serialize(
        object.servingsText,
        specifiedType: const FullType(String),
      );
    }
    if (object.shared != null) {
      yield r'shared';
      yield serializers.serialize(
        object.shared,
        specifiedType: const FullType(BuiltList, [FullType(User)]),
      );
    }
    if (object.showIngredientOverview != null) {
      yield r'show_ingredient_overview';
      yield serializers.serialize(
        object.showIngredientOverview,
        specifiedType: const FullType(bool),
      );
    }
    if (object.sourceUrl != null) {
      yield r'source_url';
      yield serializers.serialize(
        object.sourceUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(Step)]),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.waitingTime != null) {
      yield r'waiting_time';
      yield serializers.serialize(
        object.waitingTime,
        specifiedType: const FullType(int),
      );
    }
    if (object.workingTime != null) {
      yield r'working_time';
      yield serializers.serialize(
        object.workingTime,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Recipe object, {
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
    required RecipeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.createdBy.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'diameter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.diameter = valueDes;
          break;
        case r'diameter_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.diameterText = valueDes;
          break;
        case r'file_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.filePath = valueDes;
          break;
        case r'food_properties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.foodProperties = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.image = valueDes;
          break;
        case r'internal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.internal = valueDes;
          break;
        case r'keywords':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(Keyword),
            ]),
          ) as BuiltList<Keyword>?;
          if (valueDes == null) continue;
          result.keywords.replace(valueDes);
          break;
        case r'last_cooked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastCooked = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'nutrition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NutritionInformation),
          ) as NutritionInformation?;
          if (valueDes == null) continue;
          result.nutrition.replace(valueDes);
          break;
        case r'private':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.private = valueDes;
          break;
        case r'properties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(Property),
            ]),
          ) as BuiltList<Property>?;
          if (valueDes == null) continue;
          result.properties.replace(valueDes);
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.servings = valueDes;
          break;
        case r'servings_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.servingsText = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(User)]),
          ) as BuiltList<User>?;
          if (valueDes == null) continue;
          result.shared.replace(valueDes);
          break;
        case r'show_ingredient_overview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showIngredientOverview = valueDes;
          break;
        case r'source_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceUrl = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Step)]),
          ) as BuiltList<Step>;
          result.steps.replace(valueDes);
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'waiting_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.waitingTime = valueDes;
          break;
        case r'working_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.workingTime = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Recipe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeBuilder();
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

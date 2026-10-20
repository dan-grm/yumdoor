//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/recipe_overview.dart';
import 'package:tandoor_api/src/model/meal_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'meal_plan.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [addshopping]
/// * [createdBy]
/// * [fromDate]
/// * [id]
/// * [mealType]
/// * [mealTypeName]
/// * [note]
/// * [noteMarkdown]
/// * [recipe]
/// * [recipeName]
/// * [servings]
/// * [shopping]
/// * [title]
/// * [toDate]
@BuiltValue()
abstract class MealPlan implements Built<MealPlan, MealPlanBuilder> {
  @BuiltValueField(wireName: r'addshopping')
  bool? get addshopping;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'from_date')
  DateTime get fromDate;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'meal_type')
  MealType get mealType;

  @BuiltValueField(wireName: r'meal_type_name')
  String? get mealTypeName;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'note_markdown')
  String? get noteMarkdown;

  @BuiltValueField(wireName: r'recipe')
  RecipeOverview? get recipe;

  @BuiltValueField(wireName: r'recipe_name')
  String? get recipeName;

  @BuiltValueField(wireName: r'servings')
  double get servings;

  @BuiltValueField(wireName: r'shopping')
  bool? get shopping;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'to_date')
  DateTime? get toDate;

  MealPlan._();

  factory MealPlan([void updates(MealPlanBuilder b)]) = _$MealPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MealPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MealPlan> get serializer => _$MealPlanSerializer();
}

class _$MealPlanSerializer implements PrimitiveSerializer<MealPlan> {
  @override
  final Iterable<Type> types = const [MealPlan, _$MealPlan];

  @override
  final String wireName = r'MealPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MealPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.addshopping != null) {
      yield r'addshopping';
      yield serializers.serialize(
        object.addshopping,
        specifiedType: const FullType(bool),
      );
    }
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'from_date';
    yield serializers.serialize(
      object.fromDate,
      specifiedType: const FullType(DateTime),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'meal_type';
    yield serializers.serialize(
      object.mealType,
      specifiedType: const FullType(MealType),
    );
    if (object.mealTypeName != null) {
      yield r'meal_type_name';
      yield serializers.serialize(
        object.mealTypeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.noteMarkdown != null) {
      yield r'note_markdown';
      yield serializers.serialize(
        object.noteMarkdown,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.recipe != null) {
      yield r'recipe';
      yield serializers.serialize(
        object.recipe,
        specifiedType: const FullType.nullable(RecipeOverview),
      );
    }
    if (object.recipeName != null) {
      yield r'recipe_name';
      yield serializers.serialize(
        object.recipeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'servings';
    yield serializers.serialize(
      object.servings,
      specifiedType: const FullType(double),
    );
    if (object.shopping != null) {
      yield r'shopping';
      yield serializers.serialize(
        object.shopping,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.toDate != null) {
      yield r'to_date';
      yield serializers.serialize(
        object.toDate,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MealPlan object, {
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
    required MealPlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'addshopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.addshopping = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'from_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fromDate = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'meal_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MealType),
          ) as MealType;
          result.mealType.replace(valueDes);
          break;
        case r'meal_type_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mealTypeName = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'note_markdown':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.noteMarkdown = valueDes;
          break;
        case r'recipe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecipeOverview),
          ) as RecipeOverview?;
          if (valueDes == null) continue;
          result.recipe.replace(valueDes);
          break;
        case r'recipe_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recipeName = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.servings = valueDes;
          break;
        case r'shopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.shopping = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'to_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.toDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MealPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MealPlanBuilder();
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

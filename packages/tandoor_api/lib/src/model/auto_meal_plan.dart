//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/keyword_mode_enum.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_meal_plan.g.dart';

/// AutoMealPlan
///
/// Properties:
/// * [addshopping]
/// * [endDate]
/// * [keywordMode]
/// * [keywords]
/// * [mealTypeId]
/// * [servings]
/// * [shared]
/// * [startDate]
@BuiltValue()
abstract class AutoMealPlan
    implements Built<AutoMealPlan, AutoMealPlanBuilder> {
  @BuiltValueField(wireName: r'addshopping')
  bool get addshopping;

  @BuiltValueField(wireName: r'end_date')
  DateTime get endDate;

  @BuiltValueField(wireName: r'keyword_mode')
  KeywordModeEnum? get keywordMode;
  // enum keywordModeEnum {  or,  and,  };

  @BuiltValueField(wireName: r'keywords')
  BuiltList<int>? get keywords;

  @BuiltValueField(wireName: r'meal_type_id')
  int get mealTypeId;

  @BuiltValueField(wireName: r'servings')
  double get servings;

  @BuiltValueField(wireName: r'shared')
  BuiltList<User>? get shared;

  @BuiltValueField(wireName: r'start_date')
  DateTime get startDate;

  AutoMealPlan._();

  factory AutoMealPlan([void updates(AutoMealPlanBuilder b)]) = _$AutoMealPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoMealPlanBuilder b) => b
    ..keywordMode = KeywordModeEnum.and
    ..keywords = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoMealPlan> get serializer => _$AutoMealPlanSerializer();
}

class _$AutoMealPlanSerializer implements PrimitiveSerializer<AutoMealPlan> {
  @override
  final Iterable<Type> types = const [AutoMealPlan, _$AutoMealPlan];

  @override
  final String wireName = r'AutoMealPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoMealPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'addshopping';
    yield serializers.serialize(
      object.addshopping,
      specifiedType: const FullType(bool),
    );
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(DateTime),
    );
    if (object.keywordMode != null) {
      yield r'keyword_mode';
      yield serializers.serialize(
        object.keywordMode,
        specifiedType: const FullType(KeywordModeEnum),
      );
    }
    if (object.keywords != null) {
      yield r'keywords';
      yield serializers.serialize(
        object.keywords,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
    yield r'meal_type_id';
    yield serializers.serialize(
      object.mealTypeId,
      specifiedType: const FullType(int),
    );
    yield r'servings';
    yield serializers.serialize(
      object.servings,
      specifiedType: const FullType(double),
    );
    if (object.shared != null) {
      yield r'shared';
      yield serializers.serialize(
        object.shared,
        specifiedType: const FullType.nullable(BuiltList, [FullType(User)]),
      );
    }
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoMealPlan object, {
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
    required AutoMealPlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'addshopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.addshopping = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endDate = valueDes;
          break;
        case r'keyword_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(KeywordModeEnum),
          ) as KeywordModeEnum?;
          if (valueDes == null) continue;
          result.keywordMode = valueDes;
          break;
        case r'keywords':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.keywords.replace(valueDes);
          break;
        case r'meal_type_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.mealTypeId = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.servings = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(User)]),
          ) as BuiltList<User>?;
          if (valueDes == null) continue;
          result.shared.replace(valueDes);
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoMealPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoMealPlanBuilder();
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

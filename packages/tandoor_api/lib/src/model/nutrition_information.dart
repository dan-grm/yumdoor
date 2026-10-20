//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nutrition_information.g.dart';

/// NutritionInformation
///
/// Properties:
/// * [calories]
/// * [carbohydrates]
/// * [fats]
/// * [id]
/// * [proteins]
/// * [source_]
@BuiltValue()
abstract class NutritionInformation
    implements Built<NutritionInformation, NutritionInformationBuilder> {
  @BuiltValueField(wireName: r'calories')
  double get calories;

  @BuiltValueField(wireName: r'carbohydrates')
  double get carbohydrates;

  @BuiltValueField(wireName: r'fats')
  double get fats;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'proteins')
  double get proteins;

  @BuiltValueField(wireName: r'source')
  String? get source_;

  NutritionInformation._();

  factory NutritionInformation([void updates(NutritionInformationBuilder b)]) =
      _$NutritionInformation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NutritionInformationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NutritionInformation> get serializer =>
      _$NutritionInformationSerializer();
}

class _$NutritionInformationSerializer
    implements PrimitiveSerializer<NutritionInformation> {
  @override
  final Iterable<Type> types = const [
    NutritionInformation,
    _$NutritionInformation,
  ];

  @override
  final String wireName = r'NutritionInformation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NutritionInformation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'calories';
    yield serializers.serialize(
      object.calories,
      specifiedType: const FullType(double),
    );
    yield r'carbohydrates';
    yield serializers.serialize(
      object.carbohydrates,
      specifiedType: const FullType(double),
    );
    yield r'fats';
    yield serializers.serialize(
      object.fats,
      specifiedType: const FullType(double),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'proteins';
    yield serializers.serialize(
      object.proteins,
      specifiedType: const FullType(double),
    );
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NutritionInformation object, {
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
    required NutritionInformationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'calories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.calories = valueDes;
          break;
        case r'carbohydrates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.carbohydrates = valueDes;
          break;
        case r'fats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fats = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'proteins':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.proteins = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NutritionInformation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NutritionInformationBuilder();
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

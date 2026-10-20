//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/food.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unit_conversion.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [baseAmount]
/// * [baseUnit]
/// * [convertedAmount]
/// * [convertedUnit]
/// * [food]
/// * [id]
/// * [name]
/// * [openDataSlug]
@BuiltValue()
abstract class UnitConversion
    implements Built<UnitConversion, UnitConversionBuilder> {
  @BuiltValueField(wireName: r'base_amount')
  double get baseAmount;

  @BuiltValueField(wireName: r'base_unit')
  Unit get baseUnit;

  @BuiltValueField(wireName: r'converted_amount')
  double get convertedAmount;

  @BuiltValueField(wireName: r'converted_unit')
  Unit get convertedUnit;

  @BuiltValueField(wireName: r'food')
  Food? get food;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'open_data_slug')
  String? get openDataSlug;

  UnitConversion._();

  factory UnitConversion([void updates(UnitConversionBuilder b)]) =
      _$UnitConversion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnitConversionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnitConversion> get serializer =>
      _$UnitConversionSerializer();
}

class _$UnitConversionSerializer
    implements PrimitiveSerializer<UnitConversion> {
  @override
  final Iterable<Type> types = const [UnitConversion, _$UnitConversion];

  @override
  final String wireName = r'UnitConversion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnitConversion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base_amount';
    yield serializers.serialize(
      object.baseAmount,
      specifiedType: const FullType(double),
    );
    yield r'base_unit';
    yield serializers.serialize(
      object.baseUnit,
      specifiedType: const FullType(Unit),
    );
    yield r'converted_amount';
    yield serializers.serialize(
      object.convertedAmount,
      specifiedType: const FullType(double),
    );
    yield r'converted_unit';
    yield serializers.serialize(
      object.convertedUnit,
      specifiedType: const FullType(Unit),
    );
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.openDataSlug != null) {
      yield r'open_data_slug';
      yield serializers.serialize(
        object.openDataSlug,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UnitConversion object, {
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
    required UnitConversionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'base_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.baseAmount = valueDes;
          break;
        case r'base_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Unit),
          ) as Unit;
          result.baseUnit.replace(valueDes);
          break;
        case r'converted_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.convertedAmount = valueDes;
          break;
        case r'converted_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Unit),
          ) as Unit;
          result.convertedUnit.replace(valueDes);
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'open_data_slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.openDataSlug = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnitConversion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnitConversionBuilder();
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

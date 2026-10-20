//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/source_import_unit.dart';
import 'package:tandoor_api/src/model/source_import_food.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_ingredient.g.dart';

/// SourceImportIngredient
///
/// Properties:
/// * [amount]
/// * [food]
/// * [note]
/// * [order]
/// * [originalText]
/// * [unit]
@BuiltValue()
abstract class SourceImportIngredient
    implements Built<SourceImportIngredient, SourceImportIngredientBuilder> {
  @BuiltValueField(wireName: r'amount')
  double get amount;

  @BuiltValueField(wireName: r'food')
  SourceImportFood get food;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'original_text')
  String get originalText;

  @BuiltValueField(wireName: r'unit')
  SourceImportUnit get unit;

  SourceImportIngredient._();

  factory SourceImportIngredient([
    void updates(SourceImportIngredientBuilder b),
  ]) = _$SourceImportIngredient;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportIngredientBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportIngredient> get serializer =>
      _$SourceImportIngredientSerializer();
}

class _$SourceImportIngredientSerializer
    implements PrimitiveSerializer<SourceImportIngredient> {
  @override
  final Iterable<Type> types = const [
    SourceImportIngredient,
    _$SourceImportIngredient,
  ];

  @override
  final String wireName = r'SourceImportIngredient';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportIngredient object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(double),
    );
    yield r'food';
    yield serializers.serialize(
      object.food,
      specifiedType: const FullType(SourceImportFood),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'original_text';
    yield serializers.serialize(
      object.originalText,
      specifiedType: const FullType(String),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(SourceImportUnit),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportIngredient object, {
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
    required SourceImportIngredientBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.amount = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SourceImportFood),
          ) as SourceImportFood;
          result.food.replace(valueDes);
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
            specifiedType: const FullType(String),
          ) as String;
          result.originalText = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SourceImportUnit),
          ) as SourceImportUnit;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SourceImportIngredient deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportIngredientBuilder();
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

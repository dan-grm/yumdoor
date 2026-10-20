//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/supermarket_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supermarket_category_relation.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [category]
/// * [id]
/// * [order]
/// * [supermarket]
@BuiltValue()
abstract class SupermarketCategoryRelation
    implements
        Built<SupermarketCategoryRelation, SupermarketCategoryRelationBuilder> {
  @BuiltValueField(wireName: r'category')
  SupermarketCategory get category;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'supermarket')
  int get supermarket;

  SupermarketCategoryRelation._();

  factory SupermarketCategoryRelation([
    void updates(SupermarketCategoryRelationBuilder b),
  ]) = _$SupermarketCategoryRelation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupermarketCategoryRelationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupermarketCategoryRelation> get serializer =>
      _$SupermarketCategoryRelationSerializer();
}

class _$SupermarketCategoryRelationSerializer
    implements PrimitiveSerializer<SupermarketCategoryRelation> {
  @override
  final Iterable<Type> types = const [
    SupermarketCategoryRelation,
    _$SupermarketCategoryRelation,
  ];

  @override
  final String wireName = r'SupermarketCategoryRelation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupermarketCategoryRelation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SupermarketCategory),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(int),
      );
    }
    yield r'supermarket';
    yield serializers.serialize(
      object.supermarket,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupermarketCategoryRelation object, {
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
    required SupermarketCategoryRelationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupermarketCategory),
          ) as SupermarketCategory;
          result.category.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'supermarket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.supermarket = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupermarketCategoryRelation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupermarketCategoryRelationBuilder();
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

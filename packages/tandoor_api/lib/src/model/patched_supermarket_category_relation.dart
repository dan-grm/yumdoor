//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/supermarket_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_supermarket_category_relation.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [category]
/// * [id]
/// * [order]
/// * [supermarket]
@BuiltValue()
abstract class PatchedSupermarketCategoryRelation
    implements
        Built<
          PatchedSupermarketCategoryRelation,
          PatchedSupermarketCategoryRelationBuilder
        > {
  @BuiltValueField(wireName: r'category')
  SupermarketCategory? get category;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'supermarket')
  int? get supermarket;

  PatchedSupermarketCategoryRelation._();

  factory PatchedSupermarketCategoryRelation([
    void updates(PatchedSupermarketCategoryRelationBuilder b),
  ]) = _$PatchedSupermarketCategoryRelation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedSupermarketCategoryRelationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedSupermarketCategoryRelation> get serializer =>
      _$PatchedSupermarketCategoryRelationSerializer();
}

class _$PatchedSupermarketCategoryRelationSerializer
    implements PrimitiveSerializer<PatchedSupermarketCategoryRelation> {
  @override
  final Iterable<Type> types = const [
    PatchedSupermarketCategoryRelation,
    _$PatchedSupermarketCategoryRelation,
  ];

  @override
  final String wireName = r'PatchedSupermarketCategoryRelation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedSupermarketCategoryRelation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(SupermarketCategory),
      );
    }
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
    if (object.supermarket != null) {
      yield r'supermarket';
      yield serializers.serialize(
        object.supermarket,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedSupermarketCategoryRelation object, {
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
    required PatchedSupermarketCategoryRelationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SupermarketCategory),
          ) as SupermarketCategory?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  PatchedSupermarketCategoryRelation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedSupermarketCategoryRelationBuilder();
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

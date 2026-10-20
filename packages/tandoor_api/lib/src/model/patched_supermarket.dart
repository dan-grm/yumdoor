//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/supermarket_category_relation.dart';
import 'package:tandoor_api/src/model/shopping_list.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_supermarket.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [categoryToSupermarket]
/// * [description]
/// * [id]
/// * [name]
/// * [openDataSlug]
/// * [shoppingLists]
@BuiltValue()
abstract class PatchedSupermarket
    implements Built<PatchedSupermarket, PatchedSupermarketBuilder> {
  @BuiltValueField(wireName: r'category_to_supermarket')
  BuiltList<SupermarketCategoryRelation>? get categoryToSupermarket;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'open_data_slug')
  String? get openDataSlug;

  @BuiltValueField(wireName: r'shopping_lists')
  BuiltList<ShoppingList>? get shoppingLists;

  PatchedSupermarket._();

  factory PatchedSupermarket([void updates(PatchedSupermarketBuilder b)]) =
      _$PatchedSupermarket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedSupermarketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedSupermarket> get serializer =>
      _$PatchedSupermarketSerializer();
}

class _$PatchedSupermarketSerializer
    implements PrimitiveSerializer<PatchedSupermarket> {
  @override
  final Iterable<Type> types = const [PatchedSupermarket, _$PatchedSupermarket];

  @override
  final String wireName = r'PatchedSupermarket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedSupermarket object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryToSupermarket != null) {
      yield r'category_to_supermarket';
      yield serializers.serialize(
        object.categoryToSupermarket,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SupermarketCategoryRelation),
        ]),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
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
        specifiedType: const FullType(String),
      );
    }
    if (object.openDataSlug != null) {
      yield r'open_data_slug';
      yield serializers.serialize(
        object.openDataSlug,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.shoppingLists != null) {
      yield r'shopping_lists';
      yield serializers.serialize(
        object.shoppingLists,
        specifiedType: const FullType(BuiltList, [FullType(ShoppingList)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedSupermarket object, {
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
    required PatchedSupermarketBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category_to_supermarket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SupermarketCategoryRelation),
            ]),
          ) as BuiltList<SupermarketCategoryRelation>?;
          if (valueDes == null) continue;
          result.categoryToSupermarket.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
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
        case r'shopping_lists':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(ShoppingList),
            ]),
          ) as BuiltList<ShoppingList>?;
          if (valueDes == null) continue;
          result.shoppingLists.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedSupermarket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedSupermarketBuilder();
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

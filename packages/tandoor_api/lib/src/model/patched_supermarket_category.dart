//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_supermarket_category.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [description]
/// * [id]
/// * [name]
/// * [openDataSlug]
@BuiltValue()
abstract class PatchedSupermarketCategory
    implements
        Built<PatchedSupermarketCategory, PatchedSupermarketCategoryBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'open_data_slug')
  String? get openDataSlug;

  PatchedSupermarketCategory._();

  factory PatchedSupermarketCategory([
    void updates(PatchedSupermarketCategoryBuilder b),
  ]) = _$PatchedSupermarketCategory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedSupermarketCategoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedSupermarketCategory> get serializer =>
      _$PatchedSupermarketCategorySerializer();
}

class _$PatchedSupermarketCategorySerializer
    implements PrimitiveSerializer<PatchedSupermarketCategory> {
  @override
  final Iterable<Type> types = const [
    PatchedSupermarketCategory,
    _$PatchedSupermarketCategory,
  ];

  @override
  final String wireName = r'PatchedSupermarketCategory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedSupermarketCategory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedSupermarketCategory object, {
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
    required PatchedSupermarketCategoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedSupermarketCategory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedSupermarketCategoryBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/property_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_property.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [id]
/// * [propertyAmount]
/// * [propertyType]
@BuiltValue()
abstract class PatchedProperty
    implements Built<PatchedProperty, PatchedPropertyBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'property_amount')
  double? get propertyAmount;

  @BuiltValueField(wireName: r'property_type')
  PropertyType? get propertyType;

  PatchedProperty._();

  factory PatchedProperty([void updates(PatchedPropertyBuilder b)]) =
      _$PatchedProperty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedPropertyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedProperty> get serializer =>
      _$PatchedPropertySerializer();
}

class _$PatchedPropertySerializer
    implements PrimitiveSerializer<PatchedProperty> {
  @override
  final Iterable<Type> types = const [PatchedProperty, _$PatchedProperty];

  @override
  final String wireName = r'PatchedProperty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedProperty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.propertyAmount != null) {
      yield r'property_amount';
      yield serializers.serialize(
        object.propertyAmount,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.propertyType != null) {
      yield r'property_type';
      yield serializers.serialize(
        object.propertyType,
        specifiedType: const FullType(PropertyType),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedProperty object, {
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
    required PatchedPropertyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'property_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.propertyAmount = valueDes;
          break;
        case r'property_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PropertyType),
          ) as PropertyType?;
          if (valueDes == null) continue;
          result.propertyType.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedProperty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedPropertyBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/property_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'property.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [id]
/// * [propertyAmount]
/// * [propertyType]
@BuiltValue()
abstract class Property implements Built<Property, PropertyBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'property_amount')
  double? get propertyAmount;

  @BuiltValueField(wireName: r'property_type')
  PropertyType get propertyType;

  Property._();

  factory Property([void updates(PropertyBuilder b)]) = _$Property;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PropertyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Property> get serializer => _$PropertySerializer();
}

class _$PropertySerializer implements PrimitiveSerializer<Property> {
  @override
  final Iterable<Type> types = const [Property, _$Property];

  @override
  final String wireName = r'Property';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Property object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'property_amount';
    yield object.propertyAmount == null
        ? null
        : serializers.serialize(
            object.propertyAmount,
            specifiedType: const FullType.nullable(double),
          );
    yield r'property_type';
    yield serializers.serialize(
      object.propertyType,
      specifiedType: const FullType(PropertyType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Property object, {
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
    required PropertyBuilder result,
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
            specifiedType: const FullType(PropertyType),
          ) as PropertyType;
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
  Property deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PropertyBuilder();
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

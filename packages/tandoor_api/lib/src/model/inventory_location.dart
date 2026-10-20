//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/household.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_location.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [household]
/// * [id]
/// * [isFreezer]
/// * [name]
@BuiltValue()
abstract class InventoryLocation
    implements Built<InventoryLocation, InventoryLocationBuilder> {
  @BuiltValueField(wireName: r'household')
  Household get household;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'is_freezer')
  bool? get isFreezer;

  @BuiltValueField(wireName: r'name')
  String get name;

  InventoryLocation._();

  factory InventoryLocation([void updates(InventoryLocationBuilder b)]) =
      _$InventoryLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLocation> get serializer =>
      _$InventoryLocationSerializer();
}

class _$InventoryLocationSerializer
    implements PrimitiveSerializer<InventoryLocation> {
  @override
  final Iterable<Type> types = const [InventoryLocation, _$InventoryLocation];

  @override
  final String wireName = r'InventoryLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'household';
    yield serializers.serialize(
      object.household,
      specifiedType: const FullType(Household),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.isFreezer != null) {
      yield r'is_freezer';
      yield serializers.serialize(
        object.isFreezer,
        specifiedType: const FullType(bool),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLocation object, {
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
    required InventoryLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'household':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Household),
          ) as Household;
          result.household.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'is_freezer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFreezer = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLocationBuilder();
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

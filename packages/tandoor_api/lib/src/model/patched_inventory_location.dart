//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/household.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_inventory_location.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [household]
/// * [id]
/// * [isFreezer]
/// * [name]
@BuiltValue()
abstract class PatchedInventoryLocation
    implements
        Built<PatchedInventoryLocation, PatchedInventoryLocationBuilder> {
  @BuiltValueField(wireName: r'household')
  Household? get household;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'is_freezer')
  bool? get isFreezer;

  @BuiltValueField(wireName: r'name')
  String? get name;

  PatchedInventoryLocation._();

  factory PatchedInventoryLocation([
    void updates(PatchedInventoryLocationBuilder b),
  ]) = _$PatchedInventoryLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedInventoryLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedInventoryLocation> get serializer =>
      _$PatchedInventoryLocationSerializer();
}

class _$PatchedInventoryLocationSerializer
    implements PrimitiveSerializer<PatchedInventoryLocation> {
  @override
  final Iterable<Type> types = const [
    PatchedInventoryLocation,
    _$PatchedInventoryLocation,
  ];

  @override
  final String wireName = r'PatchedInventoryLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedInventoryLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.household != null) {
      yield r'household';
      yield serializers.serialize(
        object.household,
        specifiedType: const FullType(Household),
      );
    }
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedInventoryLocation object, {
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
    required PatchedInventoryLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'household':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Household),
          ) as Household?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  PatchedInventoryLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedInventoryLocationBuilder();
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

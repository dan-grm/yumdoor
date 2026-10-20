//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group.g.dart';

/// Moves `UniqueValidator`'s from the validation stage to the save stage. It solves the problem with nested validation for unique fields on update.  If you want more details, you can read related issues and articles: https://github.com/beda-software/drf-writable-nested/issues/1 http://www.django-rest-framework.org/api-guide/validators/#updating-nested-serializers  Example of usage: ```     class Child(models.Model):     field = models.CharField(unique=True)   class Parent(models.Model):     child = models.ForeignKey('Child')   class ChildSerializer(UniqueFieldsMixin, serializers.ModelSerializer):     class Meta:         model = Child   class ParentSerializer(NestedUpdateMixin, serializers.ModelSerializer):     child = ChildSerializer()      class Meta:         model = Parent ```  Note: `UniqueFieldsMixin` must be applied only on the serializer which has unique fields.  Note: When you are using both mixins (`UniqueFieldsMixin` and `NestedCreateMixin` or `NestedUpdateMixin`) you should put `UniqueFieldsMixin` ahead.
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class Group implements Built<Group, GroupBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  Group._();

  factory Group([void updates(GroupBuilder b)]) = _$Group;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Group> get serializer => _$GroupSerializer();
}

class _$GroupSerializer implements PrimitiveSerializer<Group> {
  @override
  final Iterable<Type> types = const [Group, _$Group];

  @override
  final String wireName = r'Group';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Group object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    Group object, {
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
    required GroupBuilder result,
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
  Group deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupBuilder();
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

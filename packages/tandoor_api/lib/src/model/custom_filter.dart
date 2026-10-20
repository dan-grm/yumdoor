//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custom_filter.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdBy]
/// * [id]
/// * [name]
/// * [search]
/// * [shared]
@BuiltValue()
abstract class CustomFilter
    implements Built<CustomFilter, CustomFilterBuilder> {
  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'search')
  String get search;

  @BuiltValueField(wireName: r'shared')
  BuiltList<User>? get shared;

  CustomFilter._();

  factory CustomFilter([void updates(CustomFilterBuilder b)]) = _$CustomFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomFilter> get serializer => _$CustomFilterSerializer();
}

class _$CustomFilterSerializer implements PrimitiveSerializer<CustomFilter> {
  @override
  final Iterable<Type> types = const [CustomFilter, _$CustomFilter];

  @override
  final String wireName = r'CustomFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomFilter object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'search';
    yield serializers.serialize(
      object.search,
      specifiedType: const FullType(String),
    );
    if (object.shared != null) {
      yield r'shared';
      yield serializers.serialize(
        object.shared,
        specifiedType: const FullType(BuiltList, [FullType(User)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomFilter object, {
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
    required CustomFilterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
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
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.search = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(User)]),
          ) as BuiltList<User>?;
          if (valueDes == null) continue;
          result.shared.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomFilterBuilder();
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

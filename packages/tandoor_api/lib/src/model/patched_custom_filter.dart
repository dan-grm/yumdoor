//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_custom_filter.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdBy]
/// * [id]
/// * [name]
/// * [search]
/// * [shared]
@BuiltValue()
abstract class PatchedCustomFilter
    implements Built<PatchedCustomFilter, PatchedCustomFilterBuilder> {
  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'search')
  String? get search;

  @BuiltValueField(wireName: r'shared')
  BuiltList<User>? get shared;

  PatchedCustomFilter._();

  factory PatchedCustomFilter([void updates(PatchedCustomFilterBuilder b)]) =
      _$PatchedCustomFilter;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedCustomFilterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedCustomFilter> get serializer =>
      _$PatchedCustomFilterSerializer();
}

class _$PatchedCustomFilterSerializer
    implements PrimitiveSerializer<PatchedCustomFilter> {
  @override
  final Iterable<Type> types = const [
    PatchedCustomFilter,
    _$PatchedCustomFilter,
  ];

  @override
  final String wireName = r'PatchedCustomFilter';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedCustomFilter object, {
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.search != null) {
      yield r'search';
      yield serializers.serialize(
        object.search,
        specifiedType: const FullType(String),
      );
    }
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
    PatchedCustomFilter object, {
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
    required PatchedCustomFilterBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  PatchedCustomFilter deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedCustomFilterBuilder();
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

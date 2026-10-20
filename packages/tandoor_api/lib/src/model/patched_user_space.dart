//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/household.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/group.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_user_space.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [active]
/// * [createdAt]
/// * [groups]
/// * [household]
/// * [id]
/// * [internalNote]
/// * [inviteLink]
/// * [space]
/// * [updatedAt]
/// * [user]
@BuiltValue()
abstract class PatchedUserSpace
    implements Built<PatchedUserSpace, PatchedUserSpaceBuilder> {
  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'groups')
  BuiltList<Group>? get groups;

  @BuiltValueField(wireName: r'household')
  Household? get household;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'internal_note')
  String? get internalNote;

  @BuiltValueField(wireName: r'invite_link')
  int? get inviteLink;

  @BuiltValueField(wireName: r'space')
  int? get space;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'user')
  User? get user;

  PatchedUserSpace._();

  factory PatchedUserSpace([void updates(PatchedUserSpaceBuilder b)]) =
      _$PatchedUserSpace;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedUserSpaceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedUserSpace> get serializer =>
      _$PatchedUserSpaceSerializer();
}

class _$PatchedUserSpaceSerializer
    implements PrimitiveSerializer<PatchedUserSpace> {
  @override
  final Iterable<Type> types = const [PatchedUserSpace, _$PatchedUserSpace];

  @override
  final String wireName = r'PatchedUserSpace';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedUserSpace object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.groups != null) {
      yield r'groups';
      yield serializers.serialize(
        object.groups,
        specifiedType: const FullType(BuiltList, [FullType(Group)]),
      );
    }
    if (object.household != null) {
      yield r'household';
      yield serializers.serialize(
        object.household,
        specifiedType: const FullType.nullable(Household),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.internalNote != null) {
      yield r'internal_note';
      yield serializers.serialize(
        object.internalNote,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.inviteLink != null) {
      yield r'invite_link';
      yield serializers.serialize(
        object.inviteLink,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.space != null) {
      yield r'space';
      yield serializers.serialize(
        object.space,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType.nullable(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedUserSpace object, {
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
    required PatchedUserSpaceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.active = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(Group),
            ]),
          ) as BuiltList<Group>?;
          if (valueDes == null) continue;
          result.groups.replace(valueDes);
          break;
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
        case r'internal_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.internalNote = valueDes;
          break;
        case r'invite_link':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inviteLink = valueDes;
          break;
        case r'space':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.space = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedUserSpace deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedUserSpaceBuilder();
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

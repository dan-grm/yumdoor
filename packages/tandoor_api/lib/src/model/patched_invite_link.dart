//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/household.dart';
import 'package:tandoor_api/src/model/date.dart';
import 'package:tandoor_api/src/model/invite_link_email.dart';
import 'package:tandoor_api/src/model/group.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_invite_link.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [email]
/// * [emailSent] - Return whether the invite email was successfully sent.
/// * [group]
/// * [household]
/// * [id]
/// * [internalNote]
/// * [reusable]
/// * [usedBy]
/// * [uuid]
/// * [validUntil]
@BuiltValue()
abstract class PatchedInviteLink
    implements Built<PatchedInviteLink, PatchedInviteLinkBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'email')
  InviteLinkEmail? get email;

  /// Return whether the invite email was successfully sent.
  @BuiltValueField(wireName: r'email_sent')
  bool? get emailSent;

  @BuiltValueField(wireName: r'group')
  Group? get group;

  @BuiltValueField(wireName: r'household')
  Household? get household;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'internal_note')
  String? get internalNote;

  @BuiltValueField(wireName: r'reusable')
  bool? get reusable;

  @BuiltValueField(wireName: r'used_by')
  int? get usedBy;

  @BuiltValueField(wireName: r'uuid')
  String? get uuid;

  @BuiltValueField(wireName: r'valid_until')
  Date? get validUntil;

  PatchedInviteLink._();

  factory PatchedInviteLink([void updates(PatchedInviteLinkBuilder b)]) =
      _$PatchedInviteLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedInviteLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedInviteLink> get serializer =>
      _$PatchedInviteLinkSerializer();
}

class _$PatchedInviteLinkSerializer
    implements PrimitiveSerializer<PatchedInviteLink> {
  @override
  final Iterable<Type> types = const [PatchedInviteLink, _$PatchedInviteLink];

  @override
  final String wireName = r'PatchedInviteLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedInviteLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(InviteLinkEmail),
      );
    }
    if (object.emailSent != null) {
      yield r'email_sent';
      yield serializers.serialize(
        object.emailSent,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.group != null) {
      yield r'group';
      yield serializers.serialize(
        object.group,
        specifiedType: const FullType(Group),
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
    if (object.reusable != null) {
      yield r'reusable';
      yield serializers.serialize(
        object.reusable,
        specifiedType: const FullType(bool),
      );
    }
    if (object.usedBy != null) {
      yield r'used_by';
      yield serializers.serialize(
        object.usedBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.uuid != null) {
      yield r'uuid';
      yield serializers.serialize(
        object.uuid,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.validUntil != null) {
      yield r'valid_until';
      yield serializers.serialize(
        object.validUntil,
        specifiedType: const FullType(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedInviteLink object, {
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
    required PatchedInviteLinkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InviteLinkEmail),
          ) as InviteLinkEmail?;
          if (valueDes == null) continue;
          result.email.replace(valueDes);
          break;
        case r'email_sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.emailSent = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Group),
          ) as Group?;
          if (valueDes == null) continue;
          result.group.replace(valueDes);
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
        case r'reusable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.reusable = valueDes;
          break;
        case r'used_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.usedBy = valueDes;
          break;
        case r'uuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.uuid = valueDes;
          break;
        case r'valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedInviteLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedInviteLinkBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_user.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [displayName]
/// * [firstName]
/// * [id]
/// * [isActive] - Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
/// * [isStaff] - Designates whether the user can log into this admin site.
/// * [isSuperuser] - Designates that this user has all permissions without explicitly assigning them.
/// * [lastName]
/// * [username] - Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
@BuiltValue()
abstract class PatchedUser implements Built<PatchedUser, PatchedUserBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'first_name')
  String? get firstName;

  @BuiltValueField(wireName: r'id')
  int? get id;

  /// Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  /// Designates whether the user can log into this admin site.
  @BuiltValueField(wireName: r'is_staff')
  bool? get isStaff;

  /// Designates that this user has all permissions without explicitly assigning them.
  @BuiltValueField(wireName: r'is_superuser')
  bool? get isSuperuser;

  @BuiltValueField(wireName: r'last_name')
  String? get lastName;

  /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
  @BuiltValueField(wireName: r'username')
  String? get username;

  PatchedUser._();

  factory PatchedUser([void updates(PatchedUserBuilder b)]) = _$PatchedUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedUser> get serializer => _$PatchedUserSerializer();
}

class _$PatchedUserSerializer implements PrimitiveSerializer<PatchedUser> {
  @override
  final Iterable<Type> types = const [PatchedUser, _$PatchedUser];

  @override
  final String wireName = r'PatchedUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.firstName != null) {
      yield r'first_name';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.isStaff != null) {
      yield r'is_staff';
      yield serializers.serialize(
        object.isStaff,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.isSuperuser != null) {
      yield r'is_superuser';
      yield serializers.serialize(
        object.isSuperuser,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.lastName != null) {
      yield r'last_name';
      yield serializers.serialize(
        object.lastName,
        specifiedType: const FullType(String),
      );
    }
    if (object.username != null) {
      yield r'username';
      yield serializers.serialize(
        object.username,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedUser object, {
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
    required PatchedUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'first_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.firstName = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        case r'is_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isStaff = valueDes;
          break;
        case r'is_superuser':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isSuperuser = valueDes;
          break;
        case r'last_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastName = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.username = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedUserBuilder();
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

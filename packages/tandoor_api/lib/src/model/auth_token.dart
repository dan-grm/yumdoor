//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_token.g.dart';

/// AuthToken
///
/// Properties:
/// * [password]
/// * [token]
/// * [username]
@BuiltValue()
abstract class AuthToken implements Built<AuthToken, AuthTokenBuilder> {
  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'token')
  String? get token;

  @BuiltValueField(wireName: r'username')
  String get username;

  AuthToken._();

  factory AuthToken([void updates(AuthTokenBuilder b)]) = _$AuthToken;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthTokenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthToken> get serializer => _$AuthTokenSerializer();
}

class _$AuthTokenSerializer implements PrimitiveSerializer<AuthToken> {
  @override
  final Iterable<Type> types = const [AuthToken, _$AuthToken];

  @override
  final String wireName = r'AuthToken';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthToken object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    if (object.token != null) {
      yield r'token';
      yield serializers.serialize(
        object.token,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthToken object, {
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
    required AuthTokenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.token = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AuthToken deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthTokenBuilder();
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

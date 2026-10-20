//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_space_batch_update.g.dart';

/// UserSpaceBatchUpdate
///
/// Properties:
/// * [groupSet]
/// * [household]
/// * [userSpaces]
@BuiltValue()
abstract class UserSpaceBatchUpdate
    implements Built<UserSpaceBatchUpdate, UserSpaceBatchUpdateBuilder> {
  @BuiltValueField(wireName: r'group_set')
  BuiltList<int> get groupSet;

  @BuiltValueField(wireName: r'household')
  int? get household;

  @BuiltValueField(wireName: r'user_spaces')
  BuiltList<int> get userSpaces;

  UserSpaceBatchUpdate._();

  factory UserSpaceBatchUpdate([void updates(UserSpaceBatchUpdateBuilder b)]) =
      _$UserSpaceBatchUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserSpaceBatchUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserSpaceBatchUpdate> get serializer =>
      _$UserSpaceBatchUpdateSerializer();
}

class _$UserSpaceBatchUpdateSerializer
    implements PrimitiveSerializer<UserSpaceBatchUpdate> {
  @override
  final Iterable<Type> types = const [
    UserSpaceBatchUpdate,
    _$UserSpaceBatchUpdate,
  ];

  @override
  final String wireName = r'UserSpaceBatchUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserSpaceBatchUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group_set';
    yield serializers.serialize(
      object.groupSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.household != null) {
      yield r'household';
      yield serializers.serialize(
        object.household,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'user_spaces';
    yield serializers.serialize(
      object.userSpaces,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserSpaceBatchUpdate object, {
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
    required UserSpaceBatchUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.groupSet.replace(valueDes);
          break;
        case r'household':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.household = valueDes;
          break;
        case r'user_spaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.userSpaces.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserSpaceBatchUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserSpaceBatchUpdateBuilder();
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

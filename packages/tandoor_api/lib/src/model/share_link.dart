//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'share_link.g.dart';

/// ShareLink
///
/// Properties:
/// * [link]
/// * [pk]
/// * [share]
@BuiltValue()
abstract class ShareLink implements Built<ShareLink, ShareLinkBuilder> {
  @BuiltValueField(wireName: r'link')
  String get link;

  @BuiltValueField(wireName: r'pk')
  int get pk;

  @BuiltValueField(wireName: r'share')
  String get share;

  ShareLink._();

  factory ShareLink([void updates(ShareLinkBuilder b)]) = _$ShareLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShareLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShareLink> get serializer => _$ShareLinkSerializer();
}

class _$ShareLinkSerializer implements PrimitiveSerializer<ShareLink> {
  @override
  final Iterable<Type> types = const [ShareLink, _$ShareLink];

  @override
  final String wireName = r'ShareLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShareLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'link';
    yield serializers.serialize(
      object.link,
      specifiedType: const FullType(String),
    );
    yield r'pk';
    yield serializers.serialize(object.pk, specifiedType: const FullType(int));
    yield r'share';
    yield serializers.serialize(
      object.share,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ShareLink object, {
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
    required ShareLinkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'link':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.link = valueDes;
          break;
        case r'pk':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pk = valueDes;
          break;
        case r'share':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.share = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ShareLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShareLinkBuilder();
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

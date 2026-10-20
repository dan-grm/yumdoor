//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_image.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [image]
/// * [imageUrl]
@BuiltValue()
abstract class RecipeImage implements Built<RecipeImage, RecipeImageBuilder> {
  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'image_url')
  String? get imageUrl;

  RecipeImage._();

  factory RecipeImage([void updates(RecipeImageBuilder b)]) = _$RecipeImage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeImageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeImage> get serializer => _$RecipeImageSerializer();
}

class _$RecipeImageSerializer implements PrimitiveSerializer<RecipeImage> {
  @override
  final Iterable<Type> types = const [RecipeImage, _$RecipeImage];

  @override
  final String wireName = r'RecipeImage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeImage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.imageUrl != null) {
      yield r'image_url';
      yield serializers.serialize(
        object.imageUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeImage object, {
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
    required RecipeImageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.image = valueDes;
          break;
        case r'image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeImage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeImageBuilder();
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

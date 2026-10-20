//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_from_source.g.dart';

/// RecipeFromSource
///
/// Properties:
/// * [bookmarklet]
/// * [data]
/// * [url]
@BuiltValue()
abstract class RecipeFromSource
    implements Built<RecipeFromSource, RecipeFromSourceBuilder> {
  @BuiltValueField(wireName: r'bookmarklet')
  int? get bookmarklet;

  @BuiltValueField(wireName: r'data')
  String? get data;

  @BuiltValueField(wireName: r'url')
  String? get url;

  RecipeFromSource._();

  factory RecipeFromSource([void updates(RecipeFromSourceBuilder b)]) =
      _$RecipeFromSource;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeFromSourceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeFromSource> get serializer =>
      _$RecipeFromSourceSerializer();
}

class _$RecipeFromSourceSerializer
    implements PrimitiveSerializer<RecipeFromSource> {
  @override
  final Iterable<Type> types = const [RecipeFromSource, _$RecipeFromSource];

  @override
  final String wireName = r'RecipeFromSource';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeFromSource object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bookmarklet != null) {
      yield r'bookmarklet';
      yield serializers.serialize(
        object.bookmarklet,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeFromSource object, {
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
    required RecipeFromSourceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookmarklet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.bookmarklet = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.data = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeFromSource deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeFromSourceBuilder();
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

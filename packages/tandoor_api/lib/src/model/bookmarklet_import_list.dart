//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bookmarklet_import_list.g.dart';

/// BookmarkletImportList
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [id]
/// * [url]
@BuiltValue()
abstract class BookmarkletImportList
    implements Built<BookmarkletImportList, BookmarkletImportListBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'url')
  String? get url;

  BookmarkletImportList._();

  factory BookmarkletImportList([
    void updates(BookmarkletImportListBuilder b),
  ]) = _$BookmarkletImportList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookmarkletImportListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookmarkletImportList> get serializer =>
      _$BookmarkletImportListSerializer();
}

class _$BookmarkletImportListSerializer
    implements PrimitiveSerializer<BookmarkletImportList> {
  @override
  final Iterable<Type> types = const [
    BookmarkletImportList,
    _$BookmarkletImportList,
  ];

  @override
  final String wireName = r'BookmarkletImportList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookmarkletImportList object, {
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
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
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
    BookmarkletImportList object, {
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
    required BookmarkletImportListBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
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
  BookmarkletImportList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookmarkletImportListBuilder();
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

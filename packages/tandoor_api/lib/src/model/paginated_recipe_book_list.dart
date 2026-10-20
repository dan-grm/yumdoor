//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/recipe_book.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paginated_recipe_book_list.g.dart';

/// PaginatedRecipeBookList
///
/// Properties:
/// * [count]
/// * [next]
/// * [previous]
/// * [results]
/// * [timestamp]
@BuiltValue()
abstract class PaginatedRecipeBookList
    implements Built<PaginatedRecipeBookList, PaginatedRecipeBookListBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'previous')
  String? get previous;

  @BuiltValueField(wireName: r'results')
  BuiltList<RecipeBook> get results;

  @BuiltValueField(wireName: r'timestamp')
  DateTime? get timestamp;

  PaginatedRecipeBookList._();

  factory PaginatedRecipeBookList([
    void updates(PaginatedRecipeBookListBuilder b),
  ]) = _$PaginatedRecipeBookList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaginatedRecipeBookListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaginatedRecipeBookList> get serializer =>
      _$PaginatedRecipeBookListSerializer();
}

class _$PaginatedRecipeBookListSerializer
    implements PrimitiveSerializer<PaginatedRecipeBookList> {
  @override
  final Iterable<Type> types = const [
    PaginatedRecipeBookList,
    _$PaginatedRecipeBookList,
  ];

  @override
  final String wireName = r'PaginatedRecipeBookList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaginatedRecipeBookList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.previous != null) {
      yield r'previous';
      yield serializers.serialize(
        object.previous,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'results';
    yield serializers.serialize(
      object.results,
      specifiedType: const FullType(BuiltList, [FullType(RecipeBook)]),
    );
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaginatedRecipeBookList object, {
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
    required PaginatedRecipeBookListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.previous = valueDes;
          break;
        case r'results':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecipeBook)]),
          ) as BuiltList<RecipeBook>;
          result.results.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaginatedRecipeBookList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaginatedRecipeBookListBuilder();
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

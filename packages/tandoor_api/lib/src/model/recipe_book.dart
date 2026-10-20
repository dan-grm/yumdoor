//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/custom_filter.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_book.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdBy]
/// * [description]
/// * [filter]
/// * [id]
/// * [name]
/// * [order]
/// * [shared]
@BuiltValue()
abstract class RecipeBook implements Built<RecipeBook, RecipeBookBuilder> {
  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'filter')
  CustomFilter? get filter;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'order')
  int? get order;

  @BuiltValueField(wireName: r'shared')
  BuiltList<User> get shared;

  RecipeBook._();

  factory RecipeBook([void updates(RecipeBookBuilder b)]) = _$RecipeBook;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeBookBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeBook> get serializer => _$RecipeBookSerializer();
}

class _$RecipeBookSerializer implements PrimitiveSerializer<RecipeBook> {
  @override
  final Iterable<Type> types = const [RecipeBook, _$RecipeBook];

  @override
  final String wireName = r'RecipeBook';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeBook object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.filter != null) {
      yield r'filter';
      yield serializers.serialize(
        object.filter,
        specifiedType: const FullType.nullable(CustomFilter),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.order != null) {
      yield r'order';
      yield serializers.serialize(
        object.order,
        specifiedType: const FullType(int),
      );
    }
    yield r'shared';
    yield serializers.serialize(
      object.shared,
      specifiedType: const FullType(BuiltList, [FullType(User)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeBook object, {
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
    required RecipeBookBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.createdBy.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'filter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomFilter),
          ) as CustomFilter?;
          if (valueDes == null) continue;
          result.filter.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.order = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(User)]),
          ) as BuiltList<User>;
          result.shared.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeBook deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeBookBuilder();
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

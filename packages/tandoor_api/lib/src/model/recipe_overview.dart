//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/keyword_label.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_overview.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [id]
/// * [image]
/// * [internal]
/// * [keywords]
/// * [lastCooked]
/// * [name]
/// * [new_]
/// * [private]
/// * [rating]
/// * [recent]
/// * [servings]
/// * [servingsText]
/// * [updatedAt]
/// * [waitingTime]
/// * [workingTime]
@BuiltValue()
abstract class RecipeOverview
    implements Built<RecipeOverview, RecipeOverviewBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'internal')
  bool? get internal;

  @BuiltValueField(wireName: r'keywords')
  BuiltList<KeywordLabel>? get keywords;

  @BuiltValueField(wireName: r'last_cooked')
  DateTime? get lastCooked;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'new')
  bool? get new_;

  @BuiltValueField(wireName: r'private')
  bool? get private;

  @BuiltValueField(wireName: r'rating')
  double? get rating;

  @BuiltValueField(wireName: r'recent')
  String? get recent;

  @BuiltValueField(wireName: r'servings')
  int? get servings;

  @BuiltValueField(wireName: r'servings_text')
  String? get servingsText;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'waiting_time')
  int? get waitingTime;

  @BuiltValueField(wireName: r'working_time')
  int? get workingTime;

  RecipeOverview._();

  factory RecipeOverview([void updates(RecipeOverviewBuilder b)]) =
      _$RecipeOverview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeOverviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeOverview> get serializer =>
      _$RecipeOverviewSerializer();
}

class _$RecipeOverviewSerializer
    implements PrimitiveSerializer<RecipeOverview> {
  @override
  final Iterable<Type> types = const [RecipeOverview, _$RecipeOverview];

  @override
  final String wireName = r'RecipeOverview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeOverview object, {
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
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.internal != null) {
      yield r'internal';
      yield serializers.serialize(
        object.internal,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.keywords != null) {
      yield r'keywords';
      yield serializers.serialize(
        object.keywords,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(KeywordLabel),
        ]),
      );
    }
    if (object.lastCooked != null) {
      yield r'last_cooked';
      yield serializers.serialize(
        object.lastCooked,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.new_ != null) {
      yield r'new';
      yield serializers.serialize(
        object.new_,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.private != null) {
      yield r'private';
      yield serializers.serialize(
        object.private,
        specifiedType: const FullType(bool),
      );
    }
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.recent != null) {
      yield r'recent';
      yield serializers.serialize(
        object.recent,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.servings != null) {
      yield r'servings';
      yield serializers.serialize(
        object.servings,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.servingsText != null) {
      yield r'servings_text';
      yield serializers.serialize(
        object.servingsText,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.waitingTime != null) {
      yield r'waiting_time';
      yield serializers.serialize(
        object.waitingTime,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.workingTime != null) {
      yield r'working_time';
      yield serializers.serialize(
        object.workingTime,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecipeOverview object, {
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
    required RecipeOverviewBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.image = valueDes;
          break;
        case r'internal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.internal = valueDes;
          break;
        case r'keywords':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(KeywordLabel),
            ]),
          ) as BuiltList<KeywordLabel>?;
          if (valueDes == null) continue;
          result.keywords.replace(valueDes);
          break;
        case r'last_cooked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastCooked = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'new':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.new_ = valueDes;
          break;
        case r'private':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.private = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'recent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recent = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.servings = valueDes;
          break;
        case r'servings_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.servingsText = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'waiting_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.waitingTime = valueDes;
          break;
        case r'working_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.workingTime = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecipeOverview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeOverviewBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recipe_batch_update.g.dart';

/// RecipeBatchUpdate
///
/// Properties:
/// * [clearDescription]
/// * [keywordsAdd]
/// * [keywordsRemove]
/// * [keywordsRemoveAll]
/// * [keywordsSet]
/// * [private]
/// * [recipes]
/// * [servings]
/// * [servingsText]
/// * [sharedAdd]
/// * [sharedRemove]
/// * [sharedRemoveAll]
/// * [sharedSet]
/// * [showIngredientOverview]
/// * [waitingTime]
/// * [workingTime]
@BuiltValue()
abstract class RecipeBatchUpdate
    implements Built<RecipeBatchUpdate, RecipeBatchUpdateBuilder> {
  @BuiltValueField(wireName: r'clear_description')
  bool? get clearDescription;

  @BuiltValueField(wireName: r'keywords_add')
  BuiltList<int> get keywordsAdd;

  @BuiltValueField(wireName: r'keywords_remove')
  BuiltList<int> get keywordsRemove;

  @BuiltValueField(wireName: r'keywords_remove_all')
  bool? get keywordsRemoveAll;

  @BuiltValueField(wireName: r'keywords_set')
  BuiltList<int> get keywordsSet;

  @BuiltValueField(wireName: r'private')
  bool? get private;

  @BuiltValueField(wireName: r'recipes')
  BuiltList<int> get recipes;

  @BuiltValueField(wireName: r'servings')
  int? get servings;

  @BuiltValueField(wireName: r'servings_text')
  String? get servingsText;

  @BuiltValueField(wireName: r'shared_add')
  BuiltList<int> get sharedAdd;

  @BuiltValueField(wireName: r'shared_remove')
  BuiltList<int> get sharedRemove;

  @BuiltValueField(wireName: r'shared_remove_all')
  bool? get sharedRemoveAll;

  @BuiltValueField(wireName: r'shared_set')
  BuiltList<int> get sharedSet;

  @BuiltValueField(wireName: r'show_ingredient_overview')
  bool? get showIngredientOverview;

  @BuiltValueField(wireName: r'waiting_time')
  int? get waitingTime;

  @BuiltValueField(wireName: r'working_time')
  int? get workingTime;

  RecipeBatchUpdate._();

  factory RecipeBatchUpdate([void updates(RecipeBatchUpdateBuilder b)]) =
      _$RecipeBatchUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecipeBatchUpdateBuilder b) => b
    ..keywordsRemoveAll = false
    ..sharedRemoveAll = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecipeBatchUpdate> get serializer =>
      _$RecipeBatchUpdateSerializer();
}

class _$RecipeBatchUpdateSerializer
    implements PrimitiveSerializer<RecipeBatchUpdate> {
  @override
  final Iterable<Type> types = const [RecipeBatchUpdate, _$RecipeBatchUpdate];

  @override
  final String wireName = r'RecipeBatchUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecipeBatchUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clearDescription != null) {
      yield r'clear_description';
      yield serializers.serialize(
        object.clearDescription,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'keywords_add';
    yield serializers.serialize(
      object.keywordsAdd,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'keywords_remove';
    yield serializers.serialize(
      object.keywordsRemove,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.keywordsRemoveAll != null) {
      yield r'keywords_remove_all';
      yield serializers.serialize(
        object.keywordsRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    yield r'keywords_set';
    yield serializers.serialize(
      object.keywordsSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.private != null) {
      yield r'private';
      yield serializers.serialize(
        object.private,
        specifiedType: const FullType.nullable(bool),
      );
    }
    yield r'recipes';
    yield serializers.serialize(
      object.recipes,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
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
    yield r'shared_add';
    yield serializers.serialize(
      object.sharedAdd,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'shared_remove';
    yield serializers.serialize(
      object.sharedRemove,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.sharedRemoveAll != null) {
      yield r'shared_remove_all';
      yield serializers.serialize(
        object.sharedRemoveAll,
        specifiedType: const FullType(bool),
      );
    }
    yield r'shared_set';
    yield serializers.serialize(
      object.sharedSet,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    if (object.showIngredientOverview != null) {
      yield r'show_ingredient_overview';
      yield serializers.serialize(
        object.showIngredientOverview,
        specifiedType: const FullType.nullable(bool),
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
    RecipeBatchUpdate object, {
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
    required RecipeBatchUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clear_description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.clearDescription = valueDes;
          break;
        case r'keywords_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.keywordsAdd.replace(valueDes);
          break;
        case r'keywords_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.keywordsRemove.replace(valueDes);
          break;
        case r'keywords_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.keywordsRemoveAll = valueDes;
          break;
        case r'keywords_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.keywordsSet.replace(valueDes);
          break;
        case r'private':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.private = valueDes;
          break;
        case r'recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.recipes.replace(valueDes);
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
        case r'shared_add':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.sharedAdd.replace(valueDes);
          break;
        case r'shared_remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.sharedRemove.replace(valueDes);
          break;
        case r'shared_remove_all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sharedRemoveAll = valueDes;
          break;
        case r'shared_set':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.sharedSet.replace(valueDes);
          break;
        case r'show_ingredient_overview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showIngredientOverview = valueDes;
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
  RecipeBatchUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecipeBatchUpdateBuilder();
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

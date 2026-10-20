//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/source_import_step.dart';
import 'package:tandoor_api/src/model/source_import_keyword.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/source_import_property.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_recipe.g.dart';

/// SourceImportRecipe
///
/// Properties:
/// * [description]
/// * [imageUrl]
/// * [internal]
/// * [keywords]
/// * [name]
/// * [properties]
/// * [servings]
/// * [servingsText]
/// * [sourceUrl]
/// * [steps]
/// * [waitingTime]
/// * [workingTime]
@BuiltValue()
abstract class SourceImportRecipe
    implements Built<SourceImportRecipe, SourceImportRecipeBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'image_url')
  String? get imageUrl;

  @BuiltValueField(wireName: r'internal')
  bool? get internal;

  @BuiltValueField(wireName: r'keywords')
  BuiltList<SourceImportKeyword>? get keywords;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'properties')
  BuiltList<SourceImportProperty>? get properties;

  @BuiltValueField(wireName: r'servings')
  int? get servings;

  @BuiltValueField(wireName: r'servings_text')
  String? get servingsText;

  @BuiltValueField(wireName: r'source_url')
  String get sourceUrl;

  @BuiltValueField(wireName: r'steps')
  BuiltList<SourceImportStep> get steps;

  @BuiltValueField(wireName: r'waiting_time')
  int? get waitingTime;

  @BuiltValueField(wireName: r'working_time')
  int? get workingTime;

  SourceImportRecipe._();

  factory SourceImportRecipe([void updates(SourceImportRecipeBuilder b)]) =
      _$SourceImportRecipe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportRecipeBuilder b) => b
    ..internal = true
    ..keywords = ListBuilder()
    ..properties = ListBuilder()
    ..servings = 1
    ..servingsText = ''
    ..waitingTime = 0
    ..workingTime = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportRecipe> get serializer =>
      _$SourceImportRecipeSerializer();
}

class _$SourceImportRecipeSerializer
    implements PrimitiveSerializer<SourceImportRecipe> {
  @override
  final Iterable<Type> types = const [SourceImportRecipe, _$SourceImportRecipe];

  @override
  final String wireName = r'SourceImportRecipe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportRecipe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.imageUrl != null) {
      yield r'image_url';
      yield serializers.serialize(
        object.imageUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.internal != null) {
      yield r'internal';
      yield serializers.serialize(
        object.internal,
        specifiedType: const FullType(bool),
      );
    }
    if (object.keywords != null) {
      yield r'keywords';
      yield serializers.serialize(
        object.keywords,
        specifiedType: const FullType(BuiltList, [
          FullType(SourceImportKeyword),
        ]),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.properties != null) {
      yield r'properties';
      yield serializers.serialize(
        object.properties,
        specifiedType: const FullType(BuiltList, [
          FullType(SourceImportProperty),
        ]),
      );
    }
    if (object.servings != null) {
      yield r'servings';
      yield serializers.serialize(
        object.servings,
        specifiedType: const FullType(int),
      );
    }
    if (object.servingsText != null) {
      yield r'servings_text';
      yield serializers.serialize(
        object.servingsText,
        specifiedType: const FullType(String),
      );
    }
    yield r'source_url';
    yield serializers.serialize(
      object.sourceUrl,
      specifiedType: const FullType(String),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(SourceImportStep)]),
    );
    if (object.waitingTime != null) {
      yield r'waiting_time';
      yield serializers.serialize(
        object.waitingTime,
        specifiedType: const FullType(int),
      );
    }
    if (object.workingTime != null) {
      yield r'working_time';
      yield serializers.serialize(
        object.workingTime,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportRecipe object, {
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
    required SourceImportRecipeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageUrl = valueDes;
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
              FullType(SourceImportKeyword),
            ]),
          ) as BuiltList<SourceImportKeyword>?;
          if (valueDes == null) continue;
          result.keywords.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'properties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SourceImportProperty),
            ]),
          ) as BuiltList<SourceImportProperty>?;
          if (valueDes == null) continue;
          result.properties.replace(valueDes);
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
        case r'source_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceUrl = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(SourceImportStep),
            ]),
          ) as BuiltList<SourceImportStep>;
          result.steps.replace(valueDes);
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
  SourceImportRecipe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportRecipeBuilder();
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

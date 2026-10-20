//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/custom_filter.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/recipe_simple.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'export_request.g.dart';

/// ExportRequest
///
/// Properties:
/// * [all]
/// * [customFilter]
/// * [recipes]
/// * [type]
@BuiltValue()
abstract class ExportRequest
    implements Built<ExportRequest, ExportRequestBuilder> {
  @BuiltValueField(wireName: r'all')
  bool? get all;

  @BuiltValueField(wireName: r'custom_filter')
  CustomFilter? get customFilter;

  @BuiltValueField(wireName: r'recipes')
  BuiltList<RecipeSimple>? get recipes;

  @BuiltValueField(wireName: r'type')
  String get type;

  ExportRequest._();

  factory ExportRequest([void updates(ExportRequestBuilder b)]) =
      _$ExportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExportRequestBuilder b) => b
    ..all = false
    ..recipes = ListBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<ExportRequest> get serializer =>
      _$ExportRequestSerializer();
}

class _$ExportRequestSerializer implements PrimitiveSerializer<ExportRequest> {
  @override
  final Iterable<Type> types = const [ExportRequest, _$ExportRequest];

  @override
  final String wireName = r'ExportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.all != null) {
      yield r'all';
      yield serializers.serialize(
        object.all,
        specifiedType: const FullType(bool),
      );
    }
    if (object.customFilter != null) {
      yield r'custom_filter';
      yield serializers.serialize(
        object.customFilter,
        specifiedType: const FullType.nullable(CustomFilter),
      );
    }
    if (object.recipes != null) {
      yield r'recipes';
      yield serializers.serialize(
        object.recipes,
        specifiedType: const FullType(BuiltList, [FullType(RecipeSimple)]),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExportRequest object, {
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
    required ExportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'all':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.all = valueDes;
          break;
        case r'custom_filter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomFilter),
          ) as CustomFilter?;
          if (valueDes == null) continue;
          result.customFilter.replace(valueDes);
          break;
        case r'recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(RecipeSimple),
            ]),
          ) as BuiltList<RecipeSimple>?;
          if (valueDes == null) continue;
          result.recipes.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExportRequestBuilder();
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

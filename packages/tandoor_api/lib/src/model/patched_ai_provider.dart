//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_ai_provider.g.dart';

/// PatchedAiProvider
///
/// Properties:
/// * [apiKey]
/// * [createdAt]
/// * [description]
/// * [id]
/// * [logCreditCost]
/// * [modelName]
/// * [name]
/// * [space]
/// * [updatedAt]
/// * [url]
@BuiltValue()
abstract class PatchedAiProvider
    implements Built<PatchedAiProvider, PatchedAiProviderBuilder> {
  @BuiltValueField(wireName: r'api_key')
  String? get apiKey;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'log_credit_cost')
  bool? get logCreditCost;

  @BuiltValueField(wireName: r'model_name')
  String? get modelName;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'space')
  int? get space;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'url')
  String? get url;

  PatchedAiProvider._();

  factory PatchedAiProvider([void updates(PatchedAiProviderBuilder b)]) =
      _$PatchedAiProvider;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedAiProviderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedAiProvider> get serializer =>
      _$PatchedAiProviderSerializer();
}

class _$PatchedAiProviderSerializer
    implements PrimitiveSerializer<PatchedAiProvider> {
  @override
  final Iterable<Type> types = const [PatchedAiProvider, _$PatchedAiProvider];

  @override
  final String wireName = r'PatchedAiProvider';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedAiProvider object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.apiKey != null) {
      yield r'api_key';
      yield serializers.serialize(
        object.apiKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.logCreditCost != null) {
      yield r'log_credit_cost';
      yield serializers.serialize(
        object.logCreditCost,
        specifiedType: const FullType(bool),
      );
    }
    if (object.modelName != null) {
      yield r'model_name';
      yield serializers.serialize(
        object.modelName,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.space != null) {
      yield r'space';
      yield serializers.serialize(
        object.space,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
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
    PatchedAiProvider object, {
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
    required PatchedAiProviderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'api_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.apiKey = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
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
        case r'log_credit_cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.logCreditCost = valueDes;
          break;
        case r'model_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.modelName = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'space':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.space = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
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
  PatchedAiProvider deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedAiProviderBuilder();
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

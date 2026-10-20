//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/ai_provider.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_log.g.dart';

/// AiLog
///
/// Properties:
/// * [aiProvider]
/// * [createdAt]
/// * [createdBy]
/// * [creditCost]
/// * [creditsFromBalance]
/// * [endTime]
/// * [function_]
/// * [id]
/// * [inputTokens]
/// * [outputTokens]
/// * [startTime]
/// * [updatedAt]
@BuiltValue()
abstract class AiLog implements Built<AiLog, AiLogBuilder> {
  @BuiltValueField(wireName: r'ai_provider')
  AiProvider? get aiProvider;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'credit_cost')
  double get creditCost;

  @BuiltValueField(wireName: r'credits_from_balance')
  bool? get creditsFromBalance;

  @BuiltValueField(wireName: r'end_time')
  DateTime? get endTime;

  @BuiltValueField(wireName: r'function')
  String get function_;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'input_tokens')
  int? get inputTokens;

  @BuiltValueField(wireName: r'output_tokens')
  int? get outputTokens;

  @BuiltValueField(wireName: r'start_time')
  DateTime? get startTime;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  AiLog._();

  factory AiLog([void updates(AiLogBuilder b)]) = _$AiLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiLog> get serializer => _$AiLogSerializer();
}

class _$AiLogSerializer implements PrimitiveSerializer<AiLog> {
  @override
  final Iterable<Type> types = const [AiLog, _$AiLog];

  @override
  final String wireName = r'AiLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.aiProvider != null) {
      yield r'ai_provider';
      yield serializers.serialize(
        object.aiProvider,
        specifiedType: const FullType.nullable(AiProvider),
      );
    }
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
    yield r'credit_cost';
    yield serializers.serialize(
      object.creditCost,
      specifiedType: const FullType(double),
    );
    if (object.creditsFromBalance != null) {
      yield r'credits_from_balance';
      yield serializers.serialize(
        object.creditsFromBalance,
        specifiedType: const FullType(bool),
      );
    }
    if (object.endTime != null) {
      yield r'end_time';
      yield serializers.serialize(
        object.endTime,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'function';
    yield serializers.serialize(
      object.function_,
      specifiedType: const FullType(String),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.inputTokens != null) {
      yield r'input_tokens';
      yield serializers.serialize(
        object.inputTokens,
        specifiedType: const FullType(int),
      );
    }
    if (object.outputTokens != null) {
      yield r'output_tokens';
      yield serializers.serialize(
        object.outputTokens,
        specifiedType: const FullType(int),
      );
    }
    if (object.startTime != null) {
      yield r'start_time';
      yield serializers.serialize(
        object.startTime,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AiLog object, {
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
    required AiLogBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ai_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AiProvider),
          ) as AiProvider?;
          if (valueDes == null) continue;
          result.aiProvider.replace(valueDes);
          break;
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
        case r'credit_cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.creditCost = valueDes;
          break;
        case r'credits_from_balance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.creditsFromBalance = valueDes;
          break;
        case r'end_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.endTime = valueDes;
          break;
        case r'function':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.function_ = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'input_tokens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inputTokens = valueDes;
          break;
        case r'output_tokens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.outputTokens = valueDes;
          break;
        case r'start_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startTime = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiLogBuilder();
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

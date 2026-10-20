//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_keyword.g.dart';

/// SourceImportKeyword
///
/// Properties:
/// * [id]
/// * [importKeyword]
/// * [label]
/// * [name]
@BuiltValue()
abstract class SourceImportKeyword
    implements Built<SourceImportKeyword, SourceImportKeywordBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'import_keyword')
  bool? get importKeyword;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'name')
  String get name;

  SourceImportKeyword._();

  factory SourceImportKeyword([void updates(SourceImportKeywordBuilder b)]) =
      _$SourceImportKeyword;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportKeywordBuilder b) =>
      b..importKeyword = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportKeyword> get serializer =>
      _$SourceImportKeywordSerializer();
}

class _$SourceImportKeywordSerializer
    implements PrimitiveSerializer<SourceImportKeyword> {
  @override
  final Iterable<Type> types = const [
    SourceImportKeyword,
    _$SourceImportKeyword,
  ];

  @override
  final String wireName = r'SourceImportKeyword';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportKeyword object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.importKeyword != null) {
      yield r'import_keyword';
      yield serializers.serialize(
        object.importKeyword,
        specifiedType: const FullType(bool),
      );
    }
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportKeyword object, {
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
    required SourceImportKeywordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'import_keyword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.importKeyword = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SourceImportKeyword deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportKeywordBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_import_unit.g.dart';

/// SourceImportUnit
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class SourceImportUnit
    implements Built<SourceImportUnit, SourceImportUnitBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  SourceImportUnit._();

  factory SourceImportUnit([void updates(SourceImportUnitBuilder b)]) =
      _$SourceImportUnit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SourceImportUnitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SourceImportUnit> get serializer =>
      _$SourceImportUnitSerializer();
}

class _$SourceImportUnitSerializer
    implements PrimitiveSerializer<SourceImportUnit> {
  @override
  final Iterable<Type> types = const [SourceImportUnit, _$SourceImportUnit];

  @override
  final String wireName = r'SourceImportUnit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SourceImportUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SourceImportUnit object, {
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
    required SourceImportUnitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  SourceImportUnit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SourceImportUnitBuilder();
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

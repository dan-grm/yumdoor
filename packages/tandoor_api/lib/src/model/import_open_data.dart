//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_open_data.g.dart';

/// ImportOpenData
///
/// Properties:
/// * [selectedDatatypes]
/// * [selectedVersion]
/// * [updateExisting]
/// * [useMetric]
@BuiltValue()
abstract class ImportOpenData
    implements Built<ImportOpenData, ImportOpenDataBuilder> {
  @BuiltValueField(wireName: r'selected_datatypes')
  BuiltList<String> get selectedDatatypes;

  @BuiltValueField(wireName: r'selected_version')
  String get selectedVersion;

  @BuiltValueField(wireName: r'update_existing')
  bool? get updateExisting;

  @BuiltValueField(wireName: r'use_metric')
  bool? get useMetric;

  ImportOpenData._();

  factory ImportOpenData([void updates(ImportOpenDataBuilder b)]) =
      _$ImportOpenData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportOpenDataBuilder b) => b
    ..updateExisting = true
    ..useMetric = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportOpenData> get serializer =>
      _$ImportOpenDataSerializer();
}

class _$ImportOpenDataSerializer
    implements PrimitiveSerializer<ImportOpenData> {
  @override
  final Iterable<Type> types = const [ImportOpenData, _$ImportOpenData];

  @override
  final String wireName = r'ImportOpenData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportOpenData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'selected_datatypes';
    yield serializers.serialize(
      object.selectedDatatypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'selected_version';
    yield serializers.serialize(
      object.selectedVersion,
      specifiedType: const FullType(String),
    );
    if (object.updateExisting != null) {
      yield r'update_existing';
      yield serializers.serialize(
        object.updateExisting,
        specifiedType: const FullType(bool),
      );
    }
    if (object.useMetric != null) {
      yield r'use_metric';
      yield serializers.serialize(
        object.useMetric,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportOpenData object, {
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
    required ImportOpenDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'selected_datatypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.selectedDatatypes.replace(valueDes);
          break;
        case r'selected_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.selectedVersion = valueDes;
          break;
        case r'update_existing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.updateExisting = valueDes;
          break;
        case r'use_metric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.useMetric = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportOpenData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportOpenDataBuilder();
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

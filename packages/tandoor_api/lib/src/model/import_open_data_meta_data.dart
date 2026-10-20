//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/import_open_data_version_meta_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_open_data_meta_data.g.dart';

/// ImportOpenDataMetaData
///
/// Properties:
/// * [base_]
/// * [cs]
/// * [da]
/// * [datatypes]
/// * [de]
/// * [el]
/// * [en]
/// * [es]
/// * [fr]
/// * [hu]
/// * [it]
/// * [nbNO]
/// * [nl]
/// * [pl]
/// * [pt]
/// * [ptBR]
/// * [sk]
/// * [sl]
/// * [versions]
/// * [zhHans]
@BuiltValue()
abstract class ImportOpenDataMetaData
    implements Built<ImportOpenDataMetaData, ImportOpenDataMetaDataBuilder> {
  @BuiltValueField(wireName: r'base')
  ImportOpenDataVersionMetaData get base_;

  @BuiltValueField(wireName: r'cs')
  ImportOpenDataVersionMetaData get cs;

  @BuiltValueField(wireName: r'da')
  ImportOpenDataVersionMetaData get da;

  @BuiltValueField(wireName: r'datatypes')
  BuiltList<String> get datatypes;

  @BuiltValueField(wireName: r'de')
  ImportOpenDataVersionMetaData get de;

  @BuiltValueField(wireName: r'el')
  ImportOpenDataVersionMetaData get el;

  @BuiltValueField(wireName: r'en')
  ImportOpenDataVersionMetaData get en;

  @BuiltValueField(wireName: r'es')
  ImportOpenDataVersionMetaData get es;

  @BuiltValueField(wireName: r'fr')
  ImportOpenDataVersionMetaData get fr;

  @BuiltValueField(wireName: r'hu')
  ImportOpenDataVersionMetaData get hu;

  @BuiltValueField(wireName: r'it')
  ImportOpenDataVersionMetaData get it;

  @BuiltValueField(wireName: r'nb_NO')
  ImportOpenDataVersionMetaData get nbNO;

  @BuiltValueField(wireName: r'nl')
  ImportOpenDataVersionMetaData get nl;

  @BuiltValueField(wireName: r'pl')
  ImportOpenDataVersionMetaData get pl;

  @BuiltValueField(wireName: r'pt')
  ImportOpenDataVersionMetaData get pt;

  @BuiltValueField(wireName: r'pt_BR')
  ImportOpenDataVersionMetaData get ptBR;

  @BuiltValueField(wireName: r'sk')
  ImportOpenDataVersionMetaData get sk;

  @BuiltValueField(wireName: r'sl')
  ImportOpenDataVersionMetaData get sl;

  @BuiltValueField(wireName: r'versions')
  BuiltList<String> get versions;

  @BuiltValueField(wireName: r'zh_Hans')
  ImportOpenDataVersionMetaData get zhHans;

  ImportOpenDataMetaData._();

  factory ImportOpenDataMetaData([
    void updates(ImportOpenDataMetaDataBuilder b),
  ]) = _$ImportOpenDataMetaData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportOpenDataMetaDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportOpenDataMetaData> get serializer =>
      _$ImportOpenDataMetaDataSerializer();
}

class _$ImportOpenDataMetaDataSerializer
    implements PrimitiveSerializer<ImportOpenDataMetaData> {
  @override
  final Iterable<Type> types = const [
    ImportOpenDataMetaData,
    _$ImportOpenDataMetaData,
  ];

  @override
  final String wireName = r'ImportOpenDataMetaData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportOpenDataMetaData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'cs';
    yield serializers.serialize(
      object.cs,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'da';
    yield serializers.serialize(
      object.da,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'datatypes';
    yield serializers.serialize(
      object.datatypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'de';
    yield serializers.serialize(
      object.de,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'el';
    yield serializers.serialize(
      object.el,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'en';
    yield serializers.serialize(
      object.en,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'es';
    yield serializers.serialize(
      object.es,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'fr';
    yield serializers.serialize(
      object.fr,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'hu';
    yield serializers.serialize(
      object.hu,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'it';
    yield serializers.serialize(
      object.it,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'nb_NO';
    yield serializers.serialize(
      object.nbNO,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'nl';
    yield serializers.serialize(
      object.nl,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'pl';
    yield serializers.serialize(
      object.pl,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'pt';
    yield serializers.serialize(
      object.pt,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'pt_BR';
    yield serializers.serialize(
      object.ptBR,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'sk';
    yield serializers.serialize(
      object.sk,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'sl';
    yield serializers.serialize(
      object.sl,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'zh_Hans';
    yield serializers.serialize(
      object.zhHans,
      specifiedType: const FullType(ImportOpenDataVersionMetaData),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportOpenDataMetaData object, {
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
    required ImportOpenDataMetaDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'base':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.base_.replace(valueDes);
          break;
        case r'cs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.cs.replace(valueDes);
          break;
        case r'da':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.da.replace(valueDes);
          break;
        case r'datatypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.datatypes.replace(valueDes);
          break;
        case r'de':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.de.replace(valueDes);
          break;
        case r'el':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.el.replace(valueDes);
          break;
        case r'en':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.en.replace(valueDes);
          break;
        case r'es':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.es.replace(valueDes);
          break;
        case r'fr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.fr.replace(valueDes);
          break;
        case r'hu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.hu.replace(valueDes);
          break;
        case r'it':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.it.replace(valueDes);
          break;
        case r'nb_NO':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.nbNO.replace(valueDes);
          break;
        case r'nl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.nl.replace(valueDes);
          break;
        case r'pl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.pl.replace(valueDes);
          break;
        case r'pt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.pt.replace(valueDes);
          break;
        case r'pt_BR':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.ptBR.replace(valueDes);
          break;
        case r'sk':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.sk.replace(valueDes);
          break;
        case r'sl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.sl.replace(valueDes);
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.versions.replace(valueDes);
          break;
        case r'zh_Hans':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportOpenDataVersionMetaData),
          ) as ImportOpenDataVersionMetaData;
          result.zhHans.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportOpenDataMetaData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportOpenDataMetaDataBuilder();
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

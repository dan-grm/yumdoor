//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/search_enum.dart';
import 'package:tandoor_api/src/model/search_fields.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_search_preference.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [fulltext]
/// * [icontains]
/// * [istartswith]
/// * [lookup]
/// * [search]
/// * [trigram]
/// * [trigramThreshold]
/// * [unaccent]
/// * [user]
@BuiltValue()
abstract class PatchedSearchPreference
    implements Built<PatchedSearchPreference, PatchedSearchPreferenceBuilder> {
  @BuiltValueField(wireName: r'fulltext')
  BuiltList<SearchFields>? get fulltext;

  @BuiltValueField(wireName: r'icontains')
  BuiltList<SearchFields>? get icontains;

  @BuiltValueField(wireName: r'istartswith')
  BuiltList<SearchFields>? get istartswith;

  @BuiltValueField(wireName: r'lookup')
  bool? get lookup;

  @BuiltValueField(wireName: r'search')
  SearchEnum? get search;
  // enum searchEnum {  plain,  phrase,  websearch,  raw,  };

  @BuiltValueField(wireName: r'trigram')
  BuiltList<SearchFields>? get trigram;

  @BuiltValueField(wireName: r'trigram_threshold')
  double? get trigramThreshold;

  @BuiltValueField(wireName: r'unaccent')
  BuiltList<SearchFields>? get unaccent;

  @BuiltValueField(wireName: r'user')
  User? get user;

  PatchedSearchPreference._();

  factory PatchedSearchPreference([
    void updates(PatchedSearchPreferenceBuilder b),
  ]) = _$PatchedSearchPreference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedSearchPreferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedSearchPreference> get serializer =>
      _$PatchedSearchPreferenceSerializer();
}

class _$PatchedSearchPreferenceSerializer
    implements PrimitiveSerializer<PatchedSearchPreference> {
  @override
  final Iterable<Type> types = const [
    PatchedSearchPreference,
    _$PatchedSearchPreference,
  ];

  @override
  final String wireName = r'PatchedSearchPreference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedSearchPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fulltext != null) {
      yield r'fulltext';
      yield serializers.serialize(
        object.fulltext,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SearchFields),
        ]),
      );
    }
    if (object.icontains != null) {
      yield r'icontains';
      yield serializers.serialize(
        object.icontains,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SearchFields),
        ]),
      );
    }
    if (object.istartswith != null) {
      yield r'istartswith';
      yield serializers.serialize(
        object.istartswith,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SearchFields),
        ]),
      );
    }
    if (object.lookup != null) {
      yield r'lookup';
      yield serializers.serialize(
        object.lookup,
        specifiedType: const FullType(bool),
      );
    }
    if (object.search != null) {
      yield r'search';
      yield serializers.serialize(
        object.search,
        specifiedType: const FullType(SearchEnum),
      );
    }
    if (object.trigram != null) {
      yield r'trigram';
      yield serializers.serialize(
        object.trigram,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SearchFields),
        ]),
      );
    }
    if (object.trigramThreshold != null) {
      yield r'trigram_threshold';
      yield serializers.serialize(
        object.trigramThreshold,
        specifiedType: const FullType(double),
      );
    }
    if (object.unaccent != null) {
      yield r'unaccent';
      yield serializers.serialize(
        object.unaccent,
        specifiedType: const FullType.nullable(BuiltList, [
          FullType(SearchFields),
        ]),
      );
    }
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType.nullable(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedSearchPreference object, {
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
    required PatchedSearchPreferenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fulltext':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SearchFields),
            ]),
          ) as BuiltList<SearchFields>?;
          if (valueDes == null) continue;
          result.fulltext.replace(valueDes);
          break;
        case r'icontains':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SearchFields),
            ]),
          ) as BuiltList<SearchFields>?;
          if (valueDes == null) continue;
          result.icontains.replace(valueDes);
          break;
        case r'istartswith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SearchFields),
            ]),
          ) as BuiltList<SearchFields>?;
          if (valueDes == null) continue;
          result.istartswith.replace(valueDes);
          break;
        case r'lookup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.lookup = valueDes;
          break;
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SearchEnum),
          ) as SearchEnum?;
          if (valueDes == null) continue;
          result.search = valueDes;
          break;
        case r'trigram':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SearchFields),
            ]),
          ) as BuiltList<SearchFields>?;
          if (valueDes == null) continue;
          result.trigram.replace(valueDes);
          break;
        case r'trigram_threshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.trigramThreshold = valueDes;
          break;
        case r'unaccent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(SearchFields),
            ]),
          ) as BuiltList<SearchFields>?;
          if (valueDes == null) continue;
          result.unaccent.replace(valueDes);
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedSearchPreference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedSearchPreferenceBuilder();
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

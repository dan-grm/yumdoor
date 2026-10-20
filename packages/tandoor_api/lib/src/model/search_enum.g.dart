// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchEnum _$plain = const SearchEnum._('plain');
const SearchEnum _$phrase = const SearchEnum._('phrase');
const SearchEnum _$websearch = const SearchEnum._('websearch');
const SearchEnum _$raw = const SearchEnum._('raw');
const SearchEnum _$unknownDefaultOpenApi = const SearchEnum._(
  'unknownDefaultOpenApi',
);

SearchEnum _$valueOf(String name) {
  switch (name) {
    case 'plain':
      return _$plain;
    case 'phrase':
      return _$phrase;
    case 'websearch':
      return _$websearch;
    case 'raw':
      return _$raw;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<SearchEnum> _$values = BuiltSet<SearchEnum>(const <SearchEnum>[
  _$plain,
  _$phrase,
  _$websearch,
  _$raw,
  _$unknownDefaultOpenApi,
]);

class _$SearchEnumMeta {
  const _$SearchEnumMeta();
  SearchEnum get plain => _$plain;
  SearchEnum get phrase => _$phrase;
  SearchEnum get websearch => _$websearch;
  SearchEnum get raw => _$raw;
  SearchEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  SearchEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<SearchEnum> get values => _$values;
}

mixin _$SearchEnumMixin {
  // ignore: non_constant_identifier_names
  _$SearchEnumMeta get SearchEnum => const _$SearchEnumMeta();
}

Serializer<SearchEnum> _$searchEnumSerializer = _$SearchEnumSerializer();

class _$SearchEnumSerializer implements PrimitiveSerializer<SearchEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'plain': 'plain',
    'phrase': 'phrase',
    'websearch': 'websearch',
    'raw': 'raw',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'plain': 'plain',
    'phrase': 'phrase',
    'websearch': 'websearch',
    'raw': 'raw',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchEnum];
  @override
  final String wireName = 'SearchEnum';

  @override
  Object serialize(
    Serializers serializers,
    SearchEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SearchEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SearchEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

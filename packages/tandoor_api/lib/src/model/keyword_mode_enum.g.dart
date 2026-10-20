// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_mode_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KeywordModeEnum _$or = const KeywordModeEnum._('or');
const KeywordModeEnum _$and = const KeywordModeEnum._('and');
const KeywordModeEnum _$unknownDefaultOpenApi = const KeywordModeEnum._(
  'unknownDefaultOpenApi',
);

KeywordModeEnum _$valueOf(String name) {
  switch (name) {
    case 'or':
      return _$or;
    case 'and':
      return _$and;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<KeywordModeEnum> _$values = BuiltSet<KeywordModeEnum>(
  const <KeywordModeEnum>[_$or, _$and, _$unknownDefaultOpenApi],
);

class _$KeywordModeEnumMeta {
  const _$KeywordModeEnumMeta();
  KeywordModeEnum get or => _$or;
  KeywordModeEnum get and => _$and;
  KeywordModeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  KeywordModeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<KeywordModeEnum> get values => _$values;
}

mixin _$KeywordModeEnumMixin {
  // ignore: non_constant_identifier_names
  _$KeywordModeEnumMeta get KeywordModeEnum => const _$KeywordModeEnumMeta();
}

Serializer<KeywordModeEnum> _$keywordModeEnumSerializer =
    _$KeywordModeEnumSerializer();

class _$KeywordModeEnumSerializer
    implements PrimitiveSerializer<KeywordModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'or': 'or',
    'and': 'and',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'or': 'or',
    'and': 'and',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[KeywordModeEnum];
  @override
  final String wireName = 'KeywordModeEnum';

  @override
  Object serialize(
    Serializers serializers,
    KeywordModeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KeywordModeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KeywordModeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_page_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DefaultPageEnum _$SEARCH = const DefaultPageEnum._('SEARCH');
const DefaultPageEnum _$PLAN = const DefaultPageEnum._('PLAN');
const DefaultPageEnum _$BOOKS = const DefaultPageEnum._('BOOKS');
const DefaultPageEnum _$SHOPPING = const DefaultPageEnum._('SHOPPING');
const DefaultPageEnum _$unknownDefaultOpenApi = const DefaultPageEnum._(
  'unknownDefaultOpenApi',
);

DefaultPageEnum _$valueOf(String name) {
  switch (name) {
    case 'SEARCH':
      return _$SEARCH;
    case 'PLAN':
      return _$PLAN;
    case 'BOOKS':
      return _$BOOKS;
    case 'SHOPPING':
      return _$SHOPPING;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<DefaultPageEnum> _$values = BuiltSet<DefaultPageEnum>(
  const <DefaultPageEnum>[
    _$SEARCH,
    _$PLAN,
    _$BOOKS,
    _$SHOPPING,
    _$unknownDefaultOpenApi,
  ],
);

class _$DefaultPageEnumMeta {
  const _$DefaultPageEnumMeta();
  DefaultPageEnum get SEARCH => _$SEARCH;
  DefaultPageEnum get PLAN => _$PLAN;
  DefaultPageEnum get BOOKS => _$BOOKS;
  DefaultPageEnum get SHOPPING => _$SHOPPING;
  DefaultPageEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  DefaultPageEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<DefaultPageEnum> get values => _$values;
}

mixin _$DefaultPageEnumMixin {
  // ignore: non_constant_identifier_names
  _$DefaultPageEnumMeta get DefaultPageEnum => const _$DefaultPageEnumMeta();
}

Serializer<DefaultPageEnum> _$defaultPageEnumSerializer =
    _$DefaultPageEnumSerializer();

class _$DefaultPageEnumSerializer
    implements PrimitiveSerializer<DefaultPageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEARCH': 'SEARCH',
    'PLAN': 'PLAN',
    'BOOKS': 'BOOKS',
    'SHOPPING': 'SHOPPING',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEARCH': 'SEARCH',
    'PLAN': 'PLAN',
    'BOOKS': 'BOOKS',
    'SHOPPING': 'SHOPPING',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[DefaultPageEnum];
  @override
  final String wireName = 'DefaultPageEnum';

  @override
  Object serialize(
    Serializers serializers,
    DefaultPageEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DefaultPageEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DefaultPageEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

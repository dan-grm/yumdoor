// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_type_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutomationTypeEnum _$FOOD_ALIAS = const AutomationTypeEnum._(
  'FOOD_ALIAS',
);
const AutomationTypeEnum _$UNIT_ALIAS = const AutomationTypeEnum._(
  'UNIT_ALIAS',
);
const AutomationTypeEnum _$KEYWORD_ALIAS = const AutomationTypeEnum._(
  'KEYWORD_ALIAS',
);
const AutomationTypeEnum _$DESCRIPTION_REPLACE = const AutomationTypeEnum._(
  'DESCRIPTION_REPLACE',
);
const AutomationTypeEnum _$INSTRUCTION_REPLACE = const AutomationTypeEnum._(
  'INSTRUCTION_REPLACE',
);
const AutomationTypeEnum _$NEVER_UNIT = const AutomationTypeEnum._(
  'NEVER_UNIT',
);
const AutomationTypeEnum _$TRANSPOSE_WORDS = const AutomationTypeEnum._(
  'TRANSPOSE_WORDS',
);
const AutomationTypeEnum _$FOOD_REPLACE = const AutomationTypeEnum._(
  'FOOD_REPLACE',
);
const AutomationTypeEnum _$UNIT_REPLACE = const AutomationTypeEnum._(
  'UNIT_REPLACE',
);
const AutomationTypeEnum _$NAME_REPLACE = const AutomationTypeEnum._(
  'NAME_REPLACE',
);
const AutomationTypeEnum _$unknownDefaultOpenApi = const AutomationTypeEnum._(
  'unknownDefaultOpenApi',
);

AutomationTypeEnum _$valueOf(String name) {
  switch (name) {
    case 'FOOD_ALIAS':
      return _$FOOD_ALIAS;
    case 'UNIT_ALIAS':
      return _$UNIT_ALIAS;
    case 'KEYWORD_ALIAS':
      return _$KEYWORD_ALIAS;
    case 'DESCRIPTION_REPLACE':
      return _$DESCRIPTION_REPLACE;
    case 'INSTRUCTION_REPLACE':
      return _$INSTRUCTION_REPLACE;
    case 'NEVER_UNIT':
      return _$NEVER_UNIT;
    case 'TRANSPOSE_WORDS':
      return _$TRANSPOSE_WORDS;
    case 'FOOD_REPLACE':
      return _$FOOD_REPLACE;
    case 'UNIT_REPLACE':
      return _$UNIT_REPLACE;
    case 'NAME_REPLACE':
      return _$NAME_REPLACE;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<AutomationTypeEnum> _$values = BuiltSet<AutomationTypeEnum>(
  const <AutomationTypeEnum>[
    _$FOOD_ALIAS,
    _$UNIT_ALIAS,
    _$KEYWORD_ALIAS,
    _$DESCRIPTION_REPLACE,
    _$INSTRUCTION_REPLACE,
    _$NEVER_UNIT,
    _$TRANSPOSE_WORDS,
    _$FOOD_REPLACE,
    _$UNIT_REPLACE,
    _$NAME_REPLACE,
    _$unknownDefaultOpenApi,
  ],
);

class _$AutomationTypeEnumMeta {
  const _$AutomationTypeEnumMeta();
  AutomationTypeEnum get FOOD_ALIAS => _$FOOD_ALIAS;
  AutomationTypeEnum get UNIT_ALIAS => _$UNIT_ALIAS;
  AutomationTypeEnum get KEYWORD_ALIAS => _$KEYWORD_ALIAS;
  AutomationTypeEnum get DESCRIPTION_REPLACE => _$DESCRIPTION_REPLACE;
  AutomationTypeEnum get INSTRUCTION_REPLACE => _$INSTRUCTION_REPLACE;
  AutomationTypeEnum get NEVER_UNIT => _$NEVER_UNIT;
  AutomationTypeEnum get TRANSPOSE_WORDS => _$TRANSPOSE_WORDS;
  AutomationTypeEnum get FOOD_REPLACE => _$FOOD_REPLACE;
  AutomationTypeEnum get UNIT_REPLACE => _$UNIT_REPLACE;
  AutomationTypeEnum get NAME_REPLACE => _$NAME_REPLACE;
  AutomationTypeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  AutomationTypeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<AutomationTypeEnum> get values => _$values;
}

mixin _$AutomationTypeEnumMixin {
  // ignore: non_constant_identifier_names
  _$AutomationTypeEnumMeta get AutomationTypeEnum =>
      const _$AutomationTypeEnumMeta();
}

Serializer<AutomationTypeEnum> _$automationTypeEnumSerializer =
    _$AutomationTypeEnumSerializer();

class _$AutomationTypeEnumSerializer
    implements PrimitiveSerializer<AutomationTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FOOD_ALIAS': 'FOOD_ALIAS',
    'UNIT_ALIAS': 'UNIT_ALIAS',
    'KEYWORD_ALIAS': 'KEYWORD_ALIAS',
    'DESCRIPTION_REPLACE': 'DESCRIPTION_REPLACE',
    'INSTRUCTION_REPLACE': 'INSTRUCTION_REPLACE',
    'NEVER_UNIT': 'NEVER_UNIT',
    'TRANSPOSE_WORDS': 'TRANSPOSE_WORDS',
    'FOOD_REPLACE': 'FOOD_REPLACE',
    'UNIT_REPLACE': 'UNIT_REPLACE',
    'NAME_REPLACE': 'NAME_REPLACE',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FOOD_ALIAS': 'FOOD_ALIAS',
    'UNIT_ALIAS': 'UNIT_ALIAS',
    'KEYWORD_ALIAS': 'KEYWORD_ALIAS',
    'DESCRIPTION_REPLACE': 'DESCRIPTION_REPLACE',
    'INSTRUCTION_REPLACE': 'INSTRUCTION_REPLACE',
    'NEVER_UNIT': 'NEVER_UNIT',
    'TRANSPOSE_WORDS': 'TRANSPOSE_WORDS',
    'FOOD_REPLACE': 'FOOD_REPLACE',
    'UNIT_REPLACE': 'UNIT_REPLACE',
    'NAME_REPLACE': 'NAME_REPLACE',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AutomationTypeEnum];
  @override
  final String wireName = 'AutomationTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AutomationTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AutomationTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AutomationTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

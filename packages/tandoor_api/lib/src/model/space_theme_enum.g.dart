// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_theme_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SpaceThemeEnum _$BLANK = const SpaceThemeEnum._('BLANK');
const SpaceThemeEnum _$TANDOOR = const SpaceThemeEnum._('TANDOOR');
const SpaceThemeEnum _$BOOTSTRAP = const SpaceThemeEnum._('BOOTSTRAP');
const SpaceThemeEnum _$DARKLY = const SpaceThemeEnum._('DARKLY');
const SpaceThemeEnum _$FLATLY = const SpaceThemeEnum._('FLATLY');
const SpaceThemeEnum _$SUPERHERO = const SpaceThemeEnum._('SUPERHERO');
const SpaceThemeEnum _$TANDOOR_DARK = const SpaceThemeEnum._('TANDOOR_DARK');
const SpaceThemeEnum _$unknownDefaultOpenApi = const SpaceThemeEnum._(
  'unknownDefaultOpenApi',
);

SpaceThemeEnum _$valueOf(String name) {
  switch (name) {
    case 'BLANK':
      return _$BLANK;
    case 'TANDOOR':
      return _$TANDOOR;
    case 'BOOTSTRAP':
      return _$BOOTSTRAP;
    case 'DARKLY':
      return _$DARKLY;
    case 'FLATLY':
      return _$FLATLY;
    case 'SUPERHERO':
      return _$SUPERHERO;
    case 'TANDOOR_DARK':
      return _$TANDOOR_DARK;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<SpaceThemeEnum> _$values = BuiltSet<SpaceThemeEnum>(
  const <SpaceThemeEnum>[
    _$BLANK,
    _$TANDOOR,
    _$BOOTSTRAP,
    _$DARKLY,
    _$FLATLY,
    _$SUPERHERO,
    _$TANDOOR_DARK,
    _$unknownDefaultOpenApi,
  ],
);

class _$SpaceThemeEnumMeta {
  const _$SpaceThemeEnumMeta();
  SpaceThemeEnum get BLANK => _$BLANK;
  SpaceThemeEnum get TANDOOR => _$TANDOOR;
  SpaceThemeEnum get BOOTSTRAP => _$BOOTSTRAP;
  SpaceThemeEnum get DARKLY => _$DARKLY;
  SpaceThemeEnum get FLATLY => _$FLATLY;
  SpaceThemeEnum get SUPERHERO => _$SUPERHERO;
  SpaceThemeEnum get TANDOOR_DARK => _$TANDOOR_DARK;
  SpaceThemeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  SpaceThemeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<SpaceThemeEnum> get values => _$values;
}

mixin _$SpaceThemeEnumMixin {
  // ignore: non_constant_identifier_names
  _$SpaceThemeEnumMeta get SpaceThemeEnum => const _$SpaceThemeEnumMeta();
}

Serializer<SpaceThemeEnum> _$spaceThemeEnumSerializer =
    _$SpaceThemeEnumSerializer();

class _$SpaceThemeEnumSerializer
    implements PrimitiveSerializer<SpaceThemeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BLANK': 'BLANK',
    'TANDOOR': 'TANDOOR',
    'BOOTSTRAP': 'BOOTSTRAP',
    'DARKLY': 'DARKLY',
    'FLATLY': 'FLATLY',
    'SUPERHERO': 'SUPERHERO',
    'TANDOOR_DARK': 'TANDOOR_DARK',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BLANK': 'BLANK',
    'TANDOOR': 'TANDOOR',
    'BOOTSTRAP': 'BOOTSTRAP',
    'DARKLY': 'DARKLY',
    'FLATLY': 'FLATLY',
    'SUPERHERO': 'SUPERHERO',
    'TANDOOR_DARK': 'TANDOOR_DARK',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[SpaceThemeEnum];
  @override
  final String wireName = 'SpaceThemeEnum';

  @override
  Object serialize(
    Serializers serializers,
    SpaceThemeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SpaceThemeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SpaceThemeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ThemeEnum _$TANDOOR = const ThemeEnum._('TANDOOR');
const ThemeEnum _$BOOTSTRAP = const ThemeEnum._('BOOTSTRAP');
const ThemeEnum _$DARKLY = const ThemeEnum._('DARKLY');
const ThemeEnum _$FLATLY = const ThemeEnum._('FLATLY');
const ThemeEnum _$SUPERHERO = const ThemeEnum._('SUPERHERO');
const ThemeEnum _$TANDOOR_DARK = const ThemeEnum._('TANDOOR_DARK');
const ThemeEnum _$unknownDefaultOpenApi = const ThemeEnum._(
  'unknownDefaultOpenApi',
);

ThemeEnum _$valueOf(String name) {
  switch (name) {
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

final BuiltSet<ThemeEnum> _$values = BuiltSet<ThemeEnum>(const <ThemeEnum>[
  _$TANDOOR,
  _$BOOTSTRAP,
  _$DARKLY,
  _$FLATLY,
  _$SUPERHERO,
  _$TANDOOR_DARK,
  _$unknownDefaultOpenApi,
]);

class _$ThemeEnumMeta {
  const _$ThemeEnumMeta();
  ThemeEnum get TANDOOR => _$TANDOOR;
  ThemeEnum get BOOTSTRAP => _$BOOTSTRAP;
  ThemeEnum get DARKLY => _$DARKLY;
  ThemeEnum get FLATLY => _$FLATLY;
  ThemeEnum get SUPERHERO => _$SUPERHERO;
  ThemeEnum get TANDOOR_DARK => _$TANDOOR_DARK;
  ThemeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  ThemeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<ThemeEnum> get values => _$values;
}

mixin _$ThemeEnumMixin {
  // ignore: non_constant_identifier_names
  _$ThemeEnumMeta get ThemeEnum => const _$ThemeEnumMeta();
}

Serializer<ThemeEnum> _$themeEnumSerializer = _$ThemeEnumSerializer();

class _$ThemeEnumSerializer implements PrimitiveSerializer<ThemeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TANDOOR': 'TANDOOR',
    'BOOTSTRAP': 'BOOTSTRAP',
    'DARKLY': 'DARKLY',
    'FLATLY': 'FLATLY',
    'SUPERHERO': 'SUPERHERO',
    'TANDOOR_DARK': 'TANDOOR_DARK',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TANDOOR': 'TANDOOR',
    'BOOTSTRAP': 'BOOTSTRAP',
    'DARKLY': 'DARKLY',
    'FLATLY': 'FLATLY',
    'SUPERHERO': 'SUPERHERO',
    'TANDOOR_DARK': 'TANDOOR_DARK',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ThemeEnum];
  @override
  final String wireName = 'ThemeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ThemeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ThemeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ThemeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

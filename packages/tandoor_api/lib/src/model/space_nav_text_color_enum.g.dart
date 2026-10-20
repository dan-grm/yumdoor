// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_nav_text_color_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SpaceNavTextColorEnum _$BLANK = const SpaceNavTextColorEnum._('BLANK');
const SpaceNavTextColorEnum _$LIGHT = const SpaceNavTextColorEnum._('LIGHT');
const SpaceNavTextColorEnum _$DARK = const SpaceNavTextColorEnum._('DARK');
const SpaceNavTextColorEnum _$unknownDefaultOpenApi =
    const SpaceNavTextColorEnum._('unknownDefaultOpenApi');

SpaceNavTextColorEnum _$valueOf(String name) {
  switch (name) {
    case 'BLANK':
      return _$BLANK;
    case 'LIGHT':
      return _$LIGHT;
    case 'DARK':
      return _$DARK;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<SpaceNavTextColorEnum> _$values =
    BuiltSet<SpaceNavTextColorEnum>(const <SpaceNavTextColorEnum>[
      _$BLANK,
      _$LIGHT,
      _$DARK,
      _$unknownDefaultOpenApi,
    ]);

class _$SpaceNavTextColorEnumMeta {
  const _$SpaceNavTextColorEnumMeta();
  SpaceNavTextColorEnum get BLANK => _$BLANK;
  SpaceNavTextColorEnum get LIGHT => _$LIGHT;
  SpaceNavTextColorEnum get DARK => _$DARK;
  SpaceNavTextColorEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  SpaceNavTextColorEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<SpaceNavTextColorEnum> get values => _$values;
}

mixin _$SpaceNavTextColorEnumMixin {
  // ignore: non_constant_identifier_names
  _$SpaceNavTextColorEnumMeta get SpaceNavTextColorEnum =>
      const _$SpaceNavTextColorEnumMeta();
}

Serializer<SpaceNavTextColorEnum> _$spaceNavTextColorEnumSerializer =
    _$SpaceNavTextColorEnumSerializer();

class _$SpaceNavTextColorEnumSerializer
    implements PrimitiveSerializer<SpaceNavTextColorEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BLANK': 'BLANK',
    'LIGHT': 'LIGHT',
    'DARK': 'DARK',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BLANK': 'BLANK',
    'LIGHT': 'LIGHT',
    'DARK': 'DARK',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[SpaceNavTextColorEnum];
  @override
  final String wireName = 'SpaceNavTextColorEnum';

  @override
  Object serialize(
    Serializers serializers,
    SpaceNavTextColorEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SpaceNavTextColorEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SpaceNavTextColorEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

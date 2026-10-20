// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_nav_text_color_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserPreferenceNavTextColorEnum _$LIGHT =
    const UserPreferenceNavTextColorEnum._('LIGHT');
const UserPreferenceNavTextColorEnum _$DARK =
    const UserPreferenceNavTextColorEnum._('DARK');
const UserPreferenceNavTextColorEnum _$unknownDefaultOpenApi =
    const UserPreferenceNavTextColorEnum._('unknownDefaultOpenApi');

UserPreferenceNavTextColorEnum _$valueOf(String name) {
  switch (name) {
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

final BuiltSet<UserPreferenceNavTextColorEnum> _$values =
    BuiltSet<UserPreferenceNavTextColorEnum>(
      const <UserPreferenceNavTextColorEnum>[
        _$LIGHT,
        _$DARK,
        _$unknownDefaultOpenApi,
      ],
    );

class _$UserPreferenceNavTextColorEnumMeta {
  const _$UserPreferenceNavTextColorEnumMeta();
  UserPreferenceNavTextColorEnum get LIGHT => _$LIGHT;
  UserPreferenceNavTextColorEnum get DARK => _$DARK;
  UserPreferenceNavTextColorEnum get unknownDefaultOpenApi =>
      _$unknownDefaultOpenApi;
  UserPreferenceNavTextColorEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<UserPreferenceNavTextColorEnum> get values => _$values;
}

mixin _$UserPreferenceNavTextColorEnumMixin {
  // ignore: non_constant_identifier_names
  _$UserPreferenceNavTextColorEnumMeta get UserPreferenceNavTextColorEnum =>
      const _$UserPreferenceNavTextColorEnumMeta();
}

Serializer<UserPreferenceNavTextColorEnum>
_$userPreferenceNavTextColorEnumSerializer =
    _$UserPreferenceNavTextColorEnumSerializer();

class _$UserPreferenceNavTextColorEnumSerializer
    implements PrimitiveSerializer<UserPreferenceNavTextColorEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LIGHT': 'LIGHT',
    'DARK': 'DARK',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LIGHT': 'LIGHT',
    'DARK': 'DARK',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[UserPreferenceNavTextColorEnum];
  @override
  final String wireName = 'UserPreferenceNavTextColorEnum';

  @override
  Object serialize(
    Serializers serializers,
    UserPreferenceNavTextColorEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  UserPreferenceNavTextColorEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => UserPreferenceNavTextColorEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

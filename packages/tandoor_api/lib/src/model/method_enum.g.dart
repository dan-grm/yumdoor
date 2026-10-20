// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MethodEnum _$DB = const MethodEnum._('DB');
const MethodEnum _$NEXTCLOUD = const MethodEnum._('NEXTCLOUD');
const MethodEnum _$LOCAL = const MethodEnum._('LOCAL');
const MethodEnum _$unknownDefaultOpenApi = const MethodEnum._(
  'unknownDefaultOpenApi',
);

MethodEnum _$valueOf(String name) {
  switch (name) {
    case 'DB':
      return _$DB;
    case 'NEXTCLOUD':
      return _$NEXTCLOUD;
    case 'LOCAL':
      return _$LOCAL;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<MethodEnum> _$values = BuiltSet<MethodEnum>(const <MethodEnum>[
  _$DB,
  _$NEXTCLOUD,
  _$LOCAL,
  _$unknownDefaultOpenApi,
]);

class _$MethodEnumMeta {
  const _$MethodEnumMeta();
  MethodEnum get DB => _$DB;
  MethodEnum get NEXTCLOUD => _$NEXTCLOUD;
  MethodEnum get LOCAL => _$LOCAL;
  MethodEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  MethodEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<MethodEnum> get values => _$values;
}

mixin _$MethodEnumMixin {
  // ignore: non_constant_identifier_names
  _$MethodEnumMeta get MethodEnum => const _$MethodEnumMeta();
}

Serializer<MethodEnum> _$methodEnumSerializer = _$MethodEnumSerializer();

class _$MethodEnumSerializer implements PrimitiveSerializer<MethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DB': 'DB',
    'NEXTCLOUD': 'NEXTCLOUD',
    'LOCAL': 'LOCAL',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DB': 'DB',
    'NEXTCLOUD': 'NEXTCLOUD',
    'LOCAL': 'LOCAL',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[MethodEnum];
  @override
  final String wireName = 'MethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    MethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

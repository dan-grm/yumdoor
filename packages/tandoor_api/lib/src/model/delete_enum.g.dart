// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeleteEnum _$true_ = const DeleteEnum._('true_');
const DeleteEnum _$unknownDefaultOpenApi = const DeleteEnum._(
  'unknownDefaultOpenApi',
);

DeleteEnum _$valueOf(String name) {
  switch (name) {
    case 'true_':
      return _$true_;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<DeleteEnum> _$values = BuiltSet<DeleteEnum>(const <DeleteEnum>[
  _$true_,
  _$unknownDefaultOpenApi,
]);

class _$DeleteEnumMeta {
  const _$DeleteEnumMeta();
  DeleteEnum get true_ => _$true_;
  DeleteEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  DeleteEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<DeleteEnum> get values => _$values;
}

mixin _$DeleteEnumMixin {
  // ignore: non_constant_identifier_names
  _$DeleteEnumMeta get DeleteEnum => const _$DeleteEnumMeta();
}

Serializer<DeleteEnum> _$deleteEnumSerializer = _$DeleteEnumSerializer();

class _$DeleteEnumSerializer implements PrimitiveSerializer<DeleteEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[DeleteEnum];
  @override
  final String wireName = 'DeleteEnum';

  @override
  Object serialize(
    Serializers serializers,
    DeleteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DeleteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DeleteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

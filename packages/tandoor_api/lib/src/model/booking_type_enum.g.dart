// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_type_enum.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingTypeEnum _$add = const BookingTypeEnum._('add');
const BookingTypeEnum _$remove = const BookingTypeEnum._('remove');
const BookingTypeEnum _$move = const BookingTypeEnum._('move');
const BookingTypeEnum _$unknownDefaultOpenApi = const BookingTypeEnum._(
  'unknownDefaultOpenApi',
);

BookingTypeEnum _$valueOf(String name) {
  switch (name) {
    case 'add':
      return _$add;
    case 'remove':
      return _$remove;
    case 'move':
      return _$move;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<BookingTypeEnum> _$values = BuiltSet<BookingTypeEnum>(
  const <BookingTypeEnum>[_$add, _$remove, _$move, _$unknownDefaultOpenApi],
);

class _$BookingTypeEnumMeta {
  const _$BookingTypeEnumMeta();
  BookingTypeEnum get add => _$add;
  BookingTypeEnum get remove => _$remove;
  BookingTypeEnum get move => _$move;
  BookingTypeEnum get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  BookingTypeEnum valueOf(String name) => _$valueOf(name);
  BuiltSet<BookingTypeEnum> get values => _$values;
}

mixin _$BookingTypeEnumMixin {
  // ignore: non_constant_identifier_names
  _$BookingTypeEnumMeta get BookingTypeEnum => const _$BookingTypeEnumMeta();
}

Serializer<BookingTypeEnum> _$bookingTypeEnumSerializer =
    _$BookingTypeEnumSerializer();

class _$BookingTypeEnumSerializer
    implements PrimitiveSerializer<BookingTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'add': 'add',
    'remove': 'remove',
    'move': 'move',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'add': 'add',
    'remove': 'remove',
    'move': 'move',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingTypeEnum];
  @override
  final String wireName = 'BookingTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    BookingTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  BookingTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => BookingTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

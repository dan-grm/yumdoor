//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_type_enum.g.dart';

/// * `add` - Add * `remove` - Remove * `move` - Move
class BookingTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'add')
  static const BookingTypeEnum add = _$add;
  @BuiltValueEnumConst(wireName: r'remove')
  static const BookingTypeEnum remove = _$remove;
  @BuiltValueEnumConst(wireName: r'move')
  static const BookingTypeEnum move = _$move;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const BookingTypeEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<BookingTypeEnum> get serializer =>
      _$bookingTypeEnumSerializer;

  const BookingTypeEnum._(String name) : super(name);

  static BuiltSet<BookingTypeEnum> get values => _$values;
  static BookingTypeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class BookingTypeEnumMixin = Object with _$BookingTypeEnumMixin;

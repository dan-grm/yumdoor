//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'space_nav_text_color_enum.g.dart';

/// * `BLANK` - ------- * `LIGHT` - Light * `DARK` - Dark
class SpaceNavTextColorEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'BLANK')
  static const SpaceNavTextColorEnum BLANK = _$BLANK;
  @BuiltValueEnumConst(wireName: r'LIGHT')
  static const SpaceNavTextColorEnum LIGHT = _$LIGHT;
  @BuiltValueEnumConst(wireName: r'DARK')
  static const SpaceNavTextColorEnum DARK = _$DARK;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const SpaceNavTextColorEnum unknownDefaultOpenApi =
      _$unknownDefaultOpenApi;

  static Serializer<SpaceNavTextColorEnum> get serializer =>
      _$spaceNavTextColorEnumSerializer;

  const SpaceNavTextColorEnum._(String name) : super(name);

  static BuiltSet<SpaceNavTextColorEnum> get values => _$values;
  static SpaceNavTextColorEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SpaceNavTextColorEnumMixin = Object
    with _$SpaceNavTextColorEnumMixin;

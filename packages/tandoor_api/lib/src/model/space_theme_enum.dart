//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'space_theme_enum.g.dart';

/// * `BLANK` - ------- * `TANDOOR` - Tandoor * `BOOTSTRAP` - Bootstrap * `DARKLY` - Darkly * `FLATLY` - Flatly * `SUPERHERO` - Superhero * `TANDOOR_DARK` - Tandoor Dark (INCOMPLETE)
class SpaceThemeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'BLANK')
  static const SpaceThemeEnum BLANK = _$BLANK;
  @BuiltValueEnumConst(wireName: r'TANDOOR')
  static const SpaceThemeEnum TANDOOR = _$TANDOOR;
  @BuiltValueEnumConst(wireName: r'BOOTSTRAP')
  static const SpaceThemeEnum BOOTSTRAP = _$BOOTSTRAP;
  @BuiltValueEnumConst(wireName: r'DARKLY')
  static const SpaceThemeEnum DARKLY = _$DARKLY;
  @BuiltValueEnumConst(wireName: r'FLATLY')
  static const SpaceThemeEnum FLATLY = _$FLATLY;
  @BuiltValueEnumConst(wireName: r'SUPERHERO')
  static const SpaceThemeEnum SUPERHERO = _$SUPERHERO;
  @BuiltValueEnumConst(wireName: r'TANDOOR_DARK')
  static const SpaceThemeEnum TANDOOR_DARK = _$TANDOOR_DARK;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const SpaceThemeEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<SpaceThemeEnum> get serializer =>
      _$spaceThemeEnumSerializer;

  const SpaceThemeEnum._(String name) : super(name);

  static BuiltSet<SpaceThemeEnum> get values => _$values;
  static SpaceThemeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SpaceThemeEnumMixin = Object with _$SpaceThemeEnumMixin;

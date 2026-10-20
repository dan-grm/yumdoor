//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'theme_enum.g.dart';

/// * `TANDOOR` - Tandoor * `BOOTSTRAP` - Bootstrap * `DARKLY` - Darkly * `FLATLY` - Flatly * `SUPERHERO` - Superhero * `TANDOOR_DARK` - Tandoor Dark (INCOMPLETE)
class ThemeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'TANDOOR')
  static const ThemeEnum TANDOOR = _$TANDOOR;
  @BuiltValueEnumConst(wireName: r'BOOTSTRAP')
  static const ThemeEnum BOOTSTRAP = _$BOOTSTRAP;
  @BuiltValueEnumConst(wireName: r'DARKLY')
  static const ThemeEnum DARKLY = _$DARKLY;
  @BuiltValueEnumConst(wireName: r'FLATLY')
  static const ThemeEnum FLATLY = _$FLATLY;
  @BuiltValueEnumConst(wireName: r'SUPERHERO')
  static const ThemeEnum SUPERHERO = _$SUPERHERO;
  @BuiltValueEnumConst(wireName: r'TANDOOR_DARK')
  static const ThemeEnum TANDOOR_DARK = _$TANDOOR_DARK;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ThemeEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<ThemeEnum> get serializer => _$themeEnumSerializer;

  const ThemeEnum._(String name) : super(name);

  static BuiltSet<ThemeEnum> get values => _$values;
  static ThemeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ThemeEnumMixin = Object with _$ThemeEnumMixin;

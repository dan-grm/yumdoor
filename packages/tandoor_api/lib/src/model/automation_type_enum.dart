//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'automation_type_enum.g.dart';

/// * `FOOD_ALIAS` - Food Alias * `UNIT_ALIAS` - Unit Alias * `KEYWORD_ALIAS` - Keyword Alias * `DESCRIPTION_REPLACE` - Description Replace * `INSTRUCTION_REPLACE` - Instruction Replace * `NEVER_UNIT` - Never Unit * `TRANSPOSE_WORDS` - Transpose Words * `FOOD_REPLACE` - Food Replace * `UNIT_REPLACE` - Unit Replace * `NAME_REPLACE` - Name Replace
class AutomationTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FOOD_ALIAS')
  static const AutomationTypeEnum FOOD_ALIAS = _$FOOD_ALIAS;
  @BuiltValueEnumConst(wireName: r'UNIT_ALIAS')
  static const AutomationTypeEnum UNIT_ALIAS = _$UNIT_ALIAS;
  @BuiltValueEnumConst(wireName: r'KEYWORD_ALIAS')
  static const AutomationTypeEnum KEYWORD_ALIAS = _$KEYWORD_ALIAS;
  @BuiltValueEnumConst(wireName: r'DESCRIPTION_REPLACE')
  static const AutomationTypeEnum DESCRIPTION_REPLACE = _$DESCRIPTION_REPLACE;
  @BuiltValueEnumConst(wireName: r'INSTRUCTION_REPLACE')
  static const AutomationTypeEnum INSTRUCTION_REPLACE = _$INSTRUCTION_REPLACE;
  @BuiltValueEnumConst(wireName: r'NEVER_UNIT')
  static const AutomationTypeEnum NEVER_UNIT = _$NEVER_UNIT;
  @BuiltValueEnumConst(wireName: r'TRANSPOSE_WORDS')
  static const AutomationTypeEnum TRANSPOSE_WORDS = _$TRANSPOSE_WORDS;
  @BuiltValueEnumConst(wireName: r'FOOD_REPLACE')
  static const AutomationTypeEnum FOOD_REPLACE = _$FOOD_REPLACE;
  @BuiltValueEnumConst(wireName: r'UNIT_REPLACE')
  static const AutomationTypeEnum UNIT_REPLACE = _$UNIT_REPLACE;
  @BuiltValueEnumConst(wireName: r'NAME_REPLACE')
  static const AutomationTypeEnum NAME_REPLACE = _$NAME_REPLACE;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AutomationTypeEnum unknownDefaultOpenApi =
      _$unknownDefaultOpenApi;

  static Serializer<AutomationTypeEnum> get serializer =>
      _$automationTypeEnumSerializer;

  const AutomationTypeEnum._(String name) : super(name);

  static BuiltSet<AutomationTypeEnum> get values => _$values;
  static AutomationTypeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AutomationTypeEnumMixin = Object with _$AutomationTypeEnumMixin;

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'keyword_mode_enum.g.dart';

/// * `or` - or * `and` - and
class KeywordModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'or')
  static const KeywordModeEnum or = _$or;
  @BuiltValueEnumConst(wireName: r'and')
  static const KeywordModeEnum and = _$and;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const KeywordModeEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<KeywordModeEnum> get serializer =>
      _$keywordModeEnumSerializer;

  const KeywordModeEnum._(String name) : super(name);

  static BuiltSet<KeywordModeEnum> get values => _$values;
  static KeywordModeEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class KeywordModeEnumMixin = Object with _$KeywordModeEnumMixin;

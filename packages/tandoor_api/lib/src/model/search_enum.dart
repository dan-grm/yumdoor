//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_enum.g.dart';

/// * `plain` - Simple * `phrase` - Phrase * `websearch` - Web * `raw` - Raw
class SearchEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'plain')
  static const SearchEnum plain = _$plain;
  @BuiltValueEnumConst(wireName: r'phrase')
  static const SearchEnum phrase = _$phrase;
  @BuiltValueEnumConst(wireName: r'websearch')
  static const SearchEnum websearch = _$websearch;
  @BuiltValueEnumConst(wireName: r'raw')
  static const SearchEnum raw = _$raw;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const SearchEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<SearchEnum> get serializer => _$searchEnumSerializer;

  const SearchEnum._(String name) : super(name);

  static BuiltSet<SearchEnum> get values => _$values;
  static SearchEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SearchEnumMixin = Object with _$SearchEnumMixin;

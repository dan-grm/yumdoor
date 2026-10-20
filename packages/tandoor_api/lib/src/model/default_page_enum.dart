//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'default_page_enum.g.dart';

/// * `SEARCH` - Search * `PLAN` - Meal-Plan * `BOOKS` - Books * `SHOPPING` - Shopping
class DefaultPageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const DefaultPageEnum SEARCH = _$SEARCH;
  @BuiltValueEnumConst(wireName: r'PLAN')
  static const DefaultPageEnum PLAN = _$PLAN;
  @BuiltValueEnumConst(wireName: r'BOOKS')
  static const DefaultPageEnum BOOKS = _$BOOKS;
  @BuiltValueEnumConst(wireName: r'SHOPPING')
  static const DefaultPageEnum SHOPPING = _$SHOPPING;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const DefaultPageEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<DefaultPageEnum> get serializer =>
      _$defaultPageEnumSerializer;

  const DefaultPageEnum._(String name) : super(name);

  static BuiltSet<DefaultPageEnum> get values => _$values;
  static DefaultPageEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DefaultPageEnumMixin = Object with _$DefaultPageEnumMixin;

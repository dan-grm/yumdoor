//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'method_enum.g.dart';

/// * `DB` - Dropbox * `NEXTCLOUD` - Nextcloud * `LOCAL` - Local
class MethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DB')
  static const MethodEnum DB = _$DB;
  @BuiltValueEnumConst(wireName: r'NEXTCLOUD')
  static const MethodEnum NEXTCLOUD = _$NEXTCLOUD;
  @BuiltValueEnumConst(wireName: r'LOCAL')
  static const MethodEnum LOCAL = _$LOCAL;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const MethodEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<MethodEnum> get serializer => _$methodEnumSerializer;

  const MethodEnum._(String name) : super(name);

  static BuiltSet<MethodEnum> get values => _$values;
  static MethodEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MethodEnumMixin = Object with _$MethodEnumMixin;

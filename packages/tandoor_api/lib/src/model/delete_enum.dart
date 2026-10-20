//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_enum.g.dart';

/// * `true` - true
class DeleteEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const DeleteEnum true_ = _$true_;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const DeleteEnum unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<DeleteEnum> get serializer => _$deleteEnumSerializer;

  const DeleteEnum._(String name) : super(name);

  static BuiltSet<DeleteEnum> get values => _$values;
  static DeleteEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DeleteEnumMixin = Object with _$DeleteEnumMixin;

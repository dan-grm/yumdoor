import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';

/// A unit of measurement such as `g` or `EL`, as named on the server.
@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required int id,
    required String name,
    String? pluralName,
  }) = _Unit;
}

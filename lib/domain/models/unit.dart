import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

/// A unit of measurement such as `g` or `EL`, as named on the server.
@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required int id,
    required String name,
    String? pluralName,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}

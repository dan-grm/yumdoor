import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_ref.freezed.dart';
part 'user_ref.g.dart';

/// A user of the space as shown next to their content, e.g. a recipe's author.
@freezed
abstract class UserRef with _$UserRef {
  const factory UserRef({
    required int id,

    /// The display name, falling back to the username. Can be empty.
    required String name,
  }) = _UserRef;

  factory UserRef.fromJson(Map<String, dynamic> json) =>
      _$UserRefFromJson(json);
}

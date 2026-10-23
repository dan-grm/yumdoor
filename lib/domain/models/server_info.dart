import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';

/// What a Tandoor server says about itself before login.
@freezed
abstract class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    /// The Tandoor version, e.g. `2.6.15`.
    required String version,
  }) = _ServerInfo;

  const ServerInfo._();

  /// The major version, or `null` if [version] doesn't start with a number.
  int? get majorVersion => int.tryParse(version.split('.').first);

  /// Yumdoor supports the Tandoor 2.x line.
  bool get isSupported => majorVersion == 2;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cooking_providers.g.dart';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
@Riverpod(keepAlive: true)
class WakeLockHintShown extends _$WakeLockHintShown {
  @override
  bool build() => false;

  void markShown() => state = true;
}

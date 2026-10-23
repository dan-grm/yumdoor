import 'csrf_token_source.dart';

/// Native apps don't share cookies with Tandoor's web UI: there is never a
/// token.
class PlatformCsrfTokenSource implements CsrfTokenSource {
  @override
  String? read() => null;
}

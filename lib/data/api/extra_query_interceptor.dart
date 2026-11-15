import 'package:dio/dio.dart';

/// Adds query parameters that a generated API method has no argument for.
///
/// A request whose `extra` holds a `Map<String, Object>` under [paramsKey]
/// gets those parameters, except the ones that clash with its own: the
/// request's own win. A parameter clashes with one of the same name and,
/// as Tandoor lets an exact value win over a range (`timescooked` over
/// `timescooked_gte`), an exact one with its `_gte` and `_lte`; a `_gte`
/// and an `_lte` both apply. The names left out go into the same `extra` under [skippedKey]
/// (a `List<String>`), so the caller can read them from
/// `response.requestOptions.extra`.
class ExtraQueryInterceptor extends Interceptor {
  const ExtraQueryInterceptor();

  static const paramsKey = 'yumdoor.extraQuery';
  static const skippedKey = 'yumdoor.extraQuerySkipped';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[paramsKey] case final Map<String, Object> params) {
      final query = {...options.queryParameters};
      final own = query.keys.toSet();
      final skipped = <String>[];
      for (final MapEntry(:key, :value) in params.entries) {
        if (_clashes(key, own)) {
          skipped.add(key);
        } else {
          query[key] = value;
        }
      }
      options
        ..queryParameters = query
        ..extra[skippedKey] = skipped;
    }
    handler.next(options);
  }

  static final _range = RegExp(r'_(gte|lte)$');

  /// Whether [name] clashes with one of [own].
  static bool _clashes(String name, Set<String> own) {
    if (own.contains(name)) return true;
    if (_range.hasMatch(name)) {
      return own.contains(name.replaceFirst(_range, ''));
    }
    return own.contains('${name}_gte') || own.contains('${name}_lte');
  }
}

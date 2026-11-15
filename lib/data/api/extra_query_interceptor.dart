import 'package:dio/dio.dart';

/// Adds query parameters that a generated API method has no argument for.
///
/// A request whose `extra` holds a `Map<String, Object>` under [paramsKey]
/// gets those parameters, except the ones that clash with its own: the
/// request's own win. A parameter clashes with one of the same name and,
/// as Tandoor lets an exact value win over a range (`timescooked` over
/// `timescooked_gte`), with one that differs only by a `_gte` or `_lte`
/// suffix. The names left out go into the same `extra` under [skippedKey]
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
      final own = {for (final name in query.keys) _family(name)};
      final skipped = <String>[];
      for (final MapEntry(:key, :value) in params.entries) {
        if (own.contains(_family(key))) {
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

  /// [name] without a range suffix.
  static String _family(String name) =>
      name.replaceFirst(RegExp(r'_(gte|lte)$'), '');
}

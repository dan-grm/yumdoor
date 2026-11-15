import 'package:dio/dio.dart';

/// Adds query parameters that a generated API method has no argument for.
///
/// A request whose `extra` holds a `Map<String, Object>` under [paramsKey]
/// gets those parameters, except the ones it has already: the request's own
/// win. The names left out go into the same `extra` under [skippedKey]
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
      final skipped = <String>[];
      for (final MapEntry(:key, :value) in params.entries) {
        if (query.containsKey(key)) {
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
}

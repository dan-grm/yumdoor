import 'package:dio/dio.dart';

/// Reports whether the server answered: `true` for any response, error
/// statuses included, `false` when it couldn't be reached at all.
///
/// Feeds the app's offline state together with the platform's connectivity.
class ReachabilityInterceptor extends Interceptor {
  ReachabilityInterceptor(this._onReachable);

  final void Function(bool reachable) _onReachable;

  /// Set to `true` in a request's `extra` so that its failed connection
  /// doesn't count as unreachable: an upload a proxy refuses as too large
  /// often ends as a reset connection rather than a 413.
  static const uploadKey = 'yumdoor.upload';

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _onReachable(true);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError ||
              DioExceptionType.connectionTimeout
          when err.requestOptions.extra[uploadKey] != true:
        _onReachable(false);
      case DioExceptionType.badResponse:
        _onReachable(true);
      // Cancelled, slow or unreadable: says nothing about the connection.
      default:
    }
    handler.next(err);
  }
}

import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Downloads recipe images for the offline cache.
///
/// Its [Dio] carries no token: the app loads images without one too
/// (`Image.network`), and they may live on another host than Tandoor.
class ImageDownloader {
  ImageDownloader()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 30),
          responseType: ResponseType.bytes,
        ),
      );

  /// Larger images are not stored.
  static const maxBytes = 5 * 1024 * 1024;

  final Dio _dio;

  /// The image at [url], or `null` if it is too large. Throws a
  /// [DioException] if the download fails.
  Future<Uint8List?> download(Uri url) async {
    final response = await _dio.getUri<List<int>>(url);
    final data = response.data;
    if (data == null || data.isEmpty || data.length > maxBytes) return null;
    return data is Uint8List ? data : Uint8List.fromList(data);
  }

  void close() => _dio.close(force: true);
}

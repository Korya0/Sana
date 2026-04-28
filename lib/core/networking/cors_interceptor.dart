import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/api_endpoints.dart';

class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kIsWeb) {
      final originalUrl = options.uri.toString();

      if (originalUrl.startsWith('http') &&
          !originalUrl.startsWith(ApiEndpoints.corsProxyUrl)) {
        options
          ..path = '${ApiEndpoints.corsProxyUrl}?$originalUrl'
          ..queryParameters = {}
          ..baseUrl = '';
      }
    }
    handler.next(options);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/api_endpoints.dart';

/// Intercepts requests on Web and routes them through a CORS proxy
/// to bypass restrictions when calling APIs that do not emit CORS headers.
class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kIsWeb) {
      final originalUrl = options.uri.toString();

      // If the URL is already proxied, or isn't HTTP, skip.
      if (originalUrl.startsWith('http') &&
          !originalUrl.startsWith(ApiEndpoints.corsProxyUrl)) {
        // Rewrite the request to use the proxy
        options
          ..path = '${ApiEndpoints.corsProxyUrl}?$originalUrl'
          ..baseUrl = ''; // Clear base URL to avoid Dio resolving issues
      }
    }
    handler.next(options);
  }
}

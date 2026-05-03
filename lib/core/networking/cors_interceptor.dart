import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/api_endpoints.dart';

class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kIsWeb) {
      final originalUrl = options.uri.toString();

      // List of domains that support CORS natively and don't need a proxy
      final excludedDomains = <String>[
        'nominatim.openstreetmap.org',
      ];

      final shouldExclude = excludedDomains.any(originalUrl.contains);

      if (originalUrl.startsWith('http') &&
          !originalUrl.startsWith(ApiEndpoints.corsProxyUrl) &&
          !shouldExclude) {
        options
          ..path =
              '${ApiEndpoints.corsProxyUrl}?${Uri.encodeComponent(originalUrl)}'
          ..queryParameters = {}
          ..baseUrl = '';
      }
    }
    handler.next(options);
  }
}

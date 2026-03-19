import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sana/core/networking/app_headers_interceptor.dart';
import 'package:sana/core/networking/cors_interceptor.dart';
import 'package:sana/core/networking/performance_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio();

      const timeout = Duration(seconds: 30);

      _dio!
        ..options.connectTimeout = timeout
        ..options.receiveTimeout = timeout
        ..options.sendTimeout = timeout
        ..options.headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

      _addDioInterceptors();
    }
    return _dio!;
  }

  static void _addDioInterceptors() {
    final dio = _dio!;

    // 1. Logging Interceptor (Gated by kDebugMode)
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }

    // 2. Custom App Interceptors
    dio.interceptors.addAll([
      AppHeadersInterceptor(),
      PerformanceInterceptor(),
      CorsInterceptor(),
    ]);

    // Note: Auth interceptor or others can be added here as needed
  }

  /// Reset the Dio instance (useful for testing or re-initialization)
  static void reset() {
    _dio = null;
  }
}

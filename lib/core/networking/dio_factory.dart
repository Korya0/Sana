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

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }

    dio.interceptors.addAll([
      AppHeadersInterceptor(),
      PerformanceInterceptor(),
      CorsInterceptor(),
    ]);
  }

  static void reset() {
    _dio = null;
  }
}
